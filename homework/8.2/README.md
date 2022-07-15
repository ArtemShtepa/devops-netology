# Домашнее задание по лекции "8.2 Работа с Playbook"

## Подготовка к выполнению

> 1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
> 2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
> 3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
> 4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

### 1. Приготовьте свой собственный inventory файл `prod.yml`.

В качестве инфраструктуры были выбраны Docker контейнеры, со следующим манифестом:

```yaml
---
version: "2.4"

services:
  clickhouse_vm:
    image: centos:7
    container_name: clickhouse-01
    ports:
      - 9000:9000
      - 8123:8123
    tty: true
  vector_vm:
    image: centos:7
    container_name: vector-01
    ports:
      - 8383:8383
    tty: true
...
```

Соответствующий **inventory** файл `inventory/prod.yml`

```yaml
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_connection: docker
vector:
  hosts:
    vector-01:
      ansible_connection: docker
...
```

---

### 2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).

Для использования модулей из следующего пункта подходит установка Vector в [ручном режиме из архива](https://vector.dev/docs/setup/installation/manual/from-archives/#linux-x86_64)

---

### 3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.

Шаги установки:
1. Скачать архив по ссылке `https://packages.timber.io/vector/<version>/vector-<version>-x86_64-unknown-linux-musl.tar.gz`, где `<version>` - версия **Vector**
2. Распаковать арихв в нужную директорию

---

### 4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.

---

### 5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

---

### 6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

---

### 7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

---

### 8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

---

### 9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

---

### 10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---
