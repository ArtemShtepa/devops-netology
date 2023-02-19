# Домашнее задание по лекции "15.1. Организация сети"

> Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере
> Яндекс.Облако и дополнительной части в AWS по желанию. Все домашние задания в 15 блоке связаны
> друг с другом и в конце представляют пример законченной инфраструктуры. Все задания требуется
> выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории.

---

## Обязательное задание. Яндекс.Облако

> 1. Создать VPC.
> - Создать пустую VPC. Выбрать зону.
> 2. Публичная подсеть.
> - Создать в vpc subnet с названием public, сетью 192.168.10.0/24.
> - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1
> - Создать в этой публичной подсети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.
> 3. Приватная подсеть.
> - Создать в vpc subnet с названием private, сетью 192.168.20.0/24.
> - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс
> - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее и убедиться что есть доступ к интернету

В качестве основы решения взяты скрипты подготовки инфраструктуры для домашних заданий блока **13 Конфигурация Kubernetes**

Создание сети и двух подсетей для провайдера **Яндекс.Облака** выглядит следующим образом

```terraform
resource "yandex_vpc_network" "my-net" {
  name = "master-network"
}

resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.YC_ZONE
  network_id     = yandex_vpc_network.my-net.id
}

resource "yandex_vpc_subnet" "private-subnet" {
  name           = "private"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = var.YC_ZONE
  network_id     = yandex_vpc_network.my-net.id
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_route_table" "rt" {
  name       = "route-table"
  network_id = yandex_vpc_network.my-net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = module.vm-nat-gateway.internal_ip
  }
}
```

Для подсети `private-subnet` **private** добавлен параметр `route_table_id`,
ссылающийся на таблицу маршрутизации `rt` **route-table**, где в свою очередь
создан один статический маршрут (групп **static_route** может быть несколько)
перенаправления всех запросов (**0.0.0.0/0**) на **IP** адрес "машинки" `vm-nat-gateway`,
выполняющей роль **NAT gateway** (параметр `next_hop_address`).

Все "машинки" создаются самописным модулем [vm-instance](./src/vm-instance/main.tf), где
в качестве параметров добавлены внутренний и внешний **IP** адреса, а также имя пользователя,
для которого добавляется **SSH** ключ.

Параметры создаваемых машин, включают создание ресурса системного диска `os-disk` **os-disk** -
он используется для обычных "машин". для **NAT Gateway** используется предложенный **image_id**.

```terraform
resource "yandex_compute_image" "os-disk" {
  name          = "os-disk"
  source_family = "debian-11"
}

module "vm-nat-gateway" {
  source = "./vm-instance"

  name        = "nat-gateway"
  user        = "ubuntu"
  description = "NAT Gateway"
  cpu         = 2
  ram         = 2
  cpu_load    = 5
  ip          = var.NAT_GATEWAY
  nat         = "true"
  subnet      = yandex_vpc_subnet.public-subnet.id
  main_disk_image = "fd80mrhj8fl2oe87o4e1"
  main_disk_size  = 10
}

module "vm-public" {
  source = "./vm-instance"

  name        = "public-vm"
  user        = "debian"
  description = "Machine in public subnet"
  cpu         = 2
  ram         = 2
  cpu_load    = 5
  ip          = ""
  nat         = true
  subnet      = yandex_vpc_subnet.public-subnet.id
  main_disk_image = yandex_compute_image.os-disk.id
  main_disk_size  = 10
}

module "vm-private" {
  source = "./vm-instance"

  name        = "private-vm"
  user        = "debian"
  description = "Machine in private subnet"
  cpu         = 2
  ram         = 2
  cpu_load    = 5
  ip          = ""
  nat         = false
  subnet      = yandex_vpc_subnet.private-subnet.id
  main_disk_image = yandex_compute_image.os-disk.id
  main_disk_size  = 10
}
```

"Машинки" подключаются к подсетям через передаваемый параметр `subnet`.
При необходимости задания **IP** адреса, устанавливается значение паременной `ip`.

Исходный код готового решения представлен в подкаталоге [src](./src/)

<details>
<summary>Разворачивание инфраструктуры :</summary>

```console
root@debian11:~/15.1# ./go.sh init
Initializing modules...
- vm-nat-gateway in vm-instance
- vm-private in vm-instance
- vm-public in vm-instance

Initializing the backend...

Initializing provider plugins...
- Finding yandex-cloud/yandex versions matching ">= 0.70.0"...
- Installing yandex-cloud/yandex v0.85.0...
- Installed yandex-cloud/yandex v0.85.0 (unauthenticated)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

╷
│ Warning: Incomplete lock file information for providers
│
│ Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally
│ for the following providers:
│   - yandex-cloud/yandex
│
│ The current .terraform.lock.hcl file only includes checksums for linux_amd64, so Terraform running on another
│ platform will fail to install these providers.
│
│ To calculate additional checksums for another platform, run:
│   terraform providers lock -platform=linux_amd64
│ (where linux_amd64 is the platform to generate)
╵

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
root@debian11:~/15.1# ./go.sh up

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_image.os-disk will be created
  + resource "yandex_compute_image" "os-disk" {
      + created_at      = (known after apply)
      + folder_id       = (known after apply)
      + id              = (known after apply)
      + min_disk_size   = (known after apply)
      + name            = "os-disk"
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

  # yandex_vpc_network.my-net will be created
  + resource "yandex_vpc_network" "my-net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "master-network"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_route_table.rt will be created
  + resource "yandex_vpc_route_table" "rt" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "route-table"
      + network_id = (known after apply)

      + static_route {
          + destination_prefix = "0.0.0.0/0"
          + next_hop_address   = "192.168.10.254"
        }
    }

  # yandex_vpc_subnet.private-subnet will be created
  + resource "yandex_vpc_subnet" "private-subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "private"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.20.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.public-subnet will be created
  + resource "yandex_vpc_subnet" "public-subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # module.vm-nat-gateway.yandex_compute_instance.vm-instance will be created
  + resource "yandex_compute_instance" "vm-instance" {
      + created_at                = (known after apply)
      + description               = "NAT Gateway"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCIrkKsd54oCj8Nje78lSo124fTt3aX5hcqlKAdc/CD root@debian11
            EOT
        }
      + name                      = "nat-gateway"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = "ubuntu"
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd80mrhj8fl2oe87o4e1"
              + name        = (known after apply)
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options {
          + aws_v1_http_endpoint = (known after apply)
          + aws_v1_http_token    = (known after apply)
          + gce_http_endpoint    = (known after apply)
          + gce_http_token       = (known after apply)
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "192.168.10.254"
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
          + core_fraction = 5
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = false
        }
    }

  # module.vm-private.yandex_compute_instance.vm-instance will be created
  + resource "yandex_compute_instance" "vm-instance" {
      + created_at                = (known after apply)
      + description               = "Machine in private subnet"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                debian:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCIrkKsd54oCj8Nje78lSo124fTt3aX5hcqlKAdc/CD root@debian11
            EOT
        }
      + name                      = "private-vm"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = "debian"
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options {
          + aws_v1_http_endpoint = (known after apply)
          + aws_v1_http_token    = (known after apply)
          + gce_http_endpoint    = (known after apply)
          + gce_http_token       = (known after apply)
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
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
          + core_fraction = 5
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = false
        }
    }

  # module.vm-public.yandex_compute_instance.vm-instance will be created
  + resource "yandex_compute_instance" "vm-instance" {
      + created_at                = (known after apply)
      + description               = "Machine in public subnet"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                debian:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCIrkKsd54oCj8Nje78lSo124fTt3aX5hcqlKAdc/CD root@debian11
            EOT
        }
      + name                      = "public-vm"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = "debian"
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options {
          + aws_v1_http_endpoint = (known after apply)
          + aws_v1_http_token    = (known after apply)
          + gce_http_endpoint    = (known after apply)
          + gce_http_token       = (known after apply)
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
          + core_fraction = 5
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = false
        }
    }

Plan: 8 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + SSH_Bastion = (known after apply)
yandex_vpc_network.my-net: Creating...
yandex_compute_image.os-disk: Creating...
yandex_vpc_network.my-net: Creation complete after 1s [id=enpaqt0dsl5fh9tprhi0]
yandex_vpc_subnet.public-subnet: Creating...
yandex_vpc_subnet.public-subnet: Creation complete after 1s [id=e9b6p2ri862m9d7n73dr]
module.vm-nat-gateway.yandex_compute_instance.vm-instance: Creating...
yandex_compute_image.os-disk: Creation complete after 8s [id=fd8e2t8s7934493mnibd]
module.vm-public.yandex_compute_instance.vm-instance: Creating...
module.vm-nat-gateway.yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.vm-public.yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.vm-nat-gateway.yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.vm-public.yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.vm-nat-gateway.yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.vm-public.yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.vm-nat-gateway.yandex_compute_instance.vm-instance: Still creating... [40s elapsed]
module.vm-public.yandex_compute_instance.vm-instance: Still creating... [40s elapsed]
module.vm-nat-gateway.yandex_compute_instance.vm-instance: Still creating... [50s elapsed]
module.vm-public.yandex_compute_instance.vm-instance: Still creating... [50s elapsed]
module.vm-nat-gateway.yandex_compute_instance.vm-instance: Still creating... [1m0s elapsed]
module.vm-public.yandex_compute_instance.vm-instance: Creation complete after 58s [id=fhms2eskdk4jsrreknnm]
module.vm-nat-gateway.yandex_compute_instance.vm-instance: Creation complete after 1m4s [id=fhm1m6cc1gdncnh21j7m]
yandex_vpc_route_table.rt: Creating...
yandex_vpc_route_table.rt: Creation complete after 1s [id=enpvkosi2bvmvgr3jd8h]
yandex_vpc_subnet.private-subnet: Creating...
yandex_vpc_subnet.private-subnet: Creation complete after 1s [id=e9bodjioad5r5qeebtf3]
module.vm-private.yandex_compute_instance.vm-instance: Creating...
module.vm-private.yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.vm-private.yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.vm-private.yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.vm-private.yandex_compute_instance.vm-instance: Still creating... [40s elapsed]
module.vm-private.yandex_compute_instance.vm-instance: Creation complete after 46s [id=fhmqsc5sc58ed3fp15ol]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

SSH_Bastion = "ssh -J ubuntu@158.160.61.173 debian@192.168.20.4"
```

</details>

Полученная инфраструктура:

```console
SSH_Bastion = "ssh -J ubuntu@158.160.61.173 debian@192.168.20.4"
+----------------------+---------+----------------------+----------------------+---------------+-------------------+
|          ID          |  NAME   |      NETWORK ID      |    ROUTE TABLE ID    |     ZONE      |       RANGE       |
+----------------------+---------+----------------------+----------------------+---------------+-------------------+
| e9b6p2ri862m9d7n73dr | public  | enpaqt0dsl5fh9tprhi0 |                      | ru-central1-a | [192.168.10.0/24] |
| e9bodjioad5r5qeebtf3 | private | enpaqt0dsl5fh9tprhi0 | enpvkosi2bvmvgr3jd8h | ru-central1-a | [192.168.20.0/24] |
+----------------------+---------+----------------------+----------------------+---------------+-------------------+

+----------------------+-------------+---------------+---------+----------------+----------------+
|          ID          |    NAME     |    ZONE ID    | STATUS  |  EXTERNAL IP   |  INTERNAL IP   |
+----------------------+-------------+---------------+---------+----------------+----------------+
| fhm1m6cc1gdncnh21j7m | nat-gateway | ru-central1-a | RUNNING | 158.160.61.173 | 192.168.10.254 |
| fhmqsc5sc58ed3fp15ol | private-vm  | ru-central1-a | RUNNING |                | 192.168.20.4   |
| fhms2eskdk4jsrreknnm | public-vm   | ru-central1-a | RUNNING | 158.160.45.49  | 192.168.10.30  |
+----------------------+-------------+---------------+---------+----------------+----------------+
```

Для проверка доступа в интернет будет отправляться **curl** запрос к странице поисковика **Яндекс**, а именно `curl -v -s http://ya.ru`

Подключение к "машинке" в **public** подсети выполняется напрямую

```console
root@debian11:~# ssh debian@158.160.45.49 curl -v -s http://ya.ru
The authenticity of host '158.160.45.49 (158.160.45.49)' can't be established.
ECDSA key fingerprint is SHA256:8AX44WuOf+8+eOkt/RjQwbxnWX8QILqmUlScifbzzbU.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '158.160.45.49' (ECDSA) to the list of known hosts.
*   Trying 77.88.55.242:80...
* Connected to ya.ru (77.88.55.242) port 80 (#0)
> GET / HTTP/1.1
> Host: ya.ru
> User-Agent: curl/7.74.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 301 Moved permanently
< Accept-CH: Sec-CH-UA-Platform-Version, Sec-CH-UA-Mobile, Sec-CH-UA-Model, Sec-CH-UA, Sec-CH-UA-Full-Version-List, Sec-CH-UA-WoW64, Sec-CH-UA-Arch, Sec-CH-UA-Bitness, Sec-CH-UA-Platform, Sec-CH-UA-Full-Version, Viewport-Width, DPR, Device-Memory, RTT, Downlink, ECT
< Cache-Control: max-age=1209600,private
< Date: Mon, 20 Feb 2023 11:36:11 GMT
< Location: https://ya.ru/
< NEL: {"report_to": "network-errors", "max_age": 100, "success_fraction": 0.001, "failure_fraction": 0.1}
< P3P: policyref="/w3c/p3p.xml", CP="NON DSP ADM DEV PSD IVDo OUR IND STP PHY PRE NAV UNI"
< Portal: Home
< Report-To: { "group": "network-errors", "max_age": 100, "endpoints": [{"url": "https://dr.yandex.net/nel", "priority": 1}, {"url": "https://dr2.yandex.net/nel", "priority": 2}]}
< Transfer-Encoding: chunked
< X-Content-Type-Options: nosniff
< X-Yandex-Req-Id: 1676892971323258-7251319945166262769-vla1-5784-vla-l7-balancer-8080-BAL-3930
< set-cookie: is_gdpr=0; Path=/; Domain=.ya.ru; Expires=Wed, 19 Feb 2025 11:36:11 GMT
< set-cookie: is_gdpr_b=CKWxOxDepwE=; Path=/; Domain=.ya.ru; Expires=Wed, 19 Feb 2025 11:36:11 GMT
< set-cookie: _yasc=O96Pqze0HtYFG6vhajBBN6HvlTG8CK1LdPa6+QIE8gqrO0tEzXFrxvXrac+W72E=; domain=.ya.ru; path=/; expires=Thu, 17-Feb-2033 11:36:11 GMT; secure
<
{ [5 bytes data]
* Connection #0 to host ya.ru left intact
root@debian11:~#
```

Подключение к "машинке" в **private** подсети выполняется через "машинку" **NAT-Gateway** или так называемый [SSH Бастион](https://goteleport.com/blog/ssh-bastion-host/).
Смысл: подключение к машине, не имеющей прямого доступа, выполняется через промежуточное звено,
к которому можно подключиться и уже от него устанавливать связь с целевой "машиной".
Реализуется это добавлением в команду подключения ключа `-J` с указанием параметров подключения к промежуточному звену.
Шаблон подключения формируется скриптом **Terraform** и выводится после формирования инфраструктуры.

```console
root@debian11:~# ssh -J ubuntu@158.160.61.173 debian@192.168.20.4 curl -v -s http://ya.ru
The authenticity of host '158.160.61.173 (158.160.61.173)' can't be established.
ECDSA key fingerprint is SHA256:CbWCkxm5ElTib8zkIm320+HQHMy3nXjBxIMNh9+9PWU.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '158.160.61.173' (ECDSA) to the list of known hosts.
The authenticity of host '192.168.20.4 (<no hostip for proxy command>)' can't be established.
ECDSA key fingerprint is SHA256:1wXm5R3V2m5ag/VC8M44n0AqDBc1lI1vfxHw4BwkbMU.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.20.4' (ECDSA) to the list of known hosts.
*   Trying 77.88.55.242:80...
* Connected to ya.ru (77.88.55.242) port 80 (#0)
> GET / HTTP/1.1
> Host: ya.ru
> User-Agent: curl/7.74.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 301 Moved permanently
< Accept-CH: Sec-CH-UA-Platform-Version, Sec-CH-UA-Mobile, Sec-CH-UA-Model, Sec-CH-UA, Sec-CH-UA-Full-Version-List, Sec-CH-UA-WoW64, Sec-CH-UA-Arch, Sec-CH-UA-Bitness, Sec-CH-UA-Platform, Sec-CH-UA-Full-Version, Viewport-Width, DPR, Device-Memory, RTT, Downlink, ECT
< Cache-Control: max-age=1209600,private
< Date: Mon, 20 Feb 2023 11:48:05 GMT
< Location: https://ya.ru/
< NEL: {"report_to": "network-errors", "max_age": 100, "success_fraction": 0.001, "failure_fraction": 0.1}
< P3P: policyref="/w3c/p3p.xml", CP="NON DSP ADM DEV PSD IVDo OUR IND STP PHY PRE NAV UNI"
< Portal: Home
< Report-To: { "group": "network-errors", "max_age": 100, "endpoints": [{"url": "https://dr.yandex.net/nel", "priority": 1}, {"url": "https://dr2.yandex.net/nel", "priority": 2}]}
< Transfer-Encoding: chunked
< X-Content-Type-Options: nosniff
< X-Yandex-Req-Id: 1676893685793489-16765112437140566434-vla1-5154-vla-l7-balancer-8080-BAL-5047
< set-cookie: is_gdpr=0; Path=/; Domain=.ya.ru; Expires=Wed, 19 Feb 2025 11:48:05 GMT
< set-cookie: is_gdpr_b=CKWxOxDepwE=; Path=/; Domain=.ya.ru; Expires=Wed, 19 Feb 2025 11:48:05 GMT
< set-cookie: _yasc=LbktEwMQD/62UQ2dcCkIn98c7ipCfmclcGxbCVIrjRgjA9gxN6dPeWcnYYan9w==; domain=.ya.ru; path=/; expires=Thu, 17-Feb-2033 11:48:05 GMT; secure
<
{ [5 bytes data]
* Connection #0 to host ya.ru left intact
root@debian11:~#
```
---

<details>
<summary><strike>Задание 2*. AWS (необязательное к выполнению)</strike></summary>

1. Создать VPC.
- Cоздать пустую VPC с подсетью 10.10.0.0/16.
2. Публичная подсеть.
- Создать в vpc subnet с названием public, сетью 10.10.1.0/24
- Разрешить в данной subnet присвоение public IP по-умолчанию. 
- Создать Internet gateway 
- Добавить в таблицу маршрутизации маршрут, направляющий весь исходящий трафик в Internet gateway.
- Создать security group с разрешающими правилами на SSH и ICMP. Привязать данную security-group на все создаваемые в данном ДЗ виртуалки
- Создать в этой подсети виртуалку и убедиться, что инстанс имеет публичный IP. Подключиться к ней, убедиться что есть доступ к интернету.
- Добавить NAT gateway в public subnet.
3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 10.10.2.0/24
- Создать отдельную таблицу маршрутизации и привязать ее к private-подсети
- Добавить Route, направляющий весь исходящий трафик private сети в NAT.
- Создать виртуалку в приватной сети.
- Подключиться к ней по SSH по приватному IP через виртуалку, созданную ранее в публичной подсети и убедиться, что с виртуалки есть выход в интернет.

Resource terraform
- [VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- [Internet Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)

</details>

---

<details>
<summary><strike>Задание 2*. AWS (необязательное к выполнению)</strike></summary>

1. Создать VPC.
- Cоздать пустую VPC с подсетью 10.10.0.0/16.
2. Публичная подсеть.
- Создать в vpc subnet с названием public, сетью 10.10.1.0/24
- Разрешить в данной subnet присвоение public IP по-умолчанию. 
- Создать Internet gateway 
- Добавить в таблицу маршрутизации маршрут, направляющий весь исходящий трафик в Internet gateway.
- Создать security group с разрешающими правилами на SSH и ICMP. Привязать данную security-group на все создаваемые в данном ДЗ виртуалки
- Создать в этой подсети виртуалку и убедиться, что инстанс имеет публичный IP. Подключиться к ней, убедиться что есть доступ к интернету.
- Добавить NAT gateway в public subnet.
3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 10.10.2.0/24
- Создать отдельную таблицу маршрутизации и привязать ее к private-подсети
- Добавить Route, направляющий весь исходящий трафик private сети в NAT.
- Создать виртуалку в приватной сети.
- Подключиться к ней по SSH по приватному IP через виртуалку, созданную ранее в публичной подсети и убедиться, что с виртуалки есть выход в интернет.

Resource terraform
- [VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- [Internet Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)

</details>

---

## Дополнительные материалы

Документация Яндекс: [Настроить NAT-шлюз](https://cloud.yandex.ru/docs/vpc/operations/create-nat-gateway)

Документация [Yandex.Cloud Provider](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs)

Документация по [Proxies and Jump Hosts](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts)

Статья [Setting Up an SSH Bastion Host](https://goteleport.com/blog/ssh-bastion-host/)
