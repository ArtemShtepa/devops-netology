# Домашнее задание по лекции "3.8. Компьютерные сети. Часть 3"

## 1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP

```console
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```

Вывод команд:

```console
vagrant@vagrant:~$ telnet route-views.routeviews.org
Trying 128.223.51.103...
Connected to route-views.routeviews.org.
Escape character is '^]'.
C
**********************************************************************

                    RouteViews BGP Route Viewer
                    route-views.routeviews.org

 route views data is archived on http://archive.routeviews.org

 This hardware is part of a grant by the NSF.
 Please contact help@routeviews.org if you have questions, or
 if you wish to contribute your view.

 This router has views of full routing tables from several ASes.
 The list of peers is located at http://www.routeviews.org/peers
 in route-views.oregon-ix.net.txt

 NOTE: The hardware was upgraded in August 2014.  If you are seeing
 the error message, "no default Kerberos realm", you may want to
 in Mac OS X add "default unset autologin" to your ~/.telnetrc

 To login, use the username "rviews".

 **********************************************************************


User Access Verification

Username: rviews
route-views>show ip route 88.201.188.40
Routing entry for 88.201.128.0/18
  Known via "bgp 6447", distance 20, metric 0
  Tag 3333, type external
  Last update from 193.0.0.56 18:45:41 ago
  Routing Descriptor Blocks:
  * 193.0.0.56, from 193.0.0.56, 18:45:41 ago
      Route metric is 0, traffic share count is 1
      AS Hops 4
      Route tag 3333
      MPLS label: none
route-views>show bgp 88.201.188.40
BGP routing table entry for 88.201.128.0/18, version 337193365
Paths: (2 available, best #2, table default)
  Not advertised to any peer
  Refresh Epoch 2
  8283 15703 20562 35807
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin IGP, metric 0, localpref 100, valid, external, atomic-aggregate
      Community: 8283:10 15703:652 15703:800 15703:65222 20562:45 20562:3120 20562:4001 20562:65000 20562:65020
      unknown transitive attribute: flag 0xE0 type 0x20 length 0xC
        value 0000 205B 0000 0006 0000 000A
      path 7FE11D0E4F88 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 1103 20562 35807
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external, atomic-aggregate, best
      Community: 20562:45 20562:3120 20562:4001 20562:65000 20562:65020
      path 7FE158C71F08 RPKI State not found
      rx pathid: 0, tx pathid: 0x0
route-views>exit
Connection closed by foreign host.
vagrant@vagrant:~$
```

---

## 2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации

Для использования **Dummy** интерфейсов необходимо активировать соответствующий модуль ядра:

```console
vagrant@vagrant:~$ cat /etc/modules | grep -c dummy
0
vagrant@vagrant:~$ echo "dummy" | sudo tee -a /etc/modules
dummy
vagrant@vagrant:~$
```

Настройка модуля ядра **dummy**:

```console
vagrant@vagrant:~$ echo "options dummy numdummies=2" | sudo tee /etc/modprobe.d/dummy.conf
options dummy numdummies=2
vagrant@vagrant:~$
```

Для добавления сетевого интерфейса **Dummy** нужно добавить следующие строки в конфигурационный файл сервиса **networking** (требуется пакет `ifupdown`)

```
auto dummy0
iface dummy0 inet static
  address 10.2.2.2/32
  pre-up ip link add dummy0 type dummy
  post-down ip link del dummy0
```

После перезагрузки появится добавленный интерфейс:

```console
vagrant@vagrant:~$ ip -br a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.0.2.15/24 fe80::a00:27ff:feb1:285d/64
eth1             UP             192.168.0.101/24 fe80::a00:27ff:fe2d:11a3/64
eth2             UP             192.168.0.102/24 fe80::a00:27ff:fe22:653d/64
eth3             UP             192.168.0.104/24 fe80::a00:27ff:fe08:d364/64
dummy0           UNKNOWN        10.2.2.10/32 fe80::685e:c9ff:fe6f:a941/64
vagrant@vagrant:~$
```

Статические маршруты добавляются командой `ip route add` (подробнее `man ip-route`)

  - Добавление маршрута через шлюз

  ```console
  vagrant@vagrant:~$ sudo ip route add 192.168.1.0/24 via 192.168.0.101
  vagrant@vagrant:~$
  ```

  - Добавление маршрута через интерфейс

  ```console
  vagrant@vagrant:~$ sudo ip route add 10.2.2.10 dev eth3
  vagrant@vagrant:~$ sudo ip route add 192.168.2.0/24 dev eth2
  vagrant@vagrant:~$
  ```

  - Добавление маршрута через интерфейс с метрикой

  ```console
  vagrant@vagrant:~$ sudo ip route add 192.168.3.0/24 dev eth2 metric 80
  vagrant@vagrant:~$
  ```

Проверка маршрутов:

```console
vagrant@vagrant:~$ ip route
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
10.2.2.10 dev eth3 scope link
192.168.0.0/24 dev eth1 proto kernel scope link src 192.168.0.101
192.168.0.0/24 dev eth2 proto kernel scope link src 192.168.0.102
192.168.0.0/24 dev eth3 proto kernel scope link src 192.168.0.104
192.168.1.0/24 via 192.168.0.101 dev eth1
192.168.2.0/24 dev eth2 scope link
192.168.3.0/24 dev eth2 scope link metric 80
vagrant@vagrant:~$ ip route show 10.2.2.10
10.2.2.10 dev eth3 scope link
vagrant@vagrant:~$ ip route show 192.168.1.17/24
192.168.1.0/24 via 192.168.0.101 dev eth1
vagrant@vagrant:~$ ip route show 192.168.2.98/24
192.168.2.0/24 dev eth2 scope link
vagrant@vagrant:~$ ip route show 192.168.3.114/24
192.168.3.0/24 dev eth2 scope link metric 80
vagrant@vagrant:~$
```

---

## 3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров

Для просмотра сетевой статистики используется пакет команд `ss`. Подробнее `ss --help` или `man ss`

Для просмотра открытых портов используется ключ `-l` или `--listening`

Для просмотра только TCP портов используется ключ `-t` или `--tcp`

Для вывода процессов, открывших эти порты используется ключ `-p` или `--processes` (требуются права администратора)

Вывод:

```console
vagrant@vagrant:~$ sudo ss -ltp
State    Recv-Q   Send-Q      Local Address:Port         Peer Address:Port   Process
LISTEN   0        4096            127.0.0.1:8125              0.0.0.0:*       users:(("netdata",pid=1273,fd=39))
LISTEN   0        4096              0.0.0.0:19999             0.0.0.0:*       users:(("netdata",pid=1273,fd=5))
LISTEN   0        511               0.0.0.0:8001              0.0.0.0:*       users:(("nginx",pid=1339,fd=7),("nginx",pid=1338,fd=7),("nginx",pid=1337,fd=7),("nginx",pid=1336,fd=7),("nginx",pid=1335,fd=7))
LISTEN   0        511               0.0.0.0:8002              0.0.0.0:*       users:(("nginx",pid=1339,fd=9),("nginx",pid=1338,fd=9),("nginx",pid=1337,fd=9),("nginx",pid=1336,fd=9),("nginx",pid=1335,fd=9))
LISTEN   0        511               0.0.0.0:8003              0.0.0.0:*       users:(("nginx",pid=1339,fd=11),("nginx",pid=1338,fd=11),("nginx",pid=1337,fd=11),("nginx",pid=1336,fd=11),("nginx",pid=1335,fd=11))
LISTEN   0        511               0.0.0.0:http              0.0.0.0:*       users:(("nginx",pid=1339,fd=6),("nginx",pid=1338,fd=6),("nginx",pid=1337,fd=6),("nginx",pid=1336,fd=6),("nginx",pid=1335,fd=6))
LISTEN   0        4096        127.0.0.53%lo:domain            0.0.0.0:*       users:(("systemd-resolve",pid=952,fd=13))
LISTEN   0        128               0.0.0.0:ssh               0.0.0.0:*       users:(("sshd",pid=1340,fd=3))
LISTEN   0        511                  [::]:8001                 [::]:*       users:(("nginx",pid=1339,fd=8),("nginx",pid=1338,fd=8),("nginx",pid=1337,fd=8),("nginx",pid=1336,fd=8),("nginx",pid=1335,fd=8))
LISTEN   0        511                  [::]:8002                 [::]:*       users:(("nginx",pid=1339,fd=10),("nginx",pid=1338,fd=10),("nginx",pid=1337,fd=10),("nginx",pid=1336,fd=10),("nginx",pid=1335,fd=10))
LISTEN   0        511                  [::]:8003                 [::]:*       users:(("nginx",pid=1339,fd=12),("nginx",pid=1338,fd=12),("nginx",pid=1337,fd=12),("nginx",pid=1336,fd=12),("nginx",pid=1335,fd=12))
LISTEN   0        4096                    *:9100                    *:*       users:(("node_exporter",pid=1271,fd=3))
LISTEN   0        128                  [::]:ssh                  [::]:*       users:(("sshd",pid=1340,fd=4))
vagrant@vagrant:~$
```

Примеры использовани:

- `Netdata` использует порт `8125` для каких-то своих нужд, доступный только локально, а также `19999` (**HTTP**) порт для отображения собранной статистики

- `NodeExporter` использует `9100` порт для отображения собираемой метрики (**HTTP**)

- `Nginx` использует порты `8001`, `8002`, `8003` для трёх вэб-серверов, которые служат зеркалами при балансировке нагрузки **HTTP** протокола (80 порт)

- `ssh` использует протокол `ssh` (`22` порт)

- `systemd-resolve` использует протокол `domain` (`53` порт) для получения информации с DNS серверов

Порт можно посмотреть добавив ключ `-n` или `--numeric` (отключить определения имени сервиса)

```console
vagrant@vagrant:~$ ss -lnt
State                    Recv-Q                   Send-Q                                     Local Address:Port                                        Peer Address:Port                   Process
LISTEN                   0                        4096                                           127.0.0.1:8125                                             0.0.0.0:*
LISTEN                   0                        4096                                             0.0.0.0:19999                                            0.0.0.0:*
LISTEN                   0                        511                                              0.0.0.0:8001                                             0.0.0.0:*
LISTEN                   0                        511                                              0.0.0.0:8002                                             0.0.0.0:*
LISTEN                   0                        511                                              0.0.0.0:8003                                             0.0.0.0:*
LISTEN                   0                        511                                              0.0.0.0:80                                               0.0.0.0:*
LISTEN                   0                        4096                                       127.0.0.53%lo:53                                               0.0.0.0:*
LISTEN                   0                        128                                              0.0.0.0:22                                               0.0.0.0:*
LISTEN                   0                        511                                                 [::]:8001                                                [::]:*
LISTEN                   0                        511                                                 [::]:8002                                                [::]:*
LISTEN                   0                        511                                                 [::]:8003                                                [::]:*
LISTEN                   0                        4096                                                   *:9100                                                   *:*
LISTEN                   0                        128                                                 [::]:22                                                  [::]:*
vagrant@vagrant:~$
```

---

## 4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

Для просмотра только UDP портов используется ключ `-t` или `--tcp`

```console
vagrant@vagrant:~$ sudo ss -lup
State               Recv-Q               Send-Q                              Local Address:Port                               Peer Address:Port              Process
UNCONN              0                    0                                       127.0.0.1:8125                                    0.0.0.0:*                  users:(("netdata",pid=1273,fd=33))
UNCONN              0                    0                                   127.0.0.53%lo:domain                                  0.0.0.0:*                  users:(("systemd-resolve",pid=952,fd=12))
UNCONN              0                    0                                  10.0.2.15%eth0:bootpc                                  0.0.0.0:*                  users:(("systemd-network",pid=815,fd=19))
UNCONN              0                    0                                         0.0.0.0:bootpc                                  0.0.0.0:*                  users:(("dhclient",pid=862,fd=9))
UNCONN              0                    0                                         0.0.0.0:bootpc                                  0.0.0.0:*                  users:(("dhclient",pid=867,fd=9))
vagrant@vagrant:~$
```

Примеры использовани:

- `Netdata` использует порт `8125` для каких-то своих нужд, доступный только локально

- `systemd-resolve` использует протокол `domain` (`53` порт) для получения информации с DNS серверов

- `systemd-network` использует протокол `bootpc` (`68` опрт), доступный с только с `10.0.2.15` адаптера `eth0`

- `dhclient` использует протокол `bootpc` (`68` порт)

Порт можно посмотреть добавив ключ `-n` или `--numeric` (отключить определения имени сервиса)

```console
vagrant@vagrant:~$ ss -lun
State                    Recv-Q                   Send-Q                                      Local Address:Port                                       Peer Address:Port                   Process
UNCONN                   0                        0                                               127.0.0.1:8125                                            0.0.0.0:*
UNCONN                   0                        0                                           127.0.0.53%lo:53                                              0.0.0.0:*
UNCONN                   0                        0                                          10.0.2.15%eth0:68                                              0.0.0.0:*
UNCONN                   0                        0                                                 0.0.0.0:68                                              0.0.0.0:*
UNCONN                   0                        0                                                 0.0.0.0:68                                              0.0.0.0:*
vagrant@vagrant:~$
```

---

## 5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали

![app.diagrams.net](img/diagram.svg)

---

## 6\*. Установите Nginx, настройте в режиме балансировщика TCP или UDP

**Windows** (короткая справка: `nginx.exe -?`

- Запуск: исполныемый файл `nginx.exe` в корне директории установки

- Перезагрузка конфигурационного файла: `nginx.exe -s reload`

- Выключение сервера: `nginx.exe -s stop` или `nginx.exe -s quit`

**Linux**

- Установка: `sudo apt install nginx`

- Запуск сервиса: `sudo systemctl enable nginx && sudo systemctl start nginx`

- Перезагрузка: `sudo systemctl restart nginx`

- Выключение и отключение сервиса: `sudo systemctl stop nginx && sudo systemctl disable nginx`

Конфигурационный файл **Nginx** для **Windows**: `conf/nginx.conf`

```
worker_processes  1;

events {
    worker_connections  1024;
}

stream {
    server {
        listen       80;
        proxy_pass srv_proxy;
    }
    upstream srv_proxy {
        random;
        server 127.0.0.1:8001;
        server 127.0.0.1:8002;
        server 127.0.0.1:8003;
    }
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       8001;
        server_name  srv1.localhost;
        location / {
            root   html/html-1;
            index  index.html;
        }
    }
    server {
        listen       8002;
        server_name  srv2.localhost;
        location / {
            root   html/html-2;
            index  index.html;
        }
    }
    server {
        listen       8003;
        server_name  srv3.localhost;
        location / {
            root   html/html-3;
            index  index.html;
        }
    }
}
```

Для **Linux** по умолчанию параметры **Nginx** конфигурируются в разных файлах.

В основном файле `/etc/nginx/nginx.conf` нужно добавить настройку балансировки:

```
stream {
        server {
                listen 80;
                proxy_pass srv_proxy;
        }
        upstream srv_proxy {
                random;
                server 127.0.0.1:8001;
                server 127.0.0.1:8002;
                server 127.0.0.1:8003;
        }
}
```

В нём подключаются дополнительные файлы конфигурации сайтов:

```
http {
        include /etc/nginx/sites-enabled/*;
}
```

В файле "по умолчанию" (`/etc/nginx/sites-enabled/default`) внести изменение сайтов:

```
server {
        listen 8001;
        listen [::]:8001;
        root /var/www/html-1;
        index index.html;
        server_name srv1.localhost;
        location / {
                try_files $uri $uri/ =404;
        }
}
server {
        listen 8002;
        listen [::]:8002;
        root /var/www/html-2;
        index index.html;
        server_name srv2.localhost;
        location / {
                try_files $uri $uri/ =404;
        }
}
server {
        listen 8003;
        listen [::]:8003;
        root /var/www/html-3;
        index index.html;
        server_name srv3.localhost;
        location / {
                try_files $uri $uri/ =404;
        }
}
```

В группе `stream` настраивается `server` проксирующий `80` порт на группу `srv_proxy`.
Группа `srv_proxy` задаёт режим балансировки (в данном случае `random` - произвольный выбор) и список серверов - в данном примере на три локальных сервера с портами `8001`,`8002`,`8003`

Для корректного функционирования потребуется подготовить директории (`html-1`, `html-2`, `html-3`) и файлы с соответствующим содержимым в них. В **Debian**(**Ubuntu**), возможно, придётся переименовать файлы `index.nginx-debian.html` в `index.html`

После внесения изменений в конфигурационные файлы требуется перезапустить сервис **Nginx**

Проверка балансировки (вывод терминала **Windows**, в **Linux** вывод аналогичный):

```console
06.03.2022 15:12:32,87 D:\..\>curl 127.0.0.1
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<h2>SERVER <b>2</b></h2>
</body>
</html>

06.03.2022 15:12:38,70 D:\..\>curl 127.0.0.1
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<h2>SERVER <b>1</b></h2>
</body>
</html>

06.03.2022 15:12:55,68 D:\..\>
```

> Использовалась статья: [TCP and UDP Load Balancing](https://docs.nginx.com/nginx/admin-guide/load-balancer/tcp-udp-load-balancer/)

> Использовалась статья: [Балансировка нагрузки с помощью NGINX](https://www.dmosk.ru/miniinstruktions.php?mini=nginx-balancing)

> Использовалась статья: [Как настроить nginx в качестве балансировщика нагрузки](https://blog.listratenkov.com/kak-nastroit-nginx-v-kachestve-balansirovshhika-nagruzki/)

---

## 7\*. Установите bird2, настройте динамический протокол маршрутизации RIP

Установка пакета `bird2`: `sudo apt install bird2`

Содержимое конфигурационного файла `bird2` машины `Vagrant-1`

```console
vagrant@vagrant:~$ sudo grep "^[^#]" /etc/bird/bird.conf
log syslog all;
protocol device {
}
protocol direct {
        ipv4;                   # Connect to default IPv4 table
        ipv6;                   # ... and to default IPv6 table
        interface "dummy*";
}
protocol kernel {
        ipv4 {                  # Connect protocol to IPv4 table by channel
              export all;       # Export to protocol. default is export none
        };
        persist;
}
protocol kernel {
        ipv6 { export all; };
}
protocol static {
        ipv4;                   # Again, IPv4 channel with default options
}
protocol rip {
        ipv4 {
                import all;
                export all; #where source ~ [ RTS_DEVICE, RTS_STATIC, RTS_RIP ];
        };
        interface "eth1";
        interface "eth2";
}
vagrant@vagrant:~$
```

Содержимое конфигурационного файла `interfaces` машины `Vagrant-1`

```console
vagrant@vagrant:~$ sudo grep "^[^#]" /etc/network/interfaces
auto dummy0
iface dummy0 inet static
  address 10.3.3.3/32
  pre-up ip link add dummy0 type dummy
  post-down ip link del dummy0
auto eth0
iface eth0 inet dhcp
allow-hotplug eth1
iface eth1 inet static
  address 192.168.1.11
  netmask 255.255.255.0
allow-hotplug eth2
iface eth2 inet static
  address 192.168.2.11
  netmask 255.255.255.0
auto eth3
iface eth3 inet dhcp
vagrant@vagrant:~$
```

Вывод таблицы маршрутов машины `Vagrant-1`

```console
vagrant@vagrant:~$ ip -br r
default via 10.0.2.2 dev eth0
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
10.3.3.3 dev dummy0 proto bird scope link metric 32
10.4.4.4 proto bird metric 32
        nexthop via 192.168.1.22 dev eth1 weight 1
        nexthop via 192.168.2.22 dev eth2 weight 1
192.168.0.0/24 dev eth3 proto kernel scope link src 192.168.0.104
192.168.1.0/24 dev eth1 proto kernel scope link src 192.168.1.11
192.168.2.0/24 dev eth2 proto kernel scope link src 192.168.2.11
vagrant@vagrant:~$
```

Содержимое конфигурационного файла `bird2` машины `Vagrant-2`

```console
vagrant@vagrant:~$ sudo grep "^[^#]" /etc/bird/bird.conf
log syslog all;
protocol device {
}
protocol direct {
        #disabled;              # Disable by default
        ipv4;                   # Connect to default IPv4 table
        interface "dummy*";
        #ipv6;                  # ... and to default IPv6 table
}
protocol kernel {
        ipv4 {                  # Connect protocol to IPv4 table by channel
              export all;       # Export to protocol. default is export none
        };
        persist;
}
protocol kernel {
        ipv6 { export all; };
}
protocol static {
        ipv4;                   # Again, IPv4 channel with default options
}
protocol rip {
        ipv4 {
                export all;
                import all;
        };
        interface "eth1";
        interface "eth2";
}
vagrant@vagrant:~$
```

Содержимое конфигурационного файла `interfaces` машины `Vagrant-2`

```console
vagrant@vagrant:~$ sudo grep "^[^#]" /etc/network/interfaces
auto dummy0
iface dummy0 inet static
  address 10.4.4.4/32
  pre-up ip link add dummy0 type dummy
  post-down ip link del dummy0
auto eth0
iface eth0 inet dhcp
allow-hotplug eth1
iface eth1 inet static
  address 192.168.1.22
  netmask 255.255.255.0
allow-hotplug eth2
iface eth2 inet static
  address 192.168.2.22
  netmask 255.255.255.0
auto eth3
iface eth3 inet dhcp
vagrant@vagrant:~$
```

Вывод таблицы маршрутов машины `Vagrant-2`

```console
vagrant@vagrant:~$ ip -br r
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
10.3.3.3 proto bird metric 32
        nexthop via 192.168.1.11 dev eth1 weight 1
        nexthop via 192.168.2.11 dev eth2 weight 1
10.4.4.4 dev dummy0 proto bird scope link metric 32
192.168.0.0/24 dev eth3 proto kernel scope link src 192.168.0.105
192.168.1.0/24 dev eth1 proto kernel scope link src 192.168.1.22
192.168.2.0/24 dev eth2 proto kernel scope link src 192.168.2.22
vagrant@vagrant:~$
```

---

## 8\*. Установите Netbox, создайте несколько IP префиксов, используя curl проверьте работу API

Установка **Netbox** стандартным способом по [оффициальной документации](https://netbox.readthedocs.io/en/stable/installation/)

Установка **Netbox** с использованием образа **Docker** из [NetBox-community](https://github.com/netbox-community/netbox-docker)

Запуск в **foreground** режиме при стандартной установке: `python3 /opt/netbox/netbox/manage.py runserver 0.0.0.0:8000 --insecure`

> Для виртуальной машины с установленным **Netbox** гостевой порт 8000 проброшен на хостовый порт 2205

Основной вид запущенного приложения:

![netbox](img/netbox-1.png)

Встроенная документация по REST API (используется интерактивный просмотр OpenAPI Swagger):

![netbox](img/netbox-2.png)

Функции REST API:

![netbox](img/netbox-3.png)

Проверка работы API с использованием `curl`:

> Перед использованием API нужно добавить Token авторизации запросов через меню аккаунта `Preferences` -> `API Tokens`

```console
vagrant@vagrant:/opt/netbox/netbox$ sudo curl -ss -X GET -H "Authorization: Token cdbf75329a61a7e91da117254e4aec994ff34d84" -H "Content-Type: application/json" -H "Accept: application/json; indent=4" http://127.0.0.1:8000/api/ipam/prefixes/
{
    "count": 2,
    "next": null,
    "previous": null,
    "results": [
        {
            "id": 3,
            "url": "http://127.0.0.1:8000/api/ipam/prefixes/3/",
            "display": "10.0.2.0/24",
            "family": {
                "value": 4,
                "label": "IPv4"
            },
            "prefix": "10.0.2.0/24",
            "site": null,
            "vrf": null,
            "tenant": null,
            "vlan": null,
            "status": {
                "value": "active",
                "label": "Active"
            },
            "role": null,
            "is_pool": false,
            "mark_utilized": false,
            "description": "",
            "tags": [],
            "custom_fields": {},
            "created": "2022-03-06",
            "last_updated": "2022-03-06T23:57:38.874945Z",
            "children": 0,
            "_depth": 0
        },
        {
            "id": 2,
            "url": "http://127.0.0.1:8000/api/ipam/prefixes/2/",
            "display": "10.4.4.4/32",
            "family": {
                "value": 4,
                "label": "IPv4"
            },
            "prefix": "10.4.4.4/32",
            "site": null,
            "vrf": null,
            "tenant": null,
            "vlan": null,
            "status": {
                "value": "active",
                "label": "Active"
            },
            "role": null,
            "is_pool": false,
            "mark_utilized": false,
            "description": "",
            "tags": [],
            "custom_fields": {},
            "created": "2022-03-06",
            "last_updated": "2022-03-06T23:55:20.900043Z",
            "children": 0,
            "_depth": 0
        }
    ]
}
vagrant@vagrant:/opt/netbox/netbox$
```

---

Использованные в лекции материалы:

- `ip route add 172.16.10.0/24 via 192.168.1.1` - Добавление маршрута через шлюз

- `ip route add 172.16.10.0/24 dev eth0` - Добавить маршрут через интерфейс

- `ip route add 172.16.10.0/24 dev eth0 metric 100` - Добавить маршрут через интерфейс с метрикой

- `ip route show 10.0.0.0/8` - Просмотр маршрутов по определённой сети

- `cat /proc/sys/net/ipv4/ip_forward` - Флаг пересылки пакетов интерфейсами (1 - Включено)

- `cat /etc/iproute2/rt_tables` - Таблицы маршрутизации

  ```
  # Reserved
  255 local
  254 main
  253 default
  0 unspec
  # Local
  ```

- `source /etc/network/interfaces.d/*` - Добавление постоянных маршрутов в файл `/etc/network/interfaces`

  ```
  # Сетевой интерфейс Loopback
  auto lo
  iface lo inet loopback

  auto eth0
  allow-hotplug eth0
  # iface eth0 inet dhcp
  iface eth0 inet static
    address 10.10.10.140
    netmask 255.255.255.0
    gateway 10.10.10.1

  auto eth1
  allow-hotplug eth1
  iface eth1 inet static
    address 172.16.100.10
    netmask 255.255.255.0
    post-up ip route add 172.16.100.0/24 dev eth1 src 172.16.100.10 table mgmt
    post-up ip route add default via 172.16.100.1 dev eth1 table mgmt
    post-up ip rule add from 172.16.100.10/32 table mgmt
    post-up ip route add to 172.16.100.10/32 table mgmt
  ```

- **Dummy** интерфейсы - часто используется для анонсирования маршрутов

  - `echo "dummy" >> /etc/modules` - Включение условного модуля ядра

  - `echo "options dummy numdummies=2" > /etc/modprobe.d/dummy.conf` - Настройка **Dummy** интерфейсов

  - Пример настройки в `/etc/network/interfaces`:

    ```
    auto dummy0
    iface dummy0 inet static
      address 10.2.2.2/32
      pre-up ip link add dummy0 type dummy
      post-down ip link del dummy0
    ```

  - `Bird` - Динамическая маршрутизация в Linux (пакет `bird2`). Консоль управления: `birdc`. Конфигурационный файл: `/etc/bird/bird.conf`

  - `ss -l` - Порты в ожидании входящего трафика

  - `ss -ua` - UDP сокеты

  - `ss -p` - Показать процесс использующий сокет

  - `ss -au sport = :123` - Фильтр по **Source Port**

  - `ss -s` - Статистика

