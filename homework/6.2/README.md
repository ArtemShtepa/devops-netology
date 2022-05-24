# Домашнее задание по лекции "6.2. SQL"

## Обязательная задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

**Решение:**

Образ СУБД взят с [DockerHub](https://hub.docker.com/_/postgres) с тэгом `12-alpine`

Документация к образу на [GitHub](https://github.com/docker-library/docs/blob/master/postgres/README.md)

Команда запуск контейнера: `docker run --rm --name dc-pg -v $(pwd)/data:/var/lib/postgresql/data -v $(pwd)/data:/pg-backup -e POSTGRES_PASSWORD=pg_root_pw -d postgres:12-alpine`

```console
sa@debian:~/db-62$ sudo docker run --rm --name dc-pg -v $(pwd)/data:/var/lib/postgresql/data -v $(pwd)/data:/pg-backup -e POSTGRES_PASSWORD=pg_root_pw -d postgres:12-alpine
[sudo] password for sa:
Unable to find image 'postgres:12-alpine' locally
12-alpine: Pulling from library/postgres
df9b9388f04a: Pull complete
7902437d3a12: Pull complete
709e2267bc98: Pull complete
257aa4b8c5cc: Pull complete
bab79c1d03a7: Pull complete
b1acb3ed126e: Pull complete
b1d9bf3da8b5: Pull complete
6aaa4a313e5c: Pull complete
Digest: sha256:5973e0c567af254f5ee7eadeabbb786d48f1d4f3d6436c07714e653291e9d621
Status: Downloaded newer image for postgres:12-alpine
1e4bce791a33061be6490a1b988c8d6023d04fa6701ddac96b01321c00c636bb
sa@debian:~/db-62$
```

---

## Обязательная задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

**Решение:**

Запуск оболочки БД: `docker exec -it dc-pg psql -U postgres` (запуст от пользователя `postgres`, обладающего root правами в кластере)

```console
sa@debian:~/db-62$ sudo docker exec -it dc-pg psql -U postgres
psql (12.11)
Type "help" for help.
```

Создание пользователя с праввами администратора (роль `test-admin-user`):

```console
postgres=# CREATE USER "test-admin-user" PASSWORD 'test-admin-password' SUPERUSER;
CREATE ROLE
```

Создание обычного пользователя (роль `test-simple-user`):

```console
postgres=# CREATE USER "test-simple-user" PASSWORD 'test-simple-user-password';
CREATE ROLE
```

Создание базы `test_db` с владельцем `test-admin-user`:

```console
postgres=# CREATE DATABASE test_db WITH OWNER "test-admin-user";
CREATE DATABASE
```

Подключение к базе (выбор) `test_db` (иначе таблицы будут создаваться в области `public`):

```console
postgres=# \c test_db
You are now connected to database test_db as user "postgres".
```

Создание таблицы `orders`:

```console
test_db=# CREATE TABLE orders (
test_db(# id SERIAL PRIMARY KEY,
test_db(# "наименование" varchar,
test_db(# "цена" integer );
CREATE TABLE
```

Создание таблицы `clients`:

```console
test_db=# CREATE TABLE clients (
test_db(# id SERIAL PRIMARY KEY,
test_db(# "фамилия" varchar,
test_db(# "страна" varchar,
test_db(# "заказ" integer,
test_db(# FOREIGN KEY ("заказ") REFERENCES orders (id) );
CREATE TABLE
```

Назначение всех возможных прав для `test-admin-user` на таблицы `clients` и `orders` (хотя смысла в этом, наверное, мало, так как данная роль имеет статус **SUPERUSER**)

```console
test_db=# GRANT ALL ON clients,orders TO "test-admin-user";
GRANT
```

Назначение выбранных прав для `test-simple-user` на таблицы `clients` и `orders`:

```console
test_db=# GRANT SELECT,INSERT,UPDATE,DELETE ON orders,clients TO "test-simple-user";
GRANT
```

**Ответы:**

Список баз данных:

```console
test_db=# \l
                                    List of databases
   Name    |      Owner      | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+-----------------+----------+------------+------------+-----------------------
 postgres  | postgres        | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres        | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |                 |          |            |            | postgres=CTc/postgres
 template1 | postgres        | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |                 |          |            |            | postgres=CTc/postgres
 test_db   | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```

Описание таблиц (describe):

```console
test_db=# \d clients
                                  Table "public.clients"
 Column  |       Type        | Collation | Nullable |               Default
---------+-------------------+-----------+----------+-------------------------------------
 id      | integer           |           | not null | nextval('clients_id_seq'::regclass)
 фамилия | character varying |           |          |
 страна  | character varying |           |          |
 заказ   | integer           |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# \d orders
                                    Table "public.orders"
    Column    |       Type        | Collation | Nullable |              Default
--------------+-------------------+-----------+----------+------------------------------------
 id           | integer           |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying |           |          |
 цена         | integer           |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```

SQL-запрос для выдачи списка пользователей с правами над таблицами `test_db`:

```console
test_db=# SELECT grantee,table_name,privilege_type,is_grantable,with_hierarchy
test_db-# FROM information_schema.table_privileges
test_db-# WHERE grantee IN ('test-admin-user','test-simple-user')
test_db-# AND table_name IN ('clients','orders');
     grantee      | table_name | privilege_type | is_grantable | with_hierarchy
------------------+------------+----------------+--------------+----------------
 test-admin-user  | orders     | INSERT         | YES          | NO
 test-admin-user  | orders     | SELECT         | YES          | YES
 test-admin-user  | orders     | UPDATE         | YES          | NO
 test-admin-user  | orders     | DELETE         | YES          | NO
 test-admin-user  | orders     | TRUNCATE       | YES          | NO
 test-admin-user  | orders     | REFERENCES     | YES          | NO
 test-admin-user  | orders     | TRIGGER        | YES          | NO
 test-simple-user | orders     | INSERT         | NO           | NO
 test-simple-user | orders     | SELECT         | NO           | YES
 test-simple-user | orders     | UPDATE         | NO           | NO
 test-simple-user | orders     | DELETE         | NO           | NO
 test-admin-user  | clients    | INSERT         | YES          | NO
 test-admin-user  | clients    | SELECT         | YES          | YES
 test-admin-user  | clients    | UPDATE         | YES          | NO
 test-admin-user  | clients    | DELETE         | YES          | NO
 test-admin-user  | clients    | TRUNCATE       | YES          | NO
 test-admin-user  | clients    | REFERENCES     | YES          | NO
 test-admin-user  | clients    | TRIGGER        | YES          | NO
 test-simple-user | clients    | INSERT         | NO           | NO
 test-simple-user | clients    | SELECT         | NO           | YES
 test-simple-user | clients    | UPDATE         | NO           | NO
 test-simple-user | clients    | DELETE         | NO           | NO
(22 rows)
```

Список пользователей с правами над таблицами test_db:

```console
test_db=# \du
                                       List of roles
    Role name     |                         Attributes                         | Member of
------------------+------------------------------------------------------------+-----------
 postgres         | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test-admin-user  | Superuser                                                  | {}
 test-simple-user |                                                            | {}
```

---

## Обязательная задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

**Решение:**

Вставка данных:

```console
test_db=# INSERT INTO orders ("наименование","цена") VALUES
test_db-# ('Шоколад',10),('Принтер',3000),('Книга',500),('Монитор',7000),('Гитара',4000);
INSERT 0 5
test_db=# INSERT INTO clients ("фамилия","страна") VALUES
test_db-# ('Иванов Иван Иванович','USA'),('Петров Петр Петрович','Canada'),
test_db-# ('Иоганн Себастьян Бах','Japan'),('Ронни Джеймс Дио','Russia'),
test_db-# ('Ritchie Blackmore','Russia');
INSERT 0 5
```

Вывод количества записей в таблицах:

```console
test_db=# SELECT Count(*) FROM clients;
 count
-------
     5
(1 row)

test_db=# SELECT Count(*) FROM orders;
 count
-------
     5
(1 row)
```

---

## Обязательная задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

Подсказк - используйте директиву `UPDATE`

**Решение:**

Подготовка - вывод имеющихся данных:

```console
test_db=# SELECT * FROM clients;
 id |       фамилия        | страна | заказ
----+----------------------+--------+-------
  1 | Иванов Иван Иванович | USA    |
  2 | Петров Петр Петрович | Canada |
  3 | Иоганн Себастьян Бах | Japan  |
  4 | Ронни Джеймс Дио     | Russia |
  5 | Ritchie Blackmore    | Russia |
(5 rows)

test_db=# SELECT * FROM orders;
 id | наименование | цена
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
(5 rows)
```

Обновление данных в таблице:

```console
test_db=# UPDATE clients SET "заказ"=3 WHERE id=1;
UPDATE 1
test_db=# UPDATE clients SET "заказ"=4 WHERE id=2;
UPDATE 1
test_db=# UPDATE clients SET "заказ"=5 WHERE id=3;
UPDATE 1
```

Вывод результата:

```console
test_db=# SELECT c."фамилия",c."страна",c."заказ",o."наименование",o."цена" FROM clients c LEFT JOIN orders o ON c."заказ"=o.id;
       фамилия        | страна | заказ | наименование | цена
----------------------+--------+-------+--------------+------
 Ронни Джеймс Дио     | Russia |       |              |
 Ritchie Blackmore    | Russia |       |              |
 Иванов Иван Иванович | USA    |     3 | Книга        |  500
 Петров Петр Петрович | Canada |     4 | Монитор      | 7000
 Иоганн Себастьян Бах | Japan  |     5 | Гитара       | 4000
(5 rows)
```

---

## Обязательная задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 используя директиву EXPLAIN.
Приведите получившийся результат и объясните что значат полученные значения.

**Решение:**

```console
test_db=# EXPLAIN ANALYZE SELECT * FROM clients;
                                             QUERY PLAN
-----------------------------------------------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=810 width=72) (actual time=0.008..0.014 rows=5 loops=1)
 Planning Time: 0.034 ms
 Execution Time: 0.029 ms
(3 rows)

test_db=#
```

Расшифровка полей:

- `Seq Scan` - последовательное чтение (блок за блоком)

- `on clients` - из таблицы `clients`

- `cost=0.00..18.10` - оценка стоимости запроса (затрат на его выполнение), где `0.00` - затраты на получение первой строки, `18.10` - затраты на получение всех строк

- `rows=810` - приблизительное количество строк, возвращаемое при последовательном чтении

- `width=72` - среднее значение в байтах размера одной строки

- `actual time=0.008..0.014` - действительно затраченное время в мс, где `0.008` - на получение первой строки, `0.014` - всех строк

- `rows=5` - общее число полученных строк (в данном случае получено **5** строк)

- `loops=1` - сколько раз потребовалось выполнить операцию `Seq Scan` для получения результата (в данном случае **1** раз)

- `Planning Time: 0.034 ms` - Сколько времени потребовалось СУБД чтобы подготовить запрос к выполнению (выбрать быстрейший способ получения запрашиваемых данных)

- `Execution Time: 0.029 ms` - Сколько времени потребовалось СУБД чтобы выполнить запрос и вернуть результат

Использовалась статья [PostgrePro. Документация. Оптимизация производительности](https://postgrespro.ru/docs/postgresql/12/using-explain)

---

## Обязательная задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

**Решение:**

Для решения задачи использован docker-compose манифест, где описано два контейнера.
Первый контейнер `dc-pg-1` будет являтсья источником бэкапа, а второй `dc-pg-2` - целевой БД, где будет разворачиваться дамп.
Перед запуском новых контейнеров, предыдущий был остановлен командой `sudo docker stop dc-pg` (и автоматически удалён благодаря опции `--rm` при его старте).
Монтируемый том бэкапов у контейнеров одинаковый `./backup`, а хранения файлов БД разные `./data-1` и `./data-2`.
После остановки старого контейнера `dc-pg` данные его базы будут скопированы для исходного нового контейнера `dc-pg-1` (в принципе, можно было его переименовать или вместо `./data-1` монтировать сразу `./data`)

Подготовка:

```console
sa@debian:~/db-62$ cat docker-compose.yml
version: "2.4"

services:
  db-1:
    image: postgres:12-alpine
    container_name: dc-pg-1
    restart: always
    environment:
      POSTGRES_PASSWORD: pg_root_pw
    volumes:
      - ./data-1:/var/lib/postgresql/data
      - ./backup:/pg-backup
  db-2:
    image: postgres:12-alpine
    container_name: dc-pg-2
    restart: always
    environment:
      POSTGRES_PASSWORD: pg_root_pw
    volumes:
      - ./data-2:/var/lib/postgresql/data
      - ./backup:/pg-backup
sa@debian:~/db-62$ ls backup/
sa@debian:~/db-62$ sudo cp -r data data-1
sa@debian:~/db-62$ ls
backup  data  data-1  data-2  docker-compose.yml
sa@debian:~/db-62$ sudo docker compose up -d
[+] Running 3/3
 ⠿ Network db-62_default  Created                                                                                  0.1s
 ⠿ Container dc-pg-2      Started                                                                                  0.5s
 ⠿ Container dc-pg-1      Started                                                                                  0.6s
sa@debian:~/db-62$
```

Создание резервной копии: `pg_dump` - создаёт резервную копию только одной таблицы, а `pg_dumpall` - всего кластера

```console
sa@debian:~/db-62$ ls backup/
sa@debian:~/db-62$ sudo docker exec -it dc-pg-1 bash
bash-5.1# pg_dump test_db -U "test-admin-user" >/pg-backup/dump.sql
bash-5.1# pg_dumpall -U "test-admin-user" >/pg-backup/all.sql
bash-5.1# exit
exit
sa@debian:~/db-62$ ls backup/
all.sql  dump.sql
sa@debian:~/db-62$
```

Восстановление кластера из файла резервной копии:

```console
sa@debian:~/db-62$ sudo docker exec -it dc-pg-2 bash
bash-5.1# psql -U postgres </pg-backup/all.sql
SET
SET
SET
ERROR:  role "postgres" already exists
ALTER ROLE
CREATE ROLE
ALTER ROLE
CREATE ROLE
ALTER ROLE
You are now connected to database "template1" as user "postgres".
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
You are now connected to database "postgres" as user "postgres".
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
CREATE DATABASE
ALTER DATABASE
You are now connected to database "test_db" as user "postgres".
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval
--------
      5
(1 row)

 setval
--------
      5
(1 row)

ALTER TABLE
ALTER TABLE
ALTER TABLE
GRANT
GRANT
GRANT
GRANT
bash-5.1#
```

Проверка (подключение к базе выполняется от пользователя `test-simple-user`):

```console
bash-5.1# psql test_db -U test-simple-user
psql (12.11)
Type "help" for help.

test_db=> \d
               List of relations
 Schema |      Name      |   Type   |  Owner
--------+----------------+----------+----------
 public | clients        | table    | postgres
 public | clients_id_seq | sequence | postgres
 public | orders         | table    | postgres
 public | orders_id_seq  | sequence | postgres
(4 rows)

test_db=> SELECT * FROM clients;
 id |       фамилия        | страна | заказ
----+----------------------+--------+-------
  4 | Ронни Джеймс Дио     | Russia |
  5 | Ritchie Blackmore    | Russia |
  1 | Иванов Иван Иванович | USA    |     3
  2 | Петров Петр Петрович | Canada |     4
  3 | Иоганн Себастьян Бах | Japan  |     5
(5 rows)

test_db=> exit
bash-5.1# exit
exit
sa@debian:~/db-62$
```

> Так как второй контейнер `dc-pg-2` стартует пустым, то в СУБД нет данных о пользователях и их правах, поэтому при первом восстановлении используется дамп кластера (`all.sql`). В последующих случаях достаточно использовать дамп только нужных таблиц (`dump.sql`)
