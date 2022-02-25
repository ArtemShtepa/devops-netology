# Домашнее задание по лекции "3.7. Компьютерные сети. Часть 2"

## 1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

В **Linux** посмотреть список интерфейсов можно:

- Программой `ip` с параметрами `link` (или `link show`) или `address`

  ```console
  vagrant@vagrant:~$ ip -br link
  lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
  eth0             UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
  vagrant@vagrant:~$
  ```

- Простейшим перечислением файлов: `ls /sys/class/net`

  ```console
  vagrant@vagrant:~$ ls /sys/class/net
  eth0  lo
  vagrant@vagrant:~$
  ```

- В файле ядра системы: `cat /proc/net/dev`

  ```console
  vagrant@vagrant:~$ cat /proc/net/dev
  Inter-|   Receive                                                |  Transmit
   face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
      lo:   90604    1770    0    0    0     0          0         0    90604    1770    0    0    0     0       0          0
    eth0: 1038089    1368    0    0    0     0          0         0   102347     752    0    0    0     0       0          0
  vagrant@vagrant:~$
  ```

- Программой `netstat` с ключом `-i` (Требуется установка `apt install net-tools`)

  ```console
  vagrant@vagrant:~$ netstat -i
  Kernel Interface table
  Iface      MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
  eth0      1500     1744      0      0 0           932      0      0      0 BMRU
  lo       65536     1780      0      0 0          1780      0      0      0 LRU
  vagrant@vagrant:~$
  ```

- Программой `lshw` с ключом `-class network`

  ```console
  vagrant@vagrant:~$ sudo lshw -class network -short
  H/W path      Device     Class      Description
  ===============================================
  /0/100/3      eth0       network    82540EM Gigabit Ethernet Controller
  vagrant@vagrant:~$
  ```

- Фильтром вывода всех PCI устройств системы по ключевым фразам: `lspci | egrep -i 'network|ethernet|wireless|wi-fi'`

  ```console
  vagrant@vagrant:~$ lspci | egrep -i 'network|ethernet|wireless|wi-fi'
  00:03.0 Ethernet controller: Intel Corporation 82540EM Gigabit Ethernet Controller (rev 02)
  vagrant@vagrant:~$
  ```

В **Windows** посмотреть список сетевых интерфейсов можно:

- Программой `ipconfig`

  ```console
  PS D:\vm\Vagrant-1> ipconfig
  
  Windows IP Configuration
  
  
  Ethernet adapter Intel:
  
     Media State . . . . . . . . . . . : Media disconnected
     Connection-specific DNS Suffix  . :
  
  Ethernet adapter VirtualBox Host-Only Network:
  
     Connection-specific DNS Suffix  . :
     Link-local IPv6 Address . . . . . : fe80::69bd:e5ab:a136:df99%4
     IPv4 Address. . . . . . . . . . . : 192.168.56.1
     Subnet Mask . . . . . . . . . . . : 255.255.255.0
     Default Gateway . . . . . . . . . :
  
  Ethernet adapter E2500:
  
     Connection-specific DNS Suffix  . :
     Link-local IPv6 Address . . . . . : fe80::a439:5e6:3316:1cb2%15
     IPv4 Address. . . . . . . . . . . : 192.168.1.162
     Subnet Mask . . . . . . . . . . . : 255.255.255.0
     Default Gateway . . . . . . . . . : 192.168.1.1
  PS D:\vm\Vagrant-1>
  ```

- Используя функционал программы `netsh` с использованием следующих ключей `interface ipv4 show interfaces` (не единственный вариант использования)

  ```console
  PS D:\vm\Vagrant-1> netsh interface ipv4 show interfaces
  
  Idx     Met         MTU          State                Name
  ---  ----------  ----------  ------------  ---------------------------
    1          75  4294967295  connected     Loopback Pseudo-Interface 1
   16           5        1500  disconnected  Intel
   15          35        1500  connected     E2500
    4          25        1500  connected     VirtualBox Host-Only Network
  
  PS D:\vm\Vagrant-1>
  ```

- Программой `route print`

  ```console
  PS D:\vm\Vagrant-1> route print
  ===========================================================================
  Interface List
   16...1c 1b 0d 9e 35 e1 ......Intel(R) I211 Gigabit Network Connection
    4...0a 00 27 00 00 04 ......VirtualBox Host-Only Ethernet Adapter
   15...1c 1b 0d 9e 35 df ......Killer E2500 Gigabit Ethernet Controller
    1...........................Software Loopback Interface 1
  ===========================================================================
  
  IPv4 Route Table
  ===========================================================================
  Active Routes:
  Network Destination        Netmask          Gateway       Interface  Metric
            0.0.0.0          0.0.0.0      192.168.1.1    192.168.1.162     35
          127.0.0.0        255.0.0.0         On-link         127.0.0.1    331
          127.0.0.1  255.255.255.255         On-link         127.0.0.1    331
    127.255.255.255  255.255.255.255         On-link         127.0.0.1    331
        192.168.1.0    255.255.255.0         On-link     192.168.1.162    291
      192.168.1.162  255.255.255.255         On-link     192.168.1.162    291
      192.168.1.255  255.255.255.255         On-link     192.168.1.162    291
       192.168.56.0    255.255.255.0         On-link      192.168.56.1    281
       192.168.56.1  255.255.255.255         On-link      192.168.56.1    281
     192.168.56.255  255.255.255.255         On-link      192.168.56.1    281
          224.0.0.0        240.0.0.0         On-link         127.0.0.1    331
          224.0.0.0        240.0.0.0         On-link      192.168.56.1    281
          224.0.0.0        240.0.0.0         On-link     192.168.1.162    291
    255.255.255.255  255.255.255.255         On-link         127.0.0.1    331
    255.255.255.255  255.255.255.255         On-link      192.168.56.1    281
    255.255.255.255  255.255.255.255         On-link     192.168.1.162    291
  ===========================================================================
  Persistent Routes:
    None
  
  IPv6 Route Table
  ===========================================================================
  Active Routes:
   If Metric Network Destination      Gateway
    1    331 ::1/128                  On-link
    4    281 fe80::/64                On-link
   15    291 fe80::/64                On-link
    4    281 fe80::69bd:e5ab:a136:df99/128
                                      On-link
   15    291 fe80::a439:5e6:3316:1cb2/128
                                      On-link
    1    331 ff00::/8                 On-link
    4    281 ff00::/8                 On-link
   15    291 ff00::/8                 On-link
  ===========================================================================
  Persistent Routes:
    None
  PS D:\vm\Vagrant-1>
  ```

---

## 2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

Для распозначания соседа по сетевому интерфейсу используется протокол [LLDP](https://ru.wikipedia.org/wiki/LLDP)

**Link Layer Discovery Protocol** - Протокол для обмена информацией между соседними устройствами.

Установка пакета: `sudo apt install lldpd`

Настройка автоматического запуска сервиса: `sudo systemctl enable lldpd && sudo systemctl start lldpd`

Для получения информации о соседях необходимо какое-то время (примерно 15 минут), после чего их можно посмотреть командой `lldpctl`

```console
vagrant@vagrant:~$ lldpctl
-------------------------------------------------------------------------------
LLDP neighbors:
-------------------------------------------------------------------------------
Interface:    eth1, via: LLDP, RID: 1, Time: 0 day, 00:33:00
  Chassis:
    ChassisID:    mac 08:00:27:f7:77:5d
    SysName:      vagrant
    SysDescr:     Ubuntu 20.04.3 LTS Linux 5.4.0-91-generic #102-Ubuntu SMP Fri Nov 5 16:31:28 UTC 2021 x86_64
    MgmtIP:       10.0.2.15
    MgmtIP:       fe80::a00:27ff:fef7:775d
    Capability:   Bridge, off
    Capability:   Router, off
    Capability:   Wlan, off
    Capability:   Station, on
  Port:
    PortID:       mac 08:00:27:8a:78:17
    PortDescr:    eth1
    TTL:          120
    PMD autoneg:  supported: yes, enabled: yes
      Adv:          10Base-T, HD: yes, FD: yes
      Adv:          100Base-TX, HD: yes, FD: yes
      Adv:          1000Base-T, HD: no, FD: yes
      MAU oper type: 1000BaseTFD - Four-pair Category 5 UTP, full duplex mode
-------------------------------------------------------------------------------
Interface:    eth1, via: LLDP, RID: 3, Time: 0 day, 00:32:46
  Chassis:
    ChassisID:    mac 08:00:27:e0:bb:41
    SysName:      vagrant
    SysDescr:     Ubuntu 20.04.3 LTS Linux 5.4.0-91-generic #102-Ubuntu SMP Fri Nov 5 16:31:28 UTC 2021 x86_64
    MgmtIP:       10.0.2.15
    MgmtIP:       fe80::a00:27ff:fee0:bb41
    Capability:   Bridge, off
    Capability:   Router, off
    Capability:   Wlan, off
    Capability:   Station, on
  Port:
    PortID:       mac 08:00:27:3c:60:d4
    PortDescr:    eth1
    TTL:          120
    PMD autoneg:  supported: yes, enabled: yes
      Adv:          10Base-T, HD: yes, FD: yes
      Adv:          100Base-TX, HD: yes, FD: yes
      Adv:          1000Base-T, HD: no, FD: yes
      MAU oper type: 1000BaseTFD - Four-pair Category 5 UTP, full duplex mode
-------------------------------------------------------------------------------
Interface:    eth2, via: LLDP, RID: 1, Time: 0 day, 00:32:58
  Chassis:
    ChassisID:    mac 08:00:27:f7:77:5d
    SysName:      vagrant
    SysDescr:     Ubuntu 20.04.3 LTS Linux 5.4.0-91-generic #102-Ubuntu SMP Fri Nov 5 16:31:28 UTC 2021 x86_64
    MgmtIP:       10.0.2.15
    MgmtIP:       fe80::a00:27ff:fef7:775d
    Capability:   Bridge, off
    Capability:   Router, off
    Capability:   Wlan, off
    Capability:   Station, on
  Port:
    PortID:       mac 08:00:27:53:ec:c3
    PortDescr:    eth2
    TTL:          120
    PMD autoneg:  supported: yes, enabled: yes
      Adv:          10Base-T, HD: yes, FD: yes
      Adv:          100Base-TX, HD: yes, FD: yes
      Adv:          1000Base-T, HD: no, FD: yes
      MAU oper type: 1000BaseTFD - Four-pair Category 5 UTP, full duplex mode
-------------------------------------------------------------------------------
Interface:    eth2, via: LLDP, RID: 2, Time: 0 day, 00:32:53
  Chassis:
    ChassisID:    mac 0a:00:27:00:00:04
  Port:
    PortID:       mac 0a:00:27:00:00:04
    TTL:          3601
    PMD autoneg:  supported: yes, enabled: yes
      Adv:          1000Base-T, HD: no, FD: yes
      MAU oper type: unknown
  LLDP-MED:
    Device Type:  Generic Endpoint (Class I)
    Capability:   Capabilities, yes
-------------------------------------------------------------------------------
Interface:    eth2, via: LLDP, RID: 3, Time: 0 day, 00:32:44
  Chassis:
    ChassisID:    mac 08:00:27:e0:bb:41
    SysName:      vagrant
    SysDescr:     Ubuntu 20.04.3 LTS Linux 5.4.0-91-generic #102-Ubuntu SMP Fri Nov 5 16:31:28 UTC 2021 x86_64
    MgmtIP:       10.0.2.15
    MgmtIP:       fe80::a00:27ff:fee0:bb41
    Capability:   Bridge, off
    Capability:   Router, off
    Capability:   Wlan, off
    Capability:   Station, on
  Port:
    PortID:       mac 08:00:27:db:ab:20
    PortDescr:    eth2
    TTL:          120
    PMD autoneg:  supported: yes, enabled: yes
      Adv:          10Base-T, HD: yes, FD: yes
      Adv:          100Base-TX, HD: yes, FD: yes
      Adv:          1000Base-T, HD: no, FD: yes
      MAU oper type: 1000BaseTFD - Four-pair Category 5 UTP, full duplex mode
-------------------------------------------------------------------------------
vagrant@vagrant:~$
```

> В приведённом выше примере в единую сеть объединены три виртуальные машины с тремя сетевыми картами, из которых: первые **eth0** - NAT, вторые **eth1** - Внутренняя сеть, третьи **eth2** - Виртуальный адаптер хоста.

---

## 3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига

Для разделения L2 коммутатора на несколько виртуальных сетей используется технология `VLAN` [виртуальное разделение коммутатора](http://xgu.ru/wiki/VLAN). В Linux используется одноимённый пакет **VLAN**.

Установка пакета: `sudo apt install vlan`

Для конфигурирования виртуальных сетей используется `vconfig`:

```console
vagrant@vagrant:~$ vconfig

Warning: vconfig is deprecated and might be removed in the future, please migrate to ip(route2) as soon as possible!

Expecting argc to be 3-5, inclusive.  Was: 1

Usage: add             [interface-name] [vlan_id]
       rem             [vlan-name]
       set_flag        [interface-name] [flag-num]       [0 | 1]
       set_egress_map  [vlan-name]      [skb_priority]   [vlan_qos]
       set_ingress_map [vlan-name]      [skb_priority]   [vlan_qos]
       set_name_type   [name-type]

* The [interface-name] is the name of the ethernet card that hosts
  the VLAN you are talking about.
* The vlan_id is the identifier (0-4095) of the VLAN you are operating on.
* skb_priority is the priority in the socket buffer (sk_buff).
* vlan_qos is the 3 bit priority in the VLAN header
* name-type:  VLAN_PLUS_VID (vlan0005), VLAN_PLUS_VID_NO_PAD (vlan5),
              DEV_PLUS_VID (eth0.0005), DEV_PLUS_VID_NO_PAD (eth0.5)
* FLAGS:  1 REORDER_HDR  When this is set, the VLAN device will move the
            ethernet header around to make it look exactly like a real
            ethernet device.  This may help programs such as DHCPd which
            read the raw ethernet packet and make assumptions about the
            location of bytes.  If you don't need it, don't turn it on, because
            there will be at least a small performance degradation.  Default
            is OFF.
vagrant@vagrant:~$
```

Основные команды **vconfig**:

- `vconfig add <интерфейс> <vlan_id>` - добавить виртуальную сеть **vlan** для интерфейса `<интерфейс>` с идентификатором `<vlan_id>`. В итоге получится имя `<интерфейс>.<vlan_id>`

  ```console
  vagrant@vagrant:~$ sudo vconfig add eth0 2

  Warning: vconfig is deprecated and might be removed in the future, please migrate to ip(route2) as soon as possible!

  vagrant@vagrant:~$ ip -br link
  lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
  eth0             UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
  eth0.2@eth0      DOWN           08:00:27:b1:28:5d <BROADCAST,MULTICAST>
  vagrant@vagrant:~$
  ```

- `vconfig rem <vlan_name>` - удалить виртуальную сеть **vlan** с именем `<vlan_name>`

  ```console
  vagrant@vagrant:~$ sudo vconfig rem eth0.2

  Warning: vconfig is deprecated and might be removed in the future, please migrate to ip(route2) as soon as possible!

  vagrant@vagrant:~$ ip -br link
  lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
  eth0             UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
  vagrant@vagrant:~$
  ```

Нужно обратить внимание, что использование команды `vconfig` не рекомендуется, так как она признана устаревшей, поэтому следует использовать команду `ip`

Создание виртуальной сети **VLAN** командой **ip**: `ip link add link <интерфейс> [name [<имя>] type vlan id <VLANID>`, где `<интерфейс>` - имя сетевого интерфейса для которого создаётся связь, `<имя>` - имя создаваемой виртуальной сети (по умолчанию будет `vlan` c порядковым номером начиная с 0), `<VLANID>` - идентификатор виртуальной сети - число от 2 до 4094 (0, 1 и 4095 зарезервированы)

```console
vagrant@vagrant:~$ sudo ip link add link eth0 name eth0.2 type vlan id 2
vagrant@vagrant:~$ sudo ip link add link eth1 type vlan id 3
vagrant@vagrant:~$ ip -br address
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.0.2.15/24 fe80::a00:27ff:feb1:285d/64
eth1             UP             192.168.0.104/24 fe80::a00:27ff:fe3c:a531/64
eth2             UP             192.168.0.105/24 fe80::a00:27ff:fe6a:a71c/64
eth3             UP             192.168.0.106/24 fe80::a00:27ff:fed3:9a8e/64
eth0.2@eth0      DOWN
vlan0@eth1       DOWN
vagrant@vagrant:~$
```

Удаление виртуальной сети **VLAN** командой **ip**: `ip link delete <VLAN>`, где `<VLAN>` - имя виртуальной сети

```console
vagrant@vagrant:~$ sudo ip link delete eth0.2
vagrant@vagrant:~$ sudo ip link delete vlan0
vagrant@vagrant:~$ ip -br address
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.0.2.15/24 fe80::a00:27ff:feb1:285d/64
eth1             UP             192.168.0.104/24 fe80::a00:27ff:fe3c:a531/64
eth2             UP             192.168.0.105/24 fe80::a00:27ff:fe6a:a71c/64
eth3             UP             192.168.0.106/24 fe80::a00:27ff:fed3:9a8e/64
vagrant@vagrant:~$
```

Для активации интерфейса с присвоением ему сетевого адресу нужно выполнить команду

- `sudo ifconfig eth0.2 192.168.0.101 netmask 255.255.255.0 broadcast 192.168.0.255 up`

либо последовательно

- `sudo ip addr add 192.168.0.101/24 brd 192.168.0.255 dev eth0.2`

- `sudo ip link set dev eth0.2 up`

Для выключения интерфейса нужно выполнить команду

- `sudo ifconfig eth0.2 down`

либо

- `sudo ip link set dev eth0.2 down`

При использовании вышеописанных команд созданные виртуальные сети при перезагрузке будут утеряны.
Для создания постоянных виртуальных сетей необходимо настроить службу `networking`, входящую в пакет `ifupdown` или `ifenslave`.

- Установка пакета: `sudo apt install ifenslave`

- Запуск и настройка службы на автозапуск: `sudo systemctl enable networking && sudo systemctl start networking`

- Внести в файл `/etc/network/interfaces` следующие строки:

  ```
  auto eth1.2
  iface eth1.2 inet static
    address 192.168.0.101
    netmask 255.255.255.0
    vlan-raw-device eth1

  auto vlan3
  iface vlan3 inet static
    address 192.168.0.103
    netmask 255.255.255.0
    vlan-raw-device eth3
  ```

  В данном примере создаются две **VLAN**:

  - с именем `eth1.2` на интерфейсе `eth1` со статическим адресом `192.168.0.101` в сети `192.168.0.0/24`

  - с именем `vlan3` на интерфейсе `eth3` со статическим адресом `192.168.0.103` в сети `192.168.0.0/24`

- Перезапустить систему либо службу: `sudo systemctl restart networking`

> Использовалась статья: [Настройка VLAN интерфейсов в Linux](https://itproffi.ru/nastrojka-vlan-interfejsov-v-linux/)

---

## 4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

Агрегация интерфейсов - объединение нескольких интерфейсов в совместную работу в одном из следующих режимов:

| Режим | Название | Описание |
| --- | --- | --- |
| 0 | balance-rr | Трафик распределяется по принципу «карусели»: пакеты по очереди направляются на сетевые карты объединённого интерфейса. Например, при объединении eth0, eth1 и eth2 первый пакет будет отправлен на eth0, второй на eth1, третий на eth2, четвёртый на eth0 и так далее |
| 1 | active-backup | Работает только один физический интерфейс, остальные являются резервными на случай отказа основного |
| 2 | balance-xor | Определение через какой физический интерфейс отправлять выполняется в зависимости от MAC адресов источника и получателя |
| 3 | broadcast | Все пакеты отправляются через каждый интерфейс |
| 4 | 802.3ad | Особый режим объединения в соответствии со стандартом IEEE. Требуется специально настроенный коммутатор |
| 5 | balance-tlb | Распределение нагрузки при передаче. Входящий трафик обрабатывается в обычном режиме, а при передаче интерфейс определяется на основе данных о загруженности |
| 6 | balance-alb | Адаптивное распределение нагрузки как при приёме, так и при передаче |

Балансировка задаётся параметром `xmit_hash_policy` и может осуществляться следующими алгоритмами:

| Режим | Описание |
| --- | --- |
| layer2 | Для генерации хэша используются только MAC адреса отправителя и получателя. Трафик для конкретного сетевого хоста будет отправляться всегда через один и тот же интерфейс получателя (политика по-умолчанию) |
| layer2+3 | Для генерации хэша используются MAC и IP адреса отправителя и получателя. Трафик для конкретного сетевого хоста будет отправляться всегда через один и тот же интерфейс получателя |
| layer3+4 | Для генерации хэша используются IP адрес и протокол транспортного уровня (TCP или UDP) когда доступна. (This allows for traffic to a particular network peer to span multiple slaves, although a single connection will not span multiple slaves) |
| encap2+3 | То же, что и layer2+3, но информация из заголовков выбирается на основе данных потоков, что может вести к использованию внутренних заголовков (например, при использовании туннелирования) (it relies on skb_flow_dissect to obtain the header fields which might result in the use of inner headers if an encapsulation protocol is used) |
| encap3+4 | То же, что и encap2+3, но используется хеш IP адресов и информации из вышележащих уровней. (it relies on skb_flow_dissect to obtain the header fields which might result in the use of inner headers if an encapsulation protocol is used) |

Для функционирования агрегации требуется драйвер ядра `bonding`. Проверка: `sudo modprobe bonding && echo "OK"`

Также может потребоваться установка пакета **ifenslave**: `sudo apt install ifenslave`

Создание агрегированного интерфейса командой **ip**: `ip link add <имя> type bond mode <режим>`, где `<имя>` - название создаваемого интерфейса, `<режим>` - режим агрегации

```console
vagrant@vagrant:~$ sudo ip link add bond0 type bond mode balance-rr
vagrant@vagrant:~$ sudo ip link set eth2 master bond0
vagrant@vagrant:~$ sudo ip link set eth3 master bond0
vagrant@vagrant:~$ ip -br address
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.0.2.15/24 fe80::a00:27ff:feb1:285d/64
eth1             UP             192.168.0.104/24 fe80::a00:27ff:fe3c:a531/64
eth2             UP
eth3             UP
bond0            DOWN
vagrant@vagrant:~$
```

Активировать интерфейс можно аналогично решению в пункте 3

При использовании вышеописанных команд созданный интерфейс при перезагрузке будет утерян.
Для создания постоянного агрегированного интерфейса необходимо настроить службу `networking`,
для чего содержимое файла `/etc/network/interfaces` изменить следующим образом:

  ```console
  auto eth1
  iface eth1 inet manual
    bond-master bond0
  
  auto eth2
  iface eth2 inet manual
    bond-master bond0
  
  auto eth3
  iface eth3 inet manual
    bond-master bond0
  
  auto bond0
  iface bond0 inet static
    address 192.168.0.77
    netmask 255.255.255.0
    broadcast 192.168.0.255
    gateway 192.168.0.1
      bond-mode 0
      bond-slaves eth1 eth2 eth3
  ```

  В данном примере создаётся агрегированный интерфейс `bond0` со статическим адресом `192.168.0.77` в сети `192.168.0.0/24` со шлюзом `192.168.0.1` объединяя три физических интерфейса `eth1`,`eth2` и `eth3` в режиме `0` или `balance-rr`

  Вывод после перезагрузки системы:

  ```console
  vagrant@vagrant:~$ ip -br a
  lo               UNKNOWN        127.0.0.1/8 ::1/128
  eth0             UP             10.0.2.15/24 fe80::a00:27ff:feb1:285d/64
  eth1             UP
  eth2             UP
  eth3             UP
  bond0            UP             192.168.0.77/24 fe80::a00:27ff:fe22:653d/64
  vagrant@vagrant:~$
  ```

  Проверка агрегированного интерфейса **bond0**:

  ```console
  vagrant@vagrant:~$ cat /proc/net/bonding/bond0
  Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
  
  Bonding Mode: load balancing (round-robin)
  MII Status: up
  MII Polling Interval (ms): 0
  Up Delay (ms): 0
  Down Delay (ms): 0
  Peer Notification Delay (ms): 0
  
  Slave Interface: eth2
  MII Status: up
  Speed: 1000 Mbps
  Duplex: full
  Link Failure Count: 0
  Permanent HW addr: 08:00:27:22:65:3d
  Slave queue ID: 0
  
  Slave Interface: eth1
  MII Status: up
  Speed: 1000 Mbps
  Duplex: full
  Link Failure Count: 0
  Permanent HW addr: 08:00:27:2d:11:a3
  Slave queue ID: 0
  
  Slave Interface: eth3
  MII Status: up
  Speed: 1000 Mbps
  Duplex: full
  Link Failure Count: 0
  Permanent HW addr: 08:00:27:08:d3:64
  Slave queue ID: 0
  vagrant@vagrant:~$
  ```

> Использовалась статья: [UbuntuBonding](https://help.ubuntu.com/community/UbuntuBonding)

> Использовалась статья: [Linux bonding — объединение сетевых интерфейсов в Linux](http://www.adminia.ru/linux-bonding-obiedinenie-setevyih-interfeysov-v-linux/)

> Использовалась статья: [Объединение сетевых интерфейсов в Linux. Настройка bonding](https://itproffi.ru/obedinenie-setevyh-interfejsov-v-linux-nastrojka-bonding/) **ВНИМАНИЕ!** В статье есть опечатки!

---

## 5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

Маска `/29` означает, что для номера сети используется **29** бит сетевого адреса IPv4, значит на номер хоста осталось **32-29=3** бита. **3** бита это **8** различных значений (2 в третьей степени), а с учётом номера сети (все биты номера хоста **=0**) и широковещательного адреса (все биты номера хоста **=1**) остаётся **6**.

Ответ: В сети с маской `/29` может быть только `6 хостов`

Сеть с маской `/24` может иметь **8** бит на номер хоста.
Сеть с маской `/29` может имеет **3** бита на номер хоста.
Следовательно в сети `/24` можно выделить **8-3=5** бит на распределение подсетей `/29`, а это **2^5=32**

Ответ: В сети с маской `/24` можно выделить `32` подсети с маской `/29`

Примеры подсетей `/29`:

  - Подсеть: `10.10.10.232` с IP адресами хостов `10.10.10.233` ... `10.10.10.238`

  - Подсеть: `10.10.10.184` с IP адресами хостов `10.10.10.185` ... `10.10.10.190`

  - Подсеть: `10.10.10.104` с IP адресами хостов `10.10.10.105` ... `10.10.10.110`

  - Подсеть: `10.10.10.96` с IP адресами хостов `10.10.10.97` ... `10.10.10.102`

  - Подсеть: `10.10.10.40` с IP адресами хостов `10.10.10.41` ... `10.10.10.46`

> Использовалась статья: [Пример расчета количества хостов и подсетей](https://help.keenetic.com/hc/ru/articles/213965829-Пример-расчета-количества-хостов-и-подсетей-на-основе-IP-адреса-и-маски)

---

## 6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

Из списка частных сетей можно использовать так называемый `Carrier-Grade NAT` диапазон, а именно: `100.64.0.0`-`100.127.255.255`

Для распределение 40-50 хостов необходимо использовать минимум `6 бит` для номера хоста, что хватит для **62** хостов. Меньшее число бит (**5**) сможет вместить только **30** хостов. Следовательно маска должна быть (**32-6**) `/26`

Ответ: для объединения двух организаций можно использовать сеть `100.80.90.0/26`, среди которой будут распределены до **62** IP адресов от `100.80.90.1` до `100.80.90.62`

```console
vagrant@vagrant:~$ ipcalc 100.80.90.0/26
Address:   100.80.90.0          01100100.01010000.01011010.00 000000
Netmask:   255.255.255.192 = 26 11111111.11111111.11111111.11 000000
Wildcard:  0.0.0.63             00000000.00000000.00000000.00 111111
=>
Network:   100.80.90.0/26       01100100.01010000.01011010.00 000000
HostMin:   100.80.90.1          01100100.01010000.01011010.00 000001
HostMax:   100.80.90.62         01100100.01010000.01011010.00 111110
Broadcast: 100.80.90.63         01100100.01010000.01011010.00 111111
Hosts/Net: 62                    Class A

vagrant@vagrant:~$
```

---

## 7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

| | Linux | Windows |
| --- | --- | --- |
| Вывод таблицы | `arp -n` | `arp -a` |
| Вывод таблицы с заменой именами (dns)  | `arp` или `arp -a` | |
| Добавление записи | `arp -s <IP> <MAC>` | `arp -s <IP> <MAC>` |
| Удаление конкретной записи | `arp -d <IP>` | `arp -d <IP>` |
| Полная очистка кэша | `ip neigh flush all` | `netsh interface IP delete arpcache` |

где `<IP>` - **IPv4** адрес, `<MAC>` - Физический адрес сетевого устройства

В обоих операционных системах для всех операций, кроме вывода **ARP** таблицы требуются права администратора

---

Использованные в лекции материалы:

- `ip -c -br link` - Вывод списка всех интерфейсов

- `ip link set dev <интерфейс> down|up` - Выключить(**down**)/Включить(**up**) сетевой интерфейст `<интерфейс>`

- `dhclient <интерфейс>` - Опросить DHCP сервер для установки IP адреса для интерфейса `<интерфейс>` и включить его если выключен

- `VLAN` - Виртуальное разделение сетевого интерфейса [Настройка VLAN в Ubuntu](http://xgu.ru/wiki/VLAN_в_Ubuntu)

- `LAG` - [Агрегация портов](http://xgu.ru/wiki/Агрегирование_каналов). Используемый пакет: `apt install ifenslave`. [Настройка в Debian](https://wiki.debian.org/Bonding)

- Калькулятор подсетей: `apt install ipcalc`. Пример расчёта: `ipcalc 192.168.1.1/24`

- Частные подсети:

  - 10.0.0.0 - 10.255.255.255 (Маска подсети: 255.0.0.0 или /8)

  - 172.16.0.0. - 172.31.255.255 (Маска подсети: 255.240.0.0 или /12)

  - 192.168.0.0 - 192.168.255.255 (Маска подсети: 255.255.0.0 или /16)

  - 100.64.0.0 - 100.127.255.255 (Маска подсети: 255.192.0.0 или /10) Carrier-Grade NAT

- Специальные подсети:

  - 127.0.0.0/8 - localhost

  - 169.254.0.0/16 - автоназначение, если настроено получение адреса по DHCP, но ни одного сервера нет

  - 224.0.0.0/4 - мультикаст - многоадресная рассылка

  - 240.0.0.0/4 0 зарезервировано для использования в будущем

  - [Другие](https://ru.wikipedia.org/wiki/IPv4#Назначения_подсетей)

- [Сети для самых маленьких](https://linkmeup.gitbook.io/sdsm/)

- ARP - Таблица соответствия MAC адреса IP адресу:

  - `arp -a` - Вывод таблицы

  - `arp -d <IP>` - Удаление конкретную запись из ARP таблицы по `<IP>` адресу

  - `ip neigh` - Дословно из лекции: "вывод того, что мы знает - условно, соседей."

  - `sudo ip neigh flush all` - Сброс информации по всем соседям

- [Настройка сети в Ubuntu](https://ubuntu.com/server/docs/network-configuration)

