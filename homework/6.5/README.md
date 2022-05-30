# Домашнее задание к занятию "6.5. Elasticsearch"

## Обязательная задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [elasticsearch:7](https://hub.docker.com/_/elasticsearch) как базовый:

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib` 
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения
- обратите внимание на настройки безопасности такие как `xpack.security.enabled` 
- если докер образ не запускается и падает с ошибкой 137 в этом случае может помочь настройка `-e ES_HEAP_SIZE`
- при настройке `path` возможно потребуется настройка прав доступа на директорию

**Решение:**

Для создания образа в качестве основы был взят образ [elasticsearch:7.17.4](https://hub.docker.com/_/elasticsearch)

> Тэги major веток (например, `elasticsearch:7`) на момент выполнения задачи не поддерживаются. Только конкретные версии.

Документация к текущей версии [Elasticsearch 7.17](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/index.html)

> Запуск Elasticsearch в Developer режиме: `docker run -d --name es -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.17.4`

> Директория конфигурационных файлов **elasticsearch**: `/usr/share/elasticsearch/config`

Исходные файлы для сборки образа:

Конфигурационный файл **ElasticSearch** [открыть](src/elasticsearch.yml)

```yaml
cluster.name: "my-elastic-cluster"
network.host: 0.0.0.0

path:
  data: /var/lib/elasticsearch/data
  logs: /var/log/elasticsearch
  repo: /usr/share/elasticsearch/snapshots

node.name: ${ES_NODE_NAME}
```

Файл сборки образа Docker (`Dockerfile`, запуск сборки `sudo docker build --tag artemshtepa/my-es-7:1 .`) [открыть](Dockerfile)

```console
FROM elasticsearch:7.17.4
COPY src/ /usr/share/elasticsearch/config/
RUN mkdir /var/log/elasticsearch && chown elasticsearch /var/log/elasticsearch &&\
    mkdir /var/lib/elasticsearch && chown elasticsearch /var/lib/elasticsearch &&\
    mkdir /var/lib/elasticsearch/data && chown elasticsearch /var/lib/elasticsearch/data &&\
    mkdir /usr/share/elasticsearch/snapshots && chown -R elasticsearch /usr/share/elasticsearch/snapshots &&\
    chmod -R o+rwx /usr/share/elasticsearch/snapshots
```

Файл **Docker Compose** для **ElasticSearch** (запуск `sudo docker compose up -d`) [открыть](docker-compose.yml)

```yaml
version: "2.4"

services:
  es-node-1:
    image: artemshtepa/my-es-7:2
    container_name: es-master
    restart: always
    environment:
      - ES_NODE_NAME=netology_test
      - discovery.type=single-node
    volumes:
      - ./es-data:/var/lib/elasticsearch/data
      - ./es-backup:/usr/share/elasticsearch/snapshots
    ports:
      - 9200:9200
    expose:
      - 9300
```

Ссылка на репозиторий моих образов **ElasticSearch** в [DockerHub](https://hub.docker.com/repository/docker/artemshtepa/my-es-7)

> Последняя версия образа с тегом 2. От первого отличается настройкой каталога `snapshots`

Ответ **Elasticsearch**:

```console
sa@debian:~/db-65$ curl 127.1:9200
{
  "name" : "netology_test",
  "cluster_name" : "my-elastic-cluster",
  "cluster_uuid" : "-WJUlF3OSL-Jbcv-e6agmw",
  "version" : {
    "number" : "7.17.4",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "79878662c54c886ae89206c685d9f1051a9d6411",
    "build_date" : "2022-05-18T18:04:20.964345128Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
sa@debian:~/db-65$
```

> Остановка и удаление контейнера: `sudo docker compose down`

---

## Обязательная задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

**Решение:**

Добавление индексов:

```console
sa@debian:~/db-65$ curl -X PUT "127.1:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'{"settings":{"index":{"number_of_replicas":0,"number_of_shards":1}}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}
sa@debian:~/db-65$ curl -X PUT "127.1:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'{"settings":{"index":{"number_of_replicas":1,"number_of_shards":2}}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}
sa@debian:~/db-65$ curl -X PUT "127.1:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'{"settings":{"index":{"number_of_replicas":2,"number_of_shards":4}}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}
sa@debian:~/db-65$
```

Получение списка индексов и их статуса:

```console
sa@debian:~/db-65$ curl -X GET "127.1:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases O0uKXf0DS4u0A4wx0E1y7Q   1   0         40            0     38.1mb         38.1mb
green  open   ind-1            DaFG-kr7SqGawY925-BT2Q   1   0          0            0       226b           226b
yellow open   ind-3            cARHivv6T6aj9W6kg7NA6Q   4   2          0            0       904b           904b
yellow open   ind-2            rPkSDnReSk-MDS6M-W15iw   2   1          0            0       452b           452b
sa@debian:~/db-65$
```

Индексы `ind-2` и `ind-3` имеют статус `yellow`, так как они должны иметь **1** и **2** реплики соответственно, а из-за того что у нас всего одна дата нода, то ElasticSearch не может разместить их шарды - некуда. В отличии от них индекс `ind-1` не предполагает ни одной реплики, поэтому его статус `green`.

Получение состояния кластера:

```console
sa@debian:~/db-65$ curl -X GET "127.1:9200/_cluster/health?pretty=true"
{
  "cluster_name" : "my-elastic-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
sa@debian:~/db-65$
```

Кластер имеет статус `yellow` так как имеются неразмещённые шарды в количестве **10** штук (поле `unassigned_shards`), которые состоят из **двух** шардов **одной** реплики индекса `ind-2` и **восьми** шардов **двух** реплик (по **4** в каждой) индекса `ind-3`, что подтвержается выводом состояния шардов:

```console
sa@debian:~/db-65$ curl -X GET "127.1:9200/_cat/shards?v"
index                                                         shard prirep state      docs  store ip         node
ind-2                                                         1     p      STARTED       0   226b 172.19.0.2 netology_test
ind-2                                                         1     r      UNASSIGNED
ind-2                                                         0     p      STARTED       0   226b 172.19.0.2 netology_test
ind-2                                                         0     r      UNASSIGNED
.ds-ilm-history-5-2022.06.02-000001                           0     p      STARTED                172.19.0.2 netology_test
.ds-.logs-deprecation.elasticsearch-default-2022.06.02-000001 0     p      STARTED                172.19.0.2 netology_test
.geoip_databases                                              0     p      STARTED      40 38.1mb 172.19.0.2 netology_test
ind-1                                                         0     p      STARTED       0   226b 172.19.0.2 netology_test
ind-3                                                         3     p      STARTED       0   226b 172.19.0.2 netology_test
ind-3                                                         3     r      UNASSIGNED
ind-3                                                         3     r      UNASSIGNED
ind-3                                                         2     p      STARTED       0   226b 172.19.0.2 netology_test
ind-3                                                         2     r      UNASSIGNED
ind-3                                                         2     r      UNASSIGNED
ind-3                                                         1     p      STARTED       0   226b 172.19.0.2 netology_test
ind-3                                                         1     r      UNASSIGNED
ind-3                                                         1     r      UNASSIGNED
ind-3                                                         0     p      STARTED       0   226b 172.19.0.2 netology_test
ind-3                                                         0     r      UNASSIGNED
ind-3                                                         0     r      UNASSIGNED
sa@debian:~/db-65$
```

Удаление всех индексов (и проверка статуса кластера - должен быть `green`):

```console
sa@debian:~/db-65$ curl -X DELETE "127.1:9200/ind-1?pretty"
{
  "acknowledged" : true
}
sa@debian:~/db-65$ curl -X DELETE "127.1:9200/ind-2?pretty"
{
  "acknowledged" : true
}
sa@debian:~/db-65$ curl -X DELETE "127.1:9200/ind-3?pretty"
{
  "acknowledged" : true
}
sa@debian:~/db-65$ curl -X GET "127.1:9200/_cluster/health?pretty"
{
  "cluster_name" : "my-elastic-cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 3,
  "active_shards" : 3,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
sa@debian:~/db-65$
```

---

## Обязательная задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние кластера `elasticsearch` из `snapshot`, созданного ранее.

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

**Решение:**

> Изменения конфигурационного файла `elasticsearch.yml` были произведены в задаче 1

Регистрация репозитория снапшотов:

> В данном примере регистрируется репозиторий снапшотов с именем `netology_backup` в виде файловой системы (`type: 'fs'`) и расположением (`location`) `netology`, то есть в каталоге бэкапов по пути `path.repo` будет создан каталог `netology`, где и будут располагаться снапшоты.

```console
sa@debian:~/db-65$ curl -X PUT "127.1:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'{"type":"fs","settings":{"location":"netology","compress":true}}'
{
  "acknowledged" : true
}
sa@debian:~/db-65$
```

Создание индекса `test`:

```console
sa@debian:~/db-65$ curl -X PUT "127.1:9200/test?pretty" -H 'Content-Type: application/json' -d'{"settings":{"index":{"number_of_replicas":0,"number_of_shards":1}}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
sa@debian:~/db-65$ curl -X GET "127.1:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases WVlDgI0lSVm7X9KvbCCKMA   1   0         11            0       10mb           10mb
green  open   test             47lISQgjQuKRRq44BMtBUA   1   0          0            0       226b           226b
sa@debian:~/db-65$
```

Создание снапшотов в репозитории `netology_backup` для кластера `dump_all` и отдельно для индекса **test** `dump`:

```console
sa@debian:~/db-65$ curl -X PUT "127.1:9200/_snapshot/netology_backup/dump?wait_for_completion=true&pretty" -H 'Content-Type: application/json' -d'{"indices":["test"]}'
{
  "snapshot" : {
    "snapshot" : "dump",
    "uuid" : "JbdurVGPQfSNpXY3OyJPhA",
    "repository" : "netology_backup",
    "version_id" : 7170499,
    "version" : "7.17.4",
    "indices" : [
      ".geoip_databases",
      "test"
    ],
    "data_streams" : [ ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-06-02T13:26:35.097Z",
    "start_time_in_millis" : 1654176395097,
    "end_time" : "2022-06-02T13:26:35.698Z",
    "end_time_in_millis" : 1654176395698,
    "duration_in_millis" : 601,
    "failures" : [ ],
    "shards" : {
      "total" : 2,
      "failed" : 0,
      "successful" : 2
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}
sa@debian:~/db-65$ curl -X PUT "127.1:9200/_snapshot/netology_backup/dump_all?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "dump_all",
    "uuid" : "ObXwMmPGRtafnKdHrCoE4g",
    "repository" : "netology_backup",
    "version_id" : 7170499,
    "version" : "7.17.4",
    "indices" : [
      "test",
      ".geoip_databases",
      ".ds-.logs-deprecation.elasticsearch-default-2022.06.02-000001",
      ".ds-ilm-history-5-2022.06.02-000001"
    ],
    "data_streams" : [
      "ilm-history-5",
      ".logs-deprecation.elasticsearch-default"
    ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-06-02T13:26:54.341Z",
    "start_time_in_millis" : 1654176414341,
    "end_time" : "2022-06-02T13:26:54.942Z",
    "end_time_in_millis" : 1654176414942,
    "duration_in_millis" : 601,
    "failures" : [ ],
    "shards" : {
      "total" : 4,
      "failed" : 0,
      "successful" : 4
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}
sa@debian:~/db-65$
```

> В снапшот `dump` попал системный индекс `.geoip_databases`. Чтобы его не было нужно отключить используемый плагин GeoIP внеся в конфигурационный файл `elasticsearch.yml` строку `ingest.geoip.downloader.enabled: false`, либо добавить переменную окружения в `docker-compose.yml` (`ingest.geoip.downloader.enabled=false`). Изменения должны быть внесены до первого старта ElasticSearch.

> При создании снапшота всего кластера `dump_all` в него попали ещё больше системных индексов, таких как `.ds-.logs-deprecation.elasticsearch-default-2022.06.02-000001` и `.ds-ilm-history-5-2022.06.02-000001`, которые будут в дальнейшем мешать восстаовлению наших индексов (если не используется извлечение конкретного индекса)

Вывод списка файлов в каталоге снапшотов:

> Каталог `es-backup` является подключаемым томом для используемого контейнера

```console
sa@debian:~/db-65$ find ~/db-65/es-backup/
/home/sa/db-65/es-backup/
/home/sa/db-65/es-backup/netology
/home/sa/db-65/es-backup/netology/snap-ObXwMmPGRtafnKdHrCoE4g.dat
/home/sa/db-65/es-backup/netology/meta-ObXwMmPGRtafnKdHrCoE4g.dat
/home/sa/db-65/es-backup/netology/meta-JbdurVGPQfSNpXY3OyJPhA.dat
/home/sa/db-65/es-backup/netology/index-1
/home/sa/db-65/es-backup/netology/snap-JbdurVGPQfSNpXY3OyJPhA.dat
/home/sa/db-65/es-backup/netology/index.latest
/home/sa/db-65/es-backup/netology/indices
/home/sa/db-65/es-backup/netology/indices/4iEB7J88RhSo0FZbWzOykw
/home/sa/db-65/es-backup/netology/indices/4iEB7J88RhSo0FZbWzOykw/0
/home/sa/db-65/es-backup/netology/indices/4iEB7J88RhSo0FZbWzOykw/0/snap-ObXwMmPGRtafnKdHrCoE4g.dat
/home/sa/db-65/es-backup/netology/indices/4iEB7J88RhSo0FZbWzOykw/0/__JdybeYLJRpePiFkZNlE96w
/home/sa/db-65/es-backup/netology/indices/4iEB7J88RhSo0FZbWzOykw/0/__9hHNEpM9RxafnueOQWzICA
/home/sa/db-65/es-backup/netology/indices/4iEB7J88RhSo0FZbWzOykw/0/index-g4otQS7oShS8t8FQfbZsyw
/home/sa/db-65/es-backup/netology/indices/4iEB7J88RhSo0FZbWzOykw/meta-IpCYJIEBYtxwE0ke_UFO.dat
/home/sa/db-65/es-backup/netology/indices/IX3NgcmeR1Wye-bunlXnUA
/home/sa/db-65/es-backup/netology/indices/IX3NgcmeR1Wye-bunlXnUA/0
/home/sa/db-65/es-backup/netology/indices/IX3NgcmeR1Wye-bunlXnUA/0/__MXizIuqLQ0qV0-u6Tq6ZCw
/home/sa/db-65/es-backup/netology/indices/IX3NgcmeR1Wye-bunlXnUA/0/snap-ObXwMmPGRtafnKdHrCoE4g.dat
/home/sa/db-65/es-backup/netology/indices/IX3NgcmeR1Wye-bunlXnUA/0/__vK7pQnuoTNy_jv-GL-Kq_g
/home/sa/db-65/es-backup/netology/indices/IX3NgcmeR1Wye-bunlXnUA/0/index-AYdajtu_Qv6gvb2EMhQMdQ
/home/sa/db-65/es-backup/netology/indices/IX3NgcmeR1Wye-bunlXnUA/0/__ZnxRMYkIRoCvxg0cCNof9w
/home/sa/db-65/es-backup/netology/indices/IX3NgcmeR1Wye-bunlXnUA/0/__bUollPQZQTKEVsrXsu4Q3w
/home/sa/db-65/es-backup/netology/indices/IX3NgcmeR1Wye-bunlXnUA/meta-I5CYJIEBYtxwE0ke_UFQ.dat
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/meta-IJCYJIEBYtxwE0keskEM.dat
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__L2pJ41DDSlO94pquBVB8hQ
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__rdCQgFVkRWaZ4YDTsPmqWg
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__HuppPL27Q8CZ6PxcblHIWw
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__02-6r8raRTyHeuL2RGOmqg
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__nvmoLyL9QC-a6D0E3yJMog
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__mTf4w3r6TUKNhUSNpE6Vgw
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__l5sjnOctRPuERapX24uGLQ
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__iqnby4jmQaKaEGV-a3pmwg
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__lgEUyL8HTzSjZydZvrP3Ig
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/snap-ObXwMmPGRtafnKdHrCoE4g.dat
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__BDdpzrPvShyRCrZw-AjnYw
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__TBk-bJaEREqIVlVchameUw
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/snap-JbdurVGPQfSNpXY3OyJPhA.dat
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__ky4v6k20SKGPStjLMtxfVA
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__fOgO9o0oQyOBQOny5aYiog
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__k_jl69yDTJKJ6dq41JcQTw
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__bget-i3yTFeejeTiNk4awA
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__SX2InRQjRdS4aMRSJRLuQQ
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__HIz4H4mISHWrGI-5emUCjA
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__99pl6lPBSPaVkul8FuSAuw
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__WUj6DhmnRnWrnQz4WGc3yw
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/index-0sLe_eobTlyf-AaiArL97A
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__HjMSR094T1yEA3f1EWq_zA
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__WY4B_mKsSuy3ClNeLzr8vg
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__UUtLkCzDQViOk2BN9jRTBg
/home/sa/db-65/es-backup/netology/indices/RS0tVfsRQjKP2KIVFKA5YA/0/__BMmXtUduTJCs0lmE9HU7iw
/home/sa/db-65/es-backup/netology/indices/lCV12_WUQbiHREO5M44e7g
/home/sa/db-65/es-backup/netology/indices/lCV12_WUQbiHREO5M44e7g/0
/home/sa/db-65/es-backup/netology/indices/lCV12_WUQbiHREO5M44e7g/0/snap-ObXwMmPGRtafnKdHrCoE4g.dat
/home/sa/db-65/es-backup/netology/indices/lCV12_WUQbiHREO5M44e7g/0/snap-JbdurVGPQfSNpXY3OyJPhA.dat
/home/sa/db-65/es-backup/netology/indices/lCV12_WUQbiHREO5M44e7g/0/index-NbrRhcjdS_OvS9gw6REkEQ
/home/sa/db-65/es-backup/netology/indices/lCV12_WUQbiHREO5M44e7g/meta-IZCYJIEBYtxwE0keskEQ.dat
sa@debian:~/db-65$
```

Удаление индекса `test` и создание `test2`:

```console
sa@debian:~/db-65$ curl -X DELETE "127.1:9200/test?pretty"
{
  "acknowledged" : true
}
sa@debian:~/db-65$ curl -X PUT "127.1:9200/test2?pretty" -H 'Content-Type: application/json' -d'{"settings":{"index":{"number_of_replicas":0,"number_of_shards":1}}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test2"
}
sa@debian:~/db-65$ curl -X GET "127.1:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases WVlDgI0lSVm7X9KvbCCKMA   1   0         40            0     38.1mb         38.1mb
green  open   test2            owabMkkcQf-J8QQUemSfSA   1   0          0            0       226b           226b
sa@debian:~/db-65$
```

Восстановление индекса из частичного снапшота `dump` (при этом восстанавливается статус **GeoIP** и соответственно меняется **uuid** его индекса `.geoip_databases` так как он был перестроен - перед восстановлением индекс содержал **40** документов, а на момент создания снапшота только **15**):

```console
sa@debian:~/db-65$ curl -X POST "127.1:9200/_snapshot/netology_backup/dump/_restore?wait_for_completion=true&pretty" -H 'Content-Type: application/json' -d'{"feature_states":["geoip"]}'
{
  "snapshot" : {
    "snapshot" : "dump",
    "indices" : [
      ".geoip_databases",
      "test"
    ],
    "shards" : {
      "total" : 2,
      "failed" : 0,
      "successful" : 2
    }
  }
}
sa@debian:~/db-65$ curl -X GET "127.1:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases aJrimbD3S9GskBHItwnVDQ   1   0         15            0       14mb           14mb
green  open   test2            owabMkkcQf-J8QQUemSfSA   1   0          0            0       226b           226b
green  open   test             gmj3bPxBQciHqLGZ0LFTFA   1   0          0            0       226b           226b
sa@debian:~/db-65$
```

> Так как в снапшот был включён системный индекс `.geoip_databases` при восстановлении нужно указать необходимость восстановления статуса соответствующего плагина (фичи - feature), в данном случае для `GeoIP`. При отключении GeoIP данный блок не потребуется.

Восстановление индекса из снапшота всего кластера `dump_all` (при этом системные индексы не затрагиваются, **uuid** индекса фичи **GeoIP** не меняется):

> При восстановлении снапшота необходимо предварительно удалить восстанавливаемые индексы, либо настроить их переименование

```console
sa@debian:~/db-65$ curl -X DELETE "127.1:9200/test?pretty"
{
  "acknowledged" : true
}
sa@debian:~/db-65$ curl -X POST "127.1:9200/_snapshot/netology_backup/dump_all/_restore?wait_for_completion=true&pretty" -H 'Content-Type: application/json' -d'{"indices":["test"]}'
{
  "snapshot" : {
    "snapshot" : "dump_all",
    "indices" : [
      "test"
    ],
    "shards" : {
      "total" : 1,
      "failed" : 0,
      "successful" : 1
    }
  }
}
sa@debian:~/db-65$ curl -X GET "127.1:9200/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases aJrimbD3S9GskBHItwnVDQ   1   0         15            0       14mb           14mb
green  open   test2            owabMkkcQf-J8QQUemSfSA   1   0          0            0       226b           226b
green  open   test             03s8T-jxTGmkj7o3MWKjdQ   1   0          0            0       226b           226b
sa@debian:~/db-65$
```

---

Дополнительные материалы:

[Документация Elastic. Комбинирование bool запросов](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html)

[GROK](https://habr.com/ru/post/509632/)

[Девять граблей Elasticsearch (рекомендации на оптимизации)](https://habr.com/ru/company/yoomoney/blog/419041/)

[Решение основных проблем Elasticsearch](https://coralogix.com/blog/troubleshooting-common-elasticsearch-problems/)

[Универсальный GC Log анализатор](http://gceasy.io/)

