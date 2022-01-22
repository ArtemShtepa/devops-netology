## Домашнее задание к занятию «2.1. Системы контроля версий»

Под именем файла имеется ввиду имя файла вместе с расширением (оставшаяся часть имени после последнего символа `.`)

`**/.terraform/*` - игнорировать всё содержимое каталогов `.terraform` на любом уровне вложенности.
Файл `.terraform` игнорироваться не будет.

Примеры:
- .terraform/file1.md
- dir1/.terraform/file2.md
- dir2/dir3/dir4/.terraform/file3.md

`*.tfstate` - игнорировать файлы/каталоги имя которых заканчивается на `.tfstate`.

Примеры:
- dir1/file1.tfstate
- dir1/dir2/dir3/zero.tfstate
- dir4.tfstate

`*.tfstate.*` - игнорировать файлы/каталоги имя которых содержит выражение `.tfstate.` с любым числом любых символов до и после него (выражения).

Примеры:
- file1.tfstate.ext1
- dir1/file2.tfstate.
- dir2/dir3.tfstate.dir3/file4.txt

`crash.log` - игнорировать файлы/каталоги с именем `crash.log`.

Примеры:
- crash.log
- logs/crash.log

`crash.*.log` - игнорировать файлы/каталоги имя которых начинается на `crash.` и заканчивается на `.log`.

Примеры:
- crash.01.log
- logs/crash.01-13_5.log
- logs/crash.15.log
- logs/crash..log

`*.tfvars` - игнорировать файлы/каталоги имя которых заканчивается на `.tfvars`.

Примеры:
- file1.tfvars
- dir1/file1.tfvars

`override.tf` - игнорировать файл/каталог с именем `override.tf`.

Примеры:
- override.tf
- dir1/override.tf
- dir1/dir2/override.tf

`override.tf.json` - игнорировать файл/каталог с именем `override.tf.json`.

Примеры:
- override.tf.json
- dir1/override.tf.json
- dir1/dir2/override.tf.json

`*_override.tf` - игнорировать файлы/каталоги имя которых заканчивается на `_override.tf`.

Примеры:
- test_override.tf
- dir1/file1_override.tf
- dir2/dir3/_override.tf

`*_override.tf.json` - игнорировать файлы/каталоги имя которых заканчивается на `_override.tf.json`.

Примеры:
- test_override.tf.json
- dir1/file1_override.tf.json
- dir2/dir3/___override.tf.json
- _override.tf.json

`.terraformrc` - игнорировать файл/каталог с именем `.terraformrc`.

Примеры:
- .terraformrc
- dir1/.terraformrc

`terraform.rc` - игнорировать файл/каталог с именем `terraform.rc`.

Примеры:
- terraform.rc
- dir1/terraform.rc
- dir2/dir3/terraform.rc

---

Дополнительные материалы:
- Команды: `git status -s`, `git add *`, `git restore --staged`, `git check-ignore`
- [Документация Git: gitignore](https://git-scm.com/docs/gitignore)
- [Статья Atlassian: .gitignore](https://www.atlassian.com/ru/git/tutorials/saving-changes/gitignore)
- [Книга по Git. Запись изменений в репозиторий](https://git-scm.com/book/ru/v2/Основы-Git-Запись-изменений-в-репозиторий)