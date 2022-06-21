# Домашнее задание по лекции "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

> Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием терраформа и aws. 
>
> 1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя, а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано [здесь](https://www.terraform.io/docs/backends/types/s3.html).
> 1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше.

Выполнить невозможно ввиду отсутствия возможности зарегистрировать аккаунт AWS, однако в качестве альтернативы можно создать аналогичное хранилище в Яндекс.Облаке, для чего нужно выполнить следующий план:

```terraform
variable "YC_TOKEN" { default = "" }
variable "YC_CLOUD_ID" { default = "" }
variable "YC_FOLDER_ID" { default = "" }
variable "YC_ZONE" { default = "" }

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.70"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = var.YC_ZONE
}

resource "yandex_iam_service_account" "sa" {
  name        = "sa-netology"
  description = "Service account"
  folder_id   = var.YC_FOLDER_ID
}

resource "yandex_resourcemanager_folder_iam_binding" "sa-role" {
  folder_id = var.YC_FOLDER_ID
  role = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa.id}",
  ]
  depends_on = [
    yandex_iam_service_account.sa
  ]
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
}

resource "yandex_storage_bucket" "s3-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "my-terraform-bucket"
}

output "sa_id" {
  value = yandex_iam_service_account.sa.id
  description = "Service Account ID"
}

resource "local_file" "access-key" {
  content  = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  filename = "../access_key"
}

resource "local_file" "secret-key" {
  content  = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  filename = "../secret_key"
}
```

При этом будет создано:

  - Сервисный аккаунт - ресурс `yandex_iam_service_account`
  - Настроена роль **editor** для сервисного аккаунта - ресурс `yandex_resourcemanager_folder_iam_binding`
  - Сгенерирована пара статических ключей - ресурс `yandex_iam_service_account_static_access_key`
  - Создан бакет по типу **S3 backend** - ресурс `yandex_storage_bucket`
  - Ключ доступа сохранён в локальный файл `../access_key`
  - Секретный ключ сохранён в локальный файл `../secret_key`

> К сожалению, выполнение `terraform destroy` не приводит к ожидаемому результату. Провайдер ругается на отсутствующую роль для удаляемого аккаунта, а бакет удалить нельзя ввиду того, что он не пустой.

---

## Задача 2. Инициализируем проект и создаем воркспейсы. 

> 1. Выполните `terraform init`:
>    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице dynamodb.
>    * иначе будет создан локальный файл со стейтами.  
> 1. Создайте два воркспейса `stage` и `prod`.
> 1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах использовались разные `instance_type`.
> 1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
> 1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
> 1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр жизненного цикла `create_before_destroy = true` в один из ресурсов `aws_instance`.
> 1. При желании поэкспериментируйте с другими параметрами и ресурсами.
>
> В виде результата работы пришлите:
> * Вывод команды `terraform workspace list`.
> * Вывод команды `terraform plan` для воркспейса `prod`.

Для настройка бакета (используется терминология Яндекс.Облака) нужно добавить следующий **TF** блок, где:

```terraform
terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "<name>"
    region     = "ru-central1"
    key        = "<backend-path>/<backend-file>.tfstate"
    access_key = "<key-id>"
    secret_key = "<key-value>"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
```

  - `<name>` - имя используемого бакета

  - `<backend-path>` - путь к файлу состояния в бакете

  - `<backend-file>` - имя файла состояния

  - `<key-id>` - идентификатор статического ключа (генерируется при регистрации секретной пары ключей)

  - `<key-value>` - секретный ключ (генерируется при регистрации секретной пары ключей)

> К сожалниею, переменные в данном блоке не поддерживаются, поэтому необходимо вручную прописывать ключи.
>
> При использовании внешнего хранилища локальные файлы состояния (\*.tfstate\*) не создаются

Подготовка переменных окружения для авторизации провайдера:

```console
sa@debian:~/terra$ export TF_VAR_YC_TOKEN=$(yc config get token)
sa@debian:~/terra$ export TF_VAR_YC_CLOUD_ID=$(yc config get cloud-id)
sa@debian:~/terra$ export TF_VAR_YC_FOLDER_ID=$(yc config get folder-id)
sa@debian:~/terra$ export TF_VAR_YC_ZONE=$(yc config get compute-default-zone)
sa@debian:~/terra$
```

Инициализация **Terraform**:

```console
sa@debian:~/terra$ terraform init

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

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

Создание рабочих пространств (**workspace**):

```console
sa@debian:~/terra$ terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
sa@debian:~/terra$ terraform workspace new prod
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
sa@debian:~/terra$
```

Конфигурационные файлы **Terraform**:

Настройка провайдера `provider.tf` [ссылка на файл](/terraform/provider.tf):

```terraform
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.70"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "my-terraform-backend"
    region     = "ru-central-a"
    key        = "terra-backend/stored.tfstate"
    access_key = "..."
    secret_key = "..."

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = var.YC_ZONE
}
```

> В листинге `access_key` и `secre_key` были удалены

Конфигурация инфраструктуры `main.tf` [ссылка на файл](/terraform/main.tf):

```terraform
resource "yandex_vpc_network" "my-net" {
  name = "cluster-network"
}

resource "yandex_vpc_subnet" "my-subnet" {
  name           = "cluster-subnet"
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = var.YC_ZONE
  network_id     = yandex_vpc_network.my-net.id
}

resource "yandex_compute_image" "d11-image" {
  name          = "debian11-image"
  source_family = "debian-11"
}

resource "yandex_compute_disk" "blank-disk" {
  count = local.instance_count[terraform.workspace]

  name  = "node-disk-${count.index + 1}"
  type  = "network-hdd"
  zone  = var.YC_ZONE
  size  = local.node_disk[terraform.workspace]
}

resource "yandex_compute_instance" "vm-master" {
  for_each = local.master_nodes

  name        = "master-${each.key}"
  description = "Master Node - ${each.key}"
  platform_id = "standard-v1"

  resources {
    cores         = local.instance_cpu_cores[terraform.workspace]
    memory        = local.instance_ram[terraform.workspace]
    core_fraction = local.instance_core_frac[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.d11-image.id
      type     = "network-hdd"
      size     = local.primary_disk[terraform.workspace]
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.my-subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "d11-user:${file("~/.ssh/id_rsa.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "yandex_compute_instance" "vm-dn" {
  name        = "node-${format("%01d", count.index + 1)}"
  description = "Data Node ${count.index + 1}"
  platform_id = "standard-v1"
  count       = local.instance_count[terraform.workspace]

  resources {
    cores         = local.instance_cpu_cores[terraform.workspace]
    memory        = local.instance_ram[terraform.workspace]
    core_fraction = local.instance_core_frac[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.d11-image.id
      type     = "network-hdd"
      size     = local.primary_disk[terraform.workspace]
    }
  }

  secondary_disk {
    disk_id = "${yandex_compute_disk.blank-disk[count.index].id}"
    device_name = "data"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.my-subnet.id
    nat       = true
  }

  depends_on = [
    yandex_compute_disk.blank-disk
  ]
}
```

Настройка вывода `output.tf` [ссылка на файл](/terraform/output.tf):

```terraform
output "master_main_external_ip_address" {
  value = yandex_compute_instance.vm-master["main"].network_interface.0.nat_ip_address
}

output "master_reserved_external_ip_address" {
  value = yandex_compute_instance.vm-master["reserved"].network_interface.0.nat_ip_address
}

output "DN_external_ip_address" {
  value = yandex_compute_instance.vm-dn[*].network_interface.0.nat_ip_address
}
```

Используемые переменные `variables.tf` [ссылка на файл](/terraform/variables.tf):

```terraform
variable "YC_TOKEN" { default = "" }
variable "YC_CLOUD_ID" { default = "" }
variable "YC_FOLDER_ID" { default = "" }
variable "YC_ZONE" { default = "" }

locals {
  instance_count = {
    stage = 1
    prod  = 2
  }
  instance_cpu_cores = {
    stage = 2
    prod  = 4
  }
  instance_core_frac = {
    stage = 20
    prod  = 100
  }
  instance_ram = {
    stage = 4
    prod  = 8
  }
  primary_disk = {
    stage = 10
    prod  = 20
  }
  node_disk = {
    stage = 20
    prod  = 80
  }
  master_nodes = toset(["main", "reserved"])
}
```

Вывод рабочих пространств **Terraform**:

```console
sa@debian:~/terra$ terraform workspace select prod
Switched to workspace "prod".
sa@debian:~/terra$ terraform workspace list
  default
* prod
  stage

sa@debian:~/terra$
```

План инфраструктуры для `prod` (команда `plan` заменена на `apply` так как перед применением изменений план тоже выводится):

```console
sa@debian:~/terra$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_disk.blank-disk[0] will be created
  + resource "yandex_compute_disk" "blank-disk" {
      + block_size  = 4096
      + created_at  = (known after apply)
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + name        = "node-disk-1"
      + product_ids = (known after apply)
      + size        = 80
      + status      = (known after apply)
      + type        = "network-hdd"
      + zone        = "ru-central1-a"

      + disk_placement_policy {
          + disk_placement_group_id = (known after apply)
        }
    }

  # yandex_compute_disk.blank-disk[1] will be created
  + resource "yandex_compute_disk" "blank-disk" {
      + block_size  = 4096
      + created_at  = (known after apply)
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + name        = "node-disk-2"
      + product_ids = (known after apply)
      + size        = 80
      + status      = (known after apply)
      + type        = "network-hdd"
      + zone        = "ru-central1-a"

      + disk_placement_policy {
          + disk_placement_group_id = (known after apply)
        }
    }

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

  # yandex_compute_instance.vm-dn[0] will be created
  + resource "yandex_compute_instance" "vm-dn" {
      + created_at                = (known after apply)
      + description               = "Data Node 1"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "node-1"
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
              + name        = (known after apply)
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
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }

      + secondary_disk {
          + auto_delete = false
          + device_name = "data"
          + disk_id     = (known after apply)
          + mode        = "READ_WRITE"
        }
    }

  # yandex_compute_instance.vm-dn[1] will be created
  + resource "yandex_compute_instance" "vm-dn" {
      + created_at                = (known after apply)
      + description               = "Data Node 2"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "node-2"
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
              + name        = (known after apply)
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
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }

      + secondary_disk {
          + auto_delete = false
          + device_name = "data"
          + disk_id     = (known after apply)
          + mode        = "READ_WRITE"
        }
    }

  # yandex_compute_instance.vm-master["main"] will be created
  + resource "yandex_compute_instance" "vm-master" {
      + created_at                = (known after apply)
      + description               = "Master Node - main"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                d11-user:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+QtYRy3bmi9RpLrDl0OzvwEPOHcf+OUvbCrCRZ73l+FKYceT5XRc0yG5S3vzIMbI/kvV9DRwANqRjo6M2agYPgpg/meTnQ7qko/KPVXp6SXyOYUNppr8N6Gd04WAsOgIiBtslTTgJSNdqntYGOGYC24oLMRgs5rXa4EmrkQCP2u/mbAqpKSYl3Nj04zN6JgnHhvcOgf5VmEyuH7rFrVlAfcXLeSXvd/4HE2RyhhHqBYUwZfpXNZBYeY4k/XrvPbex+pZ00JAz6E/raUZSOdXZKfbCu7sKCUTVZyp17wbeKaCn2UqBw8LLOa8wdHKIf7aWKNrihPqmp1C7TSatg9b+rGKDbLuKppSF1fO5sk/VKhd4gbG3eGeXZqrKqpLGD2q4y8SgmOKWlHT4Jibiygyc6RbfYwA/6h9weM36x/YnN9jLAUNjQuZ/uQ9sRBl5d+OfCovENBvbZix8F4tqctRZDt/W9rVKE3EQcx4qGhTNB/GcqqqqwU8LjHbmzl1Srf5srwM5KpGJ4BhqJlIAjBufhAihfEWoDkFpI3GN9JmzNtCp0fUdghAFjp6AISQ/KTywCLZgsgQqn1lJ4TlLGnUCCfI9Lh0RRM7dR5ekPb+WawBem8IWMC6X6AWdvow91Rzc3N4jpwPwXr8NM5lvoh8Xh+eGHLF5VBtkb7CYn8NglQ== sa@debian
            EOT
        }
      + name                      = "master-main"
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
              + name        = (known after apply)
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
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-master["reserved"] will be created
  + resource "yandex_compute_instance" "vm-master" {
      + created_at                = (known after apply)
      + description               = "Master Node - reserved"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                d11-user:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+QtYRy3bmi9RpLrDl0OzvwEPOHcf+OUvbCrCRZ73l+FKYceT5XRc0yG5S3vzIMbI/kvV9DRwANqRjo6M2agYPgpg/meTnQ7qko/KPVXp6SXyOYUNppr8N6Gd04WAsOgIiBtslTTgJSNdqntYGOGYC24oLMRgs5rXa4EmrkQCP2u/mbAqpKSYl3Nj04zN6JgnHhvcOgf5VmEyuH7rFrVlAfcXLeSXvd/4HE2RyhhHqBYUwZfpXNZBYeY4k/XrvPbex+pZ00JAz6E/raUZSOdXZKfbCu7sKCUTVZyp17wbeKaCn2UqBw8LLOa8wdHKIf7aWKNrihPqmp1C7TSatg9b+rGKDbLuKppSF1fO5sk/VKhd4gbG3eGeXZqrKqpLGD2q4y8SgmOKWlHT4Jibiygyc6RbfYwA/6h9weM36x/YnN9jLAUNjQuZ/uQ9sRBl5d+OfCovENBvbZix8F4tqctRZDt/W9rVKE3EQcx4qGhTNB/GcqqqqwU8LjHbmzl1Srf5srwM5KpGJ4BhqJlIAjBufhAihfEWoDkFpI3GN9JmzNtCp0fUdghAFjp6AISQ/KTywCLZgsgQqn1lJ4TlLGnUCCfI9Lh0RRM7dR5ekPb+WawBem8IWMC6X6AWdvow91Rzc3N4jpwPwXr8NM5lvoh8Xh+eGHLF5VBtkb7CYn8NglQ== sa@debian
            EOT
        }
      + name                      = "master-reserved"
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
              + name        = (known after apply)
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
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.my-net will be created
  + resource "yandex_vpc_network" "my-net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "cluster-network"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.my-subnet will be created
  + resource "yandex_vpc_subnet" "my-subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "cluster-subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.2.0.0/16",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 9 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + DN_external_ip_address              = [
      + (known after apply),
      + (known after apply),
    ]
  + master_main_external_ip_address     = (known after apply)
  + master_reserved_external_ip_address = (known after apply)
yandex_compute_image.d11-image: Creating...
yandex_compute_disk.blank-disk[1]: Creating...
yandex_vpc_network.my-net: Creating...
yandex_compute_disk.blank-disk[0]: Creating...
yandex_vpc_network.my-net: Creation complete after 1s [id=enpresadh7rsq65obuj3]
yandex_vpc_subnet.my-subnet: Creating...
yandex_vpc_subnet.my-subnet: Creation complete after 0s [id=e9be2h227ef80vsntvsb]
yandex_compute_disk.blank-disk[1]: Creation complete after 5s [id=fhm1rgktn9gollp0k3mq]
yandex_compute_disk.blank-disk[0]: Creation complete after 5s [id=fhma1npiurov5dc7ejdf]
yandex_compute_image.d11-image: Creation complete after 5s [id=fd8jmuaoka0gfuefmcfm]
yandex_compute_instance.vm-master["reserved"]: Creating...
yandex_compute_instance.vm-dn[1]: Creating...
yandex_compute_instance.vm-master["main"]: Creating...
yandex_compute_instance.vm-dn[0]: Creating...
yandex_compute_instance.vm-master["reserved"]: Still creating... [10s elapsed]
yandex_compute_instance.vm-dn[1]: Still creating... [10s elapsed]
yandex_compute_instance.vm-master["main"]: Still creating... [10s elapsed]
yandex_compute_instance.vm-dn[0]: Still creating... [10s elapsed]
yandex_compute_instance.vm-master["reserved"]: Still creating... [20s elapsed]
yandex_compute_instance.vm-dn[1]: Still creating... [20s elapsed]
yandex_compute_instance.vm-master["main"]: Still creating... [20s elapsed]
yandex_compute_instance.vm-dn[0]: Still creating... [20s elapsed]
yandex_compute_instance.vm-master["main"]: Creation complete after 27s [id=fhmadm4ov1qj8mumig3h]
yandex_compute_instance.vm-master["reserved"]: Still creating... [30s elapsed]
yandex_compute_instance.vm-dn[1]: Still creating... [30s elapsed]
yandex_compute_instance.vm-dn[0]: Still creating... [30s elapsed]
yandex_compute_instance.vm-master["reserved"]: Still creating... [40s elapsed]
yandex_compute_instance.vm-dn[1]: Still creating... [40s elapsed]
yandex_compute_instance.vm-dn[0]: Still creating... [40s elapsed]
yandex_compute_instance.vm-master["reserved"]: Creation complete after 40s [id=fhmpmgoganqh0ka1uf98]
yandex_compute_instance.vm-dn[0]: Creation complete after 41s [id=fhm4rpdsq7j6m56mg36l]
yandex_compute_instance.vm-dn[1]: Creation complete after 42s [id=fhmgmjpi0ni6vj2tqu74]

Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

DN_external_ip_address = [
  "51.250.92.198",
  "51.250.81.202",
]
master_main_external_ip_address = "51.250.86.80"
master_reserved_external_ip_address = "51.250.86.191"
sa@debian:~/terra$
```

Вывод списка ресурсов:

```console
sa@debian:~/terra$ yc compute instance list
+----------------------+-----------------+---------------+---------+---------------+-------------+
|          ID          |      NAME       |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
+----------------------+-----------------+---------------+---------+---------------+-------------+
| fhm4rpdsq7j6m56mg36l | node-1          | ru-central1-a | RUNNING | 51.250.92.198 | 10.2.0.34   |
| fhmadm4ov1qj8mumig3h | master-main     | ru-central1-a | RUNNING | 51.250.86.80  | 10.2.0.10   |
| fhmgmjpi0ni6vj2tqu74 | node-2          | ru-central1-a | RUNNING | 51.250.81.202 | 10.2.0.33   |
| fhmpmgoganqh0ka1uf98 | master-reserved | ru-central1-a | RUNNING | 51.250.86.191 | 10.2.0.31   |
+----------------------+-----------------+---------------+---------+---------------+-------------+

sa@debian:~/terra$ yc compute disk list
+----------------------+-------------+-------------+---------------+--------+----------------------+-------------+
|          ID          |    NAME     |    SIZE     |     ZONE      | STATUS |     INSTANCE IDS     | DESCRIPTION |
+----------------------+-------------+-------------+---------------+--------+----------------------+-------------+
| fhm16hmv259ea4n0bk1d |             | 21474836480 | ru-central1-a | READY  | fhmadm4ov1qj8mumig3h |             |
| fhm1rgktn9gollp0k3mq | node-disk-2 | 85899345920 | ru-central1-a | READY  | fhmgmjpi0ni6vj2tqu74 |             |
| fhm35r4vk0u7j0i9llq3 |             | 21474836480 | ru-central1-a | READY  | fhmpmgoganqh0ka1uf98 |             |
| fhm9vrrmbf2t8bhhdjj7 |             | 21474836480 | ru-central1-a | READY  | fhm4rpdsq7j6m56mg36l |             |
| fhma1npiurov5dc7ejdf | node-disk-1 | 85899345920 | ru-central1-a | READY  | fhm4rpdsq7j6m56mg36l |             |
| fhml5tl06os1lk0qthvk |             | 21474836480 | ru-central1-a | READY  | fhmgmjpi0ni6vj2tqu74 |             |
+----------------------+-------------+-------------+---------------+--------+----------------------+-------------+

sa@debian:~/terra$
```

> 4 безымянных диска - это загрузочные диски созданных машин

---

## Дополнительные материалы:

Инструкция по [загрузке состояний Terraform в Object Storage](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-state-storage)

Инструкция по [созданию бакета (backend)](https://cloud.yandex.ru/docs/storage/operations/buckets/create)
