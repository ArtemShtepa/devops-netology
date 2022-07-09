# Домашнее задание к занятию "8.1 Введение в Ansible"

## Подготовка к выполнению
> 1. Установите ansible версии 2.10 или выше.
> 2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
> 3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

Для решения задач использовался Ansible версии **2.13.1**

## Основная часть

### 1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

Запуск **playbook** выполняется по шаблону: `ansible-playbook <playbook> -i <inventory>`, где `<playbook>` - запускаемый **playbook** (**YAML** файл) в окружении `<inventory>` (обычно тоже **YAML** файл).
В указанном репозитории только один **playbook** - это `site.yml`

```console
sa@debian:~/my-ansible$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] **************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [localhost]

TASK [Print OS] ********************************************************************************************************
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] ******************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

sa@debian:~/my-ansible$
```

**Ответ**: судя по выводу **Ansible**, переменная `some_fact` имеет значение `12`

---

### 2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

В окружении `test.yml` прописан только один хост - `localhost`, следовательно **playbook** выполнялся только для него, а значит переменную `some_fact` нужно искать либо среди группы `localhost` если она есть, либо в `all` если не указаны более приоритетные источники.
В репозитори нет группы `localhost` но определена группа (каталог) `all`, значит переменная используется из файлов данной группы, а именно `group_vars/all/examp.yml`

```console
sa@debian:~/my-ansible$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] **************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [localhost]

TASK [Print OS] ********************************************************************************************************
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] ******************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

sa@debian:~/my-ansible$
```

---

### 3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

В дальнейшем будет использоваться окружение `prod` (из условий задачи), а в соответствующем файле (`inventory/prod.yml`) прописаны хосты `centos7` и `ubuntu` с соединением через **docker** (`ansible_connection: docker`), следовательно нужно развернуть два соответствующих контейнера.
В качестве окружения будем использовать **Docker Compose** манифест в режиме [Rootless](https://docs.docker.com/engine/security/rootless/#troubleshooting).
> Для полноценного функционирования **Ansible** в образе **ubuntu** также необходимо будет установить **Python**: `docker exec ubuntu apt update` и `docker exec ubuntu apt install -y python3`

```yaml
---
version: "2.4"

services:
  centos:
    image: centos:7
    container_name: centos7
    tty: true
  ubuntu:
    image: ubuntu:22.04
    container_name: ubuntu
    tty: true
```

Функционирование окружения:

```console
sa@debian:~/my-ansible$ docker compose up -d
[+] Running 3/3
 ⠿ Network my-ansible_default  Created                                                                             0.0s
 ⠿ Container ubuntu            Started                                                                             0.4s
 ⠿ Container centos7           Started                                                                             0.4s
sa@debian:~/my-ansible$ docker ps
CONTAINER ID   IMAGE          COMMAND       CREATED          STATUS         PORTS     NAMES
b40d5965b2a4   centos:7       "/bin/bash"   10 seconds ago   Up 8 seconds             centos7
733dfacf4c81   ubuntu:22.04   "bash"        10 seconds ago   Up 8 seconds             ubuntu
sa@debian:~/my-ansible$
```

---

### 4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

```console
sa@debian:~/my-ansible$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] **************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ******************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

sa@debian:~/my-ansible$
```

---

### 5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

Из предыдущего вывода следует:
- Переменная `some_fact` со значением `deb` определена для хоста `ubuntu`, а он находится в группе `group_vars/deb`
- Переменная `some_fact` со значением `el` определена для хоста `centos7`, а он находится в группе `group_vars/el`

Соответственно для `ubuntu` значения меняются в `group_vars/deb/examp.yml`

```yaml
---
  some_fact: "deb default fact"
```

а для `centos7` в `group_vars/el/examp.yml`

```yaml
---
  some_fact: "el default fact"
```

---

### 6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

```console
sa@debian:~/my-ansible$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] **************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ******************************************************************************************************
ok: [centos7] => {
   "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

sa@debian:~/my-ansible$
```

---

### 7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

Шифрование выполняется командой `ansible-vault encrypt <file>`, где `<file>` - имя файла, который нужно зашифровать

```console
sa@debian:~/my-ansible$ ansible-vault encrypt group_vars/deb/examp.yml group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
sa@debian:~/my-ansible$ cat group_vars/{deb,el}/examp.yml
$ANSIBLE_VAULT;1.1;AES256
61623833346261346365313139306438306530353539363033336266316165346364373439376439
3532613664643239323132363331333562363032383931610a363630353666383533623765626163
37333264346261343762303931663332316333383264666138376338383762376236656338396134
3530343661656239320a393066363936626533663061346534663334343430346362303866633962
32336637643433356139313132393332383161373662623736636262353631323738633239636436
6461393836326361383835663366363961643733353766313632
$ANSIBLE_VAULT;1.1;AES256
32386664623431353832663130653764356338666635343465336565393235323565656635646637
6130363239346534353437613237616366393439616662640a303435333762373965336438633266
64363534656334613439643333373135303930616535393339346265616530333639373566303230
3030343865666330340a333530373134376230326438356439313562393165316339303166343161
30623736326231303262643563386563646266373730343363653833663238323664323861643237
6438643061646534373232303232363038356331303230663762
sa@debian:~/my-ansible$
```

---

### 8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

Для успешного выполнения **playbook** с использованием зашифрованных файлов (или полей) нужно передать для **Ansible** пароль:
- либо в интерактивном режиме дополнив команду запуска ключом `--ask-vault-password`
- либо сохранив пароль в файл и добавив в командную строку параметр `--vault-password-file <file>`, где `<file>` - имя файла с сохранённым паролем

В данном случае используется файл с паролем `secret.txt`

```console
sa@debian:~/my-ansible$ ansible-playbook site.yml --vault-password-file secret.txt -i inventory/prod.yml

PLAY [Print os facts] **************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ******************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

sa@debian:~/my-ansible$
```

---

### 9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

Список плагинов для подключения: `ansible-doc -t connection -l`

```console
sa@debian:~/my-ansible$ ansible-doc -t connection -l
ansible.netcommon.httpapi      Use httpapi to run command on network appliances
ansible.netcommon.libssh       (Tech preview) Run tasks using libssh for ssh connection
ansible.netcommon.napalm       Provides persistent connection using NAPALM
ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol
ansible.netcommon.network_cli  Use network_cli to run command on network appliances
ansible.netcommon.persistent   Use a persistent unix socket for connection
community.aws.aws_ssm          execute via AWS Systems Manager
community.docker.docker        Run tasks in docker containers
community.docker.docker_api    Run tasks in docker containers
community.docker.nsenter       execute on host running controller container
community.general.chroot       Interact with local chroot
community.general.funcd        Use funcd to connect to target
community.general.iocage       Run tasks in iocage jails
community.general.jail         Run tasks in jails
community.general.lxc          Run tasks in lxc containers via lxc python library
community.general.lxd          Run tasks in lxc containers via lxc CLI
community.general.qubes        Interact with an existing QubesOS AppVM
community.general.saltstack    Allow ansible to piggyback on salt minions
community.general.zone         Run tasks in a zone instance
community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt
community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines
community.okd.oc               Execute tasks in pods running on OpenShift
community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools
community.zabbix.httpapi       Use httpapi to run command on network appliances
containers.podman.buildah      Interact with an existing buildah container
containers.podman.podman       Interact with an existing podman container
kubernetes.core.kubectl        Execute tasks in pods running on Kubernetes
local                          execute on controller
paramiko_ssh                   Run tasks via python ssh (paramiko)
psrp                           Run tasks over Microsoft PowerShell Remoting Protocol
ssh                            connect via SSH client binary
winrm                          Run tasks over Microsoft's WinRM
sa@debian:~/my-ansible$
```

Так как `control node` в нашем случае является локальной машиной, то подойдёт подключние `local`

---

### 10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

Изменённое содержимое `inventory/prod.yml`:

```yaml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```

---

### 11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

Так как в `group_vars` определена группа `all`, то для хоста `localhost` ничего менять не требуется, значение будет присвоено из этой группы

Для передачи пароля используется интерактивный режим: `--ask-vault-password`

```console
sa@debian:~/my-ansible$ ansible-playbook site.yml --ask-vault-password -i inventory/prod.yml
Vault password:

PLAY [Print os facts] **************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] ******************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

sa@debian:~/my-ansible$
```

---

### 12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`.

В качестве решения используется открытый репозиторий: [my-ansible](https://github.com/ArtemShtepa/my-ansible/tree/08-ansible-01-base)

---

## Дополнительная часть

### 1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

Расшифровка выполняется командой `ansible-vault decrypt <file>`, где `<file>` - имя файла, который нужно расшифровать

```console
sa@debian:~/my-ansible$ ansible-vault decrypt group_vars/{deb,el}/examp.yml
Vault password:
Decryption successful
sa@debian:~/my-ansible$
```

---

### 2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

Для шифрования отдельной строки нужно:
- Выполнить команду `ansible-vault encrypt_string <text>` для шифрования строки `<text>`
- Вставить полученный вывод вместо значения необходимой переменной

```console
sa@debian:~/my-ansible$ ansible-vault encrypt_string PaSSw0rd && echo
New Vault password:
Confirm New Vault password:
Encryption successful
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          36626266373864343935336435663832306135663232353136353837643430353533316436373636
          6332646238303739643761626639666661326564383963610a663838323866623535396666393534
          61326464323566366532306537623734323363653137613537363436353864363731373438363535
          6465613762303963640a313263336232353034393263333233386537373931366462383966393837
          6236
sa@debian:~/my-ansible$
```

Изменённый файл `group_vars/all/exmp.yml`:

```yaml
---
  some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          36626266373864343935336435663832306135663232353136353837643430353533316436373636
          6332646238303739643761626639666661326564383963610a663838323866623535396666393534
          61326464323566366532306537623734323363653137613537363436353864363731373438363535
          6465613762303963640a313263336232353034393263333233386537373931366462383966393837
          6236
```

---

### 3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

```console
sa@debian:~/my-ansible$ ansible-playbook site.yml --vault-password-file secret.txt -i inventory/prod.yml

PLAY [Print os facts] **************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] ******************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP *************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

sa@debian:~/my-ansible$
```

---

### 4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).

При добавлении новой группы хостов был создан файл `group_vars/fedora/examp.yml` со следующим содержимым

```yaml
---
  some_fact: "fedora var example"
```

Добавлен новый хост в **inventory** окружения **prod**

```yaml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  fedora:
    hosts:
      pycontribs-fedora:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```

Изменённое содержимое **Docker Compose** манифеста

```yaml
---
version: "2.4"

services:
  centos_vm:
    image: centos:7
    container_name: centos7
    tty: true
  ubuntu_vm:
    image: ubuntu:22.04
    container_name: ubuntu
    tty: true
  fedora_vm:
    image: pycontribs/fedora:latest
    container_name: pycontribs-fedora
    tty: true
```

---

### 5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

Готовый скрипт

```bash
echo "Store vault password to file..."
echo "netology" > secret.txt

echo "Up containers..."
docker compose up -d

echo "Install Python3 on ubuntu..."
docker exec ubuntu apt update >/dev/null 2>/dev/null
docker exec ubuntu apt install -y python3 >/dev/null 2>/dev/null

echo "Run ansible playbook..."
ansible-playbook site.yml --vault-password-file secret.txt -i inventory/prod.yml

echo "Shutdown containers..."
docker compose down

echo "Remove vault password file..."
rm secret.txt
```

Результат выполнения скрипта

```console
sa@debian:~/my-ansible$ ./test.sh
Store vault password to file...
Up containers...
[+] Running 4/4
 ⠿ Network my-ansible_default   Created                                                                            0.0s
 ⠿ Container pycontribs-fedora  Started                                                                            0.5s
 ⠿ Container centos7            Started                                                                            0.4s
 ⠿ Container ubuntu             Started                                                                            0.5s
Install Python3 on ubuntu...
Run ansible playbook...

PLAY [Print os facts] **************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [pycontribs-fedora]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [pycontribs-fedora] => {
    "msg": "Fedora"
}
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] ******************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [pycontribs-fedora] => {
    "msg": "fedora var example"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP *************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
pycontribs-fedora          : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

Shutdown containers...
[+] Running 4/4
 ⠿ Container ubuntu             Removed                                                                           10.2s
 ⠿ Container pycontribs-fedora  Removed                                                                            0.1s
 ⠿ Container centos7            Removed                                                                           10.2s
 ⠿ Network my-ansible_default   Removed                                                                            0.1s
Remove vault password file...
sa@debian:~/my-ansible$
```

---

### 6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

В качестве решения используется открытый репозиторий: [my-ansible](https://github.com/ArtemShtepa/my-ansible/tree/08-ansible-01-base)
