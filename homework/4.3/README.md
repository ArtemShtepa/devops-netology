# Домашнее задание по лекции "4.3. Языки разметки JSON и YAML"

## Обязательная задача 1

Мы выгрузили JSON, который получили через API запрос к нашему сервису:

```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```

Нужно найти и исправить все ошибки, которые допускает наш сервис

**Ошибки**:

  - Нет запятой между элементами списка `elements` - нужно моставить запятую между символами `}` и `{`

  - В строке `"ip : 71.78.22.43` пропущена вторая обрамляющая кавычка имени ключа - нужно заменить `"ip` на `"ip"`

  - В строке `"ip : 71.78.22.43` значение ключа по сути является текстом, но он не обрамлён - заключить выражение `71.78.22.43` в кавычки `"`

Исправленный файл:

```json
{
  "info": "Sample JSON output from our service\t",
  "elements": [
    {
      "name": "first",
      "type": "server",
      "ip": 7175
    },
    {
      "name": "second",
      "type": "proxy",
      "ip": "71.78.22.43"
    }
  ]
}
```

Дополнительно. Вид файла в формате YAML:

```yaml
---
info: "Sample JSON output from our service\t"
elements:
- name: first
  type: server
  ip: 7175
- name: second
  type: proxy
  ip: 71.78.22.43
...
```

---

## Обязательная задача 2

В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

Готовый скрипт:

```python
#!/usr/bin/env python3
import os
import sys
import socket
import time
import json
import yaml


SERVICES = [
    {"drive.google.com":""},
    {"mail.google.com":""},
    {"google.com":""}
]
LOG_FILENAME = "service_ip"
LOG_JSON_EXT = ".json"
LOG_YAML_EXT = ".yml"
LOG_INDENT = 2

is_loaded = False
if os.path.exists(LOG_FILENAME + LOG_JSON_EXT):
    with open(LOG_FILENAME + LOG_JSON_EXT) as f:
        try:
            SERVICES = json.load(f)
            print("Information loaded from JSON file")
            is_loaded = True
        except:
            print("JSON log is break")
if not is_loaded and os.path.exists(LOG_FILENAME + LOG_YAML_EXT):
    with open(LOG_FILENAME + LOG_YAML_EXT) as f:
        try:
            SERVICES = yaml.safe_load(f)
            print("Information loaded from YAML file")
            is_loaded = True
        except:
            print("YAML log is break")

print("Monitoring... To cancel press Ctrl+C\n")
while True:
    rewrite_log = False
    for srv_idx in range(0,len(SERVICES)):
        for srv_domain, srv_ip_old in SERVICES[srv_idx].items():
            try:
                srv_ip = socket.gethostbyname(srv_domain)
            except:
                sys.stderr.write(f"Domain {srv_domain} not found")
            if (srv_ip != "") and not srv_ip is None:
                print(f"{srv_domain} - {srv_ip}")
                if srv_ip_old != srv_ip:
                    rewrite_log = True
                    if srv_ip_old != "":
                        print(f" >> [ERROR] {srv_domain} IP mismatch: {srv_ip_old} {srv_ip}")
                    SERVICES[srv_idx] = {srv_domain: srv_ip}
    if rewrite_log:
        with open(LOG_FILENAME + LOG_JSON_EXT, "w") as f:
            json.dump(SERVICES, f, indent=LOG_INDENT)
        with open(LOG_FILENAME + LOG_YAML_EXT, "w") as f:
            yaml.dump(SERVICES, f, indent=LOG_INDENT, explicit_start=True, explicit_end=True)
        print(" >> Logs updated")
    time.sleep(3)
```

> Программа поддерживает загрузку исходных данных по сервисам из соответствующих **JSON/YAML** логов

> Формат файла **YAML** записывается с метками начала и конца

Вывод скрипта при первом запуске:

```console
Monitoring... To cancel press Ctrl+C

drive.google.com - 173.194.73.194
mail.google.com - 64.233.165.18
google.com - 142.251.1.101
 >> Logs updated
drive.google.com - 173.194.73.194
mail.google.com - 64.233.165.18
google.com - 142.251.1.101
drive.google.com - 173.194.73.194
mail.google.com - 64.233.165.18
google.com - 142.251.1.101
drive.google.com - 173.194.73.194
mail.google.com - 64.233.165.18
google.com - 64.233.165.100
 >> [ERROR] google.com IP mismatch: 142.251.1.101 64.233.165.100
 >> Logs updated
drive.google.com - 173.194.73.194
mail.google.com - 64.233.165.18
google.com - 64.233.165.100
drive.google.com - 173.194.73.194
mail.google.com - 64.233.165.18
google.com - 64.233.165.100
```

**JSON**-файл, который записывает скрипт:

```json
[
  {
    "drive.google.com": "173.194.73.194"
  },
  {
    "mail.google.com": "64.233.165.18"
  },
  {
    "google.com": "64.233.165.100"
  }
]
```

**YAML**-файл, который записает скрипт:

```yaml
---
- drive.google.com: 173.194.73.194
- mail.google.com: 64.233.165.18
- google.com: 64.233.165.100
...
```

---

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:

   * Принимать на вход имя файла

   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу

   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны

   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)

   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер

   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

Использовалась [документация по расширению PyYAML](https://pyyaml.org/wiki/PyYAMLDocumentation)

Готовый скрипт:

```python
#!/usr/bin/env python3
import os
import string
import sys
import json
import yaml


SAVE_INDENT = 2
EXT_YAML = [".yml", ".yaml"]
EXT_JSON = [".json"]
OVERWRITE_EXISTED = True


class Format_ERROR:
    def __init__(self, e_line, e_column, e_description):
        self.error_line = e_line
        self.error_column = e_column
        self.description = e_description


def check_json_format(text):
    try:
        result = json.loads(text)
    except json.decoder.JSONDecodeError as e:
        result = Format_ERROR(e.lineno-1, e.colno, e.msg)
    return result


def check_yaml_format(text):
    try:
        result = yaml.load(text, Loader=yaml.SafeLoader)
    except yaml.MarkedYAMLError as e:
        result = Format_ERROR(e.problem_mark.line, e.problem_mark.column, e.problem)
    return result


def save_yaml(file_path, obj):
    with open(file_path, "w") as f:
        yaml.dump(obj, f, indent=SAVE_INDENT, explicit_start=True, explicit_end=True)


def save_json(file_path, obj):
    with open(file_path, "w") as f:
        json.dump(obj, f, indent=SAVE_INDENT)


def echo_wrong_extension(file_src, file_dst):
    print("File has wrong extension! It will be renamed")
    if OVERWRITE_EXISTED and os.path.exists(file_dst):
        os.remove(file_dst)
    try:
        os.rename(file_src, file_dst)
    except:
        print("Can`t rename because corresponding file is exists and OVERWRITE is disable")


def echo_error(fmt, er, data = ""):
    print(f"{fmt} format error in line {er.error_line+1} and column {er.error_column}")
    if data != "":
        print("Near: "+data.splitlines()[er.error_line])
    print(f"Decoder message: {er.description}")


FILE_LIST = sys.argv[1:]
FILE_EXT_ACCEPT = EXT_YAML + EXT_JSON

if len(FILE_LIST) == 0:
    print(f"Set files to convert by command line params: file_1 [file_2 .. [file_N]]")
else:
    for file_path in FILE_LIST:
        if os.path.exists(file_path) and os.path.isfile(file_path):
            file_ext = file_path[file_path.rfind("."):].lower()
            file_name = file_path[:len(file_path)-len(file_ext)]
            if FILE_LIST.index(file_path) > 0:
                print("")
            print(f"Examining `{file_path}`...")
            if file_ext in FILE_EXT_ACCEPT:
                print("Check format...", end=" ")
                try:
                    with open(file_path, "r") as f:
                        file_data = f.read()
                except:
                    print("Can`t access file. Check permissions")
                    file_data = None
                if file_data != None:
                    js = check_json_format(file_data)
                    ym = check_yaml_format(file_data)
                    if (type(js) == Format_ERROR) and (type(ym) == Format_ERROR):
                        print("Can`t identify, because all parsers are fails. Identify by file extension")
                        if file_ext in EXT_JSON:
                            echo_error("JSON", js, file_data)
                        if file_ext in EXT_YAML:
                            echo_error("YAML", ym, file_data)
                    elif type(js) != Format_ERROR:
                        print("It's JSON")
                        if file_ext in EXT_YAML:
                            echo_wrong_extension(file_path, file_name + EXT_JSON[0])
                        print("Converting to YAML...")
                        save_yaml(file_name + EXT_YAML[0], js)
                    else:
                        print("It's YAML")
                        if file_ext in EXT_JSON:
                            echo_wrong_extension(file_path, file_name + EXT_YAML[0])
                        print("Converting to JSON...")
                        save_json(file_name + EXT_JSON[0], ym)
            else:
                print(">> Forbidden file extension")
```

> Поддерживается неограниченное число файлов для конвертации (все параметры запуска считаются как файлы для обработки)

> Проверка формата исходного файла выполняется по расширению. Доступные расширения для формата **YAML** определяются списком **EXT_YAML**, для формата **JSON** - списком **EXT_JSON**

> Если в списке доступных расширений формата указано несколько, то сохранение выполняется с приоритетным расширением - первым по порядку в списке

> Переменная **OVERWRITE_EXISTED** определяет, можно ли перезаписывать существующий файл другого формата если при обследовании источника было определено, что формат перепутан - не совпадает с соответствующими расширениями

> Переменная **SAVE_INDENT** определяет число пробелов в отступе при сохранении файлов **JSON/YAML**

> Определение используемого формата осуществляется попыткой декодирования. Если оба дэкодеры (и **JSON** и **YAML**) выдали ошибку, то считается что формат не перепутан с расширением и детальная информация по ошибке выводится с соответствующего расширению дэкодера

Программа обладает недостатком. Так как расширение **PyYAML** может декодировать **JSON**, то при появлении "битого" **JSON** фрагмента аналогичного `"param": 12.23.22.11` декодер **YAML** успешно интерпретирует значение ключа как текст, следовательно программа считает формат файла как **YAML**, не смотря на то, что он формально записан как **JSON** с ошибкой. Данное поведение можно исключить принудительной перезаписью файлов обоих форматов заменив фрагмент исходного текста

```python
                        print("It's YAML")
                        if file_ext in EXT_JSON:
                            echo_wrong_extension(file_path, file_name + EXT_YAML[0])
                        print("Converting to JSON...")
```

на следующий

```python
                        print("It's YAML")
                        if file_ext in EXT_JSON:
                            save_yaml(file_name + EXT_YAML[0], ym)
                        print("Converting to JSON...")
```

Исходные данные:

  - test_1.json - правильный **JSON**

```json
[
  {
    "drive.google.com": "173.194.73.194"
  },
  {
    "mail.google.com": "64.233.165.83"
  },
  {
    "google.com": "142.251.1.100"
  }
]
```

  - test_2.yml - правильный **YAML**

```yaml
---
- drive.google.com: 173.194.73.194
- mail.google.com: 64.233.165.83
- google.com: 142.251.1.100
...
```

  - test_3.json - "битый" **JSON**

```json
[
  {
    "drive.google.com": "173.194.73.194"
  },
  {
    "mail.google.com": "64.233.165.83"
  },
  {
    "google.com": "142.251.1.100
  }
]
```

  - test_4.yaml - "битый" **YAML**

```yaml
---
- drive.google.com: 173.194.73.194
- mail.google.com: 64.233.165.83
- google.com: 142.251.1.100
4353455345
...
```

  - test_5.yml - правильный **JSON**

```yaml
[
  {
    "drive.google.com": "173.194.73.194"
  },
  {
    "mail.google.com": "64.233.165.83"
  },
  {
    "google.com": "142.251.1.100"
  }
]
```

  - test_6.json - правильный **YAML**

```json
---
- drive.google.com: 173.194.73.194
- mail.google.com: 64.233.165.83
- google.com: 142.251.1.100
...
```

Пример работы скрипта (вариант с учётом недостатка):


```console
A:\>python test.py test_1.json test_2.yml test_3.json test_4.yaml test_5.yml test_6.json
Examining `test_1.json`...
Check format... It's JSON
Converting to YAML...

Examining `test_2.yml`...
Check format... It's YAML
Converting to JSON...

Examining `test_3.json`...
Check format... Can`t identify, because all parsers are fails. Identify by file extension
JSON format error in line 9 and column 33
Near:     "google.com": "142.251.1.100
Decoder message: Invalid control character at

Examining `test_4.yaml`...
Check format... Can`t identify, because all parsers are fails. Identify by file extension
YAML format error in line 6 and column 0
Near: ...
Decoder message: could not find expected ':'

Examining `test_5.yml`...
Check format... It's JSON
File has wrong extension! It will be renamed
Converting to YAML...

Examining `test_6.json`...
Check format... It's YAML
Converting to JSON...

A:\>
```

---

Дополнительный материалы:

- [Документация по JSON](https://www.json.org/json-ru.html)

- [Документация по YAML](https://yaml.org/spec/1.2/spec.html)

- [Здесь больше про yaml в ansible, но тем не менее](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html)

- [Как работать с YAML в Ruby](https://yaml.org/YAML_for_ruby.html)

- [Обучение обработки JSON через JavaScript](https://developer.mozilla.org/ru/docs/Learn/JavaScript/Объекты/JSON)

- [Докуентация про библиотеку JSON](https://docs.python.org/3/library/json.html)

- [Документация про библиотеку YAML](https://pyyaml.org/wiki/PyYAMLDocumentation)
