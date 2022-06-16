# Домашнее задание по лекции "7.2. Облачные провайдеры и синтаксис Terraform."

Зачастую разбираться в новых инструментах гораздо интересней понимая то, как они работают изнутри. 
Поэтому в рамках первого *необязательного* задания предлагается завести свою учетную запись в AWS (Amazon Web Services) или Yandex.Cloud.
Идеально будет познакомится с обоими облаками, потому что они отличаются.

## Задача 1 (вариант с AWS). Регистрация в aws и знакомство с основами (необязательно, но крайне желательно).

Остальные задания можно будет выполнять и без этого аккаунта, но с ним можно будет увидеть полный цикл процессов. 

AWS предоставляет достаточно много бесплатных ресурсов в первый год после регистрации, подробно описано [здесь](https://aws.amazon.com/free/).
1. Создайте аккаут aws.
1. Установите c aws-cli https://aws.amazon.com/cli/.
1. Выполните первичную настройку aws-sli https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html.
1. Создайте IAM политику для терраформа c правами
    * AmazonEC2FullAccess
    * AmazonS3FullAccess
    * AmazonDynamoDBFullAccess
    * AmazonRDSFullAccess
    * CloudWatchFullAccess
    * IAMFullAccess
1. Добавьте переменные окружения 
    ```
    export AWS_ACCESS_KEY_ID=(your access key id)
    export AWS_SECRET_ACCESS_KEY=(your secret access key)
    ```
1. Создайте, остановите и удалите ec2 инстанс (любой с пометкой `free tier`) через веб интерфейс. 

В виде результата задания приложите вывод команды `aws configure list`.

---

Выполнить данную задачу не представляется возможным, так как для регистрации аккаунта, даже на бесплатный период, осложняется следующими требованиями:

 - Аутентификация пользователя по телефону, звонком или отправкой SMS. Номера из России заблокированы.

 - Подключение банковской карты для осуществления пробного платежа. VISA и MASTERCARD блокируют платежи за пределами России, а сам Amazon [активно борется](https://qna.habr.com/q/1126202) с платежами из России. Наиболее вероятно, что MIR тоже не принимается.

> А не очень-то и хотелось...

---

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта. 
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

---

Зеркало дистрибутивов **Terraform** в [Яндекс.Облаке](https://hashicorp-releases.website.yandexcloud.net/terraform/)

Чтобы использовать в качестве параметров переменные окружения, нужно их создать в виде `export TF_VAR_<name>=<value>`, где `<name>` - имя переменной, а `<value>` - значение переменной

Для авторизации на **Яндекс.Облаке** при использовании его в качестве провайдера **Terraform** нужно задать следующие переменные:

  - `YC_TOKEN` - OAuth токен авторизации, либо `YC_SERVICE_ACCOUNT_KEY_FILE` - ключ-файл сервисного аккаунта. Инструкция как его [создать](https://cloud.yandex.ru/docs/iam/operations/iam-token/create-for-sa).

  - `YC_CLOUD_ID` - идентификатор облака

  - `YC_FOLDER_ID` - идентификатор каталога из облака

  - `YC_ZONE` - идентификатор зоны доступности

Для инициализации клиента **Яндекс.Облака** используется команда: `yc init`

Для просмотра параметров подключения: `yc config list`

Для вывода конкретного параметра, например токена: `yc config get token`

Таким образом после инициализации задание параметров в виде переменных окружения будет выглядеть так:

```console
sa@debian:~/terra$ export TF_VAR_YC_TOKEN=$(yc config get token)
sa@debian:~/terra$ export TF_VAR_YC_CLOUD_ID=$(yc config get cloud-id)
sa@debian:~/terra$ export TF_VAR_YC_FOLDER_ID=$(yc config get folder-id)
sa@debian:~/terra$ export TF_VAR_YC_ZONE=$(yc config get compute-default-zone)
sa@debian:~/terra$
```

---

## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ. 

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
2. Зарегистрируйте провайдер 
   1. для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл `main.tf` добавьте блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой выбранный вами регион внутри блока `provider`.
   2. либо для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Подробную инструкцию можно найти [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали их в виде переменных окружения. 
4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.  
5. В файле `main.tf` создайте рессурс 
   1. либо [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
   Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке 
   `Example Usage`, но желательно, указать большее количество параметров.
   2. либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).
6. Также в случае использования aws:
   1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
   2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент: 
       * AWS account ID,
       * AWS user ID,
       * AWS регион, который используется в данный момент, 
       * Приватный IP ec2 инстансы,
       * Идентификатор подсети в которой создан инстанс.  
7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок. 

В качестве результата задания предоставьте:
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
1. Ссылку на репозиторий с исходной конфигурацией терраформа.


### **Решение:**

Ввиду проблематичности создания **AWS** аккаунта соответствующие пункты задания пропущены. Взамен, больше внимания было уделено изучению провайдера **Яндекс.Облака**.

Файлы плана **Terraform**:

**main.tf** [ссылка на файл](/terraform/main.tf):

```terraform
variable "YC_TOKEN" { default = "" }
variable "YC_CLOUD_ID" { default = "" }
variable "YC_FOLDER_ID" { default = "" }
variable "YC_ZONE" { default = "" }

provider "yandex" {
  token     = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = var.YC_ZONE
}

resource "yandex_compute_image" "d11-image" {
  name          = "debian11-image"
  source_family = "debian-11"
}

resource "yandex_vpc_network" "d11-net" {}

resource "yandex_vpc_subnet" "d11-subnet" {
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = var.YC_ZONE
  network_id     = "${yandex_vpc_network.d11-net.id}"
}

resource "yandex_compute_instance" "d11-vm" {
  name        = "debian-11"
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = "${yandex_compute_image.d11-image.id}"
      name     = "d11-boot-disk"
      type     = "network-hdd"
      size     = 20
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.d11-subnet.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "d11-user:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "external_ip_address" {
  value = "${yandex_compute_instance.d11-vm.network_interface.0.nat_ip_address}"
}
```

> Помимо диска `yandex_compute_image` реализована сеть `yandex_vpc_network`, подсеть `yandex_vpc_subnet` и виртуальная машина `yandex_compute_instance`. Также добавлен вывод внешнего IP адреса машины (единственный блок `output`)

**versions.tf** [ссылка на файл](/terraform/versions.tf):

```terraform
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.70"
    }
  }
  required_version = ">= 0.13"
}
```

Инициализация платформы (провайдера **Яндекс.Облака**) с зеркала **Яндекса**:

```console
sa@debian:~/terra$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding yandex-cloud/yandex versions matching ">= 0.70.0"...
- Installing yandex-cloud/yandex v0.75.0...
- Installed yandex-cloud/yandex v0.75.0 (unauthenticated)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
sa@debian:~/terra$
```

План развёртывания инфраструктуры:

> Приведён полностью, так как позволяет наглядно видеть доступные для изменения параметры и какие из них заполнены

```console
sa@debian:~/terra$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_image.d11-image will be created
  + resource "yandex_compute_image" "d11-image" {
      + created_at      = (known after apply)
      + folder_id       = (known after apply)
      + id              = (known after apply)
      + min_disk_size   = (known after apply)
      + name            = "debian11-image"
      + os_type         = (known after apply)
      + pooled          = (known after apply)
      + product_ids     = (known after apply)
      + size            = (known after apply)
      + source_disk     = (known after apply)
      + source_family   = "debian-11"
      + source_image    = (known after apply)
      + source_snapshot = (known after apply)
      + source_url      = (known after apply)
      + status          = (known after apply)
    }

  # yandex_compute_instance.d11-vm will be created
  + resource "yandex_compute_instance" "d11-vm" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                d11-user:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcd8T0yCNNeBPhpzjsgF9hjypMrOPNLwtLbzDTyIAZ+H9skatIeYiWZJxsHQzvDfTHMP9ICt5KbouF0O9ECLAoV2sMlCW6g9KWk3KDb8qmyD2M/tQ93UYzzd8/cWOgE+fkhXvLeLu5ATq8MjH7sAtJZxO3HhduNMA/ydG1WKp4HZKahQoY63n8l9A3qfrbLVz7U22IyIY1OdB/K0njOKlYKSvKzUbfcGpBuWpJQDLhfUGVfQYZfCNXBXuQpMGR85XRVRTjgPxnsKw9DeDLJa9N/btQGEHRLYKAGRMk1ZguT3mbpb8gsICKCmjWrLMP1ZWxo6MQcpB+y7DdSHvfcDVtffzN/Ipl3jO1jDz0PxN45dvdK1lfqjBkov5yY9Jz05/rd2sRXkrs1J9wSM40Rw72bNkW9Y72dSdTi1w36eberMFnzeplrvIqt2+Hywv7bBBAwAZWs/o/T7wWCbioRIHj43A2qhqV+7sSbmfW9/HKkgFgPkvI0WJMp31oEYzeGANi9/M4Nd7QRkTq+Mo8J1/k98pNsLJn5EtwSBsa6pAQAGELsanBbXN8+D1StVur6lNXhWF/VL8wrjXkTgF9x3TbEJG3qc1LHDEYyL8v71vOO3+5leHcflfcA+6I9Olt0gBqis3tsCwDXtawJg3S8cFPfKZwpgw7TGlpH294sHXrDw== sa@debian
            EOT
        }
      + name                      = "debian-11"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = "d11-boot-disk"
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.d11-net will be created
  + resource "yandex_vpc_network" "d11-net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = (known after apply)
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.d11-subnet will be created
  + resource "yandex_vpc_subnet" "d11-subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = (known after apply)
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.2.0.0/16",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address = (known after apply)

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if
you run "terraform apply" now.
sa@debian:~/terra$
```

Применение изменений (часть вывода, дублирующего `plan` исключено из лога):

```console
sa@debian:~/terra$ terraform apply -auto-approve

...

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address = (known after apply)
yandex_compute_image.d11-image: Creating...
yandex_vpc_network.d11-net: Creating...
yandex_vpc_network.d11-net: Creation complete after 1s [id=enp04ork7mrk7qh8r1j8]
yandex_vpc_subnet.d11-subnet: Creating...
yandex_vpc_subnet.d11-subnet: Creation complete after 1s [id=e9bp2hnmjds0qpqlhlgd]
yandex_compute_image.d11-image: Creation complete after 9s [id=fd8l2h2ejumpnciggpuj]
yandex_compute_instance.d11-vm: Creating...
yandex_compute_instance.d11-vm: Still creating... [10s elapsed]
yandex_compute_instance.d11-vm: Still creating... [20s elapsed]
yandex_compute_instance.d11-vm: Creation complete after 28s [id=fhmp4stcb6vtmmp4h5d4]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address = "51.250.64.181"
sa@debian:~/terra$
```

Проверка - просмотр созданных ресурсов:

```console
sa@debian:~/terra$ yc compute image list
+----------------------+----------------+--------+----------------------+--------+
|          ID          |      NAME      | FAMILY |     PRODUCT IDS      | STATUS |
+----------------------+----------------+--------+----------------------+--------+
| fd8l2h2ejumpnciggpuj | debian11-image |        | f2e3u3sn3oqtfmi1satg | READY  |
+----------------------+----------------+--------+----------------------+--------+

sa@debian:~/terra$ yc compute instance list
+----------------------+-----------+---------------+---------+---------------+-------------+
|          ID          |   NAME    |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
+----------------------+-----------+---------------+---------+---------------+-------------+
| fhmp4stcb6vtmmp4h5d4 | debian-11 | ru-central1-a | RUNNING | 51.250.64.181 | 10.2.0.7    |
+----------------------+-----------+---------------+---------+---------------+-------------+

sa@debian:~/terra$ yc compute disk list
+----------------------+---------------+-------------+---------------+--------+----------------------+-------------+
|          ID          |     NAME      |    SIZE     |     ZONE      | STATUS |     INSTANCE IDS     | DESCRIPTION |
+----------------------+---------------+-------------+---------------+--------+----------------------+-------------+
| fhmaadmc8orb5d8t2te1 | d11-boot-disk | 21474836480 | ru-central1-a | READY  | fhmp4stcb6vtmmp4h5d4 |             |
+----------------------+---------------+-------------+---------------+--------+----------------------+-------------+

sa@debian:~/terra$
```

Уничтожение ресурсов (приведён без сокращений, так как позволяет увидеть текущие значение параметров, которые нами прямо не задавались):

```console
sa@debian:~/terra$ terraform destroy
yandex_vpc_network.d11-net: Refreshing state... [id=enp04ork7mrk7qh8r1j8]
yandex_compute_image.d11-image: Refreshing state... [id=fd8l2h2ejumpnciggpuj]
yandex_vpc_subnet.d11-subnet: Refreshing state... [id=e9bp2hnmjds0qpqlhlgd]
yandex_compute_instance.d11-vm: Refreshing state... [id=fhmp4stcb6vtmmp4h5d4]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  - destroy

Terraform will perform the following actions:

  # yandex_compute_image.d11-image will be destroyed
  - resource "yandex_compute_image" "d11-image" {
      - created_at    = "2022-06-17T20:01:52Z" -> null
      - folder_id     = "b1g3ol70h1opu6hr9kie" -> null
      - id            = "fd8l2h2ejumpnciggpuj" -> null
      - labels        = {} -> null
      - min_disk_size = 3 -> null
      - name          = "debian11-image" -> null
      - pooled        = false -> null
      - product_ids   = [
          - "f2e3u3sn3oqtfmi1satg",
        ] -> null
      - size          = 1 -> null
      - source_family = "debian-11" -> null
      - status        = "ready" -> null
    }

  # yandex_compute_instance.d11-vm will be destroyed
  - resource "yandex_compute_instance" "d11-vm" {
      - created_at                = "2022-06-17T20:02:01Z" -> null
      - folder_id                 = "b1g3ol70h1opu6hr9kie" -> null
      - fqdn                      = "fhmp4stcb6vtmmp4h5d4.auto.internal" -> null
      - hostname                  = "fhmp4stcb6vtmmp4h5d4" -> null
      - id                        = "fhmp4stcb6vtmmp4h5d4" -> null
      - labels                    = {} -> null
      - metadata                  = {
          - "ssh-keys" = <<-EOT
                d11-user:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcd8T0yCNNeBPhpzjsgF9hjypMrOPNLwtLbzDTyIAZ+H9skatIeYiWZJxsHQzvDfTHMP9ICt5KbouF0O9ECLAoV2sMlCW6g9KWk3KDb8qmyD2M/tQ93UYzzd8/cWOgE+fkhXvLeLu5ATq8MjH7sAtJZxO3HhduNMA/ydG1WKp4HZKahQoY63n8l9A3qfrbLVz7U22IyIY1OdB/K0njOKlYKSvKzUbfcGpBuWpJQDLhfUGVfQYZfCNXBXuQpMGR85XRVRTjgPxnsKw9DeDLJa9N/btQGEHRLYKAGRMk1ZguT3mbpb8gsICKCmjWrLMP1ZWxo6MQcpB+y7DdSHvfcDVtffzN/Ipl3jO1jDz0PxN45dvdK1lfqjBkov5yY9Jz05/rd2sRXkrs1J9wSM40Rw72bNkW9Y72dSdTi1w36eberMFnzeplrvIqt2+Hywv7bBBAwAZWs/o/T7wWCbioRIHj43A2qhqV+7sSbmfW9/HKkgFgPkvI0WJMp31oEYzeGANi9/M4Nd7QRkTq+Mo8J1/k98pNsLJn5EtwSBsa6pAQAGELsanBbXN8+D1StVur6lNXhWF/VL8wrjXkTgF9x3TbEJG3qc1LHDEYyL8v71vOO3+5leHcflfcA+6I9Olt0gBqis3tsCwDXtawJg3S8cFPfKZwpgw7TGlpH294sHXrDw== sa@debian
            EOT
        } -> null
      - name                      = "debian-11" -> null
      - network_acceleration_type = "standard" -> null
      - platform_id               = "standard-v1" -> null
      - status                    = "running" -> null
      - zone                      = "ru-central1-a" -> null

      - boot_disk {
          - auto_delete = true -> null
          - device_name = "fhmaadmc8orb5d8t2te1" -> null
          - disk_id     = "fhmaadmc8orb5d8t2te1" -> null
          - mode        = "READ_WRITE" -> null

          - initialize_params {
              - block_size = 4096 -> null
              - image_id   = "fd8l2h2ejumpnciggpuj" -> null
              - name       = "d11-boot-disk" -> null
              - size       = 20 -> null
              - type       = "network-hdd" -> null
            }
        }

      - network_interface {
          - index              = 0 -> null
          - ip_address         = "10.2.0.7" -> null
          - ipv4               = true -> null
          - ipv6               = false -> null
          - mac_address        = "d0:0d:19:27:3a:c5" -> null
          - nat                = true -> null
          - nat_ip_address     = "51.250.64.181" -> null
          - nat_ip_version     = "IPV4" -> null
          - security_group_ids = [] -> null
          - subnet_id          = "e9bp2hnmjds0qpqlhlgd" -> null
        }

      - placement_policy {
          - host_affinity_rules = [] -> null
        }

      - resources {
          - core_fraction = 20 -> null
          - cores         = 2 -> null
          - gpus          = 0 -> null
          - memory        = 2 -> null
        }

      - scheduling_policy {
          - preemptible = false -> null
        }
    }

  # yandex_vpc_network.d11-net will be destroyed
  - resource "yandex_vpc_network" "d11-net" {
      - created_at = "2022-06-17T20:01:52Z" -> null
      - folder_id  = "b1g3ol70h1opu6hr9kie" -> null
      - id         = "enp04ork7mrk7qh8r1j8" -> null
      - labels     = {} -> null
      - subnet_ids = [
          - "e9bp2hnmjds0qpqlhlgd",
        ] -> null
    }

  # yandex_vpc_subnet.d11-subnet will be destroyed
  - resource "yandex_vpc_subnet" "d11-subnet" {
      - created_at     = "2022-06-17T20:01:53Z" -> null
      - folder_id      = "b1g3ol70h1opu6hr9kie" -> null
      - id             = "e9bp2hnmjds0qpqlhlgd" -> null
      - labels         = {} -> null
      - network_id     = "enp04ork7mrk7qh8r1j8" -> null
      - v4_cidr_blocks = [
          - "10.2.0.0/16",
        ] -> null
      - v6_cidr_blocks = [] -> null
      - zone           = "ru-central1-a" -> null
    }

Plan: 0 to add, 0 to change, 4 to destroy.

Changes to Outputs:
  - external_ip_address = "51.250.64.181" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

yandex_compute_instance.d11-vm: Destroying... [id=fhmp4stcb6vtmmp4h5d4]
yandex_compute_instance.d11-vm: Destruction complete after 9s
yandex_compute_image.d11-image: Destroying... [id=fd8l2h2ejumpnciggpuj]
yandex_vpc_subnet.d11-subnet: Destroying... [id=e9bp2hnmjds0qpqlhlgd]
yandex_vpc_subnet.d11-subnet: Destruction complete after 6s
yandex_vpc_network.d11-net: Destroying... [id=enp04ork7mrk7qh8r1j8]
yandex_vpc_network.d11-net: Destruction complete after 0s
yandex_compute_image.d11-image: Destruction complete after 8s

Destroy complete! Resources: 4 destroyed.
sa@debian:~/terra$
```

Свой образ можно создать при помощи инструмента **Packer**.
Пример создания образа из [ДЗ 5.4](/homework/5.4/)

---

Дополнительные материалы:

Описание ресурса [yandex_compute_image](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/compute_image)

Описание ресурса [yandex_compute_instance](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance)

Список доступных [платформ (platform_id)](https://cloud.yandex.ru/docs/compute/concepts/vm-platforms)

Пример **Сергея Андрюнина**: [Infrastructure As Code](https://gitlab.com/k11s-os/infrastructure-as-code)

Пример **Сергея Андрюнина**: [Демонстрационное приложение "Новостная лента"](https://gitlab.com/k11s-os/news-app-demo)

> При возникновении сложности с использованием **makefile** (например, проблем с командой `source`) соответствующие блоки можно разделить на отдельные bash скрипты, исполнять непосредственно в консоли, либо переписать под единый bash скрипт с командой запуска
