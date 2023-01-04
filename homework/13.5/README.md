# Домашнее задание по лекции "13.5 поддержка нескольких окружений на примере Qbec"

> Приложение обычно существует в нескольких окружениях. Для удобства работы следует использовать соответствующие инструменты, например, Qbec.

Инфраструктура подготовлена при помощи **Terraform**, **Ansible** и вспомогательного скрипта **go.sh**.

Исходный коды находятся в каталоге [src](./src).

Полный лог создания кластера приведёт в отдельном [файле](./infrastructure.md).

## Задание 1: подготовить приложение для работы через qbec

> Приложение следует упаковать в qbec. Окружений должно быть два: stage и production.
> Требования:
> * stage окружение должно поднимать каждый компонент приложения в одном экземпляре;
> * production окружение — каждый компонент в трёх экземплярах;
> * для production окружения нужно добавить endpoint на внешний адрес.

Страница **qbec** на [GitHub](https://github.com/splunk/qbec)

Чтобы не писать все файлы проекта с нуля можно воспользоваться командой **qbec** для создания простого шаблона: `qbec init <prj>`, где `<prj>` - имя проекта.
При вызове данной команды **qbec** создаст одноименную директрию, в которой расположит минимальный набор файлов и каталогов в соответствии со своей типичной структурой.
Однако, по меньшей мери для версии **qbec 0.15.2** использование стандартных параметров для компонентов (промежуточного **components** при задании параметров окружения) не является обязательным.
Добавление ключа `--with-example` позволит наполнить проект простым приложением, готовым к **deploy**.

```console
root@debian11:~/13.5# qbec init netology-app
using server URL "https://62.84.117.40:6443" and default namespace "production" for the default environment
wrote netology-app/params.libsonnet
wrote netology-app/environments/base.libsonnet
wrote netology-app/environments/default.libsonnet
wrote netology-app/qbec.yaml
root@debian11:~/13.5#
```

Как видно из лога выше при инициализации проекта **qbec** в базовую конфигурацию проекта автоматически добавил кластер из настроек **Kubernetes** (`~/.kube/config`).
Но, нужно учесть, что **qbec**, в отличии от **Helm**, не позволяет автоматически создавать требуемые **namespace** если в кластере их нет.
Поэтому нужно либо создавать их такими же компонентами **qbec**, другими инструментами, либо вручную.

```console
root@debian11:~/13.5# kubectl create ns stage
namespace/stage created
root@debian11:~/13.5# kubectl create ns production
namespace/production created
root@debian11:~/13.5# kubectl get ns
NAME              STATUS   AGE
default           Active   65m
kube-node-lease   Active   65m
kube-public       Active   65m
kube-system       Active   65m
production        Active   7s
stage             Active   12s
root@debian11:~/13.5#
```

### Описание конверсии приложения [netology-app](./netology-app)

Для решения в качестве основы было взято приложение из предыдущих заданий ([13.4](https://github.com/ArtemShtepa/devops-netology/tree/homework-13.4/homework/13.4) **Jsonnet** конверсия) со следующими модификациями:
  - Вместо общего **PersistentVolume** для хранения файлов базы данных реализовано общее хранилище между **frontend** и **backend** (позволит масштабировать **pods** базы данных);
  - Разблокировано масштабирование **deploy** базы данных (число реплик не фиксируется и задаётся параметром окружения);
  - Из **deploy** **backend** убран блок **startupProbe**, чтобы создаваемый **pod** не "зависал" на несколько минут перед стартом (могло приводить к **timeout** выполнения операции **qbec**); оставшийся блок **livenessProbe** выполняет аналогичную функцию;
  - Зависимость от внешних параметров **Jsonnet** заменена значениями по умолчанию выбранного окружения **qbec**;

Состав проекта:
  - [params.libsonnet](./netology-app/params.libsonnet) - по сути программа, загружающая все существующие файлы окружений и в качестве параметров оставляет только те, которые соответствуют заданному **qbec** окружению;
  - [qbec.yaml](./netology-app/qbec.yaml) - основной конфигурационный файл проекта, где указываются используемые окружения и адрес **control plane** соответствующего кластера;
  - [test_stage.jsonnet](./netology-app/test_stage.jsonnet) - отдельный **deploy** **pod** для тестирования **frontend** и **backend** в окружении **stage**; Исполняется **Jsonnet**;
  - [test_production.jsonnet](./netology-app/test_production.jsonnet) - отдельный **deploy** **pod** для тестирования **frontend** и **backend** в окружении **production**; Исполняется **Jsonnet**;
  - environments/[base.libsonnet](./netology-app/environments/base.libsonnet) - базовые настройки переменных приложения;
  - environments/[stage.libsonnet](./netology-app/environments/stage.libsonnet) -  специфичные настройки приложения для окружения **stage**;
  - environments/[production.libsonnet](./netology-app/environments/production.libsonnet) - специфичные настройки приложения для окружения **production**;
  - components/[backend.jsonnet](./netology-app/components/backend.jsonnet) - компонент приложения, содержащий **Deploy** и **Service** **backend**;
  - components/[db.jsonnet](./netology-app/components/db.jsonnet) - компонент приложения, содержащий **StatefulSet**, **Service** и **Secret** базы данных;
  - components/[ext.jsonnet](./netology-app/components/ext.jsonnet) - опциональный компонент приложения, содержащий **Service**, **Ingress** и **Endpoint** реализации вызова к внешнему **API**;
  - components/[frontend.jsonnet](./netology-app/components/frontend.jsonnet) - компонент приложения, содержащий **Deployment** и **Service** **frontend**;
  - components/[volume.jsonnet](./netology-app/components/volume.jsonnet) - компонент приложения, реализующий общее хранилище между **frontend** и **backend**; содержит **PersistentVolumeClaim** и опциональный **PersistentVolume**.

> В решении масштабирование базы данных - сомнительная идея, так как в данном исполнении СУБД настроена на обычную внекластерную работу и
> увеличение числа реплик приведёт к созданию по сути независимых баз данных.
> Для данного примера никаких негативных последствий это не влечёт, так как в базу ничего кроме первоначального наполнения не пишется.
> Однако, при необходимости записи каких-либо данных наша "общая" база станет не консистентной, так как в разных её репликах будут находиться уже не согласованные данные.

> файлы для тестов не смотря на большую повторяемость кода разделены, так как **Jsonnet** не поддерживает параметризированный **import**

По умолчанию, **qbec** для любого окружения включает все обнаруженные компоненты.
Исключить "не нужные" можно указав их в блоке **excludes** на уровне окружения,
либо для всех окружений на уровне **spec**;
Принудитлельно включить компонент можно добавив его компонент в блок **includes** на уровне окружения.

Требование задания по опциональности **endpoint** реализовано исключением соответствующего компонента **ext** из окружения **stage**.
Посмотреть отличие окружений по компонентам можно командой: `qbec component diff <env1> <env2>` - где `<env1>` и `<env2>` - сравниваемые по компонентам окружения:

```console
root@debian11:~/13.5/netology-app# qbec component diff stage production
--- environment: stage
+++ environment: production
@@ -3,0 +4 @@
+ext                            components/ext.jsonnet


root@debian11:~/13.5/netology-app#
```

Применение конфигурации к окружению выполняется командой: `qbec apply <env>` - где `<env>` - окружени для которого нужно применить манифесты приложения

Удаление из кластера приложения выполняется командой: `qbec delete <env>` - где `<env>` - окружение из которого нужно удалить компоненты приложения

### Разворачивание приложения в окружнении **stage**

```console
root@debian11:~/13.5/netology-app# qbec apply stage
setting cluster to cluster.local
setting context to kubernetes-admin@cluster.local
cluster metadata load took 195ms
4 components evaluated in 16ms

will synchronize 8 object(s)

Do you want to continue [y/n]: y
4 components evaluated in 6ms
create secrets r1-db-secret -n stage (source db)
create persistentvolumeclaims r1-shared-pvc -n stage (source volume)
create deployments r1-backend -n stage (source backend)
create deployments r1-frontend -n stage (source frontend)
create statefulsets r1-db -n stage (source db)
create services r1-backend-svc -n stage (source backend)
create services r1-db-svc -n stage (source db)
create services r1-frontend-svc -n stage (source frontend)
server objects load took 1.361s
---
stats:
  created:
  - secrets r1-db-secret -n stage (source db)
  - persistentvolumeclaims r1-shared-pvc -n stage (source volume)
  - deployments r1-backend -n stage (source backend)
  - deployments r1-frontend -n stage (source frontend)
  - statefulsets r1-db -n stage (source db)
  - services r1-backend-svc -n stage (source backend)
  - services r1-db-svc -n stage (source db)
  - services r1-frontend-svc -n stage (source frontend)

waiting for readiness of 3 objects
  - deployments r1-backend -n stage
  - deployments r1-frontend -n stage
  - statefulsets r1-db -n stage

✓ 1s    : statefulsets r1-db -n stage :: 1 new pods updated (2 remaining)
  1s    : deployments r1-frontend -n stage :: 0 of 1 updated replicas are available
  1s    : deployments r1-backend -n stage :: 0 of 1 updated replicas are available
✓ 6s    : deployments r1-frontend -n stage :: successfully rolled out (1 remaining)
✓ 22s   : deployments r1-backend -n stage :: successfully rolled out (0 remaining)

✓ 22s: rollout complete
command took 28.89s
root@debian11:~/13.5/netology-app#
```

Запрос состояния кластера:

```console
root@debian11:~/13.5/netology-app# kubectl get po,svc,ep,pvc -n stage -o wide
NAME                               READY   STATUS    RESTARTS   AGE     IP             NODE    NOMINATED NODE   READINESS GATES
pod/r1-backend-59bc7dd669-4njxd    1/1     Running   0          3m57s   10.233.71.21   node3   <none>           <none>
pod/r1-db-0                        1/1     Running   0          3m56s   10.233.74.85   node4   <none>           <none>
pod/r1-frontend-65c84b98b4-kvm6k   1/1     Running   0          3m56s   10.233.75.23   node2   <none>           <none>

NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE     SELECTOR
service/r1-backend-svc    ClusterIP   10.233.28.140   <none>        9000/TCP   3m56s   app=r1-backend
service/r1-db-svc         ClusterIP   10.233.16.51    <none>        5432/TCP   3m54s   app=r1-db
service/r1-frontend-svc   ClusterIP   10.233.36.248   <none>        8000/TCP   3m53s   app=r1-frontend

NAME                        ENDPOINTS           AGE
endpoints/r1-backend-svc    10.233.71.21:9000   3m55s
endpoints/r1-db-svc         10.233.74.85:5432   3m53s
endpoints/r1-frontend-svc   10.233.75.23:80     3m53s

NAME                                  STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE     VOLUMEMODE
persistentvolumeclaim/r1-shared-pvc   Bound    pvc-03fc33fe-123c-46ba-b851-f97f5d3ca810   512Mi      RWX            nfs            3m57s   Filesystem
root@debian11:~/13.5/netology-app#
```

### Тестирования приложения в окружении **stage**

Тестирование приложения заключается в запуске тестовых **pods**, которые выполняют запросы к **frontend** и **backend** приложения.
Результаты запросов остаются в логах соответствующих **pods**, которые будет запрошены для проверки результата.

```console
root@debian11:~/13.5/netology-app# jsonnet -y test_stage.jsonnet | kubectl apply -f -
pod/r1-test-backend created
pod/r1-test-frontend created
root@debian11:~/13.5/netology-app# kubectl get pod -n stage -o wide
NAME                           READY   STATUS      RESTARTS   AGE     IP             NODE    NOMINATED NODE   READINESS GATES
r1-backend-59bc7dd669-4njxd    1/1     Running     0          4m50s   10.233.71.21   node3   <none>           <none>
r1-db-0                        1/1     Running     0          4m49s   10.233.74.85   node4   <none>           <none>
r1-frontend-65c84b98b4-kvm6k   1/1     Running     0          4m49s   10.233.75.23   node2   <none>           <none>
r1-test-backend                0/1     Completed   0          26s     10.233.74.86   node4   <none>           <none>
r1-test-frontend               0/1     Completed   0          25s     10.233.75.24   node2   <none>           <none>
root@debian11:~/13.5/netology-app# kubectl logs pod/r1-test-backend -n stage && echo
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}]
root@debian11:~/13.5/netology-app# kubectl logs pod/r1-test-frontend -n stage && echo
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
root@debian11:~/13.5/netology-app#
```

Также протестировано единое хранилище по следующему алгоритму:
  1. В **pod** **frontend**, расположенного на ноде `node2` выполняется команда вывода слова `TEST` в файл `test.txt` в режиме перезаписи
  1. В **pod** **backend**, расположенного на другой ноде `node3` выполняется команда добавления слова `OK` в тот же файл `test.txt`;
  1. В **pod** **frontend** запрашивается содержимое файла `test.txt`

```console
root@debian11:~/13.5/netology-app# kubectl exec r1-frontend-65c84b98b4-kvm6k -n stage -- bash -c 'echo "TEST" > /data/test.txt'
root@debian11:~/13.5/netology-app# kubectl exec r1-backend-59bc7dd669-4njxd -n stage -- bash -c 'echo "OK" >> /static/test.txt'
root@debian11:~/13.5/netology-app# kubectl exec r1-frontend-65c84b98b4-kvm6k -n stage -- cat /data/test.txt
TEST
OK
root@debian11:~/13.5/netology-app#
```

### Разворачивание приложения в окружении **production**

```console
root@debian11:~/13.5/netology-app# qbec apply production
setting cluster to cluster.local
setting context to kubernetes-admin@cluster.local
cluster metadata load took 2.255s
5 components evaluated in 5ms

will synchronize 11 object(s)

Do you want to continue [y/n]: y
5 components evaluated in 5ms
create secrets r1-db-secret -n production (source db)
create endpoints r1-ext-svc -n production (source ext)
create ingresses r1-ext-ing -n production (source ext)
create persistentvolumeclaims r1-shared-pvc -n production (source volume)
create deployments r1-backend -n production (source backend)
create deployments r1-frontend -n production (source frontend)
create statefulsets r1-db -n production (source db)
create services r1-backend-svc -n production (source backend)
create services r1-db-svc -n production (source db)
create services r1-ext-svc -n production (source ext)
create services r1-frontend-svc -n production (source frontend)
server objects load took 1.715s
---
stats:
  created:
  - secrets r1-db-secret -n production (source db)
  - endpoints r1-ext-svc -n production (source ext)
  - ingresses r1-ext-ing -n production (source ext)
  - persistentvolumeclaims r1-shared-pvc -n production (source volume)
  - deployments r1-backend -n production (source backend)
  - deployments r1-frontend -n production (source frontend)
  - statefulsets r1-db -n production (source db)
  - services r1-backend-svc -n production (source backend)
  - services r1-db-svc -n production (source db)
  - services r1-ext-svc -n production (source ext)
  - services r1-frontend-svc -n production (source frontend)

waiting for readiness of 3 objects
  - deployments r1-backend -n production
  - deployments r1-frontend -n production
  - statefulsets r1-db -n production

  0s    : deployments r1-frontend -n production :: 0 of 3 updated replicas are available
  0s    : deployments r1-backend -n production :: 0 of 3 updated replicas are available
  0s    : statefulsets r1-db -n production :: 1 of 3 updated
  6s    : deployments r1-frontend -n production :: 1 of 3 updated replicas are available
  7s    : deployments r1-frontend -n production :: 2 of 3 updated replicas are available
✓ 7s    : deployments r1-frontend -n production :: successfully rolled out (2 remaining)
  10s   : statefulsets r1-db -n production :: 2 of 3 updated
✓ 14s   : statefulsets r1-db -n production :: 3 new pods updated (1 remaining)
  1m20s : deployments r1-backend -n production :: 1 of 3 updated replicas are available
  1m30s : deployments r1-backend -n production :: 2 of 3 updated replicas are available
✓ 1m30s : deployments r1-backend -n production :: successfully rolled out (0 remaining)

✓ 1m30s: rollout complete
command took 1m42.76s
root@debian11:~/13.5/netology-app#
```

Запрос состоания кластера:

```console
root@debian11:~/13.5/netology-app# kubectl get po,svc,ep,ing,pvc -n production -o wide
NAME                               READY   STATUS    RESTARTS      AGE     IP             NODE    NOMINATED NODE   READINESS GATES
pod/r1-backend-59bc7dd669-mgbdz    1/1     Running   1 (93s ago)   2m47s   10.233.75.28   node2   <none>           <none>
pod/r1-backend-59bc7dd669-nfplw    1/1     Running   1 (92s ago)   2m47s   10.233.74.90   node4   <none>           <none>
pod/r1-backend-59bc7dd669-w54qq    1/1     Running   1 (92s ago)   2m47s   10.233.71.27   node3   <none>           <none>
pod/r1-db-0                        1/1     Running   0             2m46s   10.233.71.26   node3   <none>           <none>
pod/r1-db-1                        1/1     Running   0             2m33s   10.233.75.30   node2   <none>           <none>
pod/r1-db-2                        1/1     Running   0             2m28s   10.233.74.92   node4   <none>           <none>
pod/r1-frontend-65c84b98b4-d7fff   1/1     Running   0             2m47s   10.233.75.29   node2   <none>           <none>
pod/r1-frontend-65c84b98b4-sck2f   1/1     Running   0             2m46s   10.233.74.91   node4   <none>           <none>
pod/r1-frontend-65c84b98b4-x6skf   1/1     Running   0             2m46s   10.233.71.25   node3   <none>           <none>

NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE     SELECTOR
service/r1-backend-svc    ClusterIP   10.233.61.65    <none>        9000/TCP   2m45s   app=r1-backend
service/r1-db-svc         ClusterIP   10.233.32.89    <none>        5432/TCP   2m44s   app=r1-db
service/r1-ext-svc        ClusterIP   None            <none>        8080/TCP   2m43s   <none>
service/r1-frontend-svc   ClusterIP   10.233.49.184   <none>        8000/TCP   2m42s   app=r1-frontend

NAME                        ENDPOINTS                                               AGE
endpoints/r1-backend-svc    10.233.71.27:9000,10.233.74.90:9000,10.233.75.28:9000   2m45s
endpoints/r1-db-svc         10.233.71.26:5432,10.233.74.92:5432,10.233.75.30:5432   2m44s
endpoints/r1-ext-svc        213.180.193.58:80                                       2m51s
endpoints/r1-frontend-svc   10.233.71.25:80,10.233.74.91:80,10.233.75.29:80         2m43s

NAME                                   CLASS    HOSTS   ADDRESS   PORTS   AGE
ingress.networking.k8s.io/r1-ext-ing   <none>   *                 80      2m46s

NAME                                  STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE     VOLUMEMODE
persistentvolumeclaim/r1-shared-pvc   Bound    pvc-574d9755-a787-4e6b-8955-54d3e4fa9e36   512Mi      RWX            nfs            2m49s   Filesystem
root@debian11:~/13.5/netology-app#
```

### Тестирование приложения в окружении **production**

Основное тестирование приложения в окружении **production** аналогично тестированию окружения **stage**

```console
root@debian11:~/13.5/netology-app# jsonnet -y test_production.jsonnet | kubectl apply -f -
pod/r1-test-backend created
pod/r1-test-frontend created
root@debian11:~/13.5/netology-app# kubectl get pod -n production -o wide
NAME                           READY   STATUS      RESTARTS        AGE     IP             NODE    NOMINATED NODE   READINESS GATES
r1-backend-59bc7dd669-mgbdz    1/1     Running     1 (2m21s ago)   3m35s   10.233.75.28   node2   <none>           <none>
r1-backend-59bc7dd669-nfplw    1/1     Running     1 (2m20s ago)   3m35s   10.233.74.90   node4   <none>           <none>
r1-backend-59bc7dd669-w54qq    1/1     Running     1 (2m20s ago)   3m35s   10.233.71.27   node3   <none>           <none>
r1-db-0                        1/1     Running     0               3m34s   10.233.71.26   node3   <none>           <none>
r1-db-1                        1/1     Running     0               3m21s   10.233.75.30   node2   <none>           <none>
r1-db-2                        1/1     Running     0               3m16s   10.233.74.92   node4   <none>           <none>
r1-frontend-65c84b98b4-d7fff   1/1     Running     0               3m35s   10.233.75.29   node2   <none>           <none>
r1-frontend-65c84b98b4-sck2f   1/1     Running     0               3m34s   10.233.74.91   node4   <none>           <none>
r1-frontend-65c84b98b4-x6skf   1/1     Running     0               3m34s   10.233.71.25   node3   <none>           <none>
r1-test-backend                0/1     Completed   0               23s     10.233.75.31   node2   <none>           <none>
r1-test-frontend               0/1     Completed   0               22s     10.233.74.93   node4   <none>           <none>
root@debian11:~/13.5/netology-app# kubectl logs pod/r1-test-backend -n production && echo
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":7,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":9,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":11,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":6,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":8,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":10,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":12,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":13,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":15,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":17,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":19,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":21,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":23,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":25,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":27,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":29,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":30,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":32,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":33,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":35,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":37,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":38,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":40,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":41,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"},{"id":14,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":16,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":18,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":20,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":22,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":24,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":26,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":28,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":31,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":34,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":36,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":39,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":42,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":43,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":44,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":45,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":46,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":47,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":48,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":49,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":50,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}]
root@debian11:~/13.5/netology-app# kubectl logs pod/r1-test-frontend -n production && echo
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
root@debian11:~/13.5/netology-app#
```

Тестирование единого хранилища для окружения **production** более интересное:
  1. В **pod** **frontend**, расположенного на ноде `node2` выполняется команда вывода слова `TEST` в файл `test.txt` в режиме перезаписи
  1. В **pod** **backend**, расположенного на другой ноде `node3` выполняется команда добавления слова `OK` в тот же файл `test.txt`;
  1. В **pod** **frontend**, расположенного на третьей ноде `node4` запрашивается содержимое файла `test.txt`

```console
root@debian11:~/13.5/netology-app# kubectl exec r1-frontend-65c84b98b4-d7fff -n production -- bash -c 'echo "TEST" > /data/test.txt'
root@debian11:~/13.5/netology-app# kubectl exec r1-backend-59bc7dd669-w54qq -n production -- bash -c 'echo "OK" >> /static/test.txt'
root@debian11:~/13.5/netology-app# kubectl exec r1-frontend-65c84b98b4-sck2f -n production -- cat /data/test.txt
TEST
OK
root@debian11:~/13.5/netology-app#
```

Наличие в окружении **production** **endpoint** также позволяет его протестировать, отправив запрос к внешнему **API**

```console
root@debian11:~/13.5/netology-app# kubectl exec r1-backend-59bc7dd669-mgbdz -n production -- curl -v -s r1-ext-svc/ext
*   Trying 213.180.193.58:80...
* Connected to r1-ext-svc (213.180.193.58) port 80 (#0)
> GET /ext HTTP/1.1
> Host: r1-ext-svc
> User-Agent: curl/7.74.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 404 Not found
< Content-Length: 0
< Set-Cookie: _yasc=8MxNPedxkIK+/0Kx/XOy3sljlK5LpfIXg6ecIzEWCnWbi3cvI8qQMcGSJNw=; domain=.r1-ext-svc; path=/; expires=Fri, 07-Jan-2033 00:15:21 GMT; secure
<
* Connection #0 to host r1-ext-svc left intact
root@debian11:~/13.5/netology-app#
```
При выполнении запроса к обслуживающему сервису видно, что итоговый **IP** адрес `213.180.193.58` не принадлежит нашему кластеру и именно он был задан в качестве **endpoint** для пути `/ext`
