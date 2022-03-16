# Домашнее задание по лекции "4.2. Использование Python для решения типовых DevOps задач"

## Обязательное задание 1

Есть скрипт:
  ```python
  #!/usr/bin/env python3
  a = 1
  b = '2'
  c = a + b
  ```

  * Какое значение будет присвоено переменной c?
  * Как получить для переменной c значение 12?
  * Как получить для переменной c значение 3?

Ответ:

- Переменной `c` не будет присвоено никакое значение, так как на той строчке возникнет ошибка - неподдерживаемая операция сложения числа (int) и строки (str)

- Значение `12` для переменной `c` при неизменных `a` и `b` может быть только в виде текста:

  ```python
  #!/usr/bin/env python3
  a = 1
  b = '2'
  c = str(a) + b
  ```

- Значение `3` для переменной `c` при неизменных `a` и `b` может быть только в виде числа:

  ```python
  #!/usr/bin/env python3
  a = 1
  b = '2'
  c = a + int(b)
  ```

---

## Обязательное задание 2

Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

То есть необходимо:

1. Выяснить почему выводит не все изменённые файлы

1. Выводить все изменённые файлы

1. Выводить полный путь к изменённым файлам

  ```python
  #!/usr/bin/env python3

  import os

  bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
  result_os = os.popen(' && '.join(bash_command)).read()
  is_change = False
  for result in result_os.split('\n'):
    if result.find('modified') != -1:
      prepare_result = result.replace('\tmodified:   ', '')
      print(prepare_result)
      break
  ```

Ответ:

  - Выводятся не все изменённые файлы, потому что цикл поиска прерывается после обнаружения первого измененного файла. Чтобы исправить нужно удалить команду `break`

  - Полный путь не выводится потому, что так работает `git status`. Для решения задачи необходимо в выводе добавлять путь локального репозитория

Готовый скрипт:

```python
#!/usr/bin/env python3
import os


SEARCH_PATH = '~/netology/sysadm-homeworks'
bash_command = ["cd "+SEARCH_PATH, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(SEARCH_PATH + "/" + prepare_result)
```

> В данном варианте скрипта удален лишний, не используемый, код `is_change`

---

## Обязательное задание 3

Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

Готовый скрипт:

```python
#!/usr/bin/env python3
import os
import sys


SEARCH_PATH = [os.getcwd()]
remove_pwd = True

if len(sys.argv)>1:
    for dir in sys.argv[1:]:
        if os.path.exists(dir) and os.path.isdir(dir):
            if remove_pwd:
                SEARCH_PATH = [dir]
                remove_pwd = False
            else:
                SEARCH_PATH += [dir]

SEARCH_PATH = frozenset(SEARCH_PATH)
many_dir = len(SEARCH_PATH)>1

for cur_path in SEARCH_PATH:
    if os.path.exists(cur_path+"/.git"):
        if many_dir:
            print(f"Local git repository '{cur_path}':")

        #bash only
        #bash_command = ["cd " + cur_path, "git status"]
        #result_os = os.popen(' && '.join(bash_command)).read()
        #cross-platform
        os.chdir(cur_path)
        result_os = os.popen("git status").read()

        is_change = False
        for result in result_os.split('\n'):
            if result.find('modified') != -1:
                prepare_result = result.replace('\tmodified:   ', '')
                is_change = True
                if many_dir:
                    print("  ", end='')
                print(f"{cur_path}/{prepare_result}")
        if not is_change and many_dir:
            print("  is up to date")
    else:
        sys.stderr.write(f"Directory '{cur_path}' is not git repository")
```

> При запуске скрипта без параметров проверяется текущая директория

> При запуске скрипта с параметрами выполняется проверка списка всех переданных параметров на существование соответствующих каталогов. Если среди переданных путей есть хотя бы один, то текущий каталог не проверяется. Далее выполняется поиск модифицированных файлов для каждого переданного каталога. Если каталогов больше одного, то вывод группируется с заголовками имён каталогов. Если переданный каталог не является локальным репозиторием, то в поток ошибок выводится соответствующее сообщение.

> Базовый вариант скрипта не поддерживает операционные системы Windows, так как там не функционирует конструкция ` && `, поэтому соответствующий код заменён.

---

## Обязательное задание 4

Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.

Готовый скрипт:

```python
#!/usr/bin/env python3
import os
import sys
import socket
import time


SERVICES = {
           "drive.google.com":"",
           "mail.google.com":"",
           "google.com":""
           }

while True:
    for srv in SERVICES:
        srv_ip = ""
        try:
            srv_ip = socket.gethostbyname(srv)
        except:
            sys.stderr.write(f"Domain {srv} not found")
        if srv_ip != "":
            print(f"{srv} - {srv_ip}")
            if SERVICES[srv] != srv_ip:
                if SERVICES[srv] != "":
                    print(f"[ERROR] {srv} IP mismatch: {SERVICES[srv]} {srv_ip}")
                SERVICES[srv] = srv_ip
    time.sleep(3)
```

Альтернативный вариант с одноразовым запуском и сохранением результата в файле, без блока try

```python
#!/usr/bin/env python3
import os
import sys


SERVICES = {
           "drive.google.com":"",
           "mail.google.com":"",
           "google.com":""
           }
LOG_FILE = "lookup.log"
LOG_FILE_SEP = " = "

rewrite_log = True
if os.path.exists(LOG_FILE):
    rewrite_log = False
    with open(LOG_FILE, "r") as f:
        for s in f.read().splitlines():
            srv = s.split(LOG_FILE_SEP)
            if srv[0] in SERVICES:
                SERVICES[srv[0]] = srv[1]

for srv in SERVICES:
    result = os.popen(f"ping {srv} -n 1").read()
    pos_start = result.find("[")
    pos_finish = result.find("]")
    if pos_start and (pos_finish > pos_start):
        srv_ip = result[pos_start+1:pos_finish]
        print(f"{srv} - {srv_ip}")
        if SERVICES[srv] != srv_ip:
            rewrite_log = True
            if SERVICES[srv] != "":
                print(f"[ERROR] {srv} IP mismatch: {SERVICES[srv]} {srv_ip}")
        SERVICES[srv] = srv_ip
    else:
        sys.stderr.write(f"Domain {srv} not found")

if rewrite_log:
    with open(LOG_FILE, "w") as f:
        for srv in SERVICES:
            f.write(f"{srv}{LOG_FILE_SEP}{SERVICES[srv]}\n")
```

---

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере.
Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow,
то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный
компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и
только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация
применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно
написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github,
создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в
первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно
добавить к указанному функционалу создание новой ветки, commit и push в неё изменений
конфигурации. С директорией локального репозитория можно делать всё, что угодно.
Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push,
как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR,
в котором применяются наши изменения.

Документация по [API GitHub](https://docs.github.com/en/rest)

Для активации **API GitHub** необходимо создать **Token** доступа в разделе `Settings` -> `Developer settings` -> `Personal Access Token`

Далее полученный токен записать в исходный код скрипта в переменную `GITHUB_TOKEN`

Также в следующих переменных нужно прописать:

- `GITHUB_USER` - логин пользователя GitHub

- `GITHUB_REPO` - используемый репозиторий

- `GITHUB_MAIN` - основная ветка, по умолчанию `main`

Скрипт должен запускаться из локального репозитория

При изменении каких-либо файлов скрипт складывает их в **stash**, создаёт новую ветку, восстанавливает файлы из **stash**, добавляет их в комит, комитит изменения в созданной ветке, пушит ветку в GitHub. Далее через **API** создаёт **Pull Request**, после чего пытается его слить с основной веткой.

Если никаких изменений в GitHub и текущей ветке не обнаружено, а также текущая ветка не совпадает с основной, то скрипт пытается получить у **GitHub** список всех **Pull Request** и слить их с основной веткой. Если список пусть, то пытается создать **Pull Request** для текущей ветки и также слить его в основную.

После успешного слияния **Pull Request** с основной веткой загружаются изменения для локального репозитория

> К сожалению, скрипт при запуске в Windows не поддерживает передачу комментариев на кириллице

> Публикация токена доступа в публикуемых файлах приводит к его блокировке, поэтому в исходном тексте скрипта он не задан

Готовый скрипт:

```python
#!/usr/bin/env python3
import os
import sys
import json


GITHUB_USER = "ArtemShtepa"   # Имя пользователя GitHub
GITHUB_REPO = "test-4.2"      # Репозиторий проекта
GITHUB_MAIN = "main"          # Master ветка
GITHUB_TOKEN = ""
GITHUB_ACCEPT = '"Accept: application/vnd.github.v3+json"'

class c:
    f = ['\033[30m', # Black
         '\033[34m', # Dark Blue
         '\033[32m', # Dark Green
         '\033[36m', # Dark aqua
         '\033[31m', # Dark Red
         '\033[35m', # Dark Magnet
         '\033[33m', # Dark Yellow
         '\033[37m', # White
         '\033[90m', # Grey
         '\033[94m', # Light Blue
         '\033[92m', # Light Green
         '\033[96m', # Light Aqua
         '\033[91m', # Light Red
         '\033[95m', # Light Magnet
         '\033[93m', # Light Yellow
         '\033[97m', # Light White
        ]
    r = '\033[0m'


def is_local_changed():
    print(f"{c.f[7]}Проверка изменений локального репозитория...{c.f[8]}")
    result = os.popen("git status -s").read()
    return len(result)>0


def get_current_branch():
    result = os.popen("git status").read().splitlines()[0]
    return result[result.find(" ",result.find(" ")+1)+1:]


def is_remote_changed():
    print(f"{c.f[7]}Проверка изменений в GitHub...{c.f[8]}")
    result = len(os.popen("git fetch").read())>0
    if not result:
        echo = os.popen("git status").read()
        result = echo.find("branch is behind") >= 0
    return result


def git_pull_main():
    print(f"{c.f[7]}Получение изменений с GitHub...")
    print(c.f[8]+os.popen("git pull").read()+c.r)
    return


def get_branch_list():
    print(f"{c.f[9]}Запрос веток с GitHub...{c.f[8]}")
    lnk = f"curl -s -k -H {GITHUB_ACCEPT} -u {GITHUB_USER}:{GITHUB_TOKEN} https://api.github.com/repos/{GITHUB_USER}/{GITHUB_REPO}/branches"
    result = []
    for branch in json.loads(os.popen(lnk).read()):
        result += [branch["name"]]
    return result


def get_pr_list():
    print(f"{c.f[9]}Запрос списка Pull Requests с GitHub...{c.f[8]}")
    lnk = f"curl -s -k -H {GITHUB_ACCEPT} -u {GITHUB_USER}:{GITHUB_TOKEN} https://api.github.com/repos/{GITHUB_USER}/{GITHUB_REPO}/pulls"
    result = []
    for pr in json.loads(os.popen(lnk).read()):
        result += [pr["number"]]
    return result


def call_pr(branch_name, comment):
    print(f"{c.f[9]}Создание Pull Requst...{c.f[8]}")
    body = str('{"head":"'+branch_name+'","base":"'+GITHUB_MAIN+'","title":"'+comment+'"}').replace('"','\\"')
    lnk = f"curl -s -k -X POST -H {GITHUB_ACCEPT} -u {GITHUB_USER}:{GITHUB_TOKEN} https://api.github.com/repos/{GITHUB_USER}/{GITHUB_REPO}/pulls -d \"{body}\""
    res = json.loads(os.popen(lnk).read())
    if "number" in res:
        print(f"{c.f[10]}Получен номер Pull Request: {c.f[15]}{res['number']}")
        return res["number"]
    else:
        print(f"{c.f[12]}{res['message']}")
        return None


def try_merge_pr(number, comment):
    print(f"{c.f[9]}Пытаемся закрыть Pull Request `{c.f[15]}{number}{c.f[9]}`...{c.f[8]}")
    body = str('{"commit_title":"'+comment+'","merge_method":"merge"}').replace('"','\\"')
    lnk = f"curl -s -k -X PUT -H {GITHUB_ACCEPT} -u {GITHUB_USER}:{GITHUB_TOKEN} https://api.github.com/repos/{GITHUB_USER}/{GITHUB_REPO}/pulls/{number}/merge -d \"{body}\""
    result = json.loads(os.popen(lnk).read())
    if "merged" in result:
        return result["merged"]
    else:
        print(f"{c.f[12]}{result['message']}")
        return False


def change_branch_to_main():
    print(f"{c.f[7]}Смена ветки на основную...{c.f[8]}")
    print(os.popen(f"git switch {GITHUB_MAIN}").read())
    return


def update_local_rep():
    change_branch_to_main()
    if is_remote_changed():
        git_pull_main()
        print(f"{c.f[10]}Консистентность восстановлена")


def check_comment():
    global comment
    if comment == "":
        print(f"{c.f[12]}ОШИБКА! Укажите комментарий в параметрах запуска{c.r}")
        sys.exit(2)


if sys.platform == "win32":
    import ctypes
    kernel32 = ctypes.windll.kernel32
    kernel32.SetConsoleMode(kernel32.GetStdHandle(-11), 7)

if GITHUB_TOKEN == "":
    print(f"{c.f[12]}Задайте токен доступа в переменной GITHUB_TOKEN{c.r}")
    sys.exit(3)

master_changed = is_remote_changed()
local_changed = is_local_changed()
comment = " ".join(sys.argv[1:])

if not local_changed and not master_changed:
    branch = get_current_branch()
    if branch != GITHUB_MAIN:
        pr_list = get_pr_list()
        success = False
        check_comment()
        if len(pr_list) == 0:
            print(f"{c.f[11]}Открытых Pull Request нет")
            pr_number = call_pr(branch, comment)
            if pr_number != None:
                success = try_merge_pr(pr_number, comment)
        else:
            success = True
            for pr in pr_list:
                success &= try_merge_pr(pr, comment)
        if success:
            update_local_rep()
    else:
        print(f"{c.f[15]}Никаких изменений не обнаружено{c.r}")
    sys.exit(1)

if local_changed:
    check_comment()
    print(f"{c.f[11]}Обнаружены изменения конфигурации")
    print(f"{c.f[7]}Скрытие изменений...")
    print(c.f[8]+os.popen("git stash push").read()+c.r)

if master_changed:
    print(f"{c.f[11]}Обнаружены изменения в GitHub!")
    git_pull_main()
    print(f"{c.f[10]}Конфигурационные файлы обновлены")

if local_changed:
    branch_list = get_branch_list()
    branch_num = 1
    while True:
        branch_name = f"update_{branch_num}"
        if branch_name in branch_list:
            branch_num += 1
        else:
            break
    print(f"{c.f[7]}Создание новой ветки `{c.f[15]}{branch_name}`...{c.f[8]}")
    print(os.popen(f"git switch -c {branch_name}").read())
    print(f"{c.f[7]}Восстановление изменений...{c.f[8]}")
    print(os.popen("git stash pop").read())
    print(f"{c.f[7]}Добавление изменений в ветку...{c.f[8]}")
    print(os.popen("git add *").read())
    print(f"{c.f[7]}Сохранение изменений в ветке...{c.f[8]}")
    print(os.popen('git commit -m "'+comment+'"').read())
    print(f"{c.f[7]}Отправка ветки в репозиторий...{c.f[8]}")
    print(os.popen(f"git push -u origin {branch_name}").read())
    pr_number = call_pr(branch_name, comment)
    try_merge_pr(pr_number, comment)
    update_local_rep()
```
