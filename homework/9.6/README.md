# Домашнее задание по лекциию "9.6 Gitlab"

## Подготовка к выполнению

> 1. Необходимо [подготовить gitlab к работе по инструкции](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/gitlab-containers)
> 2. Создайте свой новый проект
> 3. Создайте новый репозиторий в gitlab, наполните его [файлами](./repository/src)
> 4. Проект должен быть публичным, остальные настройки по желанию

### Используемый инструментарий

```console
sa@ubuntu22:~/9.6$ yc --version
Yandex Cloud CLI 0.98.0 linux/amd64
sa@ubuntu22:~/9.6$ jq --version
jq-1.6
sa@ubuntu22:~/9.6$ helm version
version.BuildInfo{Version:"v3.10.2", GitCommit:"50f003e5ee8704ec937a756c646870227d7c8b58", GitTreeState:"clean", GoVersion:"go1.18.8"}
sa@ubuntu22:~/9.6$ kubectl version --client --output=yaml
clientVersion:
  buildDate: "2022-11-09T13:36:36Z"
  compiler: gc
  gitCommit: 872a965c6c6526caa949f0c6ac028ef7aff3fb78
  gitTreeState: clean
  gitVersion: v1.25.4
  goVersion: go1.19.3
  major: "1"
  minor: "25"
  platform: linux/amd64
kustomizeVersion: v4.5.7

sa@ubuntu22:~/9.6$ kubectl cluster-info
Kubernetes control plane is running at https://130.193.51.221
CoreDNS is running at https://130.193.51.221/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
sa@ubuntu22:~/9.6$
```

В инструкции **Яндекса** есть ошибка, не позволяющая проводить шаги **Deploy**, поэтому
использовался файл `gitlab-admin-service-account.yaml` со следующим содержимым:

```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gitlab-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: gitlab-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: gitlab-admin
  namespace: kube-system
```

Применение:

```console
sa@ubuntu22:~/9.6$ kubectl apply -f gitlab-admin-service-account.yaml
serviceaccount/gitlab-admin created
clusterrolebinding.rbac.authorization.k8s.io/gitlab-admin created
sa@ubuntu22:~/9.6$ kubectl -n kube-system get secrets -o json | jq -r '.items[] | select(.metadata.name | startswith("gitlab-admin")) | .data.token' | base64 --decode && echo
eyJhbGciOiJSUzI1NiIsImtpZCI6Ijk0ZGQyaHdhRVhLYVhKdDNoMTVxMU1fQ1RkeGhobDhsamFnRVAxT2NlcEkifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJnaXRsYWItYWRtaW4tdG9rZW4tdjVrbWgiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZ2l0bGFiLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMDA4YTYyNzEtNjRhNy00OWNlLWJhYjQtNTkwNTYyNTI1YjBkIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmdpdGxhYi1hZG1pbiJ9.YjzbOZySReYR52AVNUSTExMR1vCccoyfgjudEhjBj2QN9XjeRW832ad0nf09AQvgcfXj9csGBiIJ7IoMsd2soKOzt7DnEB2HjDrKDPztw5cnU1kk8Uh23ljCHel0h5a7DMeAAYr1rdOOS-BAi6bkQyACTZo57rPJgpyNc8NkZk-eL88cxB-8hekcVzWEU13yhG1b900UcTnoKIER53DPEHfc1aMbt-R5yaC9BEHVHUG7wSgEl-ldGdfLPO0Ei22JJO2lTYOLwoLI0rdydqiLYQ6D1V0Yb0rnOYo0_l7FecfQMsc3F75bzv69yRr-cYTrUYnN7Z89bvpfVZKeuWBXXA
sa@ubuntu22:~/9.6$
```

Готовая инфраструктура:

```console
sa@ubuntu22:~/9.6$ yc container cluster list
+----------------------+---------------+---------------------+---------+---------+------------------------+--------------------+
|          ID          |     NAME      |     CREATED AT      | HEALTH  | STATUS  |   EXTERNAL ENDPOINT    | INTERNAL ENDPOINT  |
+----------------------+---------------+---------------------+---------+---------+------------------------+--------------------+
| catlhql0n9ct3csi8obv | kuber-cluster | 2022-11-12 15:07:44 | HEALTHY | RUNNING | https://130.193.51.221 | https://10.128.0.8 |
+----------------------+---------------+---------------------+---------+---------+------------------------+--------------------+

sa@ubuntu22:~/9.6$ yc container registry list
+----------------------+-------------+----------------------+
|          ID          |    NAME     |      FOLDER ID       |
+----------------------+-------------+----------------------+
| crpmbgvfrehkdo5qvkgc | sa-registry | b1g3ol70h1opu6hr9kie |
+----------------------+-------------+----------------------+
```

В ходе работы было создано несколько **runner**. Первый - созданный из проекта по инструкции (блокируется для проекта):

```console
sa@ubuntu22:~/9.6$ helm repo add gitlab https://charts.gitlab.io
"gitlab" has been added to your repositories
sa@ubuntu22:~/9.6$ helm install --namespace default gitlab-runner -f values.yaml gitlab/gitlab-runner
NAME: gitlab-runner
LAST DEPLOYED: Sat Nov 12 16:47:37 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Your GitLab Runner should now be registered against the GitLab instance reachable at: "https://artemshtepa.gitlab.yandexcloud.net/"

Runner namespace "default" was found in runners.config template.
sa@ubuntu22:~/9.6$ kubectl get pods -n default | grep gitlab-runner
gitlab-runner-84cf6bc67c-rp4m8   1/1     Running   0          40s
sa@ubuntu22:~/9.6$
```

После остановки и возобновления работы кластера машины сменили идентификаторы и первый **runner** был перерегистрирован как второй, который впоследствии также был удалён.

После чего отдельно был создан **shared runner** с административных страниц (доступен всем проектам):

```console
sa@ubuntu22:~/9.6$ helm upgrade --namespace default gitlab-runner -f values.yaml gitlab/gitlab-runner
Release "gitlab-runner" has been upgraded. Happy Helming!
NAME: gitlab-runner
LAST DEPLOYED: Sun Nov 13 21:21:50 2022
NAMESPACE: default
STATUS: deployed
REVISION: 2
TEST SUITE: None
NOTES:
Your GitLab Runner should now be registered against the GitLab instance reachable at: "https://artemshtepa.gitlab.yandexcloud.net/"

Runner namespace "default" was found in runners.config template.
sa@ubuntu22:~/9.6$ kubectl get pods -n default | grep gitlab-runner
gitlab-runner-859cc65fc-2wnzp   1/1     Running   0          31m
sa@ubuntu22:~/9.6$
```

> В **GitLab** ветка по умолчанию изменена на `master`

---

## Основная часть

### DevOps

> В репозитории содержится код проекта на python. Проект - RESTful API сервис.
> Ваша задача автоматизировать сборку образа с выполнением python-скрипта:
> 1. Образ собирается на основе [centos:7](https://hub.docker.com/_/centos?tab=tags&page=1&ordering=last_updated)
> 2. Python версии не ниже 3.7
> 3. Установлены зависимости: `flask` `flask-restful`
> 4. Создана директория `/python_api`
> 5. Скрипт из репозитория размещён в `/python_api`
> 6. Точка вызова: запуск скрипта
> 7. Если сборка происходит на ветке `master`: должен подняться pod kubernetes на основе образа `python-api`, иначе этот шаг нужно пропустить

Установка зависимостей будет осуществляться через `requirements.txt`

```
flask
flask-restful
```

Подготовленный файл контейнера `Dockerfile`

```dockerfile
FROM centos:7

RUN yum install python3 python3-pip -y
ADD requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
RUN mkdir /python_api
ADD src/python-api.py /python_api/main.py
CMD ["python3","/python_api/main.py"]
```

В проект добавлены переменные:
  - `KUBE_URL` - IP адрес кластера **Kubernates**
  - `KUBE_TOKEN` - ключ доступа **Kubernates**
  - `SERVER_IMAGE` - имя **Docker** образа, который будет разворачиваться на поде

Настройка сборочных линий: `.gitlab-ci.yml`

```yaml
stages:
  - build
  - deploy

build-image:
  stage: build
  variables:
    DOCKER_DRIVER: overlay2
    DOCKER_TLS_CERTDIR: ""
    DOCKER_HOST: tcp://localhost:2375/
  image: cr.yandex/yc/metadata-token-docker-helper:0.2
  services:
    - docker:19.03.1-dind
  script:
    - docker build . -t python-api:$CI_COMMIT_SHORT_SHA
    - docker tag python-api:$CI_COMMIT_SHORT_SHA cr.yandex/crpmbgvfrehkdo5qvkgc/$SERVER_IMAGE
    - docker push cr.yandex/crpmbgvfrehkdo5qvkgc/$SERVER_IMAGE
  rules:
    - changes:
      - src/*
      - Dockerfile
      - requirements.txt
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
      when: never

deploy-image:
  stage: deploy
  image: gcr.io/cloud-builders/kubectl:latest
  script:
    - kubectl config set-cluster k8s --server="$KUBE_URL" --insecure-skip-tls-verify=true
    - kubectl config set-credentials admin --token="$KUBE_TOKEN"
    - kubectl config set-context default --cluster=k8s --user=admin
    - kubectl config use-context default
    - sed -i "s/__VERSION__/$SERVER_IMAGE/" k8s.yaml
    - kubectl apply -f k8s.yaml
  only:
    - master
```

Этап `build-image` запускается при условиях изменения кода **api сервера**, либо используемая ветка - не основная (точнее, если ветка основная, то **job** не добавлять в **pipeline**)
Первое условие оставлено для того, чтобы не получить "вечно запускающийся" **pod**, когда в **registry** отсутствует **Docker** образ.
После первого **commit** правила **rules** заменены в соответствии с условиями задачи на **except**

Результат операций инициализации проекта (добавление всех файлов проекта и конфигурирование **CI/CD**) и замены правил:
![build-deploy](img/build-deploy.png)

Функционирование контейнера в **pod kubernates**:
![kuber_log](img/kuber_log.png)

---

### Product Owner

> Вашему проекту нужна бизнесовая доработка - необходимо поменять **JSON** ответа на вызов метода **GET** `/get_info`, необходимо создать **Issue** в котором указать:
> 1. Какой метод необходимо исправить
> 2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`
> 3. **Issue** поставить **label: feature**

![issue_list](img/issue_list.png)

---

### Developer

> Вам пришел новый **Issue** на доработку, вам необходимо:
> 1. Создать отдельную ветку, связанную с этим **issue**
> 2. Внести изменения по тексту из задания
> 3. Подготовить Merge Requst, влить необходимые изменения в `master`, проверить, что сборка прошла успешно

Число назначенных задач отмечаются в интерфейсе в верхнем правом углу.
Кликнув на эту иконку выводится список всех задач, включающих назначенные **issue**.

![todo](img/todo.png)

Прямо из окна **Issue** можно сразу создать отдельную ветку и предварительный **Merge request**:
![issue_view](img/issue_view.png)

> После создания **Issue** и **Merge request** обновляются индикаторы на соответствующих иконках.

Открыв **Merge request** можно скачать связанную ветку, либо открыть её в **Web IDE**:
![mr_code](img/mr_code.png)

После внесения изменений и отправки **commit** автоматически будет запущена сборка нового **Docker** образа, что отобразится на странице **Merge request**
![mr_ready](img/mr_ready.png)

Также на данной странице можно посмотреть внесённые изменения (вкладка **Changes**), какие **Commits** были произведены, а также какие **Pipeline** и с каким результатом были выполнены.

Так как заголовок **Merge request** начинается с `Draft:`, то он считается предварительным и должен быть помечен как готовый (кнопка **Mark as ready**)

---

### Tester

> Разработчики выполнили новый Issue, необходимо проверить валидность изменений:
> 1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность
> 2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый

Аналогично роли **Developer** число "висящих" задач показывается на иконках в правом верхнем углу.

Для проверки в ручном режиме нужно загрузить контейнер с **registry**, для чего потребуется авторизоваться [одним из нескольких способов](https://cloud.yandex.ru/docs/container-registry/operations/authentication#method).

Выбран способ авторизация через **token**

```console
sa@ubuntu22:~/9.6$ docker login --username oauth --password AQAAAAADOVxNAATuwW_Wpk1xREErmh4N5XGG3-U cr.yandex
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
WARNING! Your password will be stored unencrypted in /home/sa/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
sa@ubuntu22:~/9.6$
```

Загрузка и запуск контейнера из **registry**

```console
sa@ubuntu22:~/9.6$ docker run -d --rm --name api-test -p 5290:5290 cr.yandex/crpmbgvfrehkdo5qvkgc/python-api:latest
Unable to find image 'cr.yandex/crpmbgvfrehkdo5qvkgc/python-api:latest' locally
latest: Pulling from crpmbgvfrehkdo5qvkgc/python-api
2d473b07cdd5: Already exists
039e7e6b496c: Pull complete
190ba61c057a: Pull complete
5558e787f4c4: Pull complete
edafba2d2acf: Pull complete
ccc0d58256a6: Pull complete
Digest: sha256:7b7d3d20b16ec852e21ecce76f41f6ade378c26efd68f8966f215032e731a31c
Status: Downloaded newer image for cr.yandex/crpmbgvfrehkdo5qvkgc/python-api:latest
718c6cb6d165dbf9bd7a99c7ba897e0e3eda5f40ed8d5f69657f56354ceedfea
sa@ubuntu22:~/9.6$
```

Проверка функционирования метода **get_info**

```console
sa@ubuntu22:~/9.6$ curl -s 127.1:5290/get_info | jq .message
"Running"
sa@ubuntu22:~/9.6$ curl -s 127.1:5290/get_info
{"version": 3, "method": "GET", "message": "Running"}
sa@ubuntu22:~/9.6$
```

> Руководство по [jq (development version)](https://stedolan.github.io/jq/manual/)

---

## Дополнительное задание (Необязательная часть)

> Автомазируйте работу тестировщика, пусть у вас будет отдельный конвейер,
> который автоматически поднимает контейнер и выполняет проверку, например, при помощи curl.
> На основе вывода - будет приниматься решение об успешности прохождения тестирования

Для реализации автоматизации (хотя бы частичной) был дополнен основной **CI/CD** файл репозитория новым блоком `test-image`

```yaml
test-image:
  stage: test
  trigger:
    include: .gitlab-ci-test.yml
  when: manual
  except:
    - master
```

Для блока выбран этап `test` и, ради интереса, ручной запуск `when: manual`.
Можно было оставить стандартное поведение, при котором шаги (**stage**) **test** запускаются только после завершения всех шагов **build** и так далее как определено в директиве `stages`.
Раз таких переопределений нет, то **test-image** запускался бы автоматически после выполнения **build-image**.

Блок подключает отдельный **pipeline** с автоматизацией тестирования `.gitlab-ci-test.yml` со следующим содержимым:

```yaml
stages:
  - test

test:
  stage: test
  variables:
    DOCKER_DRIVER: overlay2
    DOCKER_TLS_CERTDIR: ""
    DOCKER_HOST: tcp://localhost:2375/
  image: cr.yandex/yc/metadata-token-docker-helper:0.2
  services:
    - docker:19.03.1-dind
  script:
    - docker run -d --rm --name api-test -p 5290:5290 cr.yandex/crpmbgvfrehkdo5qvkgc/$SERVER_IMAGE
    - sleep 3
    - curl -s 127.0.0.1:5290/get_info
    - docker stop api-test
```

Так как в данном **pipeline** используется [Docker Credential helper](https://cloud.yandex.ru/docs/container-registry/operations/authentication#cred-helper), то выполнять авторизацию **Docker** в **registry** не нужно.

Представление конвейера сборки:
![pipeline](img/pipeline.png)

Лог тестирования **Docker** образа:
![test_log](img/test_log.png)

---

Финальная версия репозитория представлена в [директории](./repository)
