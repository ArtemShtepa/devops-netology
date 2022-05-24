# Домашнее задание по лекции "6.3. MySQL"

## Обязательная задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

Приведите в ответе количество записей с `price` > 300.

**Решение:**

Образ СУБД взят с [DockerHub](https://hub.docker.com/_/mysql) с тэгом `8-oracle`

Документация к образу на [GitHub](https://github.com/docker-library/docs/tree/master/mysql)

Запуск контейнера с MySQL:

```console
sa@debian:~/db-63$ sudo docker run --rm --name dc-mysql -v $(pwd)/conf:/etc/mysql -v $(pwd)/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=mysql_root_pw -d mysql:8-oracle
[sudo] password for sa:
Unable to find image 'mysql:8-oracle' locally
8-oracle: Pulling from library/mysql
90a00d516db1: Pull complete
ec380701a2aa: Pull complete
c639d40d7782: Pull complete
7ba2e5b74a30: Pull complete
3bce381d3796: Pull complete
f5e5b79d5c8e: Pull complete
858b3b51a1f9: Pull complete
2171f9f10a16: Pull complete
6f0fa78a73ac: Pull complete
bdf8a962e18c: Pull complete
Digest: sha256:b3c6816133f60df2c3721361b343308cfcae82b6e29d7e7c3f26388f608aa5cf
Status: Downloaded newer image for mysql:8-oracle
26f4ed22f7289e2b2801184456edc7aa1e8a6ddb1853e9a87dc6a525899c3b5d
sa@debian:~/db-63$
```

Либо использование Docker Compose (далее в решениях используется этот вариант, так как позволяет модифицировать конфигурационный файл СУБД без потери изменений после перезагрузки):

```console
sa@debian:~/db-63$ cat docker-compose.yml
version: "2.4"

services:
  mysql:
    image: mysql:8-oracle
    restart: always
    container_name: dc-mysql
    environment:
      MYSQL_ROOT_PASSWORD: mysql_root_pw
    volumes:
      - ./data:/var/lib/mysql
      - ./conf/my.cnf:/etc/my.cnf

sa@debian:~/db-63$ sudo docker compose up -d
[+] Running 2/2
 ⠿ Network db-63_default  Created                                                                                  0.1s
 ⠿ Container dc-mysql     Started                                                                                  0.4s
sa@debian:~/db-63$
```

Вывод текущей версии СУБД:

```console
sa@debian:~/db-63$ sudo docker exec -it dc-mysql mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 12
Server version: 8.0.29 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
ssl_session_data_print Serializes the current SSL session data to stdout or file

For server side help, type 'help contents'

mysql> \s
--------------
mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          12
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.29 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 4 min 29 sec

Threads: 2  Questions: 16  Slow queries: 0  Opens: 117  Flush tables: 3  Open tables: 36  Queries per second avg: 0.059
--------------
```

**Ответ:** Используется версия `8.0.29 MySQL Community Server - GPL` (команда `\s` или `status`)

Восстановление базы из дампа:

```console
mysql> CREATE DATABASE test_db;
Query OK, 1 row affected (0.00 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test_db            |
+--------------------+
5 rows in set (0.00 sec)

mysql> exit
Bye
sa@debian:~/db-63$ sudo docker exec -i dc-mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" test_db' < ./test_dump.sql
mysql: [Warning] Using a password on the command line interface can be insecure.
sa@debian:~/db-63$
```

Подключение к СУБД и восстановленной базе, список таблиц:

```console
sa@debian:~/db-63$ sudo docker exec -it dc-mysql mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 21
Server version: 8.0.29 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> \u test_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql>
```
**Ответ:** в развёрнутой базе всего одна таблица `orders` (команда вывода таблиц `SHOW TABLES;`)

Количество записей с `price` > 300:

```console
mysql> SELECT Count(*) FROM orders WHERE price>300;
+----------+
| Count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.01 sec)

mysql>
```

**Ответ:** в таблице **orders** всего `одна` запись с **price > 300**

---

## Обязательная задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и приведите в ответе к задаче.

**Решение:**

Документация MySQL: [Формат CREATE USER](https://dev.mysql.com/doc/refman/8.0/en/create-user.html)

Документация MySQL: [Формат GRANT](https://dev.mysql.com/doc/refman/8.0/en/grant.html)

Создание пользователя:

```console
mysql> CREATE USER 'test'@'%'
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> WITH MAX_QUERIES_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3
    -> PASSWORD_LOCK_TIME UNBOUNDED
    -> ATTRIBUTE '{"surname":"Pretty","name":"James"}' ;
Query OK, 0 rows affected (0.01 sec)

mysql>
```

Предоставление привелегий на все таблицы БД `test_db`:

```console
mysql> GRANT SELECT ON test_db.* TO test;
Query OK, 0 rows affected (0.01 sec)

mysql>
```

Вывод данных по пользователям(лю):

```console
mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES;
+------------------+-----------+----------------------------------------+
| USER             | HOST      | ATTRIBUTE                              |
+------------------+-----------+----------------------------------------+
| root             | %         | NULL                                   |
| test             | %         | {"name": "James", "surname": "Pretty"} |
| mysql.infoschema | localhost | NULL                                   |
| mysql.session    | localhost | NULL                                   |
| mysql.sys        | localhost | NULL                                   |
| root             | localhost | NULL                                   |
+------------------+-----------+----------------------------------------+
6 rows in set (0.00 sec)

mysql> SELECT attribute FROM information_schema.user_attributes WHERE user='test' \G
*************************** 1. row ***************************
ATTRIBUTE: {"name": "James", "surname": "Pretty"}
1 row in set (0.00 sec)

mysql>
```

---

## Обязательная задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и приведите в ответе.

Измените `engine` и приведите время выполнения и запрос на изменения из профайлера в ответе:
- на `MyISAM`
- на `InnoDB`

**Решение:**

Документация MySQL [Формат ALTER TABLE](https://dev.mysql.com/doc/refman/8.0/en/alter-table.html)

Включение профильрования: это означает, что СУБД будет вести учёт запросов и время их выполнения

Изучение схемы таблицы (тип движка): в данном случае используется движок `InnoDB`

```console
mysql> SHOW CREATE TABLE orders\G
*************************** 1. row ***************************
       Table: orders
Create Table: CREATE TABLE `orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(80) NOT NULL,
  `price` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
1 row in set (0.00 sec)

mysql> SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'test_db' \G
*************************** 1. row ***************************
  TABLE_CATALOG: def
   TABLE_SCHEMA: test_db
     TABLE_NAME: orders
     TABLE_TYPE: BASE TABLE
         ENGINE: InnoDB
        VERSION: 10
     ROW_FORMAT: Dynamic
     TABLE_ROWS: 6
 AVG_ROW_LENGTH: 2730
    DATA_LENGTH: 16384
MAX_DATA_LENGTH: 0
   INDEX_LENGTH: 0
      DATA_FREE: 0
 AUTO_INCREMENT: 7
    CREATE_TIME: 2022-05-26 08:43:51
    UPDATE_TIME: 2022-05-26 09:36:44
     CHECK_TIME: NULL
TABLE_COLLATION: utf8mb4_0900_ai_ci
       CHECKSUM: NULL
 CREATE_OPTIONS:
  TABLE_COMMENT:
1 row in set (0.01 sec)

mysql>
```

Запуск профилеровщика:

```console
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql>
```

При перезагрузке СУБД накопленные данные профилеровщика сбрасываются. Чтобы очистить данные без перезагрузки можно изменить максимальное число запросов в истории (`profiling_history_size`) на `0`, после чего выставить нормальнео значение. Пример:

```console
mysql> SET profiling = 0;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SET profiling_history_size = 0;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SET profiling_history_size = 100;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql>
```

Изменение движка таблицы:

```console
mysql> SHOW PROFILES;
+----------+------------+------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                            |
+----------+------------+------------------------------------------------------------------+
|        8 | 0.00735850 | DELETE FROM orders WHERE id>5                                    |
|        9 | 0.00794800 | INSERT INTO orders (title, price) VALUES ('Podolsk Cagets', 420) |
|       10 | 0.00082250 | SELECT * FROM orders                                             |
|       11 | 0.02971875 | ALTER TABLE orders ENGINE='MyISAM'                               |
|       12 | 0.00620275 | INSERT INTO orders (title, price) VALUES ('Rhzev', 420)          |
|       13 | 0.00062100 | SELECT * FROM orders                                             |
|       14 | 0.03600100 | ALTER TABLE orders ENGINE='InnoDB'                               |
+----------+------------+------------------------------------------------------------------+
7 rows in set, 1 warning (0.00 sec)

mysql> SHOW PROFILE;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000071 |
| Executing hook on transaction  | 0.000039 |
| starting                       | 0.000106 |
| checking permissions           | 0.000009 |
| checking permissions           | 0.000008 |
| init                           | 0.000014 |
| Opening tables                 | 0.000203 |
| setup                          | 0.000045 |
| creating table                 | 0.000061 |
| After create                   | 0.017059 |
| System lock                    | 0.000029 |
| copy to tmp table              | 0.000207 |
| rename result table            | 0.001000 |
| waiting for handler commit     | 0.000022 |
| waiting for handler commit     | 0.002549 |
| waiting for handler commit     | 0.000019 |
| waiting for handler commit     | 0.008487 |
| waiting for handler commit     | 0.000018 |
| waiting for handler commit     | 0.002284 |
| waiting for handler commit     | 0.000026 |
| waiting for handler commit     | 0.002269 |
| end                            | 0.000455 |
| query end                      | 0.000924 |
| closing tables                 | 0.000016 |
| waiting for handler commit     | 0.000036 |
| freeing items                  | 0.000029 |
| cleaning up                    | 0.000018 |
+--------------------------------+----------+
27 rows in set, 1 warning (0.00 sec)

mysql>
```

Для изменения движка таблицы используется команда: `ALTER TABLE <таблица> ENGINE='<движок>'`, где `<таблица>` - имя изменяемой таблицы, а `<движок>` - название (текстовой идентификатор) движка, в который будет преобразована таблица

---

## Обязательная задача 4

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

**Решение:**

Документация MySQL [Параметры InnoDB](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html)

- Скорость IO важнее сохранности данных:
  - `innodb_flush_method = O_DSYNC` - логика сброса данных на диск (указано для Unix-like систем, для Windows используется `normal`)
  - `innodb_flush_log_at_trx_commit = 2` - поведение сброса операций в лог файл в режиме приоритета IO над сохранностью данных
- Нужна компрессия таблиц для экономии места на диске:
  - `innodb_file_per_table = true` - выделять отдельный файл для каждой таблицы (всесто одного большого файла для всех таблиц)
- Размер буффера с незакомиченными транзакциями 1 Мб:
  - `innodb_log_buffer_size = 1MB` - размер буфера транзакций в незакомиченном состоянии (для 8.0 по умолчанию установлено в 16 МБайт)
- Буффер кеширования 30% от ОЗУ:
  - `innodb_buffer_pool_size = 1200MB` - объем буфера кэширования. Параметр не может быть установлен сразу в процентах, поэтому допустим, что система обладает 4 Гигабайтами оперативной памяти (для 8.0 по умолчанию равно 128 МБайт)
- Размер файла логов операций 100 Мб:
  - `innodb_log_file_size = 100MB`- размер файла лога операций (в 8.0 по умолчанию равен 50 МБайт)

```console
sa@debian:~/db-63$ cat conf/my.cnf
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
#default-authentication-plugin=mysql_native_password
authentication_policy="*,,"
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql
pid-file=/var/run/mysqld/mysqld.pid

innodb_flush_method = O_DSYNC
innodb_flush_log_at_trx_commit = 2
innodb_file_per_table = ON
innodb_log_buffer_size = 1MB
innodb_buffer_pool_size = 1200MB
innodb_log_file_size = 100MB

[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/
sa@debian:~/db-63$
```
