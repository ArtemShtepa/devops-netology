# Домашнее задание по лекции "Операционные системы (часть 1)

## 1. Какой системный вызов делает команда `cd` ?

Чтобы проще было искать системный вызов можно воспользоваться командой `grep`, подав на неё вывод `strace`. А если учесть, что `strace` делает вывод в `stderr`, то необходимо перенаправить его на `stdout` для `pipe` (`|`).

Таким образом команда примет вид: `strace bash -c "cd <путь>" 2>&1 | grep <путь>`, где `<путь>` - каталог, куда будем переходить и по которому будем искать системный вызов, например каталог `test` текущего пользователя:

   ```console
   vagrant@vagrant:~$ strace bash -c "cd ~/test" 2>&1 | grep /test
   execve("/usr/bin/bash", ["bash", "-c", "cd ~/test"], 0x7fff554306c0 /* 23 vars */) = 0
   stat("/home/vagrant/test", {st_mode=S_IFDIR|0775, st_size=4096, ...}) = 0
   chdir("/home/vagrant/test")             = 0
   vagrant@vagrant:~$
   ```

Судя по выводу, используется системный вызов `chdir` с параметром полного пути (`/home/vagrant/test`) и вызов был выполнен успешно (`= 0`)

---

## 2. Где находится база данных `file` на основании которой она делает свои догадки ?

В ходе первого анализа команды: `strace file aa.sh` были найдены системные вызовы, наиболее вероятно отвечающие за открытие файлов - `openat`, поэтому для облегчения поиска нужной информации была применена фильтрация вывода по шаблону: `strace file <файл> &2>1 | grep openat`

Фильтрованный вывод команд получился одинаковым за исключением последней строки:

   ```console
   vagrant@vagrant:~$ strace file aa.sh 2>&1 | grep openat
   openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
   openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
   openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
   openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
   openat(AT_FDCWD, "aa.sh", O_RDONLY|O_NONBLOCK) = 3
   vagrant@vagrant:~$
   ```

   Следовательно программа:

   1. Изначально пытается прочитать базу по пути `/etc/magic.mgc`, но данного файла нет (соответствующие статус и сообщение: `-1 ENOENT (No such file or directory)`)

   1. После открывает файл `/etc/magic` - данный файл существует (получен файловый дескриптор `= 3`), но как показал `cat /etc/magic` там нет полезной информации

      ```console
      vagrant@vagrant:~$ cat /etc/magic
      # Magic local data for file(1) command.
      # Insert here your local magic data. Format is described in magic(5).

      vagrant@vagrant:~$
      ```

   1. Далее программа открывает файл `/usr/share/misc/magic.mgc` - он существует, но это символическая ссылка:

      ```console
      vagrant@vagrant:~$ file /usr/share/misc/magic.mgc
      /usr/share/misc/magic.mgc: symbolic link to ../../lib/file/magic.mgc
      vagrant@vagrant:~$
      ```

   1. Символическая ссылка ведёт на файл `/usr/lib/file/magic.mgc`:

      ```console
      vagrant@vagrant:~$ file /usr/lib/file/magic.mgc
      /usr/lib/file/magic.mgc: magic binary file for file(1) cmd (version 14) (little endian)
      vagrant@vagrant:~$
      ```

Таким образом базой описания файлов является файл `/usr/lib/file/magic.mgc`, причём используется скомпилированная версия (бинарный файл)

Данное утверждание подтверждается информацией из руководства `man file`

---

## 3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе)

Подготовка окружения:

   1. Запуск приложения в фоновом режиме с непрерывной записью в файл `test_file`

      ```console
      vagrant@vagrant:~$ ping 127.1 >test_file &
      [1] 1305
      vagrant@vagrant:~$
      ```

   1. Проверка функционирования окружения
   
      ```console
      vagrant@vagrant:~$ jobs -l
      [1]+  1305 Running                 ping 127.1 > test_file &
      vagrant@vagrant:~$ ls -l
      total 12
      -rw-rw-r-- 1 vagrant vagrant 9908 Feb 12 17:41 test_file
      vagrant@vagrant:~$
      ```

   1. Удаление файла и проверка продолжения функционирования

      ```console
      vagrant@vagrant:~$ rm test_file
      vagrant@vagrant:~$ sudo lsof -p 1305
      COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
      ping    1305 vagrant  cwd    DIR  253,0     4096 1051845 /home/vagrant
      ping    1305 vagrant  rtd    DIR  253,0     4096       2 /
      ping    1305 vagrant  txt    REG  253,0    72776 1835881 /usr/bin/ping
      ping    1305 vagrant  mem    REG  253,0  3035952 1835290 /usr/lib/locale/locale-archive
      ping    1305 vagrant  mem    REG  253,0   137584 1841525 /usr/lib/x86_64-linux-gnu/libgpg-error.so.0.28.0
      ping    1305 vagrant  mem    REG  253,0  2029224 1841468 /usr/lib/x86_64-linux-gnu/libc-2.31.so
      ping    1305 vagrant  mem    REG  253,0   101320 1841650 /usr/lib/x86_64-linux-gnu/libresolv-2.31.so
      ping    1305 vagrant  mem    REG  253,0  1168056 1835853 /usr/lib/x86_64-linux-gnu/libgcrypt.so.20.2.5
      ping    1305 vagrant  mem    REG  253,0    31120 1841471 /usr/lib/x86_64-linux-gnu/libcap.so.2.32
      ping    1305 vagrant  mem    REG  253,0   191472 1841428 /usr/lib/x86_64-linux-gnu/ld-2.31.so
      ping    1305 vagrant    0u   CHR  136,0      0t0       3 /dev/pts/0
      ping    1305 vagrant    1w   REG  253,0    17460 1048607 /home/vagrant/test_file (deleted)
      ping    1305 vagrant    2u   CHR  136,0      0t0       3 /dev/pts/0
      ping    1305 vagrant    3u  icmp             0t0   29432 00000000:0004->00000000:0000
      ping    1305 vagrant    4u  sock    0,9      0t0   29433 protocol: PINGv6
      vagrant@vagrant:~$ cat test_file
      cat: test_file: No such file or directory
      vagrant@vagrant:~$ sudo tail /proc/1305/fd/1
      64 bytes from 127.0.0.1: icmp_seq=417 ttl=64 time=0.028 ms
      64 bytes from 127.0.0.1: icmp_seq=418 ttl=64 time=0.027 ms
      64 bytes from 127.0.0.1: icmp_seq=419 ttl=64 time=0.028 ms
      64 bytes from 127.0.0.1: icmp_seq=420 ttl=64 time=0.028 ms
      64 bytes from 127.0.0.1: icmp_seq=421 ttl=64 time=0.029 ms
      64 bytes from 127.0.0.1: icmp_seq=422 ttl=64 time=0.027 ms
      64 bytes from 127.0.0.1: icmp_seq=423 ttl=64 time=0.025 ms
      64 bytes from 127.0.0.1: icmp_seq=424 ttl=64 time=0.026 ms
      64 bytes from 127.0.0.1: icmp_seq=425 ttl=64 time=0.030 ms
      64 bytes from 127.0.0.1: icmp_seq=426 ttl=64 time=0.029 ms
      vagrant@vagrant:~$
      ```

      Как видно из логов, файл `test_file` считается удалённым, но запись в него продолжает произволиться.

Получить содержимое удаленного файла можно обратившись к его файловому дескриптору, например : `sudo cat /proc/<PID>/fd/<FD>`, где `<PID>` - идентификатор процесса, который выполняет запись в файл (**1305**), а `<FD>` - файловый дескриптор, связанный с удалённым файлом (**1**) - что для данного примера: `sudo cat/proc/1305/fd/1`

Обнулить удалённый, но открытый для записи файл, возможно несколькими способами, в том числе:

- Записью в файл некоторого потока, например: `echo "" | sudo tee /proc/<PID>/fd/<FD>`, где `<PID>` - идентификатор процесса, который выполняет запись в файл (**1305**), а `<FD>` - файловый дескриптор, связанный с удалённым файлом (**1**), то есть для данного примера:

   ```console
   vagrant@vagrant:~$ echo "TRUNCATE LINE" | sudo tee /proc/1305/fd/1
   TRUNCATE LINE
   vagrant@vagrant:~$ sudo cat /proc/1305/fd/1
   TRUNCATE LINE
   64 bytes from 127.0.0.1: icmp_seq=1501 ttl=64 time=0.027 ms
   64 bytes from 127.0.0.1: icmp_seq=1502 ttl=64 time=0.028 ms
   64 bytes from 127.0.0.1: icmp_seq=1503 ttl=64 time=0.039 ms
   64 bytes from 127.0.0.1: icmp_seq=1504 ttl=64 time=0.027 ms
   64 bytes from 127.0.0.1: icmp_seq=1505 ttl=64 time=0.027 ms
   64 bytes from 127.0.0.1: icmp_seq=1506 ttl=64 time=0.027 ms
   64 bytes from 127.0.0.1: icmp_seq=1507 ttl=64 time=0.029 ms
   64 bytes from 127.0.0.1: icmp_seq=1508 ttl=64 time=0.029 ms
   vagrant@vagrant:~$
   ```

- Напрямую усечь размер файла командой `sudo truncate -s0 /proc/<PID>/fd/<FD>`, где `<PID>` - идентификатор процесса, который выполняет запись в файл (**1305**), а `<FD>` - файловый дескриптор, связанный с удалённым файлом (**1**), то есть для данного примера

   ```console
   vagrant@vagrant:~$ sudo truncate -s0 /proc/1305/fd/1
   vagrant@vagrant:~$ sudo cat /proc/1305/fd/1
   64 bytes from 127.0.0.1: icmp_seq=1622 ttl=64 time=0.028 ms
   vagrant@vagrant:~$
   ```

---

## 4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

**Короткий ответ**: Нет, зомби-процессы не занимают ресурсы в ОС (CPU, RAM, IO)

Все процессы после выполнения своей работы выставляют код завершения и освобождают занятые ресурсы (CPU, RAM, IO), после чего родительский процесс должен считать и обработать код завершения порожденного процесса. На время между этими событиями (выставлением кода завершения порождённым процессом и его считыванием родителем) процесс получает статус зомби. Таким образом, все процессы в своём жизненном цикле имеют стадию зомби-процесса, когда они уже завершили свою работу и освободили все занимаемые ресурсы, но всё ещё находятся в таблице процессов. Стадия зомби будет продолжаться до тех пор пока родитель не считает код завершения зомби процесса либо не завершится сам. Проблема в том, что таблица процессов имеет конечную ёмкость и при большом количестве зомби-процессов может заблокироваться возможность создания новых процессов.

---

## 5. В iovisor BCC есть утилита `opensnoop`. На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты?

Страница [BPF Compiler Collection (BCC)](https://github.com/iovisor/bcc) на GitHub

Список файлов пакета: `dpkg -L <имя пакета>` (с фильтрацией показа только утилит: `dpkg -L bpfcc-tools | grep /sbin/`)

Утилита `opensnoop` отслеживает системный вызов `open()`

За первые несколько секунд работы были определены следующие вызовы:

```console
vagrant@vagrant:~$ sudo opensnoop-bpfcc
PID    COMM               FD ERR PATH
636    irqbalance          6   0 /proc/interrupts
636    irqbalance          6   0 /proc/stat
636    irqbalance          6   0 /proc/irq/20/smp_affinity
636    irqbalance          6   0 /proc/irq/0/smp_affinity
636    irqbalance          6   0 /proc/irq/1/smp_affinity
636    irqbalance          6   0 /proc/irq/8/smp_affinity
636    irqbalance          6   0 /proc/irq/12/smp_affinity
636    irqbalance          6   0 /proc/irq/14/smp_affinity
636    irqbalance          6   0 /proc/irq/15/smp_affinity
951    vminfo              4   0 /var/run/utmp
630    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
630    dbus-daemon        19   0 /usr/share/dbus-1/system-services
630    dbus-daemon        -1   2 /lib/dbus-1/system-services
630    dbus-daemon        19   0 /var/lib/snapd/dbus-1/system-services/
^Cvagrant@vagrant:~$
```

---

## 6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС

Вывод strace:

```console
vagrant@vagrant:~$ strace uname -a
execve("/usr/bin/uname", ["uname", "-a"], 0x7ffce1e2c188 /* 23 vars */) = 0
brk(NULL)                               = 0x56547c9e6000
arch_prctl(0x3001 /* ARCH_??? */, 0x7ffe7597cbf0) = -1 EINVAL (Invalid argument)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=26091, ...}) = 0
mmap(NULL, 26091, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f117e2e4000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360q\2\0\0\0\0\0"..., 832) = 832
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
pread64(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0", 32, 848) = 32
pread64(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0\t\233\222%\274\260\320\31\331\326\10\204\276X>\263"..., 68, 880) = 68
fstat(3, {st_mode=S_IFREG|0755, st_size=2029224, ...}) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f117e2e2000
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
pread64(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0", 32, 848) = 32
pread64(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0\t\233\222%\274\260\320\31\331\326\10\204\276X>\263"..., 68, 880) = 68
mmap(NULL, 2036952, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f117e0f0000
mprotect(0x7f117e115000, 1847296, PROT_NONE) = 0
mmap(0x7f117e115000, 1540096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x25000) = 0x7f117e115000
mmap(0x7f117e28d000, 303104, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19d000) = 0x7f117e28d000
mmap(0x7f117e2d8000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1e7000) = 0x7f117e2d8000
mmap(0x7f117e2de000, 13528, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f117e2de000
close(3)                                = 0
arch_prctl(ARCH_SET_FS, 0x7f117e2e3580) = 0
mprotect(0x7f117e2d8000, 12288, PROT_READ) = 0
mprotect(0x56547ac90000, 4096, PROT_READ) = 0
mprotect(0x7f117e318000, 4096, PROT_READ) = 0
munmap(0x7f117e2e4000, 26091)           = 0
brk(NULL)                               = 0x56547c9e6000
brk(0x56547ca07000)                     = 0x56547ca07000
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=3035952, ...}) = 0
mmap(NULL, 3035952, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f117de0a000
close(3)                                = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0), ...}) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
write(1, "Linux vagrant 5.4.0-91-generic #"..., 106Linux vagrant 5.4.0-91-generic #102-Ubuntu SMP Fri Nov 5 16:31:28 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
) = 106
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++
vagrant@vagrant:~$
```

Похоже, что команда `uname -a` выполняет системный вызов `uname`

В руководстве `man uname` нужной информации нет, но есть ссылка на дополнительные материалы:

```сconsole
SEE ALSO
       arch(1), uname(2)
```

Во второй главе `man 2 uname` есть следующая цитата:

```console
       Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version,
       domainname}.
```

> utsname - структура, указатель на которую возвращается при исполнении системного вызова `uname`

Проверка предположений:

```console
vagrant@vagrant:~$ uname -a
Linux vagrant 5.4.0-91-generic #102-Ubuntu SMP Fri Nov 5 16:31:28 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
vagrant@vagrant:~$ cat /proc/sys/kernel/{ostype,hostname,osrelease,version,domainname} | tr '\n' ' '
Linux vagrant 5.4.0-91-generic #102-Ubuntu SMP Fri Nov 5 16:31:28 UTC 2021 (none) vagrant@vagrant:~$
vagrant@vagrant:~$
```

Итоговый результат:

- Версию ядра можно узнать в файле `/proc/sys/kernel/osrelease`, что эквивалентно `uname -r`

- Релиз операционной системы можно узнать в файле `/proc/sys/kernel/version`, что эквивалентно `uname -v`

---

## 7. Чем отличается последовательность команд через `;` и через `&&` в bash?

В последовательности команд `command1 ; command2` команда `command2` будет выполнена после завершения работы команды `command1` независимо от результата выполнения первой

В последовательности команд `command1 && command2` команда `command2` будет выполнена только в том случае, если код завершения команды `command1` будет равен нулю (`0` - условный успех)

Аналогично, в последовательности комманд `command1 || command2` команда `command2` будет выполнена только в том случае, если код завершения команды `command1` будет не равен нуля (`!=0` - код ошибки)

При использовании конструкция `set -e` в последовательности комманд `bash` грубо говоря включается особый режим, при котором выполнение последовательности команд (скрипта) прекращается при получении любого отличного от нуля кода завершения команды или ответа `pipe`. Данный режим может быть отключен конструкцией `set +e`. Данными конструкциями можно выделять части скрипта `bash`.

Таким образом, выражение `test -d /tmp/some_dir && echo Hi` эквивалентно `set -e; test -d /tmp/some_dir; echo Hi`, но между ними всё равно есть существенная разница. Выполняя вторую команду (с конструкцией `set -e`) при получении не нулевого кода завершения (отсутствия каталога `/tmp/some_dir`) будет не только прервано исполнение последовательности команд, но и закрыта текущая сессия `bash`. То есть если мы выполняли эти команды в терминале SSH, то соединение будет закрыто. При использовании в конструкции `&&` такого происходить не будет. Указанные выше выражение будут приводить к одинаковому эффекту если они будут исполняться через отдельную сессию `bash`, например в скрипте, и то если после этих команд не заложена другая логика.

Однако, нужно понимать, что прерывание выполняется по результату исполнения всего выражения, то есть код ниже

```bash
#!/bin/bash
set -e
test -d /tmp/some_dir && echo "Hi"
echo "Running..."
```

не приведёт к прерыванию выполнения сценария, так как выражение `test -d /tmp/some_dir && echo "Hi"` не завершается ошибкой, даже не смотря на то, что каталога `/tmp/some_dir` не будет существовать. В отличии от `&&` знак `;` эквивалентен переводу на новую строку (`\n`), то есть мы получаем несколько разных выражений, где сбой первого может привести к завершению всего сценария.

Поэтому однозначно ответить на вопрос: "Есть ли смысл использовать в bash `&&`, если применить `set -e`?" - нельзя. Многое зависит от контекста использованя - где и как исполняется, есть ли другая логика (инструкции) после данных конструкций.

---

## 8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

Конструкция `set -euxo pipefail` может использоваться при отладке написанного сценария, так как включает следующие опции:

`e` - приводит к завершению выполнения сценария если код завершения какой-либо строки команд вернул не нулевой код завершения, то есть ошибку. Например, строка `test -d /tmp/not_existed_dir | echo "test"` не приведёт к завершению исполнения скрипта.

`u` - приводит к завершению выполнения сценария если какая-либо запрашиваемая переменная не была инициализирована. Выводит соответствуюее сообщение.

`x` - включает режим вывода строки команды перед её исполнением.

`o pipefail` - приводит к завершению сценария если какая-либо команда вернула не нулевой код завершения, то есть ошибку. Например, при выполнении строки `test -d /tmp_not_existed_dir | echo "test"` после вывода слова `test` работа сценария прервётся.

Использовался дополнительный материал: [Безопасный bash-скрипты](https://silentsokolov.github.io/safe-bash-sctipts)

---

## 9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными)

Ключ `-o stat` - задаёт пользовательский формат вывода команды, а именно только статус процессов, причём полный, с дополнительными статусами.

Для определения наиболее часто встречающегося статуса процесса можно использовать сокращённую версию (без учёта дополнительных статусов):

```console
vagrant@vagrant:~$ ps -eo s= | wc -l
105
vagrant@vagrant:~$ ps -eo s= | grep -c S
58
vagrant@vagrant:~$ ps -eo s= | grep -c R
1
vagrant@vagrant:~$ ps -eo s= | grep -c I
46
vagrant@vagrant:~$
```

Из результатов видно, что наиболее часто встречающийся статус процесс - `S` прерываемый сон.

Дополнительные статусы процесса:

- `<` — процесс с высоким приоритетом (не хорошо для других пользователей)

- `N` — процесс с низким приоритетом (хорошо для других пользоваталей)

- `L` - имеет заблокированные страницы в оперативной памяти
  
- `s` — лидер сессии

- `l` — многопоточный процесс

- `+` — в группе foreground процессов

---

Использованные в лекции материалы:

`ldd` - Вывод списка зависимостей программы (какие расшаренные объекты используются)

`sotruss` - Трассировка вызовов расшаренных библиотек через **PLT**

`strace` - Трассировки системных вызовов и сигналов  (вывода какие действия происходят в программе: открытие файлов, системные вызовы и т.д.). Использует системные вызовы `ptrace`, существенно замедляет работы системы. `-p <PID>` отслуживает действия процесса **PID**

`dpkg -L <пакет>` - Вывод списка файлов **пакета**

`fork` - Создаёт новый процесс, дублируя существующий (текущий). Новый процесс связывается как дочерний

`clone` - Дублирует процесс, включая создание потоков

`ps` - Вывод всех процессов пользователя в текущем терминале. `u` с подробным выводом `ax` без ограничений собственным процессом и запущенным терминалом (ссответственно)

`kill <PID>` - Отправка сигналов процессу **PID**. По умолчанию **SIGKILL**. `-l` выводит список сигналов

`getcap <программа>` - Выводит расширенные возможности **программы**. Пример: `getcap $(which ping)`