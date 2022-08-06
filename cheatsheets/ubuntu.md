## Расширение раздела на диске LVM

Получить список блочных устройств: `lsblk`

```console
sa@ubuntu22:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0                       7:0    0   62M  1 loop /snap/core20/1611
loop1                       7:1    0 63,2M  1 loop /snap/core20/1623
loop2                       7:2    0 79,9M  1 loop /snap/lxd/22923
loop3                       7:3    0  103M  1 loop /snap/lxd/23541
loop4                       7:4    0   47M  1 loop /snap/snapd/16292
sda                         8:0    0   40G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    2G  0 part /boot
└─sda3                      8:3    0   38G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0   38G  0 lvm  /
sr0                        11:0    1 1024M  0 rom
sa@ubuntu22:~$
```

В данном примере раздел `sda3` состоит из тома `ubuntu--vg-ubuntu--lv`, что
означает вхождение его в состав группы `ubuntu-vg` и раздела `ubuntu-lv`

```console
sa@ubuntu22:~$ sudo vgdisplay
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <38,00 GiB
  PE Size               4,00 MiB
  Total PE              9727
  Alloc PE / Size       9727 / <38,00 GiB
  Free  PE / Size       0 / 0
  VG UUID               odLIaw-DKJw-N95y-MAnD-CkT2-cWIa-sFz3ra

sa@ubuntu22:~$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                jbLbCI-v0ED-OOsY-VHZX-zZL2-kRC1-D2hXm3
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2022-08-31 09:33:29 +0000
  LV Status              available
  # open                 1
  LV Size                <38,00 GiB
  Current LE             9727
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

sa@ubuntu22:~$
```

Далее нужно либо:
  - Расширить физический том: `sudo pvresize /dev/sda3`
  - После чего расширение логический том на всё не размеченное пространство: `lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv`

Либо:
  - Редактировать раздел через `sudo cfdisk`, где
  - Расширить нужный раздел (`sda3`) на всё свободное пространство
  - Записать измененния на диск

И последнее - расширить файловую систему: `sudo resize2fs /dev/ubuntu-vg/ubuntu-lv` или `sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv`
