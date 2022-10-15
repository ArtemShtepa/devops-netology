# Домашнее задание по лекции "11.2 Микросервисы: принципы"

> Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
> Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.

## Обязательная задача 1: API Gateway

> Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.
> 
> Решение должно соответствовать следующим требованиям:
> - Маршрутизация запросов к нужному сервису на основе конфигурации
> - Возможность проверки аутентификационной информации в запросах
> - Обеспечение терминации HTTPS

**Терминация SSL** - это процесс, позволяющий обрабатывать шифрование и дешифрование SSL таким образом,
чтобы трафик между балансировщиком и внутренними серверами был в HTTP.
В данном случае серверы бэкэнда должны быть защищены путем ограничения доступа к IP балансировщика нагрузки.

По хорошему для выбора наиболее подходящего средства для реализации **API Gateway** нужны более конкретные требования, под которые подбираются программные решения.
В условиях постановки задачи перечислены требования только наличия определённых возможностей, поэтому любые продукты у которых они есть по факту являются подходящими с обоснованием "а почему нет ?".
При этом, на мой взгляд, для качественной оценки программных решений нужно исследовать каждый предлагаемый инструмент в отдельности и проводить нагрузочное тестирование для количественной оценки их характеристик и возможностей, что требует большого количества времени.
Поэтому основным критерием отбора в целях обучения будет легковесность решения, простота и доступность использования.

Характеристика | [SberCloud API Gateway](https://sbercloud.ru/ru/products/api-gateway) | [Yandex API Gateway](https://cloud.yandex.ru/docs/api-gateway/) | [nginx](https://nginx.org/ru/) | [HAProxy](https://www.haproxy.org/) | [Kong Gateway](https://docs.konghq.com/gateway/latest/) | [KrakenD](https://www.krakend.io/open-source/) | [Tyk](https://github.com/TykTechnologies/tyk)
--- | --- | --- | --- | --- | --- | --- | ---
Маршрутизация на основе конфигурации | ? | OpenAPI 3.0 | Файлы настроек | Файлы настроек | Файлы настроек | GUI + схема | OpenAPI 2/3
Проверка аутентификационной информации в запросах | Да | Да | Да | Да | Да | Да | Да
Обеспечение терминации HTTPS | Да | Да | [Да](https://www.8host.com/blog/nastrojka-balansirovki-nagruzki-nginx-i-ssl-terminacii/) | [Да](https://www.haproxy.com/blog/haproxy-ssl-termination/) | ? | Да | ?
Стоимость | оплата по факту, до 30.8 р/млн запросов + 3.49 р/ГБ исходящего трафика | 120 р/млн запросов + 1.53 р/ГБ исходящего трафика, до 100000 запросов и 10 ГБ трафика не тарифицируется | бесплатно | бесплатно | бесплатно | бесплатно | бесплатно

> Тарифы облачных API Gateway указаны на 18 октября 2022

Для небольшого проекта с низкими запросами можно использовать облачные **API Gateway** от `Яндекса` (есть бесплатный объём) или платформу `Сбер` по весьма демократичной цене. Если требуется развернуть **API Gateway** на своём "железе", то достойных вариантов также хватает. Например, классика для обучения: **nginx** - тем более он используется в третьей задаче. Как более быстрая и универсальная альтернатива - **HAProxy**. Однако, из рассмотренных маркетинговых материалов меня заинтересовал `KrakenD`, написанный на **Go** изначально с прицелом на производительность (до 7 раз быстрее **Tyk** и до 2 раз быстрее **Kong**), низким потребление памяти (100 MB на высоконагруженных нодах), **Stateless** (режим работы без сохранения состояния) и другими интересными функциями, включая также хорошую/понятную документацию и возможность установки через образ **Docker**.

---

## Обязательная задача 2: Брокер сообщений

> Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.
> 
> Решение должно соответствовать следующим требованиям:
> - Поддержка кластеризации для обеспечения надежности
> - Хранение сообщений на диске в процессе доставки
> - Высокая скорость работы
> - Поддержка различных форматов сообщений
> - Разделение прав доступа к различным потокам сообщений
> - Простота эксплуатации

В условиях нет количественных критериев оценки решения, следовательно подходящими будут являться удовлетворяющие всем требованиям:

Характеристика | [Yandex Message Queue](https://cloud.yandex.ru/docs/message-queue/) | [Apache Kafka](https://kafka.apache.org/) | [RabbitMQ](https://www.rabbitmq.com/) | [Redis](https://redis.io/)
--- | --- | --- | --- | ---
Поддержка кластеризации | Да | Да | [Да](https://www.rabbitmq.com/clustering.html) | [Да](https://redis.io/docs/manual/scaling/)
Хранение сообщений на диске в процессе доставки | [Да](https://cloud.yandex.ru/blog/posts/2019/06/message-queue) | [Да](https://habr.com/ru/company/southbridge/blog/535374/) | [Да](https://www.rabbitmq.com/persistence-conf.html) | [Частично](https://redis.io/docs/manual/persistence/)
Высокая скорость работы | [Существенные ограничения](https://cloud.yandex.ru/docs/message-queue/concepts/limits) | Да | Да | Да
Поддержка различных форматов сообщений | Да | Да | Да | Да
Разделение прав доступа к различным потокам сообщений | [Да](https://cloud.yandex.ru/docs/message-queue/security/) | [Да](https://habr.com/ru/company/nsd/blog/661007/) | [Да](https://www.rabbitmq.com/access-control.html) | [Да](https://redis.io/docs/manual/security/acl/)
Простота эксплуатации | Понятная документация, совместимость с **AWS** инструментами, управление через **GUI** | [Относительно](https://habr.com/ru/company/parimatch_tech/blog/591827/) | [Относительно](https://habr.com/ru/post/434016/) | Простая

> **Redis** - по сути база данных типа ключ/значение, которая изначально хранит данные исключительно в памяти за счёт чего достигается высокая производительность, но существуют механизмы (даже несколько), позволяющие реплицировать данные на диск.

> **Скорость работы** - величина относительная - для небольших проектов пропускная способность в 20000 сообщений в секунду уже с избытком, а где-то, возможно, требуются миллионы, но так как все решения масштабируются, то теоретически можно добиться нужных показателей любыми продуктами.

> **Поддержка различных форматов сообщений** - все брокеры поддерживают передачу текста, а в виде текста можно передать всё, что угодно, вплоть до бинарных данных. Правда при этом будут дополнительные накладные расходы, но это уже дело другое.

Статья: [Kafka vs RabbitMQ - A Head-to-Head Comparison for 2022](https://www.projectpro.io/article/kafka-vs-rabbitmq/451)

Статья: [Сравниваем эффективность Redis, Kafka и RabbitMQ](https://medium.com/nuances-of-programming/сравниваем-эффективность-redis-kafka-и-rabbitmq-fcd363d5d8c)

### Решение

Для начала я бы выбрал **Redis**, как наиболее простой инструмент. Далее можно рассматривать более сложные и специализированные инструменты.

---

## Дополнительная задача 3: API Gateway * (необязательная)

> Есть три сервиса:
> 1. **minio**
>   - Хранит загруженные файлы в бакете images
>   - S3 протокол
> 1. **uploader**
>   - Принимает файл, если он картинка сжимает и загружает его в minio
>   - POST /v1/upload
> 1. **security**
>   - Регистрация пользователя POST /v1/user
>   - Получение информации о пользователе GET /v1/user
>   - Логин пользователя POST /v1/token
>   - Проверка токена GET /v1/token/validation
>
> Необходимо воспользоваться любым балансировщиком и сделать API Gateway:
>
> **POST /v1/register**
> - Анонимный доступ.
> - Запрос направляется в сервис security POST /v1/user
>
> **POST /v1/token**
> - Анонимный доступ.
> - Запрос направляется в сервис security POST /v1/token
>
> **GET /v1/user**
> - Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/
> - Запрос направляется в сервис security GET /v1/user
>
> **POST /v1/upload**
> - Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/
> - Запрос направляется в сервис uploader POST /v1/upload
>
> **GET /v1/user/{image}**
> - Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/
> - Запрос направляется в сервис minio  GET /images/{image}
>
> Результатом выполнения задачи должен быть docker compose файл, запустив который можно локально выполнить следующие команды с успешным результатом.
>
> Предполагается что для реализации API Gateway будет написан конфиг для NGinx или другого балансировщика нагрузки
> который будет запущен как сервис через docker-compose и будет обеспечивать балансировку и проверку аутентификации входящих запросов.
>
> **Авторизация**
> curl -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://localhost/token
>
> **Загрузка файла**
> curl -X POST -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' -H 'Content-Type: octet/stream' --data-binary @yourfilename.jpg http://localhost/upload
> 
> **Получение файла**
> curl -X GET http://localhost/images/4e6df220-295e-4231-82bc-45e4b1484430.jpg

В исходном коде репозитория на первый взгляд есть всё необходимое, кроме конфигурационного файла **nginx**.

При более детальном изучении условий и репозитория у меня создалось впечатление, что задача 3 несколько недоделана -
в истории **Git** видно, что изначально было расписано больше функций для **API**,
некоторые из которых в итоге не реализованы в загрушках сервисов (например, регистрация `/v1/user`).
И потом изначально требуется реализовать **API Gateway** запросов вида `POST /v1/register`, `POST /v1/upload`, `GET /v1/user/{image}`, то есть уже готовый **API**, когда в ожидаемом результате **API** скрыто за простыми линками: `http://localhost/token`, `http://localhost/upload`, `http://localhost/images/{image}`.

Поэтому было принято решение добиться выполнения ожидаемого результата.

В процессе решения задачи было выявлено, что исходыней код из репозитория без изменений, к сожалению, не работает,
так как в актуальной версии **MinIO CLI** команда `mc policy set download <storage>` не приводит к желаемому результату, а именно разрешению анонимной загрузки артефактов.
Данная команда заменена на следующую: `mc anonymous set download <storage>`, где `<storage>` - настраиваемый **bucket** хранилища

Помимо изменения команды в контейнере `createbuckets` внесены следующие изменения:
  - Удалены лишние и неиспользуемые *volumes**
  - В целях отладки для контейнера **storage** указан дополнительны параметр запуска **MinIO** с настройкой порта консоли: `--console-address ":9001"` и проброщен соответствующий порт. Если этого не сделать консоль всё равно функционирует, но номер порта генерируется произвольно, что блокирует доступ к ней извне контейнера. Также изменён путь хранения данных **MinIO** с кэша **Docker** на текущий каталог
  - Так как я использую **rootless** режим работы **Docker**, а он не позволяет пробрасывать привелигерованные порты, то для **nginx** используется порт `8080`. Соответственно все вызовы **API** к `localhost/` заменены на `127.1:8080/`
  - Изменена версия **Flask** c `1.1.1` на `2.1.0` в файле зависимостей `requirements.txt` для контейнера `security`, так как со старой версией контейнер не запускался

Скорректированный файл манифеста **Docker**: [полная версия](src/docker-compose.yml)

```yaml
---
version: "2.4"

services:
  storage:
    image: minio/minio:latest
    command: server /data --console-address ":9001"
    restart: always
    ports:
      - 9001:9001
    expose:
      - 9000
    environment:
      MINIO_ROOT_USER: ${Storage_AccessKey:-STORAGE_ACCESS_KEY}
      MINIO_ROOT_PASSWORD: ${Storage_Secret:-STORAGE_SECRET_KEY}
    volumes:
      - ./data:/data
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 30s
      timeout: 20s
      retries: 3

  createbuckets:
    image: minio/mc
    depends_on:
      - storage
    restart: on-failure
    entrypoint: >
      /bin/sh -c "
      /usr/bin/mc config host add storage http://storage:9000 ${Storage_AccessKey-STORAGE_ACCESS_KEY} ${Storage_Secret-STORAGE_SECRET_KEY} &&
      /usr/bin/mc mb --ignore-existing storage/${Storage_Bucket:-data} &&
      /usr/bin/mc anonymous set download storage/${Storage_Bucket:-data} &&
      echo "OK" && exit 0;
      "

  uploader:
    build: ./uploader
    depends_on:
      - storage
      - createbuckets
    expose:
      - 3000
    environment:
      PORT: 3000
      S3_HOST: storage
      S3_PORT: 9000
      S3_ACCESS_KEY: ${Storage_AccessKey:-STORAGE_ACCESS_KEY}
      S3_ACCESS_SECRET: ${Storage_Secret:-STORAGE_SECRET_KEY}
      S3_BUCKET: ${Storage_Bucket:-STORAGE_BUCKET}

  security:
    build: ./security
    expose:
      - 3000
    environment:
      PORT: 3000

  gateway:
    image: nginx:alpine
    volumes:
      - ./gateway/nginx.conf:/etc/nginx/nginx.conf:ro
    ports:
      - 8080:8080
    depends_on:
      - storage
      - uploader
      - security
...
```
Для настройки nginx использовалась статья [Deploying NGINX as an API Gateway](https://www.nginx.com/blog/deploying-nginx-plus-as-an-api-gateway-part-1)

Готовый конфигурационный файл **nginx**: [расширенная версия](src/gateway/nginx.conf)

```conf
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    keepalive_timeout  65;
    include /etc/nginx/conf.d/*.conf;

    server {
        access_log /var/log/nginx/api_access.log main;
        error_log /var/log/nginx/api_errors.log;

        listen 8080;
        server_name api.example.com;

        location /token {
            proxy_pass http://security:3000/v1/token;
        }
        location /upload {
            proxy_pass http://uploader:3000/v1/upload;
        }
        location /images/ {
            proxy_pass http://storage:9000/data/;
        }

        proxy_intercept_errors on;     # Do not send backend errors to client
        default_type application/json; # If no content-type, assume JSON

        error_page 400 = @400;
        location @400 { return 400 '{"status":400,"message":"Bad request"}\n'; }

        error_page 401 = @401;
        location @401 { return 401 '{"status":401,"message":"Unauthorized"}\n'; }

        error_page 403 = @403;
        location @403 { return 403 '{"status":403,"message":"Forbidden"}\n'; }

        error_page 404 = @404;
        location @404 { return 404 '{"status":404,"message":"Resource not found"}\n'; }
    }
}
```
> В расширенной версии есть шаблон использования кластеризации одного сервиса (разделения запросов к одному сервису на несколько его нод)

Сборка и разворачивание микросервисной архитектуры:
```console
sa@ubuntu22:~/11.2$ docker compose up -d --build
[+] Running 19/19
 ⠿ createbuckets Pulled                                                                                          162.3s
   ⠿ d5d2e87c6892 Pull complete                                                                                  155.8s
   ⠿ 008dba906bf6 Pull complete                                                                                  156.2s
   ⠿ de898acf17e0 Pull complete                                                                                  156.3s
   ⠿ 4662676e8d58 Pull complete                                                                                  156.3s
   ⠿ 47db1b659137 Pull complete                                                                                  157.0s
 ⠿ gateway Pulled                                                                                                 74.7s
   ⠿ 213ec9aee27d Already exists                                                                                   0.0s
   ⠿ 6779501a69ba Pull complete                                                                                   62.5s
   ⠿ f294ffcdfaa8 Pull complete                                                                                   64.9s
   ⠿ 56424afbb509 Pull complete                                                                                   66.5s
   ⠿ 9a1e8d85723a Pull complete                                                                                   68.7s
   ⠿ 5056d2fafbf2 Pull complete                                                                                   69.3s
 ⠿ storage Pulled                                                                                                221.3s
   ⠿ a42f12d8448c Pull complete                                                                                  156.2s
   ⠿ 6830065c2120 Pull complete                                                                                  156.2s
   ⠿ d730d8576296 Pull complete                                                                                  156.3s
   ⠿ 365a45466940 Pull complete                                                                                  156.5s
   ⠿ 9a02c2f411b3 Pull complete                                                                                  215.9s
[+] Building 2.1s (19/19) FINISHED
 => [112_uploader internal] load build definition from Dockerfile                                                  0.0s
 => => transferring dockerfile: 31B                                                                                0.0s
 => [112_security internal] load build definition from Dockerfile                                                  0.0s
 => => transferring dockerfile: 32B                                                                                0.0s
 => [112_uploader internal] load .dockerignore                                                                     0.0s
 => => transferring context: 34B                                                                                   0.0s
 => [112_security internal] load .dockerignore                                                                     0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [112_uploader internal] load metadata for docker.io/library/node:alpine                                        2.0s
 => [112_security internal] load metadata for docker.io/library/python:3.9-alpine                                  1.9s
 => [112_security 1/5] FROM docker.io/library/python:3.9-alpine@sha256:1b193a6cc321bce14e407f84357daa5dd9f4e37aa0  0.0s
 => [112_security internal] load build context                                                                     0.0s
 => => transferring context: 93B                                                                                   0.0s
 => CACHED [112_security 2/5] WORKDIR /app                                                                         0.0s
 => CACHED [112_security 3/5] COPY requirements.txt .                                                              0.0s
 => CACHED [112_security 4/5] RUN pip install -r requirements.txt                                                  0.0s
 => CACHED [112_security 5/5] COPY src ./                                                                          0.0s
 => [112_uploader] exporting to image                                                                              0.0s
 => => exporting layers                                                                                            0.0s
 => => writing image sha256:e147aceec5e83b59ad8709488af2ac284efa4ccf263e90ac747b919f62dbb355                       0.0s
 => => naming to docker.io/library/112_security                                                                    0.0s
 => => writing image sha256:3d8f2cc4eebd1def5eb6f002b93bb3a0fd05bb160c49c2063ffdc48f99abb59b                       0.0s
 => => naming to docker.io/library/112_uploader                                                                    0.0s
 => [112_uploader 1/5] FROM docker.io/library/node:alpine@sha256:fc679ac2b18f0daf41adf9993b4a0e23724c458d1ceed77d  0.0s
 => [112_uploader internal] load build context                                                                     0.0s
 => => transferring context: 128B                                                                                  0.0s
 => CACHED [112_uploader 2/5] WORKDIR /app                                                                         0.0s
 => CACHED [112_uploader 3/5] COPY package*.json ./                                                                0.0s
 => CACHED [112_uploader 4/5] RUN npm install                                                                      0.0s
 => CACHED [112_uploader 5/5] COPY src ./                                                                          0.0s
[+] Running 6/6
 ⠿ Network 112_default            Created                                                                          0.0s
 ⠿ Container 112-storage-1        Started                                                                          0.7s
 ⠿ Container 112-security-1       Started                                                                          0.7s
 ⠿ Container 112-createbuckets-1  Started                                                                          1.1s
 ⠿ Container 112-uploader-1       Started                                                                          1.7s
 ⠿ Container 112-gateway-1        Started                                                                          2.0s
sa@ubuntu22:~/11.2$
```

Проверка авторизации:
```console
sa@ubuntu22:~/11.2$ curl -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://127.1:8080/token && echo
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I
sa@ubuntu22:~/11.2$
```

Загрузка файла в хранилище:
```console
sa@ubuntu22:~/11.2$ curl -X POST -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' -H 'Content-Type: octet/stream' --data-binary @v.jpg http://127.1:8080/upload && echo
{"filename":"b3ce47de-d831-4dfd-8379-03b7fd9db75d.jpg"}
sa@ubuntu22:~/11.2$
```

После успешной загрузки файла в хранилище был создан артефакт с идентификатором `b3ce47de-d831-4dfd-8379-03b7fd9db75d.jpg`
![minio](img/minio.png)

Проверка загрузки артефакта:
```console
sa@ubuntu22:~/11.2$ curl -X GET http://127.1:8080/images/b3ce47de-d831-4dfd-8379-03b7fd9db75d.jpg
Warning: Binary output can mess up your terminal. Use "--output -" to tell
Warning: curl to output it to your terminal anyway, or consider "--output
Warning: <FILE>" to save to a file.
sa@ubuntu22:~/11.2$ curl -X GET http://127.1:8080/images/b3ce47de-d831-4dfd-8379-03b7fd9db75d.jpg --output v2.jpg
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 54961  100 54961    0     0  6317k      0 --:--:-- --:--:-- --:--:-- 6709k
sa@ubuntu22:~/11.2$ ls -la
total 152
drwxrwxr-x  7 sa sa  4096 окт 19 14:06 .
drwxr-x--- 21 sa sa  4096 окт 18 05:32 ..
drwxr-xr-x  4 sa sa  4096 окт 19 12:32 data
-rw-r--r--  1 sa sa  1720 окт 19 12:26 docker-compose.yml
-rw-r--r--  1 sa sa    74 окт 19 11:52 .env
drwxr-xr-x  2 sa sa  4096 окт 19 11:57 gateway
drwxr-xr-x  2 sa sa  4096 окт 19 12:32 logs
-rw-r--r--  1 sa sa  1719 окт 18 05:01 readme.md
drwxr-xr-x  3 sa sa  4096 окт 19 07:41 security
drwxr-xr-x  3 sa sa  4096 окт 19 07:41 uploader
-rw-rw-r--  1 sa sa 54961 окт 19 14:06 v2.jpg
-rw-r--r--  1 sa sa 54961 мар  3  2022 v.jpg
sa@ubuntu22:~/11.2$
```

### Дополнение к реализации **API Gateway**

Сокращённые настройки **nginx** для проксирования запросов из условия задачи:

```
http {
    server {
        location /v1/register {
            proxy_pass http://security:3000/v1/user;
        }
        location /v1/token {
            proxy_pass http://security:3000/v1/token;
        }
        location /v1/user {
            proxy_pass http://security:3000/v1/user;
        }
        location /v1/upload {
            proxy_pass http://uploader:3000/v1/upload;
        }
        location /v1/user/images/ {
            proxy_pass http://storage:9000/data/;
        }
    }
}
```

Однако, в этом примере последние три блоках не содержат проверки токена на сервисе **security**, а просто проксируют запрос.
Реализовать проверку токена можно с использованием проекта [lua-resty-jwt](https://github.com/SkyLothar/lua-resty-jwt).
Пример реализации можно посмотреть в статье: [Аутентифицируем запросы в микросервисном приложении с помощью nginx и JWT](https://habr.com/ru/post/277677/)

---

#### Дополнительные материалы

- Репозиторий сервисов из задачи 3: [Как запускать, как тестировать, как проверить](https://github.com/netology-code/devkub-homeworks/tree/main/11-microservices-02-principles)
- Статья [Облачные API Gateway](https://habr.com/ru/post/557004/)
- Статья [10 Top Open Source API Gateways and Management Tools](https://www.tecmint.com/open-source-api-gateways-and-management-tools/)
- Статья [Настройка балансировки нагрузки NGINX и SSL-Терминации](https://www.8host.com/blog/nastrojka-balansirovki-nagruzki-nginx-i-ssl-terminacii/)
- Статья [Балансировка нагрузки NGINX](https://www.8host.com/blog/balansirovka-nagruzki-nginx/)
