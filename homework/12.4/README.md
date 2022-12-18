# Домашнее задание по лекции "12.4 Развертывание кластера на собственных серверах, лекция 2"

> Новые проекты пошли стабильным потоком.
> Каждый проект требует себе несколько кластеров: под тесты и продуктив.
> Делать все руками — не вариант, поэтому стоит автоматизировать подготовку новых кластеров.

Инфраструктура будет создаваться при помощи провайдера Яндекс.Облака для **Terraform**.
Команды подготовки, разворачивания и уничтожения вынесены в командный файл [go.sh](./src/go.sh)

<details>
<summary>Подготовка инфраструктуры :</summary>

```console
root@debian11:~/12.4# ./go.sh init
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
root@debian11:~/12.4# ./go.sh up

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

  # module.kube-worker[3].yandex_compute_instance.vm-instance will be created
  + resource "yandex_compute_instance" "vm-instance" {
      + created_at                = (known after apply)
      + description               = "Worker Node 4"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                debian:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGL4/7B+iUs1V4KPwdkyuz8L+O4UKiihDk60moD41SS2 root@debian11
            EOT
        }
      + name                      = "kube-worker-4"
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

Plan: 8 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + master_internal_ip = (known after apply)
  + master_ip          = (known after apply)
  + worker_internal_ip = [
      + (known after apply),
      + (known after apply),
      + (known after apply),
      + (known after apply),
    ]
  + worker_ip          = [
      + (known after apply),
      + (known after apply),
      + (known after apply),
      + (known after apply),
    ]
yandex_vpc_network.my-net: Creating...
yandex_compute_image.os-disk: Creating...
yandex_vpc_network.my-net: Creation complete after 1s [id=enptf4c9j3sj3st3qia3]
yandex_vpc_subnet.my-subnet: Creating...
yandex_vpc_subnet.my-subnet: Creation complete after 1s [id=e9b44ogsqlganttj5th5]
yandex_compute_image.os-disk: Creation complete after 6s [id=fd8f1f3b3vfjukgi6ph5]
module.kube-worker[0].yandex_compute_instance.vm-instance: Creating...
module.kube-worker[1].yandex_compute_instance.vm-instance: Creating...
module.kube-master.yandex_compute_instance.vm-instance: Creating...
module.kube-worker[3].yandex_compute_instance.vm-instance: Creating...
module.kube-worker[2].yandex_compute_instance.vm-instance: Creating...
module.kube-master.yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[3].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-master.yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[3].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [31s elapsed]
module.kube-worker[3].yandex_compute_instance.vm-instance: Still creating... [31s elapsed]
module.kube-master.yandex_compute_instance.vm-instance: Still creating... [31s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [31s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [31s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [41s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [41s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [41s elapsed]
module.kube-master.yandex_compute_instance.vm-instance: Still creating... [41s elapsed]
module.kube-worker[3].yandex_compute_instance.vm-instance: Still creating... [41s elapsed]
module.kube-master.yandex_compute_instance.vm-instance: Still creating... [51s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [51s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [51s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [51s elapsed]
module.kube-worker[3].yandex_compute_instance.vm-instance: Still creating... [51s elapsed]
module.kube-master.yandex_compute_instance.vm-instance: Creation complete after 57s [id=fhmq8q81v6i9b4h2e7o7]
module.kube-worker[0].yandex_compute_instance.vm-instance: Creation complete after 57s [id=fhm8831tmjdq5mfb7nk9]
module.kube-worker[2].yandex_compute_instance.vm-instance: Creation complete after 59s [id=fhm2hl5jlrmlii99fpj5]
module.kube-worker[3].yandex_compute_instance.vm-instance: Still creating... [1m1s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [1m1s elapsed]
module.kube-worker[3].yandex_compute_instance.vm-instance: Creation complete after 1m1s [id=fhmor1u82mmk9n0vmt3p]
module.kube-worker[1].yandex_compute_instance.vm-instance: Creation complete after 1m2s [id=fhmgc0imomih9kv7in79]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

master_internal_ip = "10.2.0.36"
master_ip = "51.250.81.181"
worker_internal_ip = [
  "10.2.0.13",
  "10.2.0.14",
  "10.2.0.8",
  "10.2.0.32",
]
worker_ip = [
  "62.84.113.91",
  "51.250.73.81",
  "51.250.82.94",
  "51.250.87.70",
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
ok: [localhost] => (item={'id': 'fhm2hl5jlrmlii99fpj5', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2022-12-18T08:59:13Z', 'name': 'kube-worker-3', 'description': 'Worker Node 3', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhm5ko805p3pgvhak78d'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:28:d4:b3:ae', 'subnet_id': 'e9b44ogsqlganttj5th5', 'primary_v4_address': {'address': '10.2.0.8', 'one_to_one_nat': {'address': '51.250.82.94', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhm2hl5jlrmlii99fpj5.auto.internal', 'scheduling_policy': {'preemptible': True}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})
ok: [localhost] => (item={'id': 'fhm8831tmjdq5mfb7nk9', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2022-12-18T08:59:12Z', 'name': 'kube-worker-1', 'description': 'Worker Node 1', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhm34cuqgrse41u976rn'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:84:0c:3d:b4', 'subnet_id': 'e9b44ogsqlganttj5th5', 'primary_v4_address': {'address': '10.2.0.13', 'one_to_one_nat': {'address': '62.84.113.91', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhm8831tmjdq5mfb7nk9.auto.internal', 'scheduling_policy': {'preemptible': True}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})
ok: [localhost] => (item={'id': 'fhmgc0imomih9kv7in79', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2022-12-18T08:59:12Z', 'name': 'kube-worker-2', 'description': 'Worker Node 2', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhmh5ftrmuv8nmnncq64'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:10:60:25:6c', 'subnet_id': 'e9b44ogsqlganttj5th5', 'primary_v4_address': {'address': '10.2.0.14', 'one_to_one_nat': {'address': '51.250.73.81', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhmgc0imomih9kv7in79.auto.internal', 'scheduling_policy': {'preemptible': True}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})
ok: [localhost] => (item={'id': 'fhmor1u82mmk9n0vmt3p', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2022-12-18T08:59:12Z', 'name': 'kube-worker-4', 'description': 'Worker Node 4', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhmotdqddkp75h23pm6d'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:18:d8:7c:81', 'subnet_id': 'e9b44ogsqlganttj5th5', 'primary_v4_address': {'address': '10.2.0.32', 'one_to_one_nat': {'address': '51.250.87.70', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhmor1u82mmk9n0vmt3p.auto.internal', 'scheduling_policy': {'preemptible': True}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})
ok: [localhost] => (item={'id': 'fhmq8q81v6i9b4h2e7o7', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2022-12-18T08:59:12Z', 'name': 'kube-master-1', 'description': 'Master Node', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhmionk7kg3ogpe7qpdm'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:1a:46:90:1f', 'subnet_id': 'e9b44ogsqlganttj5th5', 'primary_v4_address': {'address': '10.2.0.36', 'one_to_one_nat': {'address': '51.250.81.181', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhmq8q81v6i9b4h2e7o7.auto.internal', 'scheduling_policy': {'preemptible': True}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})

TASK [Check instance count] ********************************************************************************************
ok: [localhost] => {
    "msg": "Total instance count: 5"
}

PLAY [Approve SSH fingerprint] *****************************************************************************************

TASK [Check known_hosts for] *******************************************************************************************
ok: [kube-worker-3 -> localhost]
ok: [kube-worker-1 -> localhost]
ok: [kube-worker-2 -> localhost]
ok: [kube-worker-4 -> localhost]
ok: [kube-master-1 -> localhost]

TASK [Skip question for adding host key] *******************************************************************************
ok: [kube-worker-3]
ok: [kube-worker-1]
ok: [kube-worker-2]
ok: [kube-worker-4]
ok: [kube-master-1]

TASK [Wait for instances ready] ****************************************************************************************
ok: [kube-worker-1 -> localhost]
ok: [kube-master-1 -> localhost]
ok: [kube-worker-3 -> localhost]
ok: [kube-worker-2 -> localhost]
ok: [kube-worker-4 -> localhost]

TASK [Add SSH fingerprint to known host] *******************************************************************************
ok: [kube-worker-1]
ok: [kube-worker-2]
ok: [kube-master-1]
ok: [kube-worker-3]
ok: [kube-worker-4]

PLAY RECAP *************************************************************************************************************
kube-master-1              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
kube-worker-1              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
kube-worker-2              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
kube-worker-3              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
kube-worker-4              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

+----------------------+---------------+---------------+---------+---------------+-------------+
|          ID          |     NAME      |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
+----------------------+---------------+---------------+---------+---------------+-------------+
| fhm2hl5jlrmlii99fpj5 | kube-worker-3 | ru-central1-a | RUNNING | 51.250.82.94  | 10.2.0.8    |
| fhm8831tmjdq5mfb7nk9 | kube-worker-1 | ru-central1-a | RUNNING | 62.84.113.91  | 10.2.0.13   |
| fhmgc0imomih9kv7in79 | kube-worker-2 | ru-central1-a | RUNNING | 51.250.73.81  | 10.2.0.14   |
| fhmor1u82mmk9n0vmt3p | kube-worker-4 | ru-central1-a | RUNNING | 51.250.87.70  | 10.2.0.32   |
| fhmq8q81v6i9b4h2e7o7 | kube-master-1 | ru-central1-a | RUNNING | 51.250.81.181 | 10.2.0.36   |
+----------------------+---------------+---------------+---------+---------------+-------------+

Don't forget to add Master Node IP address to 'supplementary_addresses_in_ssl_keys'
  list of file 'group_vars/k8s_cluster/k8s_cluster.yml'
root@debian11:~/12.4#
```

</details>

## Задание 1: Подготовить инвентарь kubespray

> Новые тестовые кластеры требуют типичных простых настроек.
> Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:
> * подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
> * в качестве CRI — containerd;
> * запуск etcd производить на мастере.

* Документация по [kubespray](https://kubespray.io/)
* Документация по созданию своего [inventory](https://kubespray.io/#/docs/getting-started)
* Репозиторий [kubespray](https://github.com/kubernetes-sigs/kubespray)

### Решение

Для начала, нужно извлечь репозиторий **kubespray**: `git clone https://github.com/kubernetes-sigs/kubespray`.

Все дальнейшие действия будут проходить внутри каталога репозитория.

Для работы **kubespray** понадобятся другие пакеты, поэтому нужно установить зависимости: `pip3 install -r requirements.txt`

Репозиторий содержит шаблон(пример) файлов конфигурации кластера.
В качестве основы можно взять его: `cp -rfp inventory/sample inventory/mycluster`.
Все изменения конфигурации кластера нужно будет производить внутри `inventory/mycluster`

Файл **inventory** можно написать вручную (файл `inventory.ini`), а можно сгенерировать скриптом,
для чего потребуется задать переменную списка IP адресов нод кластера (для облачных провайдеров нужно использовать белые IP адреса): `declare -a IPS=(51.250.81.181 62.84.113.91 51.250.73.81 51.250.82.94 51.250.87.70)`

Запустить генерирование файла **inventory** скриптом: `CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}`.
Переменная **CONFIG_FILE** будет указывать куда сохранить сгенерированный **inventory** файл.
Готовый **inventory** файл нужно доработать, а именно распредеть **Control plane**, **worker plane** и **etcd** среди машин кластера.

При использовании облачных провайдеров также потребуется заменить строчки вида
```yaml
    node1:
      ansible_host: 51.250.81.181
      ip: 51.250.81.181
      access_ip: 51.250.81.181
```
на
```yaml
    node1:
      ansible_host: 51.250.81.181
      ansible_user: debian
```
где вписать имя пользователя, для которого будет осуществляться подключение к хосту.
В данном примере указан `debian`, как стандартный для образов **Debian 11** в Яндекс.Облаке.

Условию задачи (1 мастер и 4 рабочие ноды, etcd на мастере) соответствует следующая конфигурация:

```yaml
all:
  hosts:
    node1:
      ansible_host: 51.250.81.181
      ansible_user: debian
    node2:
      ansible_host: 62.84.113.91
      ansible_user: debian
    node3:
      ansible_host: 51.250.73.81
      ansible_user: debian
    node4:
      ansible_host: 51.250.82.94
      ansible_user: debian
    node5:
      ansible_host: 51.250.87.70
      ansible_user: debian
  children:
    kube_control_plane:
      hosts:
        node1:
    kube_node:
      hosts:
        node2:
        node3:
        node4:
        node5:
    etcd:
      hosts:
        node1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```

Выбор **CRI** осуществляется заданием параметра `container_manager`, расположенного в файле `group_vars/k8s_cluster/k8s-cluster.yml` относительно используемого каталога **inventory** (в решении это `inventory/mycluster`, куда мы копировали шаблон).
`containerd` установлен по умолчанию.

Подключение к кластеру выполняется по защищённому каналу связи с использованием сертификатов.
Сертификаты генерируются на конкретные IP адреса и по умолчанию включают IP адреса всех нод сети кластера.
Однако, чаще всего это внутренняя сеть с локальными адресами.
Если требуется управление кластером извне (не заходя на машину с **control plane**),
то для таких машин нужно добавить их внешние (белые) IP адреса в список параметра `supplementary_addresses_in_ssl_keys`
(расположен в том же файле, где и параметр `container_manager`). В моём случае `supplementary_addresses_in_ssl_keys: [51.250.81.181]`

Помимо всего прочего изначально можно включить желаемые **addon** в файле `group_vars/k8s_cluster/addons.yml`

Готовые файлы конфигурации кластера: [kubespray](./kubespray/inventory/mycluster)

Разворачивание кластера выполняется командой `ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b -v`

---

## Задание 2 (*): подготовить и проверить инвентарь для кластера в ~AWS~ Яндекс.Облаке

> Часть новых проектов хотят запускать на мощностях ~AWS~ Яндекс.Облака. Требования похожи:
> * разворачивать 5 нод: 1 мастер и 4 рабочие ноды;
> * работать должны на минимально допустимых ~EC2 — t3.small~ [standard-v1](https://cloud.yandex.ru/docs/compute/concepts/vm-platforms).

При создании кластера как вручную через `kubeadm` так и с использованием `kubespray` файл манифеста кластера создаётся на машине с **Control plane** по пути `/etc/kubernetes/admin.conf`.

Пример подобного файла:
```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1USXhPREE1TkRVeU5Gb1hEVE15TVRJeE5UQTVORFV5TkZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTjJoClVhY3JZSXE5Yy83d0JLcFFZMkg0U3gxNkhDTS9xS2EvS3FyYm12aHFBZXlXV2VtWFR5blVEQjVvNStFZmorYVkKMk13TkxiY3F4a1ppUU9EK1JwWCs4YThrNFJ4VVRWTzRHVmVyZnNYTUhIS1BkVE9xcmE4WDJvNFE5YUZ2dGdObAp1V21rMkx0eEdjUW1ZeUVIUEhONlRub3lHRjQvMDJYTEdnUSt6bWpCWUYybUo0cW52QUpUN1hjd3VaK2VmeHhrCjJBdnRQeGdrb0lqZ3Z6K1dudUl0NmUvMkNuVTlNY3RQQWFuT1ZHZHJwemdVZTIrL05HR29KTVNWNTFqL3Zpb0UKMThRaDB0bjFNbWJxZEc3bVFhbTBOVTZzM3RpT2thRzBxUm1vYmIvS1Y5S0hsa0p3TzlBUEx0WkhESWtLNXROagpCSytzU0VQSkZTNGdaVnc3OVlFQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZLRktidFYyWXhFdUhGUFJJK3RlZTRwWi94QitNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRFZQVFJ0SWYrWmJoc0FKTzhSTgp1VHZFRFU1WERxZ0lVNXNML3ZBQUFLNzYrOG1zVVNMTE8za2RzU0pCSGUvVFcwbkQ2SzdyRUhZZ0pMd3dHV1llCk05YllxKzFZOHVEd2xmVFJ6eFdvaFpXejdxcU4zNVM2czNuc1FQTlFPVnAyb3Mzd1JPOFN0bHRGcVMrWHZWbTAKcTBSZkRSc1JsTFd0OVBuRmdRazhLbmFNOG0rNzBrTEQrWnd3OXdybkJXbjZPODQ1aEg0SDhreWlKQ3ZvT25jTQpUOXQvaUt2ZFg4NDRjb2hxcFNZeW93alhtbS90S0hDWlJHMVF6QnB4MFRGUE9ZRmFXNE9GMEtJVHFPK2w4Vzd3CjgrRi91ZEdjeERxWFAyUlA2OUgzK1lxTkVRd1M0NFdFU082Mk1NVWplRWFUTkRLaUFJQ3dGcHplM25NbTRXQSsKTElrPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://127.0.0.1:6443
  name: cluster.local
contexts:
- context:
    cluster: cluster.local
    user: kubernetes-admin
  name: kubernetes-admin@cluster.local
current-context: kubernetes-admin@cluster.local
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURJVENDQWdtZ0F3SUJBZ0lJUlY2REhPREMwcGd3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TWpFeU1UZ3dPVFExTWpSYUZ3MHlNekV5TVRnd09UUTFNamRhTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQTNPSUJTRCtBR2VjeEJqOVkKWWROeUthVno5bzVWTTVIWTNxeGVva1h6VndwenFvWUVaY01JMEFrU0E2NmJFVTBGSERmc2RIM2VSTGxaUlVDQQpUbDlqYUNqb0MvUVovaFkvcU1FajhqMXFyRlBCR0RKRG5DQ2FFUU5PVFVNcDA3QlBCV3RWYXVNQWFncmZCejhyCjc2VWZVVFd6R2p6bGdwS2wrbXZIYUFQdUhnelZhQVMrYkMyK1JXVno2cWJvVS9ZQmVNcVpKNUxIc043ZnE0Vy8KNExCamlabHlFOFJnWFFxMnpRUzJudWRpRWp6MEtxTzFpWVNhaXUzYXRYQVJvbk9ucy9PaktTTTFlQTNXTHFsUwo5R0VBbCt3ZHRpSG1nVzgyMG5RWU9kdVhCYkZSZm15cWNXSXM5WU9tbklKRk0xdm4xWi9LSStHN3JCYm0yY3VHCnQ2NDcwUUlEQVFBQm8xWXdWREFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0RBWURWUjBUQVFIL0JBSXdBREFmQmdOVkhTTUVHREFXZ0JTaFNtN1ZkbU1STGh4VDBTUHJYbnVLV2Y4UQpmakFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBVHZJbXNxdUhSNytKRFlzbXo4QmVOT00yTU4yOHNvUENubFJVCkY5TU4yZGlJMWFpMWpRQWg5Yi9BamoxU3cvemtQWFV5WGorQUhzSDFueVZrUFlsQ3BCcjVUcWowK0txZk9ZTm4KMCs5K3BLMUEybTVhTTJMM1BpUVRTWHRkRWg4d3V6b01Dc3p5aUx4b0Z4L3FQaHFkM1JES2VGL2VQbkVXajJlaApHSkVobzVyR3B3YkpUTmFkMndwUjdpZEdXRkR0cm0wYUJyYzBheWZ4UENzMGRXTkRpaytuSmZBSG9KUGVrTzV5CmV4U3lkdUlBckJpbGdBNmhjQ3VING9mWUNNMU44OXAwWjhtREVydGx6Y2pVU1BIVzZUeUExQitqZDVtdFpxaWcKeHdybDZKVElPNlVTS1NadndydFdVMVArNU5DTHhKSk5wdlB1NXc0cFJNakIwTmVDYVE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBM09JQlNEK0FHZWN4Qmo5WVlkTnlLYVZ6OW81Vk01SFkzcXhlb2tYelZ3cHpxb1lFClpjTUkwQWtTQTY2YkVVMEZIRGZzZEgzZVJMbFpSVUNBVGw5amFDam9DL1FaL2hZL3FNRWo4ajFxckZQQkdESkQKbkNDYUVRTk9UVU1wMDdCUEJXdFZhdU1BYWdyZkJ6OHI3NlVmVVRXekdqemxncEtsK212SGFBUHVIZ3pWYUFTKwpiQzIrUldWejZxYm9VL1lCZU1xWko1TEhzTjdmcTRXLzRMQmppWmx5RThSZ1hRcTJ6UVMybnVkaUVqejBLcU8xCmlZU2FpdTNhdFhBUm9uT25zL09qS1NNMWVBM1dMcWxTOUdFQWwrd2R0aUhtZ1c4MjBuUVlPZHVYQmJGUmZteXEKY1dJczlZT21uSUpGTTF2bjFaL0tJK0c3ckJibTJjdUd0NjQ3MFFJREFRQUJBb0lCQVFDU3J6dnV3TXpQWnVyMQpuU2VTZjVyMjhUdGJaeFpKMHZkVW1OK1hvQ0NEa3h0UkNRTHVtV0RHMXQ4eHRzaWY2cWdVSDBkVjdTaW9OdmFECnVOdjhML2lSK1dod1Y4RFRMZTlFb0U3QTFleDdXSHVKR0FneUxLeGowL0F4K3dKUjVHbjF6VnZDU2RIQ21rbVcKUkd0bkVCOEdEVVZOalZkVktSSTBoVks5VHE3WklLelVmSzJVeFFabzlSeWUvRzVNVWMrU0NudWRSK21oL2xhRgpQL2JacjR2SkZqSGRYUU5mZ0dYUlZEbjR4Q1NiaXlvb3prM2FER2llSGJ3czJLbWR5aE9XdW5pSkNEdzE4NGVBCldRVUt6a3hkOEt0MDJSczVXVUt2MFVGOU9nenJacmtlR212endOQWkyUXpFeWVpRlc5b0craVhSME8wSjNoQmsKK2YzODlpYUJBb0dCQU9ydzFsVndodktnL0Z0UXgxZU04STFHK0NPTWNzQ2ZLRWNFNkdxdXZqRkoxeWtLV1pOcQowVlE1MnNlUHBOd1NWa2RhK0puSEpqMW1vMzAyMzhJNFJ4WUNBYi9ZS2F6eWNJbFJGNU5LMlZPS3d1UG5seFNpCjNxTkppL3NCSGlTZXFVOW9EQ01TV2JXR2JmSjkvNkpnU1RrMnBsNjVUbDdnc1pMTmV1OW5vc1JaQW9HQkFQQ3UKbE9Zck11QlAzVUlJckgxZnVETUNuN3YrQ241cXphK3pBdHRoRlMrZk5xYWNqdWFFdVlNNDFwbkFkbnBJeXczMQp1UVdGM1MxNFkvTlh5THA2VGZpamVYOXhCQXNMVTlZVlhSdU5teEYxQ0ZNeVc1OGR1VVN5WUM3c2dzMDVuS2czClVjYTFYYVBHYWpzN1NBMzNEcStYc1BXY05FcU9MaTBtVDdQODlDUTVBb0dBVXNjbWpaWUhSaWVvb3JmMGRJbUoKSEEzOFVmSWpZSER6YlFweXBWd0tVUzEyTE5TanVRZ3kxeDFIVTNidUhFZ3R0QmgrYlJnNUJmdEs4VXhMVEpBdApvN2h6UzFmclh5OVFyV0V3RUVxWUJoSm5Gb3U3dEo2cUdSaEp4TmVnK2tBWTRZeUVjanI5OXJKMXZMSGVSeVRyCng4ZlVtSjFyMm93S3BQSFhOZERyRFlrQ2dZQkJ0aGlYSXZJNEJmWU53bHA5dkhXSkQ4MVd3VXhTS1l6UXpKb2EKRlU1NGV3cXJ3SkRQWlN0VkpWNktDZDhQRWZMR2MvRTVEY3hPVHRGVExnTnl6bE9kYjl5TEsrc0RyT3NOeHpWdApnV0wyQ0RMbXJCZ1J3RWJGOThHRTdqUGtIamVrUWI1RTkxMkNpbmlVaFdIdDFpY2ZUOVlUcUxzcUk5bDlvRGtnCmxnNStHUUtCZ1FEaHpWdFE0dk1XbzFDMTdWT2hoZ2RlemxYTE5UK1UzYjkzZDRKZXF2S2FVZjROek51NkJEa2oKQ0pteWRuZ3NKM3BYMFN1b1l5T1RLSG9tTGdwMlRhT0RBR25COEsyczRaVUxrQUZLbVU0VGEydU5GQzhxbmFmZgpNS2FaRUZ3VGpmSWJuaFhCTStsK3ZqRmJ4UUdjWnhQL3dzejlnVm5xYVg4K3UybkVKUEg3OXc9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=
```

Если требуется реализовать управление кластером извне, то данные для подключения к кластеру нужно брать именно с этого файла.
Однако, так как файл генерировался с учётом расположения во внутренней сети (в примере `https://127.0.0.1:6443`), IP адрес подключения нужно поменять на внешний (белый) - для решения это ` https://51.250.81.181:6443`.

> Файл конфигурации кластеров и контекстов располагается в файле `~/.kube/config`

### Проверка функционирования кластера с рабочей машины:

Запрос списка нод и **deployment** кластера:
```console
root@debian11:~/12.4/kubespray# kubectl get nodes
NAME    STATUS   ROLES           AGE   VERSION
node1   Ready    control-plane   89m   v1.25.5
node2   Ready    <none>          88m   v1.25.5
node3   Ready    <none>          88m   v1.25.5
node4   Ready    <none>          88m   v1.25.5
node5   Ready    <none>          88m   v1.25.5
root@debian11:~/12.4/kubespray# kubectl get deployments -A
NAMESPACE     NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   calico-kube-controllers      1/1     1            1           85m
kube-system   coredns                      2/2     2            2           84m
kube-system   dns-autoscaler               1/1     1            1           83m
kube-system   kubernetes-dashboard         1/1     1            1           83m
kube-system   kubernetes-metrics-scraper   1/1     1            1           83m
kube-system   metrics-server               1/1     1            1           82m
root@debian11:~/12.4/kubespray#
```

Запрос списка **pod** со всех **namespace**:
```console
root@debian11:~/12.4/kubespray# kubectl get pods -A
NAMESPACE       NAME                                          READY   STATUS    RESTARTS      AGE
ingress-nginx   ingress-nginx-controller-c6zwt                1/1     Running   0             88m
ingress-nginx   ingress-nginx-controller-g47fv                1/1     Running   0             88m
ingress-nginx   ingress-nginx-controller-w8ltv                1/1     Running   0             88m
ingress-nginx   ingress-nginx-controller-xnd7f                1/1     Running   0             88m
kube-system     calico-kube-controllers-75748cc9fd-fml2t      1/1     Running   0             89m
kube-system     calico-node-44952                             1/1     Running   0             90m
kube-system     calico-node-cptbb                             1/1     Running   0             90m
kube-system     calico-node-fkbqd                             1/1     Running   0             90m
kube-system     calico-node-p7f4l                             1/1     Running   0             90m
kube-system     calico-node-w7vwt                             1/1     Running   0             90m
kube-system     coredns-588bb58b94-kvvg5                      1/1     Running   0             87m
kube-system     coredns-588bb58b94-xdvtg                      1/1     Running   0             87m
kube-system     dns-autoscaler-5b9959d7fc-4mc4l               1/1     Running   0             87m
kube-system     kube-apiserver-node1                          1/1     Running   2 (85m ago)   93m
kube-system     kube-controller-manager-node1                 1/1     Running   3 (84m ago)   93m
kube-system     kube-proxy-2hqn2                              1/1     Running   0             92m
kube-system     kube-proxy-6dvwl                              1/1     Running   0             92m
kube-system     kube-proxy-82qw6                              1/1     Running   0             92m
kube-system     kube-proxy-lzx4j                              1/1     Running   0             92m
kube-system     kube-proxy-nl9nn                              1/1     Running   0             92m
kube-system     kube-scheduler-node1                          1/1     Running   2 (84m ago)   93m
kube-system     kubernetes-dashboard-74cc7bdb6d-zx7xf         1/1     Running   0             87m
kube-system     kubernetes-metrics-scraper-75666d949b-t2w9d   1/1     Running   0             87m
kube-system     metrics-server-6bd8d699c5-nzzxr               1/1     Running   0             86m
kube-system     nginx-proxy-node2                             1/1     Running   0             92m
kube-system     nginx-proxy-node3                             1/1     Running   0             90m
kube-system     nginx-proxy-node4                             1/1     Running   0             90m
kube-system     nginx-proxy-node5                             1/1     Running   0             91m
kube-system     nodelocaldns-488mk                            1/1     Running   0             87m
kube-system     nodelocaldns-7cz67                            1/1     Running   0             87m
kube-system     nodelocaldns-mmlx4                            1/1     Running   0             87m
kube-system     nodelocaldns-pf682                            1/1     Running   0             87m
kube-system     nodelocaldns-xblgt                            1/1     Running   0             87m
root@debian11:~/12.4/kubespray#
```

Запрос описания **pod** с **dashboard**:
```console
root@debian11:~/12.4/kubespray# kubectl describe -n kube-system pods/kubernetes-dashboard-74cc7bdb6d-zx7xf
Name:                 kubernetes-dashboard-74cc7bdb6d-zx7xf
Namespace:            kube-system
Priority:             2000000000
Priority Class Name:  system-cluster-critical
Service Account:      kubernetes-dashboard
Node:                 node3/10.2.0.14
Start Time:           Sun, 18 Dec 2022 04:52:46 -0500
Labels:               k8s-app=kubernetes-dashboard
                      pod-template-hash=74cc7bdb6d
Annotations:          cni.projectcalico.org/containerID: 445271caac7ff67513117bafa2f4a5b4691293cae71a2b65aaf7684b0beaa91d
                      cni.projectcalico.org/podIP: 10.233.71.2/32
                      cni.projectcalico.org/podIPs: 10.233.71.2/32
Status:               Running
IP:                   10.233.71.2
IPs:
  IP:           10.233.71.2
Controlled By:  ReplicaSet/kubernetes-dashboard-74cc7bdb6d
Containers:
  kubernetes-dashboard:
    Container ID:  containerd://97a2b80b4d6f03d54addf8951a456f3685b694d21015f32dfbe86e77b83175e8
    Image:         docker.io/kubernetesui/dashboard:v2.7.0
    Image ID:      docker.io/kubernetesui/dashboard@sha256:2e500d29e9d5f4a086b908eb8dfe7ecac57d2ab09d65b24f588b1d449841ef93
    Port:          8443/TCP
    Host Port:     0/TCP
    Args:
      --namespace=kube-system
      --auto-generate-certificates
      --authentication-mode=token
      --token-ttl=900
    State:          Running
      Started:      Sun, 18 Dec 2022 04:53:16 -0500
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     100m
      memory:  256M
    Requests:
      cpu:        50m
      memory:     64M
    Liveness:     http-get https://:8443/ delay=30s timeout=30s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /certs from kubernetes-dashboard-certs (rw)
      /tmp from tmp-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-kk26r (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kubernetes-dashboard-certs:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  kubernetes-dashboard-certs
    Optional:    false
  tmp-volume:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:
    SizeLimit:  <unset>
  kube-api-access-kk26r:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node-role.kubernetes.io/control-plane:NoSchedule
                             node-role.kubernetes.io/master:NoSchedule
                             node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:                      <none>
root@debian11:~/12.4/kubespray#
```

Из описания вывода можно узнать об открытых портах, в данном случае: `Port:          8443/TCP`, следовательно можно выполнить **port-forward**:
```console
root@debian11:~/12.4/kubespray# kubectl -n kube-system port-forward pod/kubernetes-dashboard-74cc7bdb6d-zx7xf 8080:8443
Forwarding from 127.0.0.1:8080 -> 8443
Forwarding from [::1]:8080 -> 8443
Handling connection for 8080
```

И в отдельном терминале запросить содержимое страницы **dashboard** (в данном случае будет страница авторизации, поэтому такой небольшой объём):
```console
root@debian11:~/12.4# curl -k https://127.1:8080
<!--
Copyright 2017 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--><!DOCTYPE html><html lang="en" dir="ltr"><head>
  <meta charset="utf-8">
  <title>Kubernetes Dashboard</title>
  <link rel="icon" type="image/png" href="assets/images/kubernetes-logo.png">
  <meta name="viewport" content="width=device-width">
<style>html,body{height:100%;margin:0}*::-webkit-scrollbar{background:transparent;height:8px;width:8px}</style><link rel="stylesheet" href="styles.243e6d874431c8e8.css" media="print" onload="this.media='all'"><noscript><link rel="stylesheet" href="styles.243e6d874431c8e8.css"></noscript></head>

<body>
  <kd-root></kd-root>
<script src="runtime.134ad7745384bed8.js" type="module"></script><script src="polyfills.5c84b93f78682d4f.js" type="module"></script><script src="scripts.2c4f58d7c579cacb.js" defer></script><script src="en.main.3550e3edca7d0ed8.js" type="module"></script>


</body></html>root@debian11:~/12.4#
```
