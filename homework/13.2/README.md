# Домашнее задание по лекции "13.2 разделы и монтирование"

> Приложение запущено и работает, но время от времени появляется необходимость передавать между бекендами данные.
> А сам бекенд генерирует статику для фронта. Нужно оптимизировать это.
> Для настройки **NFS** сервера можно воспользоваться следующей инструкцией (производить под пользователем на сервере, у которого есть доступ до **kubectl**):
> * установить **helm**: `curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash`
> * добавить репозиторий чартов: `helm repo add stable https://charts.helm.sh/stable && helm repo update`
> * установить **nfs-server** через **helm**: `helm install nfs-server stable/nfs-server-provisioner`
> В конце установки будет выдан пример создания PVC для этого сервера.

<details>
<summary>Подготовка инфраструктуры :</summary>

Для создания инфраструктуры использовались вспомогательные скрипты из предыдущего задания [13.1](https://github.com/ArtemShtepa/devops-netology/tree/homework-13.1/homework/13.1/src).
Число **worker** нод увеличено до 3 для того, чтобы **pod** **frontend** и **backend** разместились на разных "машинках".

```console
root@debian11:~/13.2# ./go.sh init
Initializing modules...
- kube-master in vm-instance
- kube-worker in vm-instance

Initializing the backend...

Initializing provider plugins...
- Finding yandex-cloud/yandex versions matching ">= 0.70.0"...
- Installing yandex-cloud/yandex v0.84.0...
- Installed yandex-cloud/yandex v0.84.0 (unauthenticated)

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
root@debian11:~/13.2# ./go.sh up

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

  # module.kube-master.yandex_compute_instance.vm-instance will be created
  + resource "yandex_compute_instance" "vm-instance" {
      + created_at                = (known after apply)
      + description               = "Master Node"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                debian:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGL4/7B+iUs1V4KPwdkyuz8L+O4UKiihDk60moD41SS2 root@debian11
            EOT
        }
      + name                      = "kube-master-1"
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
          + preemptible = true
        }
    }

  # module.kube-worker[0].yandex_compute_instance.vm-instance will be created
  + resource "yandex_compute_instance" "vm-instance" {
      + created_at                = (known after apply)
      + description               = "Worker Node 1"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                debian:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGL4/7B+iUs1V4KPwdkyuz8L+O4UKiihDk60moD41SS2 root@debian11
            EOT
        }
      + name                      = "kube-worker-1"
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
          + preemptible = true
        }
    }

  # module.kube-worker[1].yandex_compute_instance.vm-instance will be created
  + resource "yandex_compute_instance" "vm-instance" {
      + created_at                = (known after apply)
      + description               = "Worker Node 2"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                debian:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGL4/7B+iUs1V4KPwdkyuz8L+O4UKiihDk60moD41SS2 root@debian11
            EOT
        }
      + name                      = "kube-worker-2"
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
          + preemptible = true
        }
    }

  # module.kube-worker[2].yandex_compute_instance.vm-instance will be created
  + resource "yandex_compute_instance" "vm-instance" {
      + created_at                = (known after apply)
      + description               = "Worker Node 3"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                debian:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGL4/7B+iUs1V4KPwdkyuz8L+O4UKiihDk60moD41SS2 root@debian11
            EOT
        }
      + name                      = "kube-worker-3"
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
          + preemptible = true
        }
    }

Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + master_internal_ip = (known after apply)
  + master_ip          = (known after apply)
  + worker_internal_ip = [
      + (known after apply),
      + (known after apply),
      + (known after apply),
    ]
  + worker_ip          = [
      + (known after apply),
      + (known after apply),
      + (known after apply),
    ]
yandex_vpc_network.my-net: Creating...
yandex_compute_image.os-disk: Creating...
yandex_vpc_network.my-net: Creation complete after 1s [id=enpgiprp0nqeg9iuv5se]
yandex_vpc_subnet.my-subnet: Creating...
yandex_vpc_subnet.my-subnet: Creation complete after 1s [id=e9b4nq2h6oqiradccado]
yandex_compute_image.os-disk: Creation complete after 7s [id=fd85p5ibnpbkc6bur51a]
module.kube-worker[2].yandex_compute_instance.vm-instance: Creating...
module.kube-worker[1].yandex_compute_instance.vm-instance: Creating...
module.kube-master.yandex_compute_instance.vm-instance: Creating...
module.kube-worker[0].yandex_compute_instance.vm-instance: Creating...
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-master.yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-master.yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.kube-master.yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Creation complete after 32s [id=fhmq8lutl01i12ehd57m]
module.kube-worker[2].yandex_compute_instance.vm-instance: Creation complete after 34s [id=fhmqsbutp8d34qo5lmge]
module.kube-master.yandex_compute_instance.vm-instance: Still creating... [40s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [40s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [50s elapsed]
module.kube-master.yandex_compute_instance.vm-instance: Still creating... [50s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Creation complete after 51s [id=fhmqgdfl1do3ctuffbbu]
module.kube-master.yandex_compute_instance.vm-instance: Creation complete after 53s [id=fhmnmpgv9no6sqjlu3s2]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

master_internal_ip = "10.2.0.7"
master_ip = "158.160.49.153"
worker_internal_ip = [
  "10.2.0.8",
  "10.2.0.29",
  "10.2.0.13",
]
worker_ip = [
  "158.160.44.136",
  "158.160.46.132",
  "158.160.37.212",
]
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match
'all'

PLAY [Generate dynamic inventory] **************************************************************************************

TASK [Get instances from Yandex.Cloud CLI] *****************************************************************************
ok: [localhost]

TASK [Set instances to facts] ******************************************************************************************
ok: [localhost]

TASK [Add instances IP to hosts] ***************************************************************************************
ok: [localhost] => (item={'id': 'fhmnmpgv9no6sqjlu3s2', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2023-01-02T16:22:59Z', 'name': 'kube-master-1', 'description': 'Master Node', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhm0g7l2031tb0e5curo'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:17:b6:61:f4', 'subnet_id': 'e9b4nq2h6oqiradccado', 'primary_v4_address': {'address': '10.2.0.7', 'one_to_one_nat': {'address': '158.160.49.153', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhmnmpgv9no6sqjlu3s2.auto.internal', 'scheduling_policy': {'preemptible': True}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})
ok: [localhost] => (item={'id': 'fhmq8lutl01i12ehd57m', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2023-01-02T16:22:59Z', 'name': 'kube-worker-2', 'description': 'Worker Node 2', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhmb7opu3bkl6m965vgp'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:1a:45:7d:da', 'subnet_id': 'e9b4nq2h6oqiradccado', 'primary_v4_address': {'address': '10.2.0.29', 'one_to_one_nat': {'address': '158.160.46.132', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhmq8lutl01i12ehd57m.auto.internal', 'scheduling_policy': {'preemptible': True}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})
ok: [localhost] => (item={'id': 'fhmqgdfl1do3ctuffbbu', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2023-01-02T16:22:59Z', 'name': 'kube-worker-1', 'description': 'Worker Node 1', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhmi1t4vct0lqgfh96ts'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:1a:83:5f:50', 'subnet_id': 'e9b4nq2h6oqiradccado', 'primary_v4_address': {'address': '10.2.0.8', 'one_to_one_nat': {'address': '158.160.44.136', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhmqgdfl1do3ctuffbbu.auto.internal', 'scheduling_policy': {'preemptible': True}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})
ok: [localhost] => (item={'id': 'fhmqsbutp8d34qo5lmge', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2023-01-02T16:22:59Z', 'name': 'kube-worker-3', 'description': 'Worker Node 3', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhmpi9ibphfs2ae3opbr'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:1a:e2:fd:dc', 'subnet_id': 'e9b4nq2h6oqiradccado', 'primary_v4_address': {'address': '10.2.0.13', 'one_to_one_nat': {'address': '158.160.37.212', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhmqsbutp8d34qo5lmge.auto.internal', 'scheduling_policy': {'preemptible': True}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})

TASK [Check instance count] ********************************************************************************************
ok: [localhost] => {
    "msg": "Total instance count: 4"
}

PLAY [Approve SSH fingerprint] *****************************************************************************************

TASK [Check known_hosts for] *******************************************************************************************
ok: [kube-master-1 -> localhost]
ok: [kube-worker-1 -> localhost]
ok: [kube-worker-2 -> localhost]
ok: [kube-worker-3 -> localhost]

TASK [Skip question for adding host key] *******************************************************************************
ok: [kube-master-1]
ok: [kube-worker-2]
ok: [kube-worker-1]
ok: [kube-worker-3]

TASK [Wait for instances ready] ****************************************************************************************
ok: [kube-worker-3 -> localhost]
ok: [kube-worker-2 -> localhost]
ok: [kube-worker-1 -> localhost]
ok: [kube-master-1 -> localhost]

TASK [Add SSH fingerprint to known host] *******************************************************************************
ok: [kube-worker-3]
ok: [kube-worker-2]
ok: [kube-worker-1]
ok: [kube-master-1]

PLAY RECAP *************************************************************************************************************
kube-master-1              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
kube-worker-1              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
kube-worker-2              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
kube-worker-3              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

+----------------------+---------------+---------------+---------+----------------+-------------+
|          ID          |     NAME      |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+---------------+---------------+---------+----------------+-------------+
| fhmnmpgv9no6sqjlu3s2 | kube-master-1 | ru-central1-a | RUNNING | 158.160.49.153 | 10.2.0.7    |
| fhmq8lutl01i12ehd57m | kube-worker-2 | ru-central1-a | RUNNING | 158.160.46.132 | 10.2.0.29   |
| fhmqgdfl1do3ctuffbbu | kube-worker-1 | ru-central1-a | RUNNING | 158.160.44.136 | 10.2.0.8    |
| fhmqsbutp8d34qo5lmge | kube-worker-3 | ru-central1-a | RUNNING | 158.160.37.212 | 10.2.0.13   |
+----------------------+---------------+---------------+---------+----------------+-------------+

Don't forget to add Master Node IP address to 'supplementary_addresses_in_ssl_keys'
  list of file 'group_vars/k8s_cluster/k8s_cluster.yml'
root@debian11:~/13.2#
```

Установка **Helm** и **NFS** сервера:

```console
root@debian11:~/13.2/kubespray# curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 11345  100 11345    0     0  96965      0 --:--:-- --:--:-- --:--:-- 96965
Downloading https://get.helm.sh/helm-v3.10.3-linux-amd64.tar.gz
Verifying checksum... Done.
Preparing to install helm into /usr/local/bin
helm installed into /usr/local/bin/helm
root@debian11:~/13.2/kubespray# helm version
version.BuildInfo{Version:"v3.10.3", GitCommit:"835b7334cfe2e5e27870ab3ed4135f136eecc704", GitTreeState:"clean", GoVersion:"go1.18.9"}
root@debian11:~/13.2/kubespray# helm repo add stable https://charts.helm.sh/stable && helm repo update
"stable" has been added to your repositories
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈
root@debian11:~/13.2/kubespray# helm install nfs-server stable/nfs-server-provisioner
WARNING: This chart is deprecated
NAME: nfs-server
LAST DEPLOYED: Mon Jan  2 14:19:53 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The NFS Provisioner service has now been installed.

A storage class named 'nfs' has now been created
and is available to provision dynamic volumes.

You can use this storageclass by creating a `PersistentVolumeClaim` with the
correct storageClassName attribute. For example:

    ---
    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
      name: test-dynamic-volume-claim
    spec:
      storageClassName: "nfs"
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 100Mi
root@debian11:~/13.2# kubectl get sc
NAME   PROVISIONER                                       RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
nfs    cluster.local/nfs-server-nfs-server-provisioner   Delete          Immediate           true                   3m40s
root@debian11:~/13.2#
```

Дополнительно на все ноды был установлен пакет `nfs-common`

</details>

---

## Задание 1: подключить для тестового конфига общую папку

> В **stage** окружении часто возникает необходимость отдавать статику бекенда сразу фронтом.
> Проще всего сделать это через общую папку. Требования:
> * в поде подключена общая папка между контейнерами (например, `/static`);
> * после записи чего-либо в контейнере с беком файлы можно получить из контейнера с фронтом.

Для реализации общей папки между контейнерами одного **pod** используется сущность хранения типа [EmptyDir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir).
Создаётся путём указания одноимённой точки монтирования (`volumeMounts`->`mountPath`) для каждого контейнера, а также её описание на уровне **pod** (`volumes`) с указанием типа `emptyDir: {}`.
Особенность - данные пропадают после перезапуска **pod**.

### Манифест создания **pod**, содержащего два контейнера с общей директорией: ([файл](./manifests/stage-app.yml))

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: testapp
  name: testapp
  namespace: stage
spec:
  replicas: 1
  selector:
    matchLabels:
      app: testapp
  template:
    metadata:
      labels:
        app: testapp
    spec:
      containers:
        - name: frontend
          image: artemshtepa/netology-app:frontend
          imagePullPolicy: IfNotPresent
          ports:
            - name: frontend-port
              containerPort: 80
              protocol: TCP
          volumeMounts:
            - mountPath: "/static"
              name: tmp-volume
        - name: backend
          image: artemshtepa/netology-app:backend
          imagePullPolicy: IfNotPresent
          ports:
            - name: backend-port
              containerPort: 9000
              protocol: TCP
          volumeMounts:
            - mountPath: "/tmp/cache"
              name: tmp-volume
      volumes:
        - name: tmp-volume
          emptyDir: {}
```

<details>
<summary>Применение конфигурации и запрос описания <b>pod</b></summary>

```console
root@debian11:~/13.2# kubectl create ns stage
namespace/stage created
root@debian11:~/13.2# kubectl config set-context --current --namespace=stage
Context "kubernetes-admin@cluster.local" modified.
root@debian11:~/13.2# kubectl apply -f manifests/stage-app.yml
deployment.apps/testapp created
root@debian11:~/13.2# kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
testapp-6fdb79b97-mql99   2/2     Running   0          8s
root@debian11:~/13.2# kubectl describe pods/testapp-6fdb79b97-mql99
Name:             testapp-6fdb79b97-mql99
Namespace:        stage
Priority:         0
Service Account:  default
Node:             node2/10.2.0.8
Start Time:       Mon, 02 Jan 2023 15:44:29 -0500
Labels:           app=testapp
                  pod-template-hash=6fdb79b97
Annotations:      cni.projectcalico.org/containerID: bb0c1d6eb379129096ea73ca0c9bb3863c6d27ab6213a9f0fb3fa467aa39d845
                  cni.projectcalico.org/podIP: 10.233.75.3/32
                  cni.projectcalico.org/podIPs: 10.233.75.3/32
Status:           Running
IP:               10.233.75.3
IPs:
  IP:           10.233.75.3
Controlled By:  ReplicaSet/testapp-6fdb79b97
Containers:
  frontend:
    Container ID:   containerd://3df3ed73b932d0f5cd3b2efd3a4c4784e1d0128ba91eb298d0d8b0daa0364492
    Image:          artemshtepa/netology-app:frontend
    Image ID:       docker.io/artemshtepa/netology-app@sha256:d9599188343850f2af33d4ea0857819f8aea0f31165c6e48c0a8da9baf9e2a71
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 02 Jan 2023 15:44:32 -0500
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /static from tmp-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-6jdbb (ro)
  backend:
    Container ID:   containerd://1eb5f4f295ead0a4cc1e6d6234882688c12dba224775fbce39ea1c4b8747eb62
    Image:          artemshtepa/netology-app:backend
    Image ID:       docker.io/artemshtepa/netology-app@sha256:de7388f1f95a8c4b9562ab75550c6ffc7efd7e1f243cb8bac1104332237b42c0
    Port:           9000/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 02 Jan 2023 15:44:33 -0500
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /tmp/cache from tmp-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-6jdbb (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  tmp-volume:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:
    SizeLimit:  <unset>
  kube-api-access-6jdbb:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  3m47s  default-scheduler  Successfully assigned stage/testapp-6fdb79b97-mql99 to node2
  Normal  Pulled     3m44s  kubelet            Container image "artemshtepa/netology-app:frontend" already present on machine
  Normal  Created    3m44s  kubelet            Created container frontend
  Normal  Started    3m44s  kubelet            Started container frontend
  Normal  Pulled     3m44s  kubelet            Container image "artemshtepa/netology-app:backend" already present on machine
  Normal  Created    3m44s  kubelet            Created container backend
  Normal  Started    3m43s  kubelet            Started container backend
root@debian11:~/13.2#
```

</details>

### Проверка функционирования общей директории

Создание файла и наполнение содержимым в контейнере **backend**:

```console
root@debian11:~/13.2# kubectl exec testapp-6fdb79b97-mql99 -c backend -- bash -c "echo 'test line1'>/tmp/cache/one.txt"
root@debian11:~/13.2#
```

Чтение файла из контейнера **frontend**:

```console
root@debian11:~/13.2# kubectl exec testapp-6fdb79b97-mql99 -c frontend -- bash -c "ls /static/"
one.txt
root@debian11:~/13.2# kubectl exec testapp-6fdb79b97-mql99 -c frontend -- bash -c "cat /static/one.txt"
test line1
root@debian11:~/13.2#
```

---

## Задание 2: подключить общую папку для прода

> Поработав на **stage**, доработки нужно отправить на прод.
> В **production** у нас контейнеры крутятся в разных подах, поэтому потребуется **PV** и связь через **PVC**.
> Сам **PV** должен быть связан с **NFS** сервером. Требования:
> * все бекенды подключаются к одному **PV** в режиме `ReadWriteMany`;
> * фронтенды тоже подключаются к этому же **PV** с таким же режимом;
> * файлы, созданные бекендом, должны быть доступны фронту.

**PersistentVolume** будет создаваться динамически **provisioner** **NFS** сервера.

Распределение пространства будет выполняться через запрос **PersistentVolumeClaim** следующим [файлом](./manifests/pvc.yml) манифеста:

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: dynamic-volume-claim
spec:
  storageClassName: "nfs"
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
```

Использование общего пространства указывается точкой монтирования (`volumeMounts`->`mountPath`) в контейнере и на уровне пода с указанием **PVC** (`volumes`->`persistentVolumeClaim`)

### Манифест создания **frontend**: ([файл](./manifests/prod-frontend.yml))

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: frontend
  name: frontend
  namespace: production
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: frontend
          image: artemshtepa/netology-app:frontend
          imagePullPolicy: IfNotPresent
          env:
            - name: BASE_URL
              value: http://backend-svc:9000
          ports:
            - name: frontend-port
              containerPort: 80
              protocol: TCP
          volumeMounts:
            - mountPath: "/databank"
              name: nfs-storage
      volumes:
        - name: nfs-storage
          persistentVolumeClaim:
            claimName: dynamic-volume-claim
```

### Манифест создания **backend**: ([файл](./manifests/prod-backend.yml))

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: backend
  name: backend
  namespace: production
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
        - name: backend
          image: artemshtepa/netology-app:backend
          imagePullPolicy: IfNotPresent
          env:
            - name: DATABASE_URL
              value: "postgresql://postgres:postgres@db-svc:5432/news"
          ports:
            - name: backend-port
              containerPort: 9000
              protocol: TCP
          volumeMounts:
            - mountPath: "/databank"
              name: nfs-storage
      volumes:
        - name: nfs-storage
          persistentVolumeClaim:
            claimName: dynamic-volume-claim
```

<details>
<summary>Применение конфигурации и запрос описания <b>pod</b></summary>

```console
root@debian11:~/13.2# kubectl create ns stage
namespace/stage created
root@debian11:~/13.2# kubectl config set-context --current --namespace=stage
Context "kubernetes-admin@cluster.local" modified.
root@debian11:~/13.2# kubectl apply -f manifests/pvc.yml
persistentvolumeclaim/dynamic-volume-claim created
root@debian11:~/13.2# kubectl apply -f manifests/prod-frontend.yml
deployment.apps/frontend created
root@debian11:~/13.2# kubectl apply -f manifests/prod-backend.yml
deployment.apps/backend created
root@debian11:~/13.2# kubectl get pods -o wide
NAME                       READY   STATUS    RESTARTS   AGE     IP             NODE    NOMINATED NODE   READINESS GATES
backend-5555d6c99b-v2686   1/1     Running   0          3m19s   10.233.74.68   node4   <none>           <none>
frontend-fbb6c4f74-6c5ds   1/1     Running   0          3m24s   10.233.75.4    node2   <none>           <none>
root@debian11:~/13.2# kubectl describe pods/frontend-fbb6c4f74-6c5ds
Name:             frontend-fbb6c4f74-6c5ds
Namespace:        production
Priority:         0
Service Account:  default
Node:             node2/10.2.0.8
Start Time:       Mon, 02 Jan 2023 17:03:14 -0500
Labels:           app=frontend
                  pod-template-hash=fbb6c4f74
Annotations:      cni.projectcalico.org/containerID: bf9f4525c1433e49a000ce4bc667ab54b063d0554b900919867ba41182e37291
                  cni.projectcalico.org/podIP: 10.233.75.4/32
                  cni.projectcalico.org/podIPs: 10.233.75.4/32
Status:           Running
IP:               10.233.75.4
IPs:
  IP:           10.233.75.4
Controlled By:  ReplicaSet/frontend-fbb6c4f74
Containers:
  frontend:
    Container ID:   containerd://26a388492b9c17220b60881d13bddeddfd8dc90e53c59228619db1d6f09b5793
    Image:          artemshtepa/netology-app:frontend
    Image ID:       docker.io/artemshtepa/netology-app@sha256:d9599188343850f2af33d4ea0857819f8aea0f31165c6e48c0a8da9baf9e2a71
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 02 Jan 2023 17:03:19 -0500
    Ready:          True
    Restart Count:  0
    Environment:
      BASE_URL:  http://backend-svc:9000
    Mounts:
      /databank from nfs-storage (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-k2dtd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  nfs-storage:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  dynamic-volume-claim
    ReadOnly:   false
  kube-api-access-k2dtd:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  4m25s  default-scheduler  Successfully assigned production/frontend-fbb6c4f74-6c5ds to node2
  Normal  Pulled     4m20s  kubelet            Container image "artemshtepa/netology-app:frontend" already present on machine
  Normal  Created    4m20s  kubelet            Created container frontend
  Normal  Started    4m20s  kubelet            Started container frontend
root@debian11:~/13.2# kubectl describe pods/backend-5555d6c99b-v2686
Name:             backend-5555d6c99b-v2686
Namespace:        production
Priority:         0
Service Account:  default
Node:             node4/10.2.0.13
Start Time:       Mon, 02 Jan 2023 17:03:19 -0500
Labels:           app=backend
                  pod-template-hash=5555d6c99b
Annotations:      cni.projectcalico.org/containerID: 13522f733aca5fa085141a600f87ecd310ed6ea84e5e9133b9ee100765858a77
                  cni.projectcalico.org/podIP: 10.233.74.68/32
                  cni.projectcalico.org/podIPs: 10.233.74.68/32
Status:           Running
IP:               10.233.74.68
IPs:
  IP:           10.233.74.68
Controlled By:  ReplicaSet/backend-5555d6c99b
Containers:
  backend:
    Container ID:   containerd://17240a2bceb584e5d807451172156db3affdee9af4b81388a5fa8addc74ee89b
    Image:          artemshtepa/netology-app:backend
    Image ID:       docker.io/artemshtepa/netology-app@sha256:de7388f1f95a8c4b9562ab75550c6ffc7efd7e1f243cb8bac1104332237b42c0
    Port:           9000/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 02 Jan 2023 17:04:47 -0500
    Ready:          True
    Restart Count:  0
    Environment:
      DATABASE_URL:  postgresql://postgres:postgres@db-svc:5432/news
    Mounts:
      /databank from nfs-storage (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-zr8fc (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  nfs-storage:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  dynamic-volume-claim
    ReadOnly:   false
  kube-api-access-zr8fc:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  5m3s   default-scheduler  Successfully assigned production/backend-5555d6c99b-v2686 to node4
  Normal  Pulling    5m1s   kubelet            Pulling image "artemshtepa/netology-app:backend"
  Normal  Pulled     3m38s  kubelet            Successfully pulled image "artemshtepa/netology-app:backend" in 1m22.962363457s
  Normal  Created    3m37s  kubelet            Created container backend
  Normal  Started    3m36s  kubelet            Started container backend
root@debian11:~/13.2#
```

</details>

### Проверка функционирования общего пространства

Статус подключения общего пространства:

```console
root@debian11:~/13.2# kubectl get pvc,pv
NAME                                         STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/dynamic-volume-claim   Bound    pvc-eb587a99-171b-4748-9eb8-9bbb33a7e285   1Gi        RWX            nfs            21m

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                             STORAGECLASS   REASON   AGE
persistentvolume/pvc-eb587a99-171b-4748-9eb8-9bbb33a7e285   1Gi        RWX            Delete           Bound    production/dynamic-volume-claim   nfs                     21m
root@debian11:~/13.2#
```

Имеющиеся **pods** размещены на двух разных нодах (`node2` и `node4`):

```console
root@debian11:~/13.2# kubectl get pods -o wide
NAME                       READY   STATUS    RESTARTS   AGE     IP             NODE    NOMINATED NODE   READINESS GATES
backend-5555d6c99b-v2686   1/1     Running   0          7m18s   10.233.74.68   node4   <none>           <none>
frontend-fbb6c4f74-6c5ds   1/1     Running   0          7m23s   10.233.75.4    node2   <none>           <none>
root@debian11:~/13.2#
```

Создание файла и наполнение содержимым в **pod** **backend**:

```console
root@debian11:~/13.2# kubectl exec backend-5555d6c99b-v2686 -- bash -c "echo 'test line2'>/databank/two.txt"
root@debian11:~/13.2#
```

Чтение файла из **pod** **frontend**:

```console
root@debian11:~/13.2# kubectl exec frontend-fbb6c4f74-6c5ds -- bash -c "ls /databank/"
two.txt
root@debian11:~/13.2# kubectl exec frontend-fbb6c4f74-6c5ds -- bash -c "cat /databank/two.txt"
test line2
root@debian11:~/13.2#
```
