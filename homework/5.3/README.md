# Домашнее задание по лекции "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Обязательная задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;

- выберете любой образ, который содержит веб-сервер Nginx;

- создайте свой fork образа;

- реализуйте функциональность:

запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:

```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

### Решение

В качестве основы взят официальный образ [Nginx](https://hub.docker.com/_/nginx)

В соответствии с его документацией, директория контента web сервера - `/usr/share/nginx/html`.
Следовательно, чтобы индекс-страница имела требуемое содержание нужно сохранить его HTML-код в файл `index.html` по данному пути.

Итоговый файл Docker манифеста (используется конкретная версия 1.21.6, можно опустить)

```
FROM nginx:1.21.6
RUN  echo "<html><head>Hey, Netology</head><body><h1>I’m DevOps Engineer!</h1></body></html>" >/usr/share/nginx/html/index.html
```

Сборка образа: `docker build -t <имя> <контент>`, где `<имя>` - тэг образа, `<контент>` - каталог для сборки контента

> При использовании DockerHub имя образа должно быть в формате: `пользователь/репозиторий/тэг`

```console
sa@debian:~/docker-1$ sudo docker build -t artemshtepa/my-nginx:1.0 .
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM nginx:1.21.6
1.21.6: Pulling from library/nginx
214ca5fb9032: Pull complete
f0156b83954c: Pull complete
5c4340f87b72: Pull complete
9de84a6a72f5: Pull complete
63f91b232fe3: Pull complete
860d24db679a: Pull complete
Digest: sha256:fd3a964c591d73fd36a32c3b1009e5e5de2d4972e20aae3f537b51876171bce2
Status: Downloaded newer image for nginx:1.21.6
 ---> 7425d3a7c478
Step 2/2 : RUN  echo "<html><head>Hey, Netology</head><body><h1>I’m DevOps Engineer!</h1></body></html>" >/usr/share/nginx/html/index.html
 ---> Running in 50e3423acad0
Removing intermediate container 50e3423acad0
 ---> 18803315c83e
Successfully built 18803315c83e
Successfully tagged artemshtepa/my-nginx:1.0
sa@debian:~/docker-1$
```

Запуск контейнера: `docker run <опции> <образ>`, где `<опции>` - параметры запуска, `<образ>` - имя запускаемого образа

Расшифровка используемых опций:

  - `-d` - создание "отвязанного" контейнера (работает в фоне);

  - `-p 8080:80` - проброс 80 порта контейнера на 8080 порт хоста;

  - `--rm` - удаление контейнера после его остановки;

  - `--name myn` - присвоение создаваемому контейнеру имени `myn`

```console
sa@debian:~/docker-1$ sudo docker run -d -p 8080:80 --rm --name myn artemshtepa/my-nginx:1.0
a2adf2ca7236a3155dcca9d0769e972bff82720891342ce4416247d71ef4b16c
sa@debian:~/docker-1$
```

Проверка функционирования:

```console
sa@debian:~/docker-1$ curl 127.0.0.1:8080
<html><head>Hey, Netology</head><body><h1>I’m DevOps Engineer!</h1></body></html>
sa@debian:~/docker-1$
```

Остановка контейнера: `docker stop <контейнер>`, где `<контейнер>` - имя или ID контейнера

```console
sa@debian:~/docker-1$ sudo docker stop myn
myn
sa@debian:~/docker-1$ sudo docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
sa@debian:~/docker-1$ curl 127.0.0.1:8080
curl: (7) Failed to connect to 127.0.0.1 port 8080: Connection refused
sa@debian:~/docker-1$
```

Авторизация на DockerHub: `docker login -u <пользователь>`, где `<пользователь>` - логин зарегистрированного пользователя DockerHub (DockerID)

```console
sa@debian:~/docker-1$ sudo docker login -u artemshtepa
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
sa@debian:~/docker-1$
```

Отправка образа в DockerHub: `docker push <имя>`, где `<имя>` - имя образа (должно быть в следующем формате: `пользователь/репозиторий/тэг`)

```console
sa@debian:~/docker-1$ sudo docker push artemshtepa/my-nginx:1.0
The push refers to repository [docker.io/artemshtepa/my-nginx]
6e4bbbf95f90: Pushed
feb57d363211: Mounted from library/nginx
98c84706d0f7: Mounted from library/nginx
4311f0ea1a86: Mounted from library/nginx
6d049f642241: Mounted from library/nginx
3158f7304641: Mounted from library/nginx
fd95118eade9: Mounted from library/nginx
1.0: digest: sha256:be603c097575c47dabd78c73364303083251e7826b2c2feaae8cbb094217b714 size: 1777
sa@debian:~/docker-1$
```

Ссылка на репозиторий [my-nginx](https://hub.docker.com/repository/docker/artemshtepa/my-nginx)

---

## Обязательная задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

### Ответ

> Гипотетически, в контейнер можно поместить всё, что угодно, равно как и в виртуальную машину. Считаю, что в общем случае если не требуется полнейшей изоляции и требования одновременного использования разных операционных систем (например, Windows и Linux) всегда лучше использовать контейнеры нежели виртуальные машины. Контейнеризация генерирует меньшие накладных расходов аппаратных ресурсов. Контейнеры быстрее запускаются и останавливаются. Загрузку обновлений контейнеров можно выполнять не останавливая работающие экземпляры. Настройка контейнеров также выглядит проще.

#### **Сценарий "Высоконагруженное монолитное java веб-приложение"**

Для данного сценария контейнеризация, наверное, лучшее решение, так как в сравнении с виртуализацией это позволит сэкономить аппаратные ресурсы хостовой системы, а в сравнении с физической машиной реализовать горизонтальное масштабирование, так как контейнеры также обеспечивают стабильность окружения, но вместе с тем их обновление может быть выполнено значительно быстрее.

#### **Сценарий "Nodejs веб-приложение"**

В данном сценарии также применима контейнеризация - она позволит собрать многочисленные JavaScript модули web-приложения в едином образе и гарантировать стабильность окружения. Также позволит легко переносить прилоежние на другой сервер. Если в приложении возникнет сбой это не отразится на физической машине (изолирование), а контейнер можно будет быстро перезапустить.

#### **Сценарий "Мобильное приложение c версиями для Android и iOS"**

Не уверен, но вряд ли возможно использование контейнеризации на разных ядрах операционных систем. Наверное, больше подойдёт виртуализация.

#### **Сценарий "Шина данных на базе Apache Kafka"**

Apache Kafka - распределенный программный брокер сообщений (определение из [Википедии](https://ru.wikipedia.org/wiki/Apache_Kafka)). Так как система спроектирована как распределённая, горизонтально масштабируемая, то контейнеразация очень хорошо подойдёт для данного сценария, обеспечивая единство окружения всех узлов, простоту наращивания новых и обновления существующих.

#### **Сценарий "Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana"**

Описание сценария включает три группы ([elasticsearch](https://ru.wikipedia.org/wiki/Elasticsearch), logstash, [kibana](https://ru.wikipedia.org/wiki/Kibana)) однотипных сервисов. Значит контейнеры также будет полезны. Сценарий похож на соседние - шину данных и мониторинг, поэтому и обоснования аналогичные - проще масштабирование и обслуживание однотипных нод.

#### **Сценарий "Мониторинг-стек на базе Prometheus и Grafana"**

Контейнеризация вполне подходит и для реализации мониторирования. Благодаря гибкой настройки сети и доступа к аппаратным ресурсам изоляция в контейнеры не помешает мониторингу параметров хостовой машины или её компонентов. Более того, это позволит быстро развернуть мониторинг на новых машинах - достаточно будет запустить аналогичные образы.

#### **Сценарий "MongoDB, как основное хранилище данных для java-приложения"**

В лекции упоминалось, что базу данных не рекомендуется устанавливать в контейнере, так как это создаёт дополнительный лаг при работе с данными по сети и усложняет администрирование.

#### **Сценарий "Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry"**

Одним из способов установки Gitlab как раз и являются образы Docker. Причём их использование значительно упрощает и экономит время на установку, настройку и дальнейшее обслуживание системы, так как всё эти действия грубо говоря сводятся к запуску образа или перезапуску на новом образе при обновлении. Установка, обновление или удаление используемых компонентов выполняется автоматически.

---

## Обязательная задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

### Решение

Подключение каталога осуществляется опциями: `-v <снаружи>:<внутри>`, где `<снаружи>` - монтируемый каталог хоста, `<внутри>` - соответствующий каталог в контейнере

Интерактивный режим активируется комбинацией ключей: `-i` (сохранение потока STDIN) и `-t` (создание псердотерминала TTY)

Предварительно создан каталог `data`

Запуск первого контейнера на основе образа **centos** (используется тэг [centos8](https://hub.docker.com/layers/centos/library/centos/centos8/images/sha256-a1801b843b1bfaf77c501e7a6d3f709401a1e0c83863037fa3aab063a7fdb9dc?context=explore) для репозитория [centos](https://hub.docker.com/_/centos))

```console
sa@debian:~/docker-1$ sudo docker run -i -t -d --rm --name c_centos8 -v $(pwd)/data:/data centos:centos8
Unable to find image 'centos:centos8' locally
centos8: Pulling from library/centos
a1d0c7532777: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:centos8
c6eb958a1f98612d7c1fe562f4593de1e5ab299aaa723d60505657bdd4c4a6f3
sa@debian:~/docker-1$ sudo docker ps
CONTAINER ID   IMAGE            COMMAND       CREATED         STATUS         PORTS     NAMES
c6eb958a1f98   centos:centos8   "/bin/bash"   6 seconds ago   Up 5 seconds             c_centos8
sa@debian:~/docker-1$
```

Запуск второго контейнера на основе образа **debian** (репозиторий [debian](https://hub.docker.com/_/debian) без тэга)

```console
sa@debian:~/docker-1$ sudo docker run -i -t -d --rm --name c_debian -v $(pwd)/data:/data debian
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
67e8aa6c8bbc: Pull complete
Digest: sha256:6137c67e2009e881526386c42ba99b3657e4f92f546814a33d35b14e60579777
Status: Downloaded newer image for debian:latest
1275b2aa17fa464221bba2bff2ee2a47963163493405117cd94950118bb4dcc0
sa@debian:~/docker-1$ sudo docker ps
CONTAINER ID   IMAGE            COMMAND       CREATED          STATUS          PORTS     NAMES
1275b2aa17fa   debian           "bash"        10 minutes ago   Up 10 minutes             c_debian
c6eb958a1f98   centos:centos8   "/bin/bash"   15 minutes ago   Up 15 minutes             c_centos8
sa@debian:~/docker-1$
```

Создание файла в контейнере `c_centos8`

```console
sa@debian:~/docker-1$ sudo docker exec -it c_centos8 bash
[root@c6eb958a1f98 /]# echo "data1">/data/file1 && cat /data/file1
data1
[root@c6eb958a1f98 /]# exit
exit
sa@debian:~/docker-1$
```

Создание второго файла на хостовой машине

```console
sa@debian:~/docker-1$ echo "data2">data/file2 && cat data/file2
data2
sa@debian:~/docker-1$
```

Проверка монтирования каталога (содержимого файлов) во втором контейнере (`c_debian`)

```console
sa@debian:~/docker-1$ sudo docker exec -it c_debian bash
root@1275b2aa17fa:/# ls /data && cat $(find /data/*)
file1  file2
data1
data2
root@1275b2aa17fa:/# exit
exit
sa@debian:~/docker-1$
```

---

## Дополнительная задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

Лог сборки с проверки (усечённый)

```console
sa@debian:~/docker-2$ cat Dockerfile
FROM alpine:3.14

RUN CARGO_NET_GIT_FETCH_WITH_CLI=1 && \
    apk --no-cache add \
        sudo \
        python3\
        py3-pip \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        git && \
    apk --no-cache add --virtual build-dependencies \
        python3-dev \
        libffi-dev \
        musl-dev \
        gcc \
        cargo \
        openssl-dev \
        libressl-dev \
        build-base && \
    pip install --upgrade pip wheel && \
    pip install --upgrade cryptography cffi && \
    pip uninstall ansible-base && \
    pip install ansible-core && \
    pip install ansible==2.10.0 && \
    pip install mitogen ansible-lint jmespath && \
    pip install --upgrade pywinrm && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/pip && \
    rm -rf /root/.cargo

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]
sa@debian:~/docker-2$ sudo docker build -t artemshtepa/ansible:2.10 .
Sending build context to Docker daemon  3.072kB
Step 1/5 : FROM alpine:3.14
3.14: Pulling from library/alpine
8663204ce13b: Pull complete
Digest: sha256:06b5d462c92fc39303e6363c65e074559f8d6b1363250027ed5053557e3398c5
Status: Downloaded newer image for alpine:3.14
 ---> e04c818066af
Step 2/5 : RUN CARGO_NET_GIT_FETCH_WITH_CLI=1 &&     apk --no-cache add         sudo         python3        py3-pip         openssl         ca-certificates         sshpass         openssh-client         rsync         git &&     apk --no-cache add --virtual build-dependencies         python3-dev         libffi-dev         musl-dev         gcc         cargo         openssl-dev         libressl-dev         build-base &&     pip install --upgrade pip wheel &&     pip install --upgrade cryptography cffi &&     pip uninstall ansible-base &&     pip install ansible-core &&     pip install ansible==2.10.0 &&     pip install mitogen ansible-lint jmespath &&     pip install --upgrade pywinrm &&     apk del build-dependencies &&     rm -rf /var/cache/apk/* &&     rm -rf /root/.cache/pip &&     rm -rf /root/.cargo
 ---> Running in c9df420defb3
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/community/x86_64/APKINDEX.tar.gz
(1/55) Installing ca-certificates (20211220-r0)
(2/55) Installing brotli-libs (1.0.9-r5)
(3/55) Installing nghttp2-libs (1.43.0-r0)
(4/55) Installing libcurl (7.79.1-r1)
(5/55) Installing expat (2.4.7-r0)
(6/55) Installing pcre2 (10.36-r0)
(7/55) Installing git (2.32.1-r0)
(8/55) Installing openssh-keygen (8.6_p1-r3)
(9/55) Installing ncurses-terminfo-base (6.2_p20210612-r0)
(10/55) Installing ncurses-libs (6.2_p20210612-r0)
(11/55) Installing libedit (20210216.3.1-r0)
(12/55) Installing openssh-client-common (8.6_p1-r3)
(13/55) Installing openssh-client-default (8.6_p1-r3)
(14/55) Installing openssl (1.1.1n-r0)
(15/55) Installing libbz2 (1.0.8-r1)
(16/55) Installing libffi (3.3-r2)
(17/55) Installing gdbm (1.19-r0)
(18/55) Installing xz-libs (5.2.5-r1)
(19/55) Installing libgcc (10.3.1_git20210424-r2)
(20/55) Installing libstdc++ (10.3.1_git20210424-r2)
(21/55) Installing mpdecimal (2.5.1-r1)
(22/55) Installing readline (8.1.0-r0)
(23/55) Installing sqlite-libs (3.35.5-r0)
(24/55) Installing python3 (3.9.5-r2)
(25/55) Installing py3-appdirs (1.4.4-r2)
(26/55) Installing py3-chardet (4.0.0-r2)
(27/55) Installing py3-idna (3.2-r0)
(28/55) Installing py3-urllib3 (1.26.5-r0)
(29/55) Installing py3-certifi (2020.12.5-r1)
(30/55) Installing py3-requests (2.25.1-r4)
(31/55) Installing py3-msgpack (1.0.2-r1)
(32/55) Installing py3-lockfile (0.12.2-r4)

...

(31/37) Purging libxml2 (2.9.14-r0)
(32/37) Purging libgit2 (1.1.0-r2)
(33/37) Purging http-parser (2.9.4-r0)
(34/37) Purging pcre (8.44-r0)
(35/37) Purging libssh2 (1.9.0-r1)
(36/37) Purging libressl3.3-libcrypto (3.3.6-r0)
(37/37) Purging libmagic (5.40-r1)
Executing busybox-1.33.1-r7.trigger
OK: 98 MiB in 69 packages
Removing intermediate container c9df420defb3
 ---> 324066a17975
Step 3/5 : RUN mkdir /ansible &&     mkdir -p /etc/ansible &&     echo 'localhost' > /etc/ansible/hosts
 ---> Running in 6bc03e546f79
Removing intermediate container 6bc03e546f79
 ---> 34d4828f740a
Step 4/5 : WORKDIR /ansible
 ---> Running in 6b8dabb00257
Removing intermediate container 6b8dabb00257
 ---> b750776af4f6
Step 5/5 : CMD [ "ansible-playbook", "--version" ]
 ---> Running in cae6b1207241
Removing intermediate container cae6b1207241
 ---> a5d2c0ccda8b
Successfully built a5d2c0ccda8b
Successfully tagged artemshtepa/ansible:2.10
sa@debian:~/docker-2$ sudo docker run --rm artemshtepa/ansible:2.10
ansible-playbook 2.10.17
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.9/site-packages/ansible
  executable location = /usr/bin/ansible-playbook
  python version = 3.9.5 (default, Nov 24 2021, 21:19:13) [GCC 10.3.1 20210424]
sa@debian:~/docker-2$ sudo docker login -u artemshtepa
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
sa@debian:~/docker-2$ sudo docker images
REPOSITORY             TAG       IMAGE ID       CREATED          SIZE
artemshtepa/ansible    2.10      a5d2c0ccda8b   26 seconds ago   376MB
artemshtepa/my-nginx   1.0       18803315c83e   2 hours ago      142MB
nginx                  1.21.6    7425d3a7c478   5 hours ago      142MB
debian                 latest    c4905f2a4f97   9 hours ago      124MB
alpine                 3.14      e04c818066af   5 weeks ago      5.59MB
centos                 centos8   5d0da3dc9764   7 months ago     231MB
sa@debian:~/docker-2$ sudo docker push artemshtepa/ansible:2.10
The push refers to repository [docker.io/artemshtepa/ansible]
6027012cb152: Pushed
c1907cd60721: Pushed
b541d28bf3b4: Mounted from library/alpine
2.10: digest: sha256:028caf89d1e90057e8bcd48d172eefcd090adb07cb235e191549a0c4e21e4dba size: 947
sa@debian:~/docker-2$
```

Ссылка на репозиторий [ansible](https://hub.docker.com/repository/docker/artemshtepa/ansible)
