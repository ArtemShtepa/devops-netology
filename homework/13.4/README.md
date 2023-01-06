# Домашнее задание по лекции "13.4 инструменты для упрощения написания конфигурационных файлов. Helm и Jsonnet"

> В работе часто приходится применять системы автоматической генерации конфигураций.
> Для изучения нюансов использования разных инструментов нужно попробовать упаковать приложение каждым из них.

При решении заданий управление инфраструктурой производилось через **Terraform**, разворачивание кластера - **Kubespray**.
Настройка доступа к **Control Plane** кластером и установка **NFS** частично автоматизированы, как и часто используемые действия..
Исходный код вспомогательных скриптов представлен в каталоге [src](./src)

Полный лог разворачивания инфраструктуры представлен в отдельном [файле](infrastructure.md)

## Задание 1: подготовить helm чарт для приложения

> Необходимо упаковать приложение в чарт для деплоя в разные окружения.
> Требования:
> * каждый компонент приложения деплоится отдельным deployment’ом/statefulset’ом;
> * в переменных чарта измените образ приложения для изменения версии.

За основу решения взято приложение из предыдущих заданий со следующими доработками:
  - логин и пароль базы данных перенесены в секрет;
  - если логин и/или пароль не заданы, то они генерируются автоматически (только для **Helm**);
  - реализован выбор способа создания **PersistentVolume** для базы данных - статический или динамический (использование **NFS** сервера);
  - для **backend** реализован блок `startupProbe` проверяющий функционирование серсива при старте (за **N** попыток) - если за указанное время команда успешно не выполнится, то **pod** будет пересоздан;
  - для **backend** реализован блок `livenessProbe` периодически проверяющий функционирование сервиса - если функция завершается ошибкой, **pod** перезапускается;
  - для **backend** реализован блок `readinessProbe` проверяющий доступность порта сервиса - в принципе, блок излишний - оставлен для примера;
  - созданы два **pods** для тестирования **backend** и **frontend**.

*Число реплик базы данных зафиксировано на `1`, так как увеличение числа реплик базы данных,
настроенной на одиночную работу и с единым хранилищем на все экземпляры,
практически гарантированно приведёт к непредсказуемым последствиям,
особенно при использовании **NFS** сервера - яркий пример "как делать не надо".*

Тестовые **pods** созданы на основе аналогичных из примера `helm create test`, но используемый образ заменён на [curlimages/curl](https://hub.docker.com/r/curlimages/curl/tags)

### Содержание проекта [netology-app](./netology-app/)

Каждый элемент приложения выделен в отдельный файл по правилу **сервис_сущностьKubernetes.yaml**:
  - [Chart.yaml](./netology-app/Chart.yaml) - Ярлычок приложения, основное описание проекта с указанием версии чарта и приложения;
  - [values.yaml](./netology-app/values.yaml) - Переменные для настройки сервисов проекта, в том числе используемые **docker** образы;
  - templates/_helpers.tpl - В проекте не используется, оставлен как пример;
  - templates/[backend_deploy.yaml](./netology-app/templates/backend_deploy.yaml) - Создание **deploy** **backend**;
  - templates/[backend_service.yaml](./netology-app/templates/backend_service.yaml) - **ClusterIP** сервис для доступа к **backend**;
  - templates/[db_pvc.yaml](./netology-app/templates/db_pvc.yaml) - В зависимости от параметра `db.use_nfs` создание нужного **PersistentVolumeClaim**;
  - templates/[db_secret.yaml](./netology-app/templates/db_secret.yaml) - Секрет для хранения логина и пароля от базы данных;
  - templates/[db_service.yaml](./netology-app/templates/db_service.yaml) - **ClusterIP** сервис для доступа к базе данных;
  - templates/[db_statefulset.yaml](./netology-app/templates/db_statefulset.yaml) - Создание **StatefulSet** базы данных;
  - templates/[ext_endpoint.yaml](./netology-app/templates/ext_endpoint.yaml) - Маршрут на внешний **IP** для сервиса внешнего **API**;
  - templates/[ext_ingress.yaml](./netology-app/templates/ext_ingress.yaml) - **Ingress** для внешнего **API**;
  - templates/[ext_service.yaml](./netology-app/templates/ext_service.yaml) - Сервис доступа к внешнему **API**;
  - templates/[frontend_deploy.yaml](./netology-app/templates/frontend_deploy.yaml) - Создание **deploy** **frontend**;
  - templates/[frontend_service.yaml](./netology-app/templates/frontend_service.yaml) - **ClusterIP** сервис для доступа к **frontend**;
  - templates/[NOTES.txt](./netology-app/templates/NOTES.txt) - Сообщение о конфигурации приложения, выводимое при установке / обновлении;
  - templates/[pv.yaml](./netology-app/templates/pv.yaml) - Ручное распределение пространства **PersistentVolume**. Выполняется только при `db.use_nfs` не `true`;
  - templates/tests/[test-frontend.yaml](./netology-app/templates/tests/test-frontend.yaml) - **Pod** для тестирования **frontend**;
  - templates/tests/[test-backend.yaml](./netology-app/templates/tests/test-backend.yaml) - **Pod** для тестирования **backend**.

---

## Задание 2: запустить 2 версии в разных неймспейсах

> Подготовив чарт, необходимо его проверить.
> Попробуйте запустить несколько копий приложения:
> * одну версию в namespace=app1;
> * вторую версию в том же неймспейсе;
> * третью версию в namespace=app2.

Установка приложения, упакованного в **Helm**, производится командой: `helm install <релиз> <опции>`, где `<релиз>` - текстовой идентификатор выпуска приложения, `<опции>` - параметры установки и настройка приложения

Текстовой идентификатор выпуска доступен в окружении **Helm** в параметре `.Release.Name`.
По умолчанию приложение разворачивается в **namespace** `default` и чтобы его изменить используется опция `-n <namespace>`.
Выбранный **namespace** доступен в окружении **Helm** в параметре `.Release.Namespace`.
Вышеуказанные параметры можно использовать для разграничения **deploy** разных версий приложения в одном кластере (одном/разных **namespace**).

Повторная установка приложения командой `helm install <релиз>` невозможна - существующий выпуск нужно обновлять командой `helm upgrade <релиз>`.
Однако, для автоматизации можно использовать гибридный метод: `helm upgrade <релиз> --install`.

При разворачивании приложения в отсутствующем **namespace**, его создание можно поручить **Helm** указав параметр `--create-namespace`

Параметры приложения, указанные в `values.yaml` можно переопределить при запуске разворачивания передав новые значения списком через опцию `--set`

Таким образом решение задачи осуществляется разворачиваем трёх версий приложения следующими командами:
  - `helm upgrade r1 --install -n app1 --create-namespace netology-app`
  - `helm upgrade r2 --install -n app1 --create-namespace netology-app`
  - `helm upgrage r3 --install -n app2 --create-namespace netology-app`

### Демонстрация решения

Выпуск `r1` приложения `netology-app` в **namespace** `app1`:

```console
root@debian11:~/13.4# helm upgrade r1 --install -n app1 --create-namespace netology-app
Release "r1" does not exist. Installing it now.
NAME: r1
LAST DEPLOYED: Sun Jan  8 11:54:54 2023
NAMESPACE: app1
STATUS: deployed
REVISION: 1
NOTES:
------------------------------------------------------------

  Deploy application version: 0.9.2
  with image tags and replicas:
    - Frontend: 1.0, x1
    - Backend: 1.0, x1
    - Database: postgres:13-alpine, x1
  External URL: ext
  Database URL: postgresql://postgres:postgres@r1-db-svc:5432/news
  Database use manual PV

------------------------------------------------------------
root@debian11:~/13.4#
```

Выпуск `r2` приложения `netology-app` в том же **namespace** `app1` с увеличением числа реплик **frontend** и **backend** до `2`

```console
root@debian11:~/13.4# helm upgrade r2 --install -n app1 --create-namespace netology-app --set frontend.replicas=2,backend.replicas=2
Release "r2" does not exist. Installing it now.
NAME: r2
LAST DEPLOYED: Sun Jan  8 12:05:41 2023
NAMESPACE: app1
STATUS: deployed
REVISION: 1
NOTES:
------------------------------------------------------------

  Current chart version: 1.4.2
  Deploy application version: 0.9.2
  with image tags and replicas:
    - Frontend: 1.0, x2
    - Backend: 1.0, x2
    - Database: postgres:13-alpine, x1
  External URL: ext
  Database URL: postgresql://postgres:postgres@r2-db-svc:5432/news
  Database use manual PV

------------------------------------------------------------
root@debian11:~/13.4#
```

Выпуск `r3` приложения `netology-app` в **namespace** `app2` с переопределением пользователя и пароля базы данных, а также использование **NFS** сервера в качестве хранилища файлов базы

```console
root@debian11:~/13.4# helm upgrade r3 --install -n app2 --create-namespace netology-app --set db.user=,db.password=,db.use_nfs=true
Release "r3" does not exist. Installing it now.
NAME: r3
LAST DEPLOYED: Sun Jan  8 12:17:43 2023
NAMESPACE: app2
STATUS: deployed
REVISION: 1
NOTES:
------------------------------------------------------------

  Current chart version: 1.4.2
  Deploy application version: 0.9.2
  with image tags and replicas:
    - Frontend: 1.0, x1
    - Backend: 1.0, x1
    - Database: postgres:13-alpine, x1
  External URL: ext
  Database URL: postgresql://login:password@r3-db-svc:5432/news
    Login and password are generic by Helm and can be viewed by edit secret r3-db-secret
    Restore from base64: echo <CODE> | base64 -d && echo
  Database use NFS storage class

------------------------------------------------------------
root@debian11:~/13.4#
```

> После выпуска **r1** был скорректирован файл `NOTES.txt`, поэтому вывод немного отличается.
> Это видно также по логу тестирования, где содержимое **NOTES** сохранилось даже после его модификации в исходном коде.

### Состояние кластера

```console
root@debian11:~/13.4# kubectl get pod,svc,ep,pvc -n app1 -o wide
NAME                               READY   STATUS    RESTARTS      AGE   IP             NODE    NOMINATED NODE   READINESS GATES
pod/r1-backend-6474855c86-s22wf    1/1     Running   0             32m   10.233.75.2    node2   <none>           <none>
pod/r1-db-0                        1/1     Running   0             32m   10.233.74.66   node4   <none>           <none>
pod/r1-frontend-79f7f7f98c-ph7rh   1/1     Running   0             32m   10.233.71.2    node3   <none>           <none>
pod/r2-backend-77df55549-cvgx2     1/1     Running   1 (16m ago)   21m   10.233.75.4    node2   <none>           <none>
pod/r2-backend-77df55549-gwmmd     1/1     Running   1 (14m ago)   21m   10.233.71.3    node3   <none>           <none>
pod/r2-db-0                        1/1     Running   0             21m   10.233.71.4    node3   <none>           <none>
pod/r2-frontend-b76ffbcf7-2hzzr    1/1     Running   0             21m   10.233.74.67   node4   <none>           <none>
pod/r2-frontend-b76ffbcf7-lf967    1/1     Running   0             21m   10.233.75.3    node2   <none>           <none>

NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE   SELECTOR
service/r1-backend-svc    ClusterIP   10.233.24.204   <none>        9000/TCP   32m   app=r1-backend
service/r1-db-svc         ClusterIP   10.233.28.246   <none>        5432/TCP   32m   app=r1-db
service/r1-ext            ClusterIP   None            <none>        8080/TCP   32m   <none>
service/r1-frontend-svc   ClusterIP   10.233.39.229   <none>        8000/TCP   32m   app=r1-frontend
service/r2-backend-svc    ClusterIP   10.233.27.83    <none>        9000/TCP   21m   app=r2-backend
service/r2-db-svc         ClusterIP   10.233.29.244   <none>        5432/TCP   21m   app=r2-db
service/r2-ext            ClusterIP   None            <none>        8080/TCP   21m   <none>
service/r2-frontend-svc   ClusterIP   10.233.56.133   <none>        8000/TCP   21m   app=r2-frontend

NAME                        ENDPOINTS                           AGE
endpoints/r1-backend-svc    10.233.75.2:9000                    32m
endpoints/r1-db-svc         10.233.74.66:5432                   32m
endpoints/r1-ext            213.180.193.58:80                   32m
endpoints/r1-frontend-svc   10.233.71.2:80                      32m
endpoints/r2-backend-svc    10.233.71.3:9000,10.233.75.4:9000   21m
endpoints/r2-db-svc         10.233.71.4:5432                    21m
endpoints/r2-ext            213.180.193.58:80                   21m
endpoints/r2-frontend-svc   10.233.74.67:80,10.233.75.3:80      21m

NAME                              STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE   VOLUMEMODE
persistentvolumeclaim/r1-db-pvc   Bound    r1-pv    512Mi      RWO                           32m   Filesystem
persistentvolumeclaim/r2-db-pvc   Bound    r2-pv    512Mi      RWO                           21m   Filesystem
root@debian11:~/13.4#
root@debian11:~/13.4#
root@debian11:~/13.4# kubectl get pod,svc,ep,pvc -n app2 -o wide
NAME                               READY   STATUS    RESTARTS        AGE   IP             NODE    NOMINATED NODE   READINESS GATES
pod/r3-backend-6b468dcd44-sksh6    1/1     Running   1 (2m31s ago)   10m   10.233.74.68   node4   <none>           <none>
pod/r3-db-0                        1/1     Running   0               10m   10.233.75.5    node2   <none>           <none>
pod/r3-frontend-86849d6947-k92f2   1/1     Running   0               10m   10.233.71.5    node3   <none>           <none>

NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE   SELECTOR
service/r3-backend-svc    ClusterIP   10.233.58.160   <none>        9000/TCP   10m   app=r3-backend
service/r3-db-svc         ClusterIP   10.233.46.246   <none>        5432/TCP   10m   app=r3-db
service/r3-ext            ClusterIP   None            <none>        8080/TCP   10m   <none>
service/r3-frontend-svc   ClusterIP   10.233.36.207   <none>        8000/TCP   10m   app=r3-frontend

NAME                        ENDPOINTS           AGE
endpoints/r3-backend-svc    10.233.74.68:9000   10m
endpoints/r3-db-svc         10.233.75.5:5432    10m
endpoints/r3-ext            213.180.193.58:80   10m
endpoints/r3-frontend-svc   10.233.71.5:80      10m

NAME                              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE   VOLUMEMODE
persistentvolumeclaim/r3-db-pvc   Bound    pvc-325426d9-7991-46d7-a653-35df264f034b   512Mi      RWX            nfs            10m   Filesystem
root@debian11:~/13.4#
```

> Перезапуск **pods** выпуска `r2` говорит о том, что при старте этих **pods** база данных ещё не была готова.
> Например, `pod/r2-backend-77df55549-cvgx2` был размещён на той же ноде что и **backend** выпуска `r1`,
> а значит образ **backend** там уже был и соответствующий **pod** запустился раньше чем база данных выпуска `r2`.
> Аналогичная ситуация наблюдалась с выпуском `r3`, но благодаря правильной настройки **deploy** (блок `startupProbe` или `livelessProbe`) приложение через какое-то время начинает функционировать.
> При отсутствуии обоих этих блокаов **pods** стартуют, но приложение не смотря на статусы **Running** не работает должным образом, так как база данных не наполнена содержимым (задача **backend**).

### Запуск тестов функционирования приложения выпусков **r1**, **r2** и **r3**

Запуск тестовых **pods** выполняется командой: `helm test <релиз> <опции>`, где `<релиз>` - текстовой идентификатор выпуска приложения;
В `<опции>` указываются параметры, например, используемый **namespace** (`-n`), вывод полученных с **pods** логов (`--logs`), отладочная информация (`--debug`) и другое.

```console
root@debian11:~/13.4# helm test r1 -n app1 --logs
NAME: r1
LAST DEPLOYED: Sun Jan  8 11:54:54 2023
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE:     r1-test-backend
Last Started:   Sun Jan  8 12:30:00 2023
Last Completed: Sun Jan  8 12:30:23 2023
Phase:          Succeeded
TEST SUITE:     r1-test-frontend
Last Started:   Sun Jan  8 12:30:23 2023
Last Completed: Sun Jan  8 12:30:30 2023
Phase:          Succeeded
NOTES:
------------------------------------------------------------

  Deploy application version: 0.9.2
  with image tags and replicas:
    - Frontend: 1.0, x1
    - Backend: 1.0, x1
    - Database: postgres:13-alpine, x1
  External URL: ext
  Database URL: postgresql://postgres:postgres@r1-db-svc:5432/news
  Database use manual PV

------------------------------------------------------------

POD LOGS: r1-test-backend
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}]
POD LOGS: r1-test-frontend
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
root@debian11:~/13.4# helm test r2 -n app1 --logs
NAME: r2
LAST DEPLOYED: Sun Jan  8 12:05:41 2023
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE:     r2-test-backend
Last Started:   Sun Jan  8 12:31:21 2023
Last Completed: Sun Jan  8 12:31:29 2023
Phase:          Succeeded
TEST SUITE:     r2-test-frontend
Last Started:   Sun Jan  8 12:31:29 2023
Last Completed: Sun Jan  8 12:31:37 2023
Phase:          Succeeded
NOTES:
------------------------------------------------------------

  Current chart version: 1.4.2
  Deploy application version: 0.9.2
  with image tags and replicas:
    - Frontend: 1.0, x2
    - Backend: 1.0, x2
    - Database: postgres:13-alpine, x1
  External URL: ext
  Database URL: postgresql://postgres:postgres@r2-db-svc:5432/news
  Database use manual PV

------------------------------------------------------------

POD LOGS: r2-test-backend
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}]
POD LOGS: r2-test-frontend
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
root@debian11:~/13.4# helm test r3 -n app2 --logs
NAME: r3
LAST DEPLOYED: Sun Jan  8 12:17:43 2023
NAMESPACE: app2
STATUS: deployed
REVISION: 1
TEST SUITE:     r3-test-backend
Last Started:   Sun Jan  8 12:31:57 2023
Last Completed: Sun Jan  8 12:32:05 2023
Phase:          Succeeded
TEST SUITE:     r3-test-frontend
Last Started:   Sun Jan  8 12:32:05 2023
Last Completed: Sun Jan  8 12:32:13 2023
Phase:          Succeeded
NOTES:
------------------------------------------------------------

  Current chart version: 1.4.2
  Deploy application version: 0.9.2
  with image tags and replicas:
    - Frontend: 1.0, x1
    - Backend: 1.0, x1
    - Database: postgres:13-alpine, x1
  External URL: ext
  Database URL: postgresql://login:password@r3-db-svc:5432/news
    Login and password are generic by Helm and can be viewed by edit secret r3-db-secret
    Restore from base64: echo <CODE> | base64 -d && echo
  Database use NFS storage class

------------------------------------------------------------

POD LOGS: r3-test-backend
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}]
POD LOGS: r3-test-frontend
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
root@debian11:~/13.4#
```

После отработки тестовых **pods** по умолчанию они остаются в кластере.
Изменить такое поведение можно добавив аннотацию `"helm.sh/hook-delete-policy"` с нужным значением в соответствии с [документацией](https://helm.sh/docs/topics/charts_hooks/#hook-deletion-policies).
Например, добавив `hook-succeeded` **pod** будет автоматически уничтожен после успешного завершения.
Однако, если это произойдёт, то нельзя будет получить логи выполнения **pod** (ключ `--logs`).
Удалить отработанные **pods** можно вручную командой `kubectl delete pod --field-selector=status.phase==Succeeded -A`, где статус `Succeeded` означает успешное завершение работы (при завершении с ошибкой статус будет `Failed`).

```console
root@debian11:~/13.4# kubectl delete pod --field-selector=status.phase==Succeeded -A
pod "r1-test-backend" deleted
pod "r1-test-frontend" deleted
pod "r2-test-backend" deleted
pod "r2-test-frontend" deleted
pod "r3-test-backend" deleted
pod "r3-test-frontend" deleted
root@debian11:~/13.4#
```

Удаление приложений выполняется командой: `helm uninstall <релиз> <опции>`, где `<релиз>` - текстовой идентификатор выпуска приложения; в `<опции>` указываются параметры, например используемый **namespace** (`-n`)

```console
root@debian11:~/13.4# helm uninstall r3 -n app2
release "r3" uninstalled
root@debian11:~/13.4# helm uninstall r2 -n app1
release "r2" uninstalled
root@debian11:~/13.4# helm uninstall r1 -n app1
release "r1" uninstalled
root@debian11:~/13.4#
```
---

## Задание 3 (*): повторить упаковку на jsonnet

> Для изучения другого инструмента стоит попробовать повторить опыт упаковки из задания 1, только теперь с помощью инструмента jsonnet.

**Jsonnet** является универсальным инструментом, позволяющим в том числе использовать его для формализации манифестов **Kubernetes** на основе шаблонов и вычислений.
Применительно к **Kubernetes** обработка манифестов осуществляется следующей командой: `jsonnet -y <jsonnet> -V <опция> | kubectl apply -f -` (**apply** можно заменить на **delete**),
где `<jsonnet>` - файл шаблона на **Jsonnet**, `<опция>` - задание переменных, используемых в шаблонах, которые проще задать извне и другие параметры

### Содержание проекта [jsonnet](./jsonnet/)

Для решения имеющиеся отдельные манифесты объеденены по сервисам:
  - [backend.jsonnet](./jsonnet/backend.jsonnet) - Все манифесты, связанные с **backend**
  - [db.jsonnet](./jsonnet/db.jsonnet) - Все манифесты, связанные с базой данных
  - [ext.jsonnet](./jsonnet/ext.jsonnet) - Все манифесты, связанные с реализацией вызова к внешниму **API**
  - [frontend.jsonnet](./jsonnet/frontend.jsonnet) - Все манифесты, связанные с **frontend**
  - config/[backend.libsonnet](./jsonnet/config/backend.libsonnet) - Переменные настройки **backend**
  - config/[db.libsonnet](./jsonnet/config/db.libsonnet) - Переменные настройки базы данных
  - config/[external.libsonnet](./jsonnet/config/external.libsonnet) - Переменные настройки внешнего **API**
  - config/[frontend.libsonnet](./jsonnet/config/frontend.libsonnet) - Переменные настройки **frontend**
  - config/[images.libsonnet](./jsonnet/config/images.libsonnet) - Перечень используемых в приложении образов (**Docker** репозитории)

Тестовые **pods** переписаны как отдельные файлы: [test_frontend.jsonnet](./jsonnet/test_frontend.jsonnet) и [test_backend.jsonnet](./jsonnet/test_backend.jsonnet)

В конверсии проекта под **Jsonnet** вместо значений `{{ .Release }}` и `{{ .Chart }}` используются внешние переменные `r_name`, `r_ns` и `r_chart`

> К сожалению, найти функцию для генерирования случайной последовательности символов для **Jsonnet** я не нашёл, поэтому данный функционал исключён из конверсии

### Тестирование конверсии

Запуск приложения с выпуском `r4` в **namespace** `app3`

```console
root@debian11:~/13.4# ./go.sh upjsonnet
statefulset.apps/r4-db created
service/r4-db-svc created
secret/r4-db-secret created
persistentvolumeclaim/r4-db-pvc created
persistentvolume/r4-pv created
deployment.apps/r4-frontend created
service/r4-frontend-svc created
service/r4-ext-svc created
ingress.networking.k8s.io/r4-ext-ing created
endpoints/r4-ext-ep created
deployment.apps/r4-backend created
service/r4-backend-svc created
root@debian11:~/13.4#
```

После готовности всех **pods** запуск тестовых

```console
root@debian11:~/13.4# ./go.sh testjsonnet
pod/r4-test-frontend created
pod/r4-test-backend created
root@debian11:~/13.4# kubectl get pod -n app3
NAME                          READY   STATUS      RESTARTS      AGE
r4-backend-5bbf59fbc5-vqr86   1/1     Running     1 (71s ago)   6m43s
r4-db-0                       1/1     Running     0             6m46s
r4-frontend-85699b5f7-kb8gr   1/1     Running     0             6m45s
r4-test-backend               0/1     Completed   0             32s
r4-test-frontend              0/1     Completed   0             32s
root@debian11:~/13.4#
```

Опрос логов тестовых **pods**

```console
root@debian11:~/13.4# kubectl logs r4-test-frontend -n app3 && echo
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
root@debian11:~/13.4# kubectl logs r4-test-backend -n app3 && echo
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}]
root@debian11:~/13.4#
```

Удаление приложения

```console
root@debian11:~/13.4# ./go.sh downjsonnet
service "r4-ext-svc" deleted
ingress.networking.k8s.io "r4-ext-ing" deleted
endpoints "r4-ext-ep" deleted
deployment.apps "r4-frontend" deleted
service "r4-frontend-svc" deleted
deployment.apps "r4-backend" deleted
service "r4-backend-svc" deleted
statefulset.apps "r4-db" deleted
service "r4-db-svc" deleted
secret "r4-db-secret" deleted
persistentvolumeclaim "r4-db-pvc" deleted
persistentvolume "r4-pv" deleted
root@debian11:~/13.4#
```

---

## Дополнительные материалы

Вывести все развёрнутые с помощью **Helm** приложения можно командой: `helm list -A`, где `-A` означает вывод всех **namespace**.
Для использования конкретного **namespace** нужно использовать ключ `-n <namespace>`

Информация по секретам **Kubernetes**:
  - Документация **Kubernetes**: [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
  - Статья [Знакомство с Kubernetes. Часть 14: Секреты (Secrets)](https://ealebed.github.io/posts/2018/знакомство-с-kubernetes-часть-14-секреты-secrets/)

Полезные ссылки для **Jsonnet**:
  - Страница **Jsonnet** (исходная версия на **C++**) на [GitHub](https://github.com/google/jsonnet)
  - Страница **Go-Jsonnet** (новая реализация на **Go**) на [GitHub](https://github.com/google/go-jsonnet)
  - Преобразователь **YAML** в **JSON** [Conversion Tool](https://jsonnet.org/articles/kubernetes.html)
  - Команды **Jsonnet** [Standard Library](https://jsonnet.org/ref/stdlib.html)
  - Основы языка **Jsonnet** [Language Reference](https://jsonnet.org/ref/language.html)

> Некоторые функции Go для работы со строками: [sprig](https://masterminds.github.io/sprig/strings.html)
