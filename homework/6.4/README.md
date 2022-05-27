# Домашнее задание по лекции "6.4. PostgreSQL"

## Обязательная задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

**Решение:**

Образ БД взят с [DockerHub](https://hub.docker.com/_/postgres) с тэгом `13-alpine`

Документация к образу на [GitHub](https://github.com/docker-library/docs/blob/master/postgres/README.md)

Команда запуск контейнера: `docker run --rm --name dc-pg -v $(pwd)/data:/var/lib/postgresql/data -e POSTGRES_PASSWORD=pg_root_pw -d postgres:13-alpine`

Файл Docker Compose манифеста:

```yaml
version: "2.4"

services:
  db:
    image: postgres:13-alpine
    container_name: dc-pg
    restart: always
    environment:
      POSTGRES_PASSWORD: pg_root_pw
    volumes:
      - ./data:/var/lib/postgresql/data
```

Ответы:

- вывода списка БД: `\l` или расширенный вывод `\l+`

- подключения к БД: `\c <база>`, где `<база>` - имя БД к которой необходимо подключиться

- вывода списка таблиц: `\dt` или расширенный вывод `\dt+`. Для включения в вывод системных таблиц используются команды `\dtS` или с расширенным выводом `\dtS+`

  ```console
  test_database=# \dt+
                                List of relations
   Schema |  Name  | Type  |  Owner   | Persistence |    Size    | Description
  --------+--------+-------+----------+-------------+------------+-------------
   public | orders | table | postgres | permanent   | 8192 bytes |
  (1 row)
  ```

- вывода описания содержимого таблиц: `\d <таблица>`, где `<таблица>` - имя таблицы описание которой нужно вывести

  ```console
  test_database=# \d orders;
                                     Table "public.orders"
   Column |         Type          | Collation | Nullable |              Default
  --------+-----------------------+-----------+----------+------------------------------------
   id     | integer               |           | not null | nextval('orders_id_seq'::regclass)
   title  | character varying(80) |           | not null |
   price  | integer               |           |          | 0
  Indexes:
      "orders_pkey" PRIMARY KEY, btree (id)
  ```

- выхода из psql: `\q`

---

## Обязательная задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

**Решение:**

Создание базы и восстановление её содержимого из дампа:

```console
sa@debian:~/db-64$ sudo docker exec -it dc-pg psql -U postgres
psql (13.7)
Type "help" for help.

postgres=# CREATE DATABASE test_database;
CREATE DATABASE
postgres=# \q
sa@debian:~/db-64$ sudo docker exec -i dc-pg sh -c "exec psql test_database -U postgres" < test_dump.sql
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
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
sa@debian:~/db-64$
```

Анализирование таблиц: средний размер элементов в столбце записывается в `avg_width`. Для расчёта максимального значения используется встроенная функция **MAX()**

```console
test_database=# ANALYZE orders;
ANALYZE
test_database=# SELECT * FROM pg_stats WHERE tablename='orders';
 schemaname | tablename | attname | inherited | null_frac | avg_width | n_distinct | most_common_vals | most_common_freqs |                                                                 histogram_bounds                                                                  | correlation | most_common_elems | most_common_elem_freqs | elem_count_histogram
------------+-----------+---------+-----------+-----------+-----------+------------+------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------------------------+-------------+-------------------+------------------------+----------------------
 public     | orders    | id      | f         |         0 |         4 |         -1 |                  |                   | {1,2,3,4,5,6,7,8}                                                                                                                                 |           1 |                   |                        |
 public     | orders    | title   | f         |         0 |        16 |         -1 |                  |                   | {"Adventure psql time",Dbiezdmin,"Log gossips","Me and my bash-pet","My little database","Server gravity falls","WAL never lies","War and peace"} |  -0.3809524 |                   |                        |
 public     | orders    | price   | f         |         0 |         4 |     -0.875 | {300}            | {0.25}            | {100,123,499,500,501,900}                                                                                                                         |   0.5952381 |                   |                        |
(3 rows)

test_database=# SELECT attname FROM pg_stats WHERE tablename='orders' AND avg_width = (SELECT MAX(avg_width) FROM pg_stats WHERE tablename='orders');
 attname
---------
 title
(1 row)

test_database=#
```

Для вычисления названия столбца сначала нужно найти наибольшее среднее значение размера элементов.
Среднее значение размера элемента находится в столбце `avg_width`.
Для определения наибольшего значения используется функция-агрегатор **MAX**: `SELECT MAX(avg_width) FROM pg_stats WHERE tablename='orders';`
Далее определяем название столбца запросом: `SELECT attname FROM pg_stats WHERE tablename='orders' AND avg_width = ();`, куда нужно подставить первый запрос.

Ответ:

  - Запрос: `SELECT attname FROM pg_stats WHERE tablename='orders' AND avg_width = (SELECT MAX(avg_width) FROM pg_stats WHERE tablename='orders');`

  - Результат: стоблец с наибольшим средним размером элемента это `title`

---

## Обязательная задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

**Решение:**

Статья [Масштабирование базы данных через шардирование и партиционирование](https://habr.com/ru/company/oleg-bunin/blog/309330/)

Документация PostgreSQL [Наследование](https://www.postgresql.org/docs/13/ddl-inherit.html)

Документация PostgreSQL [Партицирование](https://www.postgresql.org/docs/13/ddl-partitioning.html)

Документация PostgreSQL [Использование WITH](https://www.postgresql.org/docs/13/queries-with.html)

Создание партиционных таблиц наследованием:

```console
test_database=# CREATE TABLE orders_1 ( CHECK ( price > 499 ) ) INHERITS (orders);
CREATE TABLE
test_database=# CREATE SEQUENCE public.orders_1_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

CREATE SEQUENCE
test_database=# ALTER SEQUENCE public.orders_1_id_seq OWNED BY public.orders_1.id;
ALTER SEQUENCE
test_database=# ALTER TABLE ONLY orders_1 ADD CONSTRAINT orders_1_pkey PRIMARY KEY (id);
ALTER TABLE
test_database=# CREATE TABLE orders_2 ( CHECK ( price <= 499 ) ) INHERITS (orders);
CREATE TABLE
test_database=# CREATE SEQUENCE public.orders_2_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

CREATE SEQUENCE
test_database=# ALTER SEQUENCE public.orders_2_id_seq OWNED BY public.orders_2.id;
ALTER SEQUENCE
test_database=# ALTER TABLE ONLY orders_2 ADD CONSTRAINT orders_2_pkey PRIMARY KEY (id);
ALTER TABLE
test_database=# \d orders
                                   Table "public.orders"
 Column |         Type          | Collation | Nullable |              Default
--------+-----------------------+-----------+----------+------------------------------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass)
 title  | character varying(80) |           | not null |
 price  | integer               |           |          | 0
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
    "orders_title_key" UNIQUE CONSTRAINT, btree (title)
Number of child tables: 2 (Use \d+ to list them.)

test_database=# \d orders_1
                                  Table "public.orders_1"
 Column |         Type          | Collation | Nullable |              Default
--------+-----------------------+-----------+----------+------------------------------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass)
 title  | character varying(80) |           | not null |
 price  | integer               |           |          | 0
Indexes:
    "orders_1_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "orders_1_price_check" CHECK (price > 499)
Inherits: orders

test_database=# \d orders_2
                                  Table "public.orders_2"
 Column |         Type          | Collation | Nullable |              Default
--------+-----------------------+-----------+----------+------------------------------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass)
 title  | character varying(80) |           | not null |
 price  | integer               |           |          | 0
Indexes:
    "orders_2_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "orders_2_price_check" CHECK (price <= 499)
Inherits: orders

test_database=#
```

Перемещение данных в партиционные таблицы:

```console
test_database=# WITH moved_orders AS ( DELETE FROM orders WHERE price > 499 RETURNING * ) INSERT INTO orders_1 SELECT * FROM moved_orders;
INSERT 0 3
test_database=# WITH moved_orders AS ( DELETE FROM orders WHERE price <= 499 RETURNING * ) INSERT INTO orders_2 SELECT * FROM moved_orders;
INSERT 0 5
test_database=# select * from orders_1;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# select * from orders_2;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

test_database=# select * from orders;
 id |        title         | price
----+----------------------+-------
  2 | My little database   |   500
  6 | WAL never lies       |   900
  8 | Dbiezdmin            |   501
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(8 rows)

test_database=#
```

Создание правил на добавление:

```console
test_database=# CREATE RULE order_insert_1 AS ON INSERT TO orders WHERE ( price > 499 ) DO INSTEAD INSERT INTO orders_1 VALUES (NEW.*);
CREATE RULE
test_database=# CREATE RULE order_insert_2 AS ON INSERT TO orders WHERE ( price <= 499 ) DO INSTEAD INSERT INTO orders_2 VALUES (NEW.*);
CREATE RULE
```

Проверка вставки:

```console
test_database=# INSERT INTO orders (title, price) VALUES ('test1', 770);
INSERT 0 0
test_database=# INSERT INTO orders (title, price) VALUES ('test2', 170);
INSERT 0 0
test_database=# SELECT * FROM orders;
 id |        title         | price
----+----------------------+-------
  2 | My little database   |   500
  6 | WAL never lies       |   900
  8 | Dbiezdmin            |   501
  9 | test1                |   770
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
 10 | test2                |   170
(10 rows)

test_database=# SELECT * FROM orders_1;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
  9 | test1              |   770
(4 rows)

test_database=# SELECT * FROM orders_2;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
 10 | test2                |   170
(6 rows)

test_database=#
```

Итоговая транзакция без создания индексов и ключей:

```sql
BEGIN;
CREATE TABLE orders_1 ( CHECK ( price > 499 ) ) INHERITS (orders);
CREATE TABLE orders_2 ( CHECK ( price <= 499 ) ) INHERITS (orders);
WITH moved_orders AS ( DELETE FROM orders WHERE price > 499 RETURNING * ) INSERT INTO orders_1 SELECT * FROM moved_orders;
WITH moved_orders AS ( DELETE FROM orders WHERE price <= 499 RETURNING * ) INSERT INTO orders_2 SELECT * FROM moved_orders;
CREATE RULE order_insert_1 AS ON INSERT TO orders WHERE ( price > 499 ) DO INSTEAD INSERT INTO orders_1 VALUES (NEW.*);
CREATE RULE order_insert_2 AS ON INSERT TO orders WHERE ( price <= 499 ) DO INSTEAD INSERT INTO orders_2 VALUES (NEW.*);
COMMIT;
```

При разработке структуры БД можно было изначально исключить "ручное" разбиение. Для этого потребовалось бы:

  - Создать основную таблицу `orders` как шаблон

  - Создать нужное количество партицонных таблиц, наследованных от `orders`

  - Настроить правила вставки в партиционные таблицы (фактически замену `INSERT INTO orders` на вставку в партифионные таблицы по принятым правилам разделения)

---

Также есть альтернативный вариант создания партиционных таблиц, например:

Создание основной таблицы-шаблона (разделение по диапазону цен):

```console
test_database=# CREATE TABLE new_orders (id integer not null, title varchar not null, price int) PARTITION BY RANGE (price);
CREATE TABLE
```

Создание партиционных таблиц с определёнными диапазонами: первая **от 0 до 500**, вторая **от 500 до 10000**.

```console
test_database=# CREATE TABLE new_orders_1 PARTITION OF new_orders FOR VALUES FROM (0) TO (500);
CREATE TABLE
test_database=# CREATE TABLE new_orders_2 PARTITION OF new_orders FOR VALUES FROM (500) TO (10000);
CREATE TABLE
```

> При задании диапазона верхняя граница (TO) не включается, то есть запись `INSERT INTO new_orders (3,'test3',500)` попадёт в таблицу `new_orders_2`

> Однако, при попытке вставить данные вне перечисленных диапазонов произойдёт ошибка

> Данный способ поддерживает наращивание числа партиционных таблиц, покрывая всё больший диапазон значений

> Помимо диапазона разделение можно выполнить по списку - точному соответствию значению, например **group=1** для первой таблицы, **group=2** для второй и так далее

Проверка и сравнение:

```console
test_database=# \d
                    List of relations
 Schema |      Name       |       Type        |  Owner
--------+-----------------+-------------------+----------
 public | new_orders      | partitioned table | postgres
 public | new_orders_1    | table             | postgres
 public | new_orders_2    | table             | postgres
 public | orders          | table             | postgres
 public | orders_1        | table             | postgres
 public | orders_1_id_seq | sequence          | postgres
 public | orders_2        | table             | postgres
 public | orders_2_id_seq | sequence          | postgres
 public | orders_id_seq   | sequence          | postgres
(9 rows)

test_database=# \d new_orders
            Partitioned table "public.new_orders"
 Column |       Type        | Collation | Nullable | Default
--------+-------------------+-----------+----------+---------
 id     | integer           |           | not null |
 title  | character varying |           | not null |
 price  | integer           |           |          |
Partition key: RANGE (price)
Number of partitions: 2 (Use \d+ to list them.)

test_database=# \d new_orders_1
                 Table "public.new_orders_1"
 Column |       Type        | Collation | Nullable | Default
--------+-------------------+-----------+----------+---------
 id     | integer           |           | not null |
 title  | character varying |           | not null |
 price  | integer           |           |          |
Partition of: new_orders FOR VALUES FROM (0) TO (500)

test_database=# \d new_orders_2
                 Table "public.new_orders_2"
 Column |       Type        | Collation | Nullable | Default
--------+-------------------+-----------+----------+---------
 id     | integer           |           | not null |
 title  | character varying |           | not null |
 price  | integer           |           |          |
Partition of: new_orders FOR VALUES FROM (500) TO (10000)

test_database=# INSERT INTO new_orders VALUES (1,'test1',300),(2,'test2',800);
INSERT 0 2
test_database=# select * from new_orders;
 id | title | price
----+-------+-------
  1 | test1 |   300
  2 | test2 |   800
(2 rows)

test_database=# select * from new_orders_1;
 id | title | price
----+-------+-------
  1 | test1 |   300
(1 row)

test_database=# select * from new_orders_2;
 id | title | price
----+-------+-------
  2 | test2 |   800
(1 row)

test_database=#
```

---

## Обязательная задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

**Решение:**

Создание бэкапа: `sudo docker exec -it dc-pg pg_dump -c test_database -U postgres >new_dump.sql` - при этом благодаря параметру `-c` или `--clean` в дамп будут включены строки удаления таблиц (**DROP**) во избежание конфликтов (например, при создании индексов)

Для того, чтобы добавить уникальность значения столбца `title` в блоке создания таблицы в строчке столбца `title` нужно добавить `UNIQUE`, то есть заменить блок кода

```sql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);
```

на

```sql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL UNIQUE,
    price integer DEFAULT 0
);
```

Проверка после восстановления дампа (из структуры видно, что автоматически добавился новый индекс `orders_title_key` с настройкой `UNIQUE`):

```console
test_database=# \d orders;
                                   Table "public.orders"
 Column |         Type          | Collation | Nullable |              Default
--------+-----------------------+-----------+----------+------------------------------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass)
 title  | character varying(80) |           | not null |
 price  | integer               |           |          | 0
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
    "orders_title_key" UNIQUE CONSTRAINT, btree (title)

test_database=# select * from orders;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  2 | My little database   |   500
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
(8 rows)

test_database=# INSERT INTO orders (title,price) VALUES ('test',1);
INSERT 0 1
test_database=# INSERT INTO orders (title,price) VALUES ('test',2);
ERROR:  duplicate key value violates unique constraint "orders_title_key"
DETAIL:  Key (title)=(test) already exists.
test_database=#
```
