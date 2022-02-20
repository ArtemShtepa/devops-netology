# Домашнее задание по лекции "Файловые системы"

## 1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах

Разраженный файл - особым образом сжатый файл, где последовательности нулевых байт заменены метаданными о размере такой последовательности.

Удобно использовать при создании динамически расширяемых жестких дисков виртуальных машин, так как при номинальном объёме физически файл образа диска будет занимать существенно меньший объём. Также могут используется при создании снапшотов дисков/томов для минимизации размера файла.

Разряженный логический том (sparse LogicalManagement) можно создать средствами утилиты `lvcreate` при одновременной передаче параметров `-V` (виртуальный размер) и `-L` (линейный размер) (подробнее в руководстве `man 8 lvcreate` и `man 7 lvmthin`).

---

## 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Нет, не могут. Потому что все жесткие ссылки одного файла ссылаются на одну и ту же область файловой системы и так как физически объект один (все жесткие ссылки имеют один номер **inode**), то он не может иметь множество различных состояний (прав доступа, аттрибудов и.т.п.).

```console
vagrant@vagrant:~$ ln aa.sh aa2.sh
vagrant@vagrant:~$ stat aa.sh
  File: aa.sh
  Size: 64              Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d    Inode: 1054799     Links: 2
Access: (0775/-rwxrwxr-x)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)
Access: 2022-02-19 14:25:18.777662636 +0000
Modify: 2022-02-19 14:25:22.349617730 +0000
Change: 2022-02-19 14:35:22.486072993 +0000
 Birth: -
vagrant@vagrant:~$ stat aa2.sh
  File: aa2.sh
  Size: 64              Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d    Inode: 1054799     Links: 2
Access: (0775/-rwxrwxr-x)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)
Access: 2022-02-19 14:25:18.777662636 +0000
Modify: 2022-02-19 14:25:22.349617730 +0000
Change: 2022-02-19 14:35:22.486072993 +0000
 Birth: -
vagrant@vagrant:~$
```

В отличии от жестких, символические ссылки представляются отдельным объёктом файловой системы со своим номером **inode**, размером и т.д.

```console
vagrant@vagrant:~$ ln -s bb.sh bb2.sh
vagrant@vagrant:~$ stat bb.sh
  File: bb.sh
  Size: 175             Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d    Inode: 1054801     Links: 1
Access: (0775/-rwxrwxr-x)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)
Access: 2022-02-19 14:22:05.772089045 +0000
Modify: 2022-02-13 19:41:58.655736925 +0000
Change: 2022-02-19 12:20:56.790225557 +0000
 Birth: -
vagrant@vagrant:~$ stat bb2.sh
  File: bb2.sh -> bb.sh
  Size: 5               Blocks: 0          IO Block: 4096   symbolic link
Device: fd00h/64768d    Inode: 1048597     Links: 1
Access: (0777/lrwxrwxrwx)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)
Access: 2022-02-19 14:39:28.366981852 +0000
Modify: 2022-02-19 14:39:20.399082022 +0000
Change: 2022-02-19 14:39:20.399082022 +0000
 Birth: -
vagrant@vagrant:~$
```

Механизм жестких ссылок реализован на более низком уровне фаловой системы и поэтому они ограничены одним накопителем, когда символические - нет. Жесткие ссылки представляют один объект **inode** и они равнозначны, то есть при удалении любого из них целостность остальных не меняется.

Символисечкие ссылки - это отдельные объекты файловой системы со своими номерами **inode**, которые только ссылаются на "источник" и если его удалить, то ссылающиеся на него символические ссылки станут "битыми". Однако, такие объекты можно перемещать на другие накопители. Также они явно отображаются в выводе команды `ls`

```console
vagrant@vagrant:~$ ls -li
total 16
1054799 -rwxrwxr-x 2 vagrant vagrant   64 Feb 19 14:25 aa2.sh
1054799 -rwxrwxr-x 2 vagrant vagrant   64 Feb 19 14:25 aa.sh
1048597 lrwxrwxrwx 1 vagrant vagrant    5 Feb 19 14:39 bb2.sh -> bb.sh
1054801 -rwxrwxr-x 1 vagrant vagrant  175 Feb 13 19:41 bb.sh
1048616 drwxr-xr-x 2 vagrant vagrant 4096 Feb 15 17:28 node_exporter
vagrant@vagrant:~$
```

---

## 3. Создание виртуальной машины с необходимой конфигурацией накопителей

Для удаление предыдущей виртуальной машины используется команда `vagrant destroy`

При создании новой виртуальной машины используется следующий конфигурационный файл:

```bash
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider :virtualbox do |vb|
    vb.memory = 2048
    vb.cpus = 2
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
  end
end
```

Процесс создания виртуальной машины с двумя дополнительными неразмеченными дисками по 2.5 Гб.

```console
PS: 02/19/2022 18:35:08>vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'bento/ubuntu-20.04' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'bento/ubuntu-20.04'
    default: URL: https://vagrantcloud.com/bento/ubuntu-20.04
==> default: Adding box 'bento/ubuntu-20.04' (v202112.19.0) for provider: virtualbox
    default: Downloading: https://vagrantcloud.com/bento/boxes/ubuntu-20.04/versions/202112.19.0/providers/virtualbox.box
    default:
==> default: Successfully added box 'bento/ubuntu-20.04' (v202112.19.0) for 'virtualbox'!
==> default: Importing base box 'bento/ubuntu-20.04'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
==> default: Setting the name of the VM: Vagrant-FS_default_1645285016552_43329
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => D:/VM/Vagrant-FS
PS: 02/19/2022 18:37:27>
```

---

## 4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство

Имеющиеся блочные устройства:

```console
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop /snap/lxd/21029
loop3                       7:3    0 43.6M  1 loop /snap/snapd/14978
loop4                       7:4    0 55.5M  1 loop /snap/core18/2284
loop5                       7:5    0 61.9M  1 loop /snap/core20/1328
loop6                       7:6    0 67.2M  1 loop /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
sdc                         8:32   0  2.5G  0 disk
vagrant@vagrant:~$
```

Определены два дополнительных накопителя: `/dev/sdb` и `/dev/sbc`

Процесс создания разделов на накопителе `/dev/sdb`

```console
vagrant@vagrant:~$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x4e36c89f.

Command (m for help): m

Help:

  DOS (MBR)
   a   toggle a bootable flag
   b   edit nested BSD disklabel
   c   toggle the dos compatibility flag

  Generic
   d   delete a partition
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition
   p   print the partition table
   t   change a partition type
   v   verify the partition table
   i   print information about a partition

  Misc
   m   print this menu
   u   change display/entry units
   x   extra functionality (experts only)

  Script
   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file

  Save & Exit
   w   write table to disk and exit
   q   quit without saving changes

  Create a new label
   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty DOS partition table
   s   create a new empty Sun partition table


Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-5242879, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2):
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

Created a new partition 2 of type 'Linux' and of size 511 MiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

vagrant@vagrant:~$
```

Итоговый результат:

```console
vagrant@vagrant:~$ sudo fdisk -l /dev/sdb
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x4e36c89f

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux
vagrant@vagrant:~$
```

---

## 5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск

В соответствии с разделом `BACKING UP THE PARTITION TABLE` руководства `man 8 sfdisk` перенос таблицы разделов можно осуществить либо через дамп с последующим восстановлением, либо напрямую используя pipe.

Создание резервной копии таблицы разделов: `sfdisk --dump <диск> > <дамп>`, где `<диск>` - накопитель, таблицу разделов которого нужно скопировать в файл `<дамп>`. Восстановление резервной копии выполняется простым перенаправлением: `sfdisk <диск> < <дамп>`

Копирование таблицы разделов с использованием pipe:

```console
vagrant@vagrant:~$ sudo sfdisk --dump /dev/sdb | sudo sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x4e36c89f.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x4e36c89f

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
vagrant@vagrant:~$
```

Итоговый результат:

```console
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop /snap/lxd/21029
loop3                       7:3    0 43.6M  1 loop /snap/snapd/14978
loop4                       7:4    0 55.5M  1 loop /snap/core18/2284
loop5                       7:5    0 61.9M  1 loop /snap/core20/1328
loop6                       7:6    0 67.2M  1 loop /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
└─sdc2                      8:34   0  511M  0 part
vagrant@vagrant:~$
```

> создание таблицы разделов можно выполнить утилитой `cfdisk`, которая помимо текстового GUI также позволяет создать совместимый с `sfdisk` дамп таблицы разделов.

---

## 6. Соберите `mdadm` RAID1 на паре разделов 2 Гб

В соответствии с руководством `man 8 mdadm` создание RAID массива выполняется следующей командой: `mdadm --create <устройство> --level=<тип> --raid-devices=<число> <разделы>`, где `устройство` - итоговое устройство, которое будет создано, `<тип>` - тип RAID массива, `<число>` - число дисков, подключаемых в массив, `<разделы>` - список разделов, добавляемых в массив (должно совпадать с параметром `<число>`)

```console
vagrant@vagrant:~$ sudo mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
vagrant@vagrant:~$
```

Итоговый результат:

```console
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 43.6M  1 loop  /snap/snapd/14978
loop4                       7:4    0 55.5M  1 loop  /snap/core18/2284
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1328
loop6                       7:6    0 67.2M  1 loop  /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
vagrant@vagrant:~$
```

---

## 7. Соберите `mdadm` RAID0 на второй паре маленьких разделов

Создание массива RAID0 выполняется аналогично предыдущему пункту

```console
vagrant@vagrant:~$ sudo mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
vagrant@vagrant:~$
```

Итоговый результат:

```console
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 43.6M  1 loop  /snap/snapd/14978
loop4                       7:4    0 55.5M  1 loop  /snap/core18/2284
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1328
loop6                       7:6    0 67.2M  1 loop  /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md0                     9:0    0 1018M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md0                     9:0    0 1018M  0 raid0
vagrant@vagrant:~$
```

---

## 8. Создайте 2 независимых **PV** на получившихся md-устройствах

Список утилит управления физическими томами:

```console
vagrant@vagrant:~$ ls /usr/sbin/ | grep pv
pvchange
pvck
pvcreate
pvdisplay
pvmove
pvremove
pvresize
pvs
pvscan
vagrant@vagrant:~$
```

В соответствии с руководством `man 8 pvcreate` создание физического тома **PhysicalVolume** (**PV**) осуществляется командой: `pvcreate <разделы>`, где `<разделы>` - список разделов для которых будут созданы физичесике тома

```console
vagrant@vagrant:~$ sudo pvcreate /dev/md0 /dev/md1
  Physical volume "/dev/md0" successfully created.
  Physical volume "/dev/md1" successfully created.
vagrant@vagrant:~$
```

Итоговый результат:

```console
vagrant@vagrant:~$ sudo pvs
  PV         VG        Fmt  Attr PSize    PFree
  /dev/md0             lvm2 ---  1018.00m 1018.00m
  /dev/md1             lvm2 ---    <2.00g   <2.00g
  /dev/sda3  ubuntu-vg lvm2 a--   <63.00g  <31.50g
vagrant@vagrant:~$ sudo pvscan
  PV /dev/sda3   VG ubuntu-vg       lvm2 [<63.00 GiB / <31.50 GiB free]
  PV /dev/md0                       lvm2 [1018.00 MiB]
  PV /dev/md1                       lvm2 [<2.00 GiB]
  Total: 3 [<65.99 GiB] / in use: 1 [<63.00 GiB] / in no VG: 2 [2.99 GiB]
vagrant@vagrant:~$ sudo pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda3
  VG Name               ubuntu-vg
  PV Size               <63.00 GiB / not usable 0
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              16127
  Free PE               8063
  Allocated PE          8064
  PV UUID               sDUvKe-EtCc-gKuY-ZXTD-1B1d-eh9Q-XldxLf

  "/dev/md0" is a new physical volume of "1018.00 MiB"
  --- NEW Physical volume ---
  PV Name               /dev/md0
  VG Name
  PV Size               1018.00 MiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               ZAzaVK-ZISY-kbad-dpUc-gA8b-uuO0-T5yHEw

  "/dev/md1" is a new physical volume of "<2.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/md1
  VG Name
  PV Size               <2.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               uUeLBa-EJJt-3OC0-F3U3-miPS-leWC-ifFMUV

vagrant@vagrant:~$
```

---

## 9. Создайте общую volume-group на этих двух **PV**

Список утилит управления группами томов:

```console
vagrant@vagrant:~$ ls /usr/sbin/ | grep vg
vgcfgbackup
vgcfgrestore
vgchange
vgck
vgconvert
vgcreate
vgdisplay
vgexport
vgextend
vgimport
vgimportclone
vgmerge
vgmknodes
vgreduce
vgremove
vgrename
vgs
vgscan
vgsplit
vagrant@vagrant:~$
```

В соответствии с руководством `man 8 vgcreate` создание группы физических тома **VolumeGroup** (**VG**) осуществляется командой: `vgcreate <имя> <PV>`, где `<имя>` - название создаваемой группы, а `<PV>` - список физических томов **PV**, которые будут включены в группу

```console
vagrant@vagrant:~$ sudo vgcreate myvg /dev/md1 /dev/md0
  Volume group "myvg" successfully created
vagrant@vagrant:~$
```

Итоговый результат:

```console
vagrant@vagrant:~$ sudo vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  myvg        2   0   0 wz--n-  <2.99g  <2.99g
  ubuntu-vg   1   1   0 wz--n- <63.00g <31.50g
vagrant@vagrant:~$ sudo vgscan
  Found volume group "ubuntu-vg" using metadata type lvm2
  Found volume group "myvg" using metadata type lvm2
vagrant@vagrant:~$ sudo vgdisplay
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <63.00 GiB
  PE Size               4.00 MiB
  Total PE              16127
  Alloc PE / Size       8064 / 31.50 GiB
  Free  PE / Size       8063 / <31.50 GiB
  VG UUID               aK7Bd1-JPle-i0h7-5jJa-M60v-WwMk-PFByJ7

  --- Volume group ---
  VG Name               myvg
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <2.99 GiB
  PE Size               4.00 MiB
  Total PE              765
  Alloc PE / Size       0 / 0
  Free  PE / Size       765 / <2.99 GiB
  VG UUID               o2RQP2-7B69-P5cB-iT9f-qWs2-ro2y-vlFsZ0

vagrant@vagrant:~$
```

---

## 10. Создайте **LV** размером 100 Мб, указав его расположение на **PV** с **RAID0**

Список утилит управления логическими томами:

```console
vagrant@vagrant:~$ ls /usr/sbin/ | grep lv
lvchange
lvconvert
lvcreate
lvdisplay
lvextend
lvm
lvmconfig
lvmdiskscan
lvmdump
lvmpolld
lvmsadc
lvmsar
lvreduce
lvremove
lvrename
lvresize
lvs
lvscan
vagrant@vagrant:~$
```

В соответствии с руководством `man 8 lvcreate` создание логического тома выполняется по шаблону: `lvcreate --size <размер> <VG> <PV>`, где `<размер>` - размер создаваемого логического тома, `<VG>` - группа томов в которой выполняется разметка и опционально `<PV>` - физические тома, на которых выполняется разметка (без указания конкретных **PV** разметка будет выполнятся по порядку томов в группе начиная с первого). Вместо параметра `--size` может использоваться его синоним `-L`

```conssole
vagrant@vagrant:~$ sudo lvcreate -L 100m myvg /dev/md0
  Logical volume "lvol0" created.
vagrant@vagrant:~$
```

Итоговый результат:

```console
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 55.5M  1 loop  /snap/core18/2284
loop4                       7:4    0 43.6M  1 loop  /snap/snapd/14978
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1328
loop6                       7:6    0 67.2M  1 loop  /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md0                     9:0    0 1017M  0 raid0
    └─myvg-lvol0          253:1    0  100M  0 lvm
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md0                     9:0    0 1017M  0 raid0
    └─myvg-lvol0          253:1    0  100M  0 lvm
vagrant@vagrant:~$
```

---

## 11. Создайте `mkfs.ext4` ФС на получившемся LV

Создание файловой системы на логическом томе утилитами группы `mkfs` осуществляется либо напрямую нужной утилитой (например, `mkfs.ext4` для создания файловой системы **EXT4**), либо через обёртку `mkfs` с параметром `-t` или `--type` и указанием нужной файловой системы (например, `mkfs -t ext4` для создания файловой системы **EXT4**). Однако нужно учитывать, что при использовании обёртки `mkfs` без указания конкретной файловой системы используется `EXT2` (может меняться). Для создания файловой системы в простейшем случае достаточно передать билдеру файловой системы имя логического тома (с учётом вхождения в группу томов), например: `mkfs.ext4 /dev/myvg/lvol0` или `mkfs --type ext4 /dev/myvg/lvol0`

```console
vagrant@vagrant:~$ sudo mkfs.ext4 /dev/myvg/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

vagrant@vagrant:~$
```

---

## 12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`

В простеейшем случае монтирование осуществляется программой **mount** по шаблону: `mount <ФС> <путь>`, где `<ФС>` - монтируемая файловая система, `<путь>` - директория, куда выполняется монтирование.

```console
vagrant@vagrant:~$ mkdir /tmp/new
vagrant@vagrant:~$ sudo mount /dev/myvg/lvol0 /tmp/new
vagrant@vagrant:~$ sudo chown vagrant:vagrant /tmp/new
vagrant@vagrant:~$ ls /tmp/new -l
total 0
vagrant@vagrant:~$
```

Проверка монтирования:

```console
vagrant@vagrant:~$ mount | grep tmp/new
/dev/mapper/myvg-lvol0 on /tmp/new type ext4 (rw,relatime,stripe=256)
vagrant@vagrant:~$ ls -la /tmp/new
total 8
drwxr-xr-x  2 vagrant vagrant 4096 Feb 21 13:52 .
drwxrwxrwt 11 root    root    4096 Feb 21 13:50 ..
vagrant@vagrant:~$
```

Директория `/tmp/new` имеет владельца и группу `vagrant`, и смотнирована на логический том `lvol0` в группе томов `myvg`

---

## 13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`

```console
vagrant@vagrant:~$ wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2022-02-20 12:25:21--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22285332 (21M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz              100%[=================================================>]  21.25M  7.74MB/s    in 2.7s

2022-02-20 12:25:23 (7.74 MB/s) - ‘/tmp/new/test.gz’ saved [22285332/22285332]

vagrant@vagrant:~$ ls -l /tmp/new
total 21764
-rw-rw-r-- 1 vagrant vagrant 22285332 Feb 20 11:03 test.gz
vagrant@vagrant:~$
```

---

## 14. Прикрепите вывод `lsblk`

```console
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 55.5M  1 loop  /snap/core18/2284
loop4                       7:4    0 43.6M  1 loop  /snap/snapd/14978
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1328
loop6                       7:6    0 67.2M  1 loop  /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md0                     9:0    0 1017M  0 raid0
    └─myvg-lvol0          253:1    0  100M  0 lvm
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md0                     9:0    0 1017M  0 raid0
    └─myvg-lvol0          253:1    0  100M  0 lvm
vagrant@vagrant:~$
```

---

## 15. Протестируйте целостность загруженного файла **test.gz**

Целостность архива проверяется встроенными средствами архиватора `gzip -t <файл>`, где `<файл>` - имя файла проверяемого архива

```console
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
vagrant@vagrant:~$ echo $?
0
vagrant@vagrant:~$
```

---

## 16. Используя `pvmove`, переместите содержимое **PV** с **RAID0** на **RAID1**

Для переноса содержимого физического тома нужно запустить утилиту по следующему шаблону: `pvmove <источник> <цель>`, где `<источник>` - имя физиеского тома **PV** который переносится, а `<цель>` - имя физического тома **PV** куда осуществляется перенос

```console
vagrant@vagrant:~$ sudo pvmove /dev/md0 /dev/md1
  /dev/md0: Moved: 52.00%
  /dev/md0: Moved: 100.00%
vagrant@vagrant:~$
```

Итоговый результат:

```console
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 55.5M  1 loop  /snap/core18/2284
loop4                       7:4    0 43.6M  1 loop  /snap/snapd/14978
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1328
loop6                       7:6    0 67.2M  1 loop  /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
│   └─myvg-lvol0          253:1    0  100M  0 lvm
└─sdb2                      8:18   0  511M  0 part
  └─md0                     9:0    0 1017M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
│   └─myvg-lvol0          253:1    0  100M  0 lvm
└─sdc2                      8:34   0  511M  0 part
  └─md0                     9:0    0 1017M  0 raid0
vagrant@vagrant:~$
```

---

## 17. Сделайте `--fail` на устройство в вашем RAID1 md

Ключ `--fail`, он же `-f`, он же `--set-fault`, помечает физический том **PV** в RAID массиве как сбойный и применяется в программе **MDADM** по следующему шаблону: `mdadm <RAID> --fail <диск>`, где `<RAID>` - RAID массив в котором выполняется операция, `<диск>` - устройство, которое помечается сбойным.

```console
vagrant@vagrant:~$ sudo mdadm --detail /dev/md1
/dev/md1:
           Version : 1.2
     Creation Time : Sun Feb 20 10:31:25 2022
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Sun Feb 20 12:34:51 2022
             State : clean
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:1  (local to host vagrant)
              UUID : 26d93200:53e33af2:e036c3f9:fb458b4b
            Events : 17

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
vagrant@vagrant:~$ sudo mdadm /dev/md1 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md1
vagrant@vagrant:~$
```

---

## 18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии

Вывод системных сообщений:

```console
vagrant@vagrant:~$ dmesg
[12632.612252] md/raid1:md1: Disk failure on sdb1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
vagrant@vagrant:~$
```

Вывод статуса **MDADM**:

```console
vagrant@vagrant:~$ sudo mdadm --detail /dev/md1
/dev/md1:
           Version : 1.2
     Creation Time : Sun Feb 20 10:31:25 2022
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Sun Feb 20 13:56:07 2022
             State : clean, degraded
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:1  (local to host vagrant)
              UUID : 26d93200:53e33af2:e036c3f9:fb458b4b
            Events : 19

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1

       0       8       17        -      faulty   /dev/sdb1
vagrant@vagrant:~$
```

---

## 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен.

Целостность файла проверяется аналогично пункту 15

```console
vagrant@vagrant:/tmp/new$ gzip -t test.gz
vagrant@vagrant:/tmp/new$ echo $?
0
vagrant@vagrant:/tmp/new$
```

---

## 20. Погасите тестовый хост, `vagrant destroy`

Команда `destroy` выключает машину и удаляет все "следы" (ассоциированные с машиной ресурсы) виртуальной машины. Выключение выполняется командой `halt`

```console
PS: 02/20/2022 17:03:13>vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
PS: 02/20/2022 17:04:16>
```

---

Использованные в лекции материалы:

- `stat` - Вывод информации о файле

- `ln` - Создание ссылок на файлы. По умолчанию создается жесткая ссылка. `-s` - символьческая ссылка

- `chown` - Изменение владельца и/или группы файла (`<пользователь>:<группа>`)

- `chmod` - Изменение прав доступа файла для: чтение(r), запись (w), исполенение (x).

   Права объединяются в группы: Владельца, Группы, Всех остаьных.

   Значение прав для файлов и директорий отличаются:

  - Для файлов: `r` - чтение, `w` - запись, `x` - исполнение

  - Для директорий: `r` - просмотр содержимого, `w` - создание и удаление объектов в директории, `x` - переход в директорию

- `df` - Вывод статистики по файловой системе. `-i` информация по `inode`

- `mkfifo` - Создание именованого `pipe`

- `touch` - Создание файла

- `umask` - Задаём маску прав доступа по умолчанию. Штатные права ОС для файлов - `0666`, для директорий - `0777`. Маска применяется при создании, а именно вычитается из прав доступа ОС по умолчанию.

- Дополнительные права доступа: `setuid`, `setgid`, `sticky`:

  - `sticky` - позволяет записывать в директорию многим пользователям, но запрещает изменять файлы не их владельцам

  - `setuid` - обеспечивает исполнение файла с правами владельца

  - `setgid` - обеспечивает наследование группы владельца родительского каталога для всех создаваемых внутри файлов и каталогов, а не пользователя, инициаровавшего операцию

- `lsattr` - Вывод дополнительных аттрибутов файла. Список возможных аттрибутов в руководстве `man chattr`

- `chattr` - Изменение аттрибутов файла: `+` - установить, `-` - снять

- `lsblk` - Вывод списка блочных устройств в виде структуры

- `blkid` - Вывод списка блочных устройств с их UUID (или `ls -l /dev/disk/by-uuid/`)

- `mdadm` - Управление программным RAID. `cat /proc/mdstat` - текущий статус

- `lvs` или `lvdisplay` - Вывод списка логических томов. Дополнительные утилиты: `lv*`

- `vgs` или `vgdisplay` - Вывод списка групп томов. Дополнительные утилиты: `vg*`

- `pvs` или `pvdisplay` - Вывод списка физических томов. Дополнительные утилиты: `pv*`

- `fdisk` - Управление таблицей разделов

- `sfdisk` - Вывод и манипуляция таблицами разделов

- `mkfs` - Создание файловой системы. Дополнительно: `mkfs.*`

- `mount` - Монтирование файловой системы. Автоматическое монтирование `/etc/fstab` - подробнее в руководстве `man 5 fstab`
