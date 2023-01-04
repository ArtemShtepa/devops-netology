```console
root@debian11:~/13.5# ./go.sh init
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
Cloning into 'kubespray'...
remote: Enumerating objects: 65774, done.
remote: Counting objects: 100% (199/199), done.
remote: Compressing objects: 100% (156/156), done.
remote: Total 65774 (delta 82), reused 123 (delta 34), pack-reused 65575
Receiving objects: 100% (65774/65774), 20.83 MiB | 7.35 MiB/s, done.
Resolving deltas: 100% (36940/36940), done.
Requirement already satisfied: ansible==5.7.1 in /usr/local/lib/python3.9/dist-packages (from -r kubespray/requirements.txt (line 1)) (5.7.1)
Requirement already satisfied: ansible-core==2.12.5 in /usr/local/lib/python3.9/dist-packages (from -r kubespray/requirements.txt (line 2)) (2.12.5)
Requirement already satisfied: cryptography==3.4.8 in /usr/local/lib/python3.9/dist-packages (from -r kubespray/requirements.txt (line 3)) (3.4.8)
Requirement already satisfied: jinja2==2.11.3 in /usr/local/lib/python3.9/dist-packages (from -r kubespray/requirements.txt (line 4)) (2.11.3)
Requirement already satisfied: netaddr==0.7.19 in /usr/local/lib/python3.9/dist-packages (from -r kubespray/requirements.txt (line 5)) (0.7.19)
Requirement already satisfied: pbr==5.4.4 in /usr/local/lib/python3.9/dist-packages (from -r kubespray/requirements.txt (line 6)) (5.4.4)
Requirement already satisfied: jmespath==0.9.5 in /usr/local/lib/python3.9/dist-packages (from -r kubespray/requirements.txt (line 7)) (0.9.5)
Requirement already satisfied: ruamel.yaml==0.16.10 in /usr/local/lib/python3.9/dist-packages (from -r kubespray/requirements.txt (line 8)) (0.16.10)
Requirement already satisfied: ruamel.yaml.clib==0.2.7 in /usr/local/lib/python3.9/dist-packages (from -r kubespray/requirements.txt (line 9)) (0.2.7)
Requirement already satisfied: MarkupSafe==1.1.1 in /usr/local/lib/python3.9/dist-packages (from -r kubespray/requirements.txt (line 10)) (1.1.1)
Requirement already satisfied: PyYAML in /usr/lib/python3/dist-packages (from ansible-core==2.12.5->-r kubespray/requirements.txt (line 2)) (5.3.1)
Requirement already satisfied: resolvelib<0.6.0,>=0.5.3 in /usr/local/lib/python3.9/dist-packages (from ansible-core==2.12.5->-r kubespray/requirements.txt (line 2)) (0.5.4)
Requirement already satisfied: packaging in /usr/local/lib/python3.9/dist-packages (from ansible-core==2.12.5->-r kubespray/requirements.txt (line 2)) (22.0)
Requirement already satisfied: cffi>=1.12 in /usr/local/lib/python3.9/dist-packages (from cryptography==3.4.8->-r kubespray/requirements.txt (line 3)) (1.15.1)
Requirement already satisfied: pycparser in /usr/local/lib/python3.9/dist-packages (from cffi>=1.12->cryptography==3.4.8->-r kubespray/requirements.txt (line 3)) (2.21)
root@debian11:~/13.5# ./go.sh up

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

  # module.kube-master[0].yandex_compute_instance.vm-instance will be created
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
          + preemptible = false
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
              + size        = 20
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
              + size        = 20
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
              + size        = 20
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

Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + master_internal_ip = [
      + (known after apply),
    ]
  + master_ip          = [
      + (known after apply),
    ]
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
yandex_vpc_network.my-net: Creation complete after 1s [id=enpfs1nlgm8g9naseeh6]
yandex_vpc_subnet.my-subnet: Creating...
yandex_vpc_subnet.my-subnet: Creation complete after 1s [id=e9b7smgagrprv5f5anb1]
yandex_compute_image.os-disk: Creation complete after 6s [id=fd8eengr58ekld66p9me]
module.kube-master[0].yandex_compute_instance.vm-instance: Creating...
module.kube-worker[2].yandex_compute_instance.vm-instance: Creating...
module.kube-worker[0].yandex_compute_instance.vm-instance: Creating...
module.kube-worker[1].yandex_compute_instance.vm-instance: Creating...
module.kube-master[0].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-master[0].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.kube-master[0].yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.kube-master[0].yandex_compute_instance.vm-instance: Still creating... [40s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [40s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [40s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [40s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [50s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [50s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [50s elapsed]
module.kube-master[0].yandex_compute_instance.vm-instance: Still creating... [50s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Creation complete after 59s [id=fhmuqau1i8tsei06nvt9]
module.kube-worker[1].yandex_compute_instance.vm-instance: Creation complete after 59s [id=fhmi4tv1roiqgjn06m1o]
module.kube-master[0].yandex_compute_instance.vm-instance: Still creating... [1m0s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [1m0s elapsed]
module.kube-master[0].yandex_compute_instance.vm-instance: Creation complete after 1m2s [id=fhmmlr985erh7v4qeht8]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [1m10s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Creation complete after 1m13s [id=fhmj1tiqg0vfkbjteo6v]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

master_internal_ip = [
  "10.2.0.16",
]
master_ip = [
  "62.84.117.40",
]
worker_internal_ip = [
  "10.2.0.11",
  "10.2.0.6",
  "10.2.0.34",
]
worker_ip = [
  "51.250.3.40",
  "51.250.14.11",
  "51.250.85.66",
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
ok: [localhost] => (item={'id': 'fhmi4tv1roiqgjn06m1o', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2023-01-09T19:44:36Z', 'name': 'kube-worker-2', 'description': 'Worker Node 2', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhmghpe5b7g4e6mteds7'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:12:27:7e:1d', 'subnet_id': 'e9b7smgagrprv5f5anb1', 'primary_v4_address': {'address': '10.2.0.6', 'one_to_one_nat': {'address': '51.250.14.11', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhmi4tv1roiqgjn06m1o.auto.internal', 'scheduling_policy': {}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})
ok: [localhost] => (item={'id': 'fhmj1tiqg0vfkbjteo6v', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2023-01-09T19:44:36Z', 'name': 'kube-worker-1', 'description': 'Worker Node 1', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhmh3bbd5vlo6in71ngs'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:13:0f:65:a8', 'subnet_id': 'e9b7smgagrprv5f5anb1', 'primary_v4_address': {'address': '10.2.0.11', 'one_to_one_nat': {'address': '51.250.3.40', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhmj1tiqg0vfkbjteo6v.auto.internal', 'scheduling_policy': {}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})
ok: [localhost] => (item={'id': 'fhmmlr985erh7v4qeht8', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2023-01-09T19:44:36Z', 'name': 'kube-master-1', 'description': 'Master Node', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhmfelfelrb76c0ji565'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:16:ae:d2:82', 'subnet_id': 'e9b7smgagrprv5f5anb1', 'primary_v4_address': {'address': '10.2.0.16', 'one_to_one_nat': {'address': '62.84.117.40', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhmmlr985erh7v4qeht8.auto.internal', 'scheduling_policy': {}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})
ok: [localhost] => (item={'id': 'fhmuqau1i8tsei06nvt9', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2023-01-09T19:44:36Z', 'name': 'kube-worker-3', 'description': 'Worker Node 3', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhmhrip3gvregtpsr833'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:1e:d2:bc:19', 'subnet_id': 'e9b7smgagrprv5f5anb1', 'primary_v4_address': {'address': '10.2.0.34', 'one_to_one_nat': {'address': '51.250.85.66', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhmuqau1i8tsei06nvt9.auto.internal', 'scheduling_policy': {}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})

TASK [Check instance count] ********************************************************************************************
ok: [localhost] => {
    "msg": "Total instance count: 4"
}

PLAY [Approve SSH fingerprint] *****************************************************************************************

TASK [Check known_hosts for] *******************************************************************************************
ok: [kube-worker-1 -> localhost]
ok: [kube-worker-2 -> localhost]
ok: [kube-master-1 -> localhost]
ok: [kube-worker-3 -> localhost]

TASK [Skip question for adding host key] *******************************************************************************
ok: [kube-worker-2]
ok: [kube-worker-1]
ok: [kube-master-1]
ok: [kube-worker-3]

TASK [Wait for instances ready] ****************************************************************************************
ok: [kube-worker-2 -> localhost]
ok: [kube-worker-1 -> localhost]
ok: [kube-worker-3 -> localhost]
ok: [kube-master-1 -> localhost]

TASK [Add SSH fingerprint to known host] *******************************************************************************
ok: [kube-worker-1]
ok: [kube-worker-3]
ok: [kube-worker-2]
ok: [kube-master-1]

PLAY RECAP *************************************************************************************************************
kube-master-1              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
kube-worker-1              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
kube-worker-2              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
kube-worker-3              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

+----------------------+---------------+---------------+---------+--------------+-------------+
|          ID          |     NAME      |    ZONE ID    | STATUS  | EXTERNAL IP  | INTERNAL IP |
+----------------------+---------------+---------------+---------+--------------+-------------+
| fhmi4tv1roiqgjn06m1o | kube-worker-2 | ru-central1-a | RUNNING | 51.250.14.11 | 10.2.0.6    |
| fhmj1tiqg0vfkbjteo6v | kube-worker-1 | ru-central1-a | RUNNING | 51.250.3.40  | 10.2.0.11   |
| fhmmlr985erh7v4qeht8 | kube-master-1 | ru-central1-a | RUNNING | 62.84.117.40 | 10.2.0.16   |
| fhmuqau1i8tsei06nvt9 | kube-worker-3 | ru-central1-a | RUNNING | 51.250.85.66 | 10.2.0.34   |
+----------------------+---------------+---------------+---------+--------------+-------------+

Commands to configure Kubespray (inside kubespray dir):
  declare -a IPS=(maste_ip ... worker_ip ...)
  CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
Manage nodes in inventory/_sample_/hosts.yaml, where _sample_ is your inventory dir.
Don't forget to add Master Node IP address to 'supplementary_addresses_in_ssl_keys'
  list of file 'group_vars/k8s_cluster/k8s-cluster.yml'
root@debian11:~/13.5# cd kubespray/
root@debian11:~/13.5/kubespray# declare -a IPS=(62.84.117.40 51.250.3.40 51.250.14.11 51.250.85.66)
root@debian11:~/13.5/kubespray# CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
DEBUG: Adding group all
DEBUG: Adding group kube_control_plane
DEBUG: Adding group kube_node
DEBUG: Adding group etcd
DEBUG: Adding group k8s_cluster
DEBUG: Adding group calico_rr
DEBUG: adding host node1 to group all
DEBUG: adding host node2 to group all
DEBUG: adding host node3 to group all
DEBUG: adding host node4 to group all
DEBUG: adding host node1 to group etcd
DEBUG: adding host node2 to group etcd
DEBUG: adding host node3 to group etcd
DEBUG: adding host node1 to group kube_control_plane
DEBUG: adding host node2 to group kube_control_plane
DEBUG: adding host node1 to group kube_node
DEBUG: adding host node2 to group kube_node
DEBUG: adding host node3 to group kube_node
DEBUG: adding host node4 to group kube_node
root@debian11:~/13.5/kubespray# nano inventory/mycluster/hosts.yaml
root@debian11:~/13.5/kubespray# nano inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
root@debian11:~/13.5/kubespray# cd ..
root@debian11:~/13.5# ./go.sh deploy
[WARNING]: Skipping callback plugin 'ara_default', unable to load

PLAY [localhost] *******************************************************************************************************
Monday 09 January 2023  14:50:33 -0500 (0:00:00.013)       0:00:00.013 ********

TASK [Check 2.11.0 <= Ansible version < 2.13.0] ************************************************************************
ok: [localhost] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:50:33 -0500 (0:00:00.016)       0:00:00.032 ********

TASK [Check that python netaddr is installed] **************************************************************************
ok: [localhost] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:50:34 -0500 (0:00:00.073)       0:00:00.105 ********

TASK [Check that jinja is not too old (install via pip)] ***************************************************************
ok: [localhost] => {
    "changed": false,
    "msg": "All assertions passed"
}
[WARNING]: Could not match supplied host pattern, ignoring: kube-master

PLAY [Add kube-master nodes to kube_control_plane] *********************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: kube-node

PLAY [Add kube-node nodes to kube_node] ********************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: k8s-cluster

PLAY [Add k8s-cluster nodes to k8s_cluster] ****************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: calico-rr

PLAY [Add calico-rr nodes to calico_rr] ********************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: no-floating

PLAY [Add no-floating nodes to no_floating] ****************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: bastion

PLAY [bastion[0]] ******************************************************************************************************
skipping: no hosts matched

PLAY [k8s_cluster:etcd] ************************************************************************************************
Monday 09 January 2023  14:50:34 -0500 (0:00:00.034)       0:00:00.139 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.026)       0:00:00.170 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.180)       0:00:00.351 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.016)       0:00:00.368 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.036)       0:00:00.404 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.027)       0:00:00.431 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.027)       0:00:00.459 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.031)       0:00:00.490 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.017)       0:00:00.508 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.028)       0:00:00.536 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.045)       0:00:00.581 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node2] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node3] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node4] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Monday 09 January 2023  14:50:34 -0500 (0:00:00.053)       0:00:00.635 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.021)       0:00:00.657 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.009)       0:00:00.666 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.025)       0:00:00.692 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.009)       0:00:00.701 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.021)       0:00:00.722 ********
Monday 09 January 2023  14:50:34 -0500 (0:00:00.032)       0:00:00.754 ********
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword

TASK [bootstrap-os : Fetch /etc/os-release] ****************************************************************************
ok: [node4]
ok: [node3]
ok: [node2]
ok: [node1]
Monday 09 January 2023  14:50:36 -0500 (0:00:01.417)       0:00:02.172 ********
Monday 09 January 2023  14:50:36 -0500 (0:00:00.023)       0:00:02.195 ********
Monday 09 January 2023  14:50:36 -0500 (0:00:00.023)       0:00:02.219 ********
Monday 09 January 2023  14:50:36 -0500 (0:00:00.171)       0:00:02.391 ********
Monday 09 January 2023  14:50:36 -0500 (0:00:00.022)       0:00:02.413 ********
Monday 09 January 2023  14:50:36 -0500 (0:00:00.021)       0:00:02.435 ********
Monday 09 January 2023  14:50:36 -0500 (0:00:00.022)       0:00:02.458 ********

TASK [bootstrap-os : include_tasks] ************************************************************************************
included: /root/13.5/kubespray/roles/bootstrap-os/tasks/bootstrap-debian.yml for node1, node2, node3, node4
Monday 09 January 2023  14:50:36 -0500 (0:00:00.039)       0:00:02.499 ********
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword

TASK [bootstrap-os : Check if bootstrap is needed] *********************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:50:36 -0500 (0:00:00.184)       0:00:02.683 ********
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword

TASK [bootstrap-os : Check http::proxy in apt configuration files] *****************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:50:36 -0500 (0:00:00.299)       0:00:02.982 ********
Monday 09 January 2023  14:50:36 -0500 (0:00:00.027)       0:00:03.010 ********
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword

TASK [bootstrap-os : Check https::proxy in apt configuration files] ****************************************************
ok: [node4]
ok: [node3]
ok: [node2]
ok: [node1]
Monday 09 January 2023  14:50:37 -0500 (0:00:00.233)       0:00:03.244 ********
Monday 09 January 2023  14:50:37 -0500 (0:00:00.022)       0:00:03.267 ********
Monday 09 January 2023  14:50:37 -0500 (0:00:00.021)       0:00:03.289 ********
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword

TASK [bootstrap-os : Update Apt cache] *********************************************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  14:52:16 -0500 (0:01:39.754)       0:01:43.043 ********

TASK [bootstrap-os : Set the ansible_python_interpreter fact] **********************************************************
ok: [node1]
ok: [node3]
ok: [node2]
ok: [node4]
Monday 09 January 2023  14:52:17 -0500 (0:00:00.028)       0:01:43.072 ********

TASK [bootstrap-os : Install dbus for the hostname module] *************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:52:23 -0500 (0:00:06.773)       0:01:49.845 ********
Monday 09 January 2023  14:52:23 -0500 (0:00:00.027)       0:01:49.873 ********
Monday 09 January 2023  14:52:23 -0500 (0:00:00.022)       0:01:49.896 ********

TASK [bootstrap-os : Create remote_tmp for it is used by another module] ***********************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:52:26 -0500 (0:00:02.418)       0:01:52.314 ********

TASK [bootstrap-os : Gather host facts to get ansible_os_family] *******************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:52:31 -0500 (0:00:05.266)       0:01:57.581 ********

TASK [bootstrap-os : Assign inventory name to unconfigured hostnames (non-CoreOS, non-Flatcar, Suse and ClearLinux, non-Fedora)] ***
changed: [node2]
changed: [node3]
changed: [node1]
changed: [node4]
Monday 09 January 2023  14:52:36 -0500 (0:00:04.506)       0:02:02.088 ********
Monday 09 January 2023  14:52:36 -0500 (0:00:00.025)       0:02:02.114 ********
Monday 09 January 2023  14:52:36 -0500 (0:00:00.028)       0:02:02.142 ********
Monday 09 January 2023  14:52:36 -0500 (0:00:00.025)       0:02:02.168 ********

TASK [bootstrap-os : Ensure bash_completion.d folder exists] ***********************************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]

PLAY [Gather facts] ****************************************************************************************************
Monday 09 January 2023  14:52:37 -0500 (0:00:01.807)       0:02:03.976 ********

TASK [Gather minimal facts] ********************************************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:52:42 -0500 (0:00:04.620)       0:02:08.597 ********

TASK [Gather necessary facts (network)] ********************************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:52:45 -0500 (0:00:03.260)       0:02:11.858 ********

TASK [Gather necessary facts (hardware)] *******************************************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]

PLAY [k8s_cluster:etcd] ************************************************************************************************
Monday 09 January 2023  14:52:49 -0500 (0:00:04.125)       0:02:15.983 ********
Monday 09 January 2023  14:52:49 -0500 (0:00:00.032)       0:02:16.015 ********
Monday 09 January 2023  14:52:49 -0500 (0:00:00.015)       0:02:16.031 ********
Monday 09 January 2023  14:52:49 -0500 (0:00:00.012)       0:02:16.043 ********
Monday 09 January 2023  14:52:50 -0500 (0:00:00.030)       0:02:16.074 ********
Monday 09 January 2023  14:52:50 -0500 (0:00:00.031)       0:02:16.105 ********
Monday 09 January 2023  14:52:50 -0500 (0:00:00.032)       0:02:16.138 ********
Monday 09 January 2023  14:52:50 -0500 (0:00:00.035)       0:02:16.173 ********
Monday 09 January 2023  14:52:50 -0500 (0:00:00.011)       0:02:16.185 ********
Monday 09 January 2023  14:52:50 -0500 (0:00:00.029)       0:02:16.215 ********
Monday 09 January 2023  14:52:50 -0500 (0:00:00.719)       0:02:16.934 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node2] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node3] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node4] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Monday 09 January 2023  14:52:50 -0500 (0:00:00.055)       0:02:16.990 ********
Monday 09 January 2023  14:52:50 -0500 (0:00:00.054)       0:02:17.044 ********

TASK [kubespray-defaults : create fallback_ips_base] *******************************************************************
ok: [node1 -> localhost]
Monday 09 January 2023  14:52:51 -0500 (0:00:00.030)       0:02:17.075 ********

TASK [kubespray-defaults : set fallback_ips] ***************************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:52:51 -0500 (0:00:00.042)       0:02:17.117 ********
Monday 09 January 2023  14:52:51 -0500 (0:00:00.014)       0:02:17.132 ********
Monday 09 January 2023  14:52:51 -0500 (0:00:00.032)       0:02:17.165 ********
Monday 09 January 2023  14:52:51 -0500 (0:00:00.047)       0:02:17.212 ********

TASK [adduser : User | Create User Group] ******************************************************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:52:53 -0500 (0:00:02.423)       0:02:19.636 ********

TASK [adduser : User | Create User] ************************************************************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:52:56 -0500 (0:00:02.575)       0:02:22.211 ********

TASK [kubernetes/preinstall : Remove swapfile from /etc/fstab] *********************************************************
ok: [node2] => (item=swap)
ok: [node3] => (item=swap)
ok: [node2] => (item=none)
ok: [node4] => (item=swap)
ok: [node3] => (item=none)
ok: [node1] => (item=swap)
ok: [node4] => (item=none)
ok: [node1] => (item=none)
Monday 09 January 2023  14:53:01 -0500 (0:00:04.996)       0:02:27.208 ********

TASK [kubernetes/preinstall : check swap] ******************************************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  14:53:04 -0500 (0:00:03.189)       0:02:30.397 ********
Monday 09 January 2023  14:53:04 -0500 (0:00:00.031)       0:02:30.429 ********
Monday 09 January 2023  14:53:04 -0500 (0:00:00.031)       0:02:30.460 ********

TASK [kubernetes/preinstall : Stop if either kube_control_plane or kube_node group is empty] ***************************
ok: [node1] => (item=kube_control_plane) => {
    "ansible_loop_var": "item",
    "changed": false,
    "item": "kube_control_plane",
    "msg": "All assertions passed"
}
ok: [node1] => (item=kube_node) => {
    "ansible_loop_var": "item",
    "changed": false,
    "item": "kube_node",
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:04 -0500 (0:00:00.040)       0:02:30.501 ********

TASK [kubernetes/preinstall : Stop if etcd group is empty in external etcd mode] ***************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:04 -0500 (0:00:00.023)       0:02:30.524 ********

TASK [kubernetes/preinstall : Stop if non systemd OS type] *************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node2] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node3] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:04 -0500 (0:00:00.039)       0:02:30.564 ********

TASK [kubernetes/preinstall : Stop if unknown OS] **********************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node2] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node3] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:04 -0500 (0:00:00.040)       0:02:30.605 ********

TASK [kubernetes/preinstall : Stop if unknown network plugin] **********************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node2] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node3] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:04 -0500 (0:00:00.043)       0:02:30.649 ********

TASK [kubernetes/preinstall : Stop if unsupported version of Kubernetes] ***********************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node2] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node3] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:04 -0500 (0:00:00.054)       0:02:30.703 ********

TASK [kubernetes/preinstall : Stop if known booleans are set as strings (Use JSON format on CLI: -e "{'key': true }")] ***
ok: [node1] => (item={'name': 'download_run_once', 'value': False}) => {
    "ansible_loop_var": "item",
    "changed": false,
    "item": {
        "name": "download_run_once",
        "value": false
    },
    "msg": "All assertions passed"
}
ok: [node1] => (item={'name': 'deploy_netchecker', 'value': False}) => {
    "ansible_loop_var": "item",
    "changed": false,
    "item": {
        "name": "deploy_netchecker",
        "value": false
    },
    "msg": "All assertions passed"
}
ok: [node1] => (item={'name': 'download_always_pull', 'value': False}) => {
    "ansible_loop_var": "item",
    "changed": false,
    "item": {
        "name": "download_always_pull",
        "value": false
    },
    "msg": "All assertions passed"
}
ok: [node1] => (item={'name': 'helm_enabled', 'value': False}) => {
    "ansible_loop_var": "item",
    "changed": false,
    "item": {
        "name": "helm_enabled",
        "value": false
    },
    "msg": "All assertions passed"
}
ok: [node1] => (item={'name': 'openstack_lbaas_enabled', 'value': False}) => {
    "ansible_loop_var": "item",
    "changed": false,
    "item": {
        "name": "openstack_lbaas_enabled",
        "value": false
    },
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:04 -0500 (0:00:00.061)       0:02:30.765 ********

TASK [kubernetes/preinstall : Stop if even number of etcd hosts] *******************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:04 -0500 (0:00:00.036)       0:02:30.802 ********

TASK [kubernetes/preinstall : Stop if memory is too small for masters] *************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:04 -0500 (0:00:00.060)       0:02:30.863 ********

TASK [kubernetes/preinstall : Stop if memory is too small for nodes] ***************************************************
ok: [node2] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node3] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:04 -0500 (0:00:00.043)       0:02:30.906 ********
Monday 09 January 2023  14:53:04 -0500 (0:00:00.037)       0:02:30.945 ********
Monday 09 January 2023  14:53:04 -0500 (0:00:00.036)       0:02:30.981 ********
Monday 09 January 2023  14:53:04 -0500 (0:00:00.034)       0:02:31.015 ********
Monday 09 January 2023  14:53:04 -0500 (0:00:00.034)       0:02:31.050 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.031)       0:02:31.081 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.035)       0:02:31.117 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.036)       0:02:31.153 ********

TASK [kubernetes/preinstall : Stop if bad hostname] ********************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node2] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node3] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:05 -0500 (0:00:00.040)       0:02:31.194 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.038)       0:02:31.232 ********

TASK [kubernetes/preinstall : Check that kube_service_addresses is a network range] ************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:05 -0500 (0:00:00.045)       0:02:31.278 ********

TASK [kubernetes/preinstall : Check that kube_pods_subnet is a network range] ******************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:05 -0500 (0:00:00.046)       0:02:31.324 ********

TASK [kubernetes/preinstall : Check that kube_pods_subnet does not collide with kube_service_addresses] ****************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:05 -0500 (0:00:00.052)       0:02:31.377 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.012)       0:02:31.389 ********

TASK [kubernetes/preinstall : Stop if unknown dns mode] ****************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:05 -0500 (0:00:00.024)       0:02:31.413 ********

TASK [kubernetes/preinstall : Stop if unknown kube proxy mode] *********************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:05 -0500 (0:00:00.022)       0:02:31.435 ********

TASK [kubernetes/preinstall : Stop if unknown cert_management] *********************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:05 -0500 (0:00:00.023)       0:02:31.459 ********

TASK [kubernetes/preinstall : Stop if unknown resolvconf_mode] *********************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:05 -0500 (0:00:00.023)       0:02:31.483 ********

TASK [kubernetes/preinstall : Stop if etcd deployment type is not host, docker or kubeadm] *****************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:05 -0500 (0:00:00.037)       0:02:31.521 ********

TASK [kubernetes/preinstall : Stop if container manager is not docker, crio or containerd] *****************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:05 -0500 (0:00:00.023)       0:02:31.545 ********

TASK [kubernetes/preinstall : Stop if etcd deployment type is not host or kubeadm when container_manager != docker] ****
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:05 -0500 (0:00:00.033)       0:02:31.578 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.018)       0:02:31.597 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.015)       0:02:31.613 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.031)       0:02:31.645 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.031)       0:02:31.676 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.031)       0:02:31.708 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.031)       0:02:31.739 ********

TASK [kubernetes/preinstall : Ensure minimum containerd version] *******************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:05 -0500 (0:00:00.024)       0:02:31.763 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.034)       0:02:31.798 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.034)       0:02:31.832 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.035)       0:02:31.868 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.034)       0:02:31.903 ********
Monday 09 January 2023  14:53:05 -0500 (0:00:00.032)       0:02:31.936 ********

TASK [kubernetes/preinstall : check if booted with ostree] *************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:53:08 -0500 (0:00:02.339)       0:02:34.276 ********

TASK [kubernetes/preinstall : set is_fedora_coreos] ********************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:53:10 -0500 (0:00:02.634)       0:02:36.911 ********

TASK [kubernetes/preinstall : set is_fedora_coreos] ********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:53:10 -0500 (0:00:00.042)       0:02:36.953 ********

TASK [kubernetes/preinstall : check resolvconf] ************************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:53:13 -0500 (0:00:02.858)       0:02:39.812 ********

TASK [kubernetes/preinstall : check existence of /etc/resolvconf/resolv.conf.d] ****************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:53:15 -0500 (0:00:02.201)       0:02:42.014 ********

TASK [kubernetes/preinstall : check status of /etc/resolv.conf] ********************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:53:18 -0500 (0:00:02.114)       0:02:44.129 ********

TASK [kubernetes/preinstall : get content of /etc/resolv.conf] *********************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:53:20 -0500 (0:00:01.996)       0:02:46.125 ********

TASK [kubernetes/preinstall : get currently configured nameservers] ****************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:53:20 -0500 (0:00:00.074)       0:02:46.199 ********

TASK [kubernetes/preinstall : Stop if /etc/resolv.conf not configured nameservers] *************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node2] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node3] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:53:20 -0500 (0:00:00.047)       0:02:46.247 ********

TASK [kubernetes/preinstall : NetworkManager | Check if host has NetworkManager] ***************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:53:22 -0500 (0:00:02.488)       0:02:48.735 ********

TASK [kubernetes/preinstall : check systemd-resolved] ******************************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  14:53:24 -0500 (0:00:02.209)       0:02:50.945 ********

TASK [kubernetes/preinstall : set default dns if remove_default_searchdomains is false] ********************************
ok: [node1]
ok: [node3]
ok: [node2]
ok: [node4]
Monday 09 January 2023  14:53:24 -0500 (0:00:00.042)       0:02:50.987 ********

TASK [kubernetes/preinstall : set dns facts] ***************************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:53:24 -0500 (0:00:00.042)       0:02:51.029 ********

TASK [kubernetes/preinstall : check if kubelet is configured] **********************************************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:53:27 -0500 (0:00:02.289)       0:02:53.318 ********

TASK [kubernetes/preinstall : check if early DNS configuration stage] **************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:53:27 -0500 (0:00:00.037)       0:02:53.356 ********

TASK [kubernetes/preinstall : target resolv.conf files] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:53:27 -0500 (0:00:00.039)       0:02:53.396 ********
Monday 09 January 2023  14:53:27 -0500 (0:00:00.029)       0:02:53.425 ********

TASK [kubernetes/preinstall : check if /etc/dhclient.conf exists] ******************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:53:29 -0500 (0:00:02.282)       0:02:55.708 ********
Monday 09 January 2023  14:53:29 -0500 (0:00:00.030)       0:02:55.739 ********

TASK [kubernetes/preinstall : check if /etc/dhcp/dhclient.conf exists] *************************************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:53:32 -0500 (0:00:02.414)       0:02:58.153 ********

TASK [kubernetes/preinstall : target dhclient conf file for /etc/dhcp/dhclient.conf] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:53:32 -0500 (0:00:00.038)       0:02:58.191 ********
Monday 09 January 2023  14:53:32 -0500 (0:00:00.029)       0:02:58.221 ********

TASK [kubernetes/preinstall : target dhclient hook file for Debian family] *********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:53:32 -0500 (0:00:00.038)       0:02:58.260 ********

TASK [kubernetes/preinstall : generate search domains to resolvconf] ***************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:53:32 -0500 (0:00:00.038)       0:02:58.299 ********

TASK [kubernetes/preinstall : pick coredns cluster IP or default resolver] *********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:53:32 -0500 (0:00:00.074)       0:02:58.373 ********
Monday 09 January 2023  14:53:32 -0500 (0:00:00.028)       0:02:58.402 ********

TASK [kubernetes/preinstall : generate nameservers for resolvconf, not including cluster DNS] **************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:53:32 -0500 (0:00:00.059)       0:02:58.461 ********

TASK [kubernetes/preinstall : gather os specific variables] ************************************************************
ok: [node1] => (item=/root/13.5/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
ok: [node2] => (item=/root/13.5/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
ok: [node3] => (item=/root/13.5/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
ok: [node4] => (item=/root/13.5/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
Monday 09 January 2023  14:53:32 -0500 (0:00:00.045)       0:02:58.506 ********
Monday 09 January 2023  14:53:32 -0500 (0:00:00.031)       0:02:58.537 ********

TASK [kubernetes/preinstall : check /usr readonly] *********************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:53:34 -0500 (0:00:02.434)       0:03:00.972 ********
Monday 09 January 2023  14:53:34 -0500 (0:00:00.027)       0:03:01.015 ********
Monday 09 January 2023  14:53:34 -0500 (0:00:00.031)       0:03:01.047 ********
Monday 09 January 2023  14:53:35 -0500 (0:00:00.029)       0:03:01.076 ********

TASK [kubernetes/preinstall : Create kubernetes directories] ***********************************************************
changed: [node2] => (item=/etc/kubernetes)
changed: [node3] => (item=/etc/kubernetes)
changed: [node2] => (item=/etc/kubernetes/ssl)
changed: [node4] => (item=/etc/kubernetes)
changed: [node3] => (item=/etc/kubernetes/ssl)
changed: [node2] => (item=/etc/kubernetes/manifests)
changed: [node3] => (item=/etc/kubernetes/manifests)
changed: [node2] => (item=/usr/local/bin/kubernetes-scripts)
changed: [node1] => (item=/etc/kubernetes)
changed: [node4] => (item=/etc/kubernetes/ssl)
changed: [node2] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
changed: [node3] => (item=/usr/local/bin/kubernetes-scripts)
changed: [node3] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
changed: [node4] => (item=/etc/kubernetes/manifests)
changed: [node1] => (item=/etc/kubernetes/ssl)
changed: [node4] => (item=/usr/local/bin/kubernetes-scripts)
changed: [node4] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
changed: [node1] => (item=/etc/kubernetes/manifests)
changed: [node1] => (item=/usr/local/bin/kubernetes-scripts)
changed: [node1] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
Monday 09 January 2023  14:53:46 -0500 (0:00:11.845)       0:03:12.923 ********

TASK [kubernetes/preinstall : Create other directories] ****************************************************************
ok: [node2] => (item=/usr/local/bin)
ok: [node3] => (item=/usr/local/bin)
ok: [node4] => (item=/usr/local/bin)
ok: [node1] => (item=/usr/local/bin)
Monday 09 January 2023  14:53:49 -0500 (0:00:02.293)       0:03:15.216 ********

TASK [kubernetes/preinstall : Check if kubernetes kubeadm compat cert dir exists] **************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:53:51 -0500 (0:00:02.175)       0:03:17.391 ********

TASK [kubernetes/preinstall : Create kubernetes kubeadm compat cert dir (kubernetes/kubeadm issue 1498)] ***************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:53:53 -0500 (0:00:02.232)       0:03:19.624 ********

TASK [kubernetes/preinstall : Create cni directories] ******************************************************************
changed: [node3] => (item=/etc/cni/net.d)
changed: [node2] => (item=/etc/cni/net.d)
changed: [node4] => (item=/etc/cni/net.d)
changed: [node3] => (item=/opt/cni/bin)
changed: [node2] => (item=/opt/cni/bin)
changed: [node1] => (item=/etc/cni/net.d)
changed: [node2] => (item=/var/lib/calico)
changed: [node3] => (item=/var/lib/calico)
changed: [node4] => (item=/opt/cni/bin)
changed: [node4] => (item=/var/lib/calico)
changed: [node1] => (item=/opt/cni/bin)
changed: [node1] => (item=/var/lib/calico)
Monday 09 January 2023  14:54:00 -0500 (0:00:06.856)       0:03:26.481 ********
Monday 09 January 2023  14:54:00 -0500 (0:00:00.037)       0:03:26.518 ********
Monday 09 January 2023  14:54:00 -0500 (0:00:00.034)       0:03:26.552 ********

TASK [kubernetes/preinstall : Add domain/search/nameservers/options to resolv.conf] ************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  14:54:03 -0500 (0:00:02.761)       0:03:29.313 ********

TASK [kubernetes/preinstall : Remove search/domain/nameserver options before block] ************************************
ok: [node3] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'options\\s'])
Monday 09 January 2023  14:54:13 -0500 (0:00:10.380)       0:03:39.694 ********

TASK [kubernetes/preinstall : Remove search/domain/nameserver options after block] *************************************
changed: [node3] => (item=['/etc/resolv.conf', 'search\\s'])
changed: [node2] => (item=['/etc/resolv.conf', 'search\\s'])
changed: [node4] => (item=['/etc/resolv.conf', 'search\\s'])
changed: [node3] => (item=['/etc/resolv.conf', 'nameserver\\s'])
changed: [node1] => (item=['/etc/resolv.conf', 'search\\s'])
changed: [node3] => (item=['/etc/resolv.conf', 'domain\\s'])
changed: [node2] => (item=['/etc/resolv.conf', 'nameserver\\s'])
changed: [node4] => (item=['/etc/resolv.conf', 'nameserver\\s'])
changed: [node2] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'options\\s'])
changed: [node4] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'options\\s'])
changed: [node1] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'options\\s'])
changed: [node1] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'options\\s'])
Monday 09 January 2023  14:54:22 -0500 (0:00:09.102)       0:03:48.796 ********
Monday 09 January 2023  14:54:22 -0500 (0:00:00.034)       0:03:48.830 ********
Monday 09 January 2023  14:54:22 -0500 (0:00:00.037)       0:03:48.868 ********
Monday 09 January 2023  14:54:22 -0500 (0:00:00.036)       0:03:48.904 ********
Monday 09 January 2023  14:54:22 -0500 (0:00:00.033)       0:03:48.938 ********
Monday 09 January 2023  14:54:22 -0500 (0:00:00.031)       0:03:48.970 ********
Monday 09 January 2023  14:54:22 -0500 (0:00:00.031)       0:03:49.001 ********
Monday 09 January 2023  14:54:22 -0500 (0:00:00.034)       0:03:49.035 ********
Monday 09 January 2023  14:54:22 -0500 (0:00:00.030)       0:03:49.066 ********
Monday 09 January 2023  14:54:23 -0500 (0:00:00.032)       0:03:49.099 ********
Monday 09 January 2023  14:54:23 -0500 (0:00:00.034)       0:03:49.133 ********
Monday 09 January 2023  14:54:23 -0500 (0:00:00.031)       0:03:49.164 ********
Monday 09 January 2023  14:54:23 -0500 (0:00:00.031)       0:03:49.196 ********
Monday 09 January 2023  14:54:23 -0500 (0:00:00.031)       0:03:49.228 ********

TASK [kubernetes/preinstall : Update package management cache (APT)] ***************************************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:54:28 -0500 (0:00:05.052)       0:03:54.280 ********
Monday 09 January 2023  14:54:28 -0500 (0:00:00.035)       0:03:54.316 ********
Monday 09 January 2023  14:54:28 -0500 (0:00:00.032)       0:03:54.348 ********
Monday 09 January 2023  14:54:28 -0500 (0:00:00.031)       0:03:54.380 ********

TASK [kubernetes/preinstall : Update common_required_pkgs with ipvsadm when kube_proxy_mode is ipvs] *******************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:54:28 -0500 (0:00:00.042)       0:03:54.423 ********

TASK [kubernetes/preinstall : Install packages requirements] ***********************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:57:17 -0500 (0:02:49.153)       0:06:43.576 ********
Monday 09 January 2023  14:57:17 -0500 (0:00:00.036)       0:06:43.613 ********
Monday 09 January 2023  14:57:17 -0500 (0:00:00.034)       0:06:43.648 ********
Monday 09 January 2023  14:57:17 -0500 (0:00:00.033)       0:06:43.682 ********
Monday 09 January 2023  14:57:17 -0500 (0:00:00.037)       0:06:43.720 ********

TASK [kubernetes/preinstall : Clean previously used sysctl file locations] *********************************************
ok: [node3] => (item=ipv4-ip_forward.conf)
ok: [node2] => (item=ipv4-ip_forward.conf)
ok: [node4] => (item=ipv4-ip_forward.conf)
ok: [node1] => (item=ipv4-ip_forward.conf)
ok: [node2] => (item=bridge-nf-call.conf)
ok: [node3] => (item=bridge-nf-call.conf)
ok: [node4] => (item=bridge-nf-call.conf)
ok: [node1] => (item=bridge-nf-call.conf)
Monday 09 January 2023  14:57:21 -0500 (0:00:03.607)       0:06:47.328 ********

TASK [kubernetes/preinstall : Stat sysctl file configuration] **********************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:57:22 -0500 (0:00:01.737)       0:06:49.066 ********

TASK [kubernetes/preinstall : Change sysctl file path to link source if linked] ****************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:57:23 -0500 (0:00:00.046)       0:06:49.112 ********

TASK [kubernetes/preinstall : Make sure sysctl file path folder exists] ************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:57:24 -0500 (0:00:01.736)       0:06:50.849 ********

TASK [kubernetes/preinstall : Enable ip forwarding] ********************************************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:57:27 -0500 (0:00:02.787)       0:06:53.636 ********
Monday 09 January 2023  14:57:27 -0500 (0:00:00.032)       0:06:53.669 ********

TASK [kubernetes/preinstall : Check if we need to set fs.may_detach_mounts] ********************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:57:29 -0500 (0:00:01.868)       0:06:55.538 ********
Monday 09 January 2023  14:57:29 -0500 (0:00:00.038)       0:06:55.576 ********

TASK [kubernetes/preinstall : Ensure kube-bench parameters are set] ****************************************************
changed: [node3] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
changed: [node2] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
changed: [node4] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
changed: [node2] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
changed: [node3] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
changed: [node2] => (item={'name': 'kernel.panic', 'value': 10})
changed: [node4] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
changed: [node1] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
changed: [node3] => (item={'name': 'kernel.panic', 'value': 10})
changed: [node2] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
changed: [node4] => (item={'name': 'kernel.panic', 'value': 10})
changed: [node2] => (item={'name': 'vm.overcommit_memory', 'value': 1})
changed: [node3] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
changed: [node2] => (item={'name': 'vm.panic_on_oom', 'value': 0})
changed: [node4] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
changed: [node3] => (item={'name': 'vm.overcommit_memory', 'value': 1})
changed: [node1] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
changed: [node3] => (item={'name': 'vm.panic_on_oom', 'value': 0})
changed: [node4] => (item={'name': 'vm.overcommit_memory', 'value': 1})
changed: [node4] => (item={'name': 'vm.panic_on_oom', 'value': 0})
changed: [node1] => (item={'name': 'kernel.panic', 'value': 10})
changed: [node1] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
changed: [node1] => (item={'name': 'vm.overcommit_memory', 'value': 1})
changed: [node1] => (item={'name': 'vm.panic_on_oom', 'value': 0})
Monday 09 January 2023  14:57:45 -0500 (0:00:16.055)       0:07:11.632 ********

TASK [kubernetes/preinstall : Check dummy module] **********************************************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  14:57:48 -0500 (0:00:02.597)       0:07:14.230 ********
Monday 09 January 2023  14:57:48 -0500 (0:00:00.041)       0:07:14.271 ********
Monday 09 January 2023  14:57:48 -0500 (0:00:00.041)       0:07:14.313 ********
Monday 09 January 2023  14:57:48 -0500 (0:00:00.043)       0:07:14.357 ********
Monday 09 January 2023  14:57:48 -0500 (0:00:00.047)       0:07:14.404 ********
Monday 09 January 2023  14:57:48 -0500 (0:00:00.039)       0:07:14.444 ********
Monday 09 January 2023  14:57:48 -0500 (0:00:00.036)       0:07:14.481 ********
Monday 09 January 2023  14:57:48 -0500 (0:00:00.037)       0:07:14.518 ********
Monday 09 January 2023  14:57:48 -0500 (0:00:00.036)       0:07:14.555 ********
Monday 09 January 2023  14:57:48 -0500 (0:00:00.040)       0:07:14.596 ********
Monday 09 January 2023  14:57:48 -0500 (0:00:00.046)       0:07:14.643 ********

TASK [kubernetes/preinstall : Hosts | create list from inventory] ******************************************************
ok: [node1 -> localhost]
Monday 09 January 2023  14:57:48 -0500 (0:00:00.117)       0:07:14.760 ********

TASK [kubernetes/preinstall : Hosts | populate inventory into hosts file] **********************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:57:50 -0500 (0:00:01.917)       0:07:16.677 ********
Monday 09 January 2023  14:57:50 -0500 (0:00:00.045)       0:07:16.723 ********

TASK [kubernetes/preinstall : Hosts | Retrieve hosts file content] *****************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  14:57:52 -0500 (0:00:01.833)       0:07:18.556 ********

TASK [kubernetes/preinstall : Hosts | Extract existing entries for localhost from hosts file] **************************
ok: [node1] => (item=127.0.0.1 localhost)
ok: [node4] => (item=127.0.0.1 localhost)
ok: [node2] => (item=127.0.0.1 localhost)
ok: [node4] => (item=::1 ip6-localhost ip6-loopback)
ok: [node3] => (item=127.0.0.1 localhost)
ok: [node1] => (item=::1 ip6-localhost ip6-loopback)
ok: [node2] => (item=::1 ip6-localhost ip6-loopback)
ok: [node3] => (item=::1 ip6-localhost ip6-loopback)
Monday 09 January 2023  14:57:52 -0500 (0:00:00.213)       0:07:18.770 ********

TASK [kubernetes/preinstall : Hosts | Update target hosts file entries dict with required entries] *********************
ok: [node1] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [node2] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [node1] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [node3] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [node2] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [node4] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [node3] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [node4] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
Monday 09 January 2023  14:57:52 -0500 (0:00:00.082)       0:07:18.852 ********

TASK [kubernetes/preinstall : Hosts | Update (if necessary) hosts file] ************************************************
changed: [node3] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [node2] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [node4] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [node3] => (item={'key': '::1', 'value': ['ip6-localhost', 'ip6-loopback', 'localhost6', 'localhost6.localdomain']})
changed: [node4] => (item={'key': '::1', 'value': ['ip6-localhost', 'ip6-loopback', 'localhost6', 'localhost6.localdomain']})
changed: [node2] => (item={'key': '::1', 'value': ['ip6-localhost', 'ip6-loopback', 'localhost6', 'localhost6.localdomain']})
changed: [node1] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [node1] => (item={'key': '::1', 'value': ['ip6-localhost', 'ip6-loopback', 'localhost6', 'localhost6.localdomain']})
Monday 09 January 2023  14:57:56 -0500 (0:00:04.056)       0:07:22.909 ********

TASK [kubernetes/preinstall : Update facts] ****************************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:58:01 -0500 (0:00:04.730)       0:07:27.639 ********

TASK [kubernetes/preinstall : Configure dhclient to supersede search/domain/nameservers] *******************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:58:03 -0500 (0:00:02.386)       0:07:30.025 ********

TASK [kubernetes/preinstall : Configure dhclient hooks for resolv.conf (non-RH)] ***************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:58:07 -0500 (0:00:04.026)       0:07:34.052 ********
Monday 09 January 2023  14:58:08 -0500 (0:00:00.048)       0:07:34.101 ********
Monday 09 January 2023  14:58:08 -0500 (0:00:00.044)       0:07:34.146 ********
Monday 09 January 2023  14:58:08 -0500 (0:00:00.060)       0:07:34.206 ********
Monday 09 January 2023  14:58:08 -0500 (0:00:00.000)       0:07:34.206 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | propagate resolvconf to k8s components] **************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:58:10 -0500 (0:00:02.190)       0:07:36.397 ********
Monday 09 January 2023  14:58:10 -0500 (0:00:00.071)       0:07:36.469 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | kube-apiserver configured] ***************************************
ok: [node1]
Monday 09 January 2023  14:58:12 -0500 (0:00:01.877)       0:07:38.346 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | kube-controller configured] **************************************
ok: [node1]
Monday 09 January 2023  14:58:13 -0500 (0:00:01.725)       0:07:40.072 ********
Monday 09 January 2023  14:58:14 -0500 (0:00:00.039)       0:07:40.112 ********
Monday 09 January 2023  14:58:14 -0500 (0:00:00.043)       0:07:40.156 ********
Monday 09 January 2023  14:58:14 -0500 (0:00:00.042)       0:07:40.199 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | restart kube-apiserver crio/containerd] **************************
changed: [node1]
Monday 09 January 2023  14:58:16 -0500 (0:00:01.937)       0:07:42.136 ********
Monday 09 January 2023  14:58:16 -0500 (0:00:00.046)       0:07:42.182 ********

TASK [kubernetes/preinstall : Check if we are running inside a Azure VM] ***********************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:58:18 -0500 (0:00:01.943)       0:07:44.126 ********
Monday 09 January 2023  14:58:18 -0500 (0:00:00.041)       0:07:44.167 ********
Monday 09 January 2023  14:58:18 -0500 (0:00:00.045)       0:07:44.212 ********
Monday 09 January 2023  14:58:18 -0500 (0:00:00.040)       0:07:44.253 ********
Monday 09 January 2023  14:58:18 -0500 (0:00:00.041)       0:07:44.294 ********
Monday 09 January 2023  14:58:18 -0500 (0:00:00.039)       0:07:44.334 ********
Monday 09 January 2023  14:58:18 -0500 (0:00:00.037)       0:07:44.371 ********
Monday 09 January 2023  14:58:18 -0500 (0:00:00.039)       0:07:44.411 ********

TASK [Run calico checks] ***********************************************************************************************
Monday 09 January 2023  14:58:18 -0500 (0:00:00.391)       0:07:44.802 ********

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (ipip)] ******************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:58:18 -0500 (0:00:00.033)       0:07:44.836 ********

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (ipip_mode)] *************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:58:18 -0500 (0:00:00.036)       0:07:44.873 ********

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (calcio_ipam_autoallocateblocks)] ****
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:58:18 -0500 (0:00:00.024)       0:07:44.902 ********
Monday 09 January 2023  14:58:18 -0500 (0:00:00.020)       0:07:44.923 ********

TASK [network_plugin/calico : Stop if supported Calico versions] *******************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:58:18 -0500 (0:00:00.033)       0:07:44.956 ********
ASYNC FAILED on node1: jid=626284352350.8075

TASK [network_plugin/calico : Get current calico cluster version] ******************************************************
ok: [node1]
Monday 09 January 2023  14:58:26 -0500 (0:00:07.631)       0:07:52.588 ********
Monday 09 January 2023  14:58:26 -0500 (0:00:00.022)       0:07:52.611 ********
Monday 09 January 2023  14:58:26 -0500 (0:00:00.021)       0:07:52.633 ********
Monday 09 January 2023  14:58:26 -0500 (0:00:00.019)       0:07:52.652 ********

TASK [network_plugin/calico : Check vars defined correctly] ************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:58:26 -0500 (0:00:00.031)       0:07:52.684 ********

TASK [network_plugin/calico : Check calico network backend defined correctly] ******************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:58:26 -0500 (0:00:00.029)       0:07:52.714 ********

TASK [network_plugin/calico : Check ipip and vxlan mode defined correctly] *********************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:58:26 -0500 (0:00:00.033)       0:07:52.748 ********
Monday 09 January 2023  14:58:26 -0500 (0:00:00.021)       0:07:52.769 ********

TASK [network_plugin/calico : Check ipip and vxlan mode if simultaneously enabled] *************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  14:58:26 -0500 (0:00:00.034)       0:07:52.804 ********

TASK [network_plugin/calico : Get Calico default-pool configuration] ***************************************************
ok: [node1]
Monday 09 January 2023  14:58:28 -0500 (0:00:01.345)       0:07:54.149 ********
Monday 09 January 2023  14:58:28 -0500 (0:00:00.023)       0:07:54.173 ********
Monday 09 January 2023  14:58:28 -0500 (0:00:00.019)       0:07:54.192 ********
Monday 09 January 2023  14:58:28 -0500 (0:00:00.018)       0:07:54.211 ********
Monday 09 January 2023  14:58:28 -0500 (0:00:00.018)       0:07:54.229 ********
Monday 09 January 2023  14:58:28 -0500 (0:00:00.047)       0:07:54.276 ********

TASK [container-engine/validate-container-engine : validate-container-engine | check if fedora coreos] *****************
ok: [node2]
ok: [node3]
ok: [node1]
ok: [node4]
Monday 09 January 2023  14:58:29 -0500 (0:00:01.762)       0:07:56.039 ********

TASK [container-engine/validate-container-engine : validate-container-engine | set is_ostree] **************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:58:30 -0500 (0:00:00.051)       0:07:56.091 ********

TASK [container-engine/validate-container-engine : Ensure kubelet systemd unit exists] *********************************
ok: [node2]
ok: [node3]
ok: [node1]
ok: [node4]
Monday 09 January 2023  14:58:32 -0500 (0:00:02.641)       0:07:58.733 ********

TASK [container-engine/validate-container-engine : Populate service facts] *********************************************
ok: [node2]
ok: [node3]
ok: [node1]
ok: [node4]
Monday 09 January 2023  14:58:47 -0500 (0:00:14.638)       0:08:13.372 ********

TASK [container-engine/validate-container-engine : Check if containerd is installed] ***********************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:58:49 -0500 (0:00:02.607)       0:08:15.979 ********

TASK [container-engine/validate-container-engine : Check if docker is installed] ***************************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:58:52 -0500 (0:00:02.542)       0:08:18.522 ********

TASK [container-engine/validate-container-engine : Check if crio is installed] *****************************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:58:54 -0500 (0:00:02.360)       0:08:20.882 ********
Monday 09 January 2023  14:58:54 -0500 (0:00:00.053)       0:08:20.936 ********
Monday 09 January 2023  14:58:54 -0500 (0:00:00.051)       0:08:20.988 ********
Monday 09 January 2023  14:58:54 -0500 (0:00:00.054)       0:08:21.042 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.055)       0:08:21.097 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.102)       0:08:21.200 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.058)       0:08:21.258 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.053)       0:08:21.311 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.052)       0:08:21.364 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.055)       0:08:21.419 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.052)       0:08:21.472 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.087)       0:08:21.560 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.086)       0:08:21.646 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.057)       0:08:21.704 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.098)       0:08:21.803 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.061)       0:08:21.864 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.089)       0:08:21.954 ********
Monday 09 January 2023  14:58:55 -0500 (0:00:00.051)       0:08:22.016 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.069)       0:08:22.086 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.061)       0:08:22.147 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.135)       0:08:22.283 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.065)       0:08:22.348 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.064)       0:08:22.413 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.065)       0:08:22.478 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.061)       0:08:22.540 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.111)       0:08:22.652 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.070)       0:08:22.722 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.057)       0:08:22.779 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.061)       0:08:22.840 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.053)       0:08:22.895 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.058)       0:08:22.953 ********
Monday 09 January 2023  14:58:56 -0500 (0:00:00.083)       0:08:23.036 ********
Monday 09 January 2023  14:58:57 -0500 (0:00:00.151)       0:08:23.188 ********
Monday 09 January 2023  14:58:57 -0500 (0:00:00.058)       0:08:23.247 ********
Monday 09 January 2023  14:58:57 -0500 (0:00:00.059)       0:08:23.306 ********
Monday 09 January 2023  14:58:57 -0500 (0:00:00.063)       0:08:23.370 ********
Monday 09 January 2023  14:58:57 -0500 (0:00:00.081)       0:08:23.451 ********
Monday 09 January 2023  14:58:57 -0500 (0:00:00.060)       0:08:23.511 ********
Monday 09 January 2023  14:58:57 -0500 (0:00:00.058)       0:08:23.570 ********
Monday 09 January 2023  14:58:57 -0500 (0:00:00.066)       0:08:23.637 ********
Monday 09 January 2023  14:58:57 -0500 (0:00:00.057)       0:08:23.694 ********
Monday 09 January 2023  14:58:57 -0500 (0:00:00.064)       0:08:23.759 ********
Monday 09 January 2023  14:58:57 -0500 (0:00:00.109)       0:08:23.869 ********
Monday 09 January 2023  14:58:57 -0500 (0:00:00.091)       0:08:23.960 ********
Monday 09 January 2023  14:58:57 -0500 (0:00:00.060)       0:08:24.021 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.060)       0:08:24.082 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.101)       0:08:24.184 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.057)       0:08:24.241 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.066)       0:08:24.308 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.054)       0:08:24.363 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.060)       0:08:24.423 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.062)       0:08:24.486 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.085)       0:08:24.572 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.060)       0:08:24.633 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.059)       0:08:24.692 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.060)       0:08:24.753 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.064)       0:08:24.817 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.080)       0:08:24.902 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.065)       0:08:24.967 ********
Monday 09 January 2023  14:58:58 -0500 (0:00:00.063)       0:08:25.031 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.060)       0:08:25.091 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.063)       0:08:25.155 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.068)       0:08:25.223 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.064)       0:08:25.288 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.068)       0:08:25.356 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.055)       0:08:25.411 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.082)       0:08:25.494 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.062)       0:08:25.556 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.131)       0:08:25.687 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.056)       0:08:25.744 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.055)       0:08:25.800 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.066)       0:08:25.867 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.066)       0:08:25.934 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.061)       0:08:25.995 ********
Monday 09 January 2023  14:58:59 -0500 (0:00:00.067)       0:08:26.062 ********
Monday 09 January 2023  14:59:00 -0500 (0:00:00.094)       0:08:26.156 ********
Monday 09 January 2023  14:59:00 -0500 (0:00:00.061)       0:08:26.217 ********
Monday 09 January 2023  14:59:00 -0500 (0:00:00.052)       0:08:26.270 ********
Monday 09 January 2023  14:59:00 -0500 (0:00:00.099)       0:08:26.370 ********
Monday 09 January 2023  14:59:00 -0500 (0:00:00.056)       0:08:26.427 ********
Monday 09 January 2023  14:59:00 -0500 (0:00:00.096)       0:08:26.523 ********
Monday 09 January 2023  14:59:00 -0500 (0:00:00.056)       0:08:26.580 ********
Monday 09 January 2023  14:59:00 -0500 (0:00:00.089)       0:08:26.670 ********
Monday 09 January 2023  14:59:00 -0500 (0:00:00.083)       0:08:26.757 ********
Monday 09 January 2023  14:59:00 -0500 (0:00:00.145)       0:08:26.903 ********
Monday 09 January 2023  14:59:00 -0500 (0:00:00.056)       0:08:26.959 ********
Monday 09 January 2023  14:59:00 -0500 (0:00:00.061)       0:08:27.021 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.065)       0:08:27.087 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.057)       0:08:27.144 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.099)       0:08:27.244 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.054)       0:08:27.299 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.053)       0:08:27.352 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.057)       0:08:27.410 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.054)       0:08:27.464 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.091)       0:08:27.555 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.054)       0:08:27.610 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.053)       0:08:27.664 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.060)       0:08:27.724 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.054)       0:08:27.779 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.059)       0:08:27.839 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.060)       0:08:27.899 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.057)       0:08:27.957 ********
Monday 09 January 2023  14:59:01 -0500 (0:00:00.056)       0:08:28.014 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.061)       0:08:28.075 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.061)       0:08:28.136 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.061)       0:08:28.198 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.061)       0:08:28.259 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.059)       0:08:28.319 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.055)       0:08:28.375 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.060)       0:08:28.436 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.058)       0:08:28.494 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.060)       0:08:28.555 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.063)       0:08:28.619 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.063)       0:08:28.683 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.062)       0:08:28.746 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.068)       0:08:28.814 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.040)       0:08:28.864 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.049)       0:08:28.913 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.051)       0:08:28.965 ********
Monday 09 January 2023  14:59:02 -0500 (0:00:00.063)       0:08:29.028 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.050)       0:08:29.079 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.057)       0:08:29.136 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.080)       0:08:29.216 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.057)       0:08:29.274 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.054)       0:08:29.328 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.051)       0:08:29.380 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.052)       0:08:29.433 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.070)       0:08:29.503 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.056)       0:08:29.560 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.060)       0:08:29.621 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.052)       0:08:29.673 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.052)       0:08:29.726 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.061)       0:08:29.787 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.069)       0:08:29.857 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.053)       0:08:29.910 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.056)       0:08:29.966 ********
Monday 09 January 2023  14:59:03 -0500 (0:00:00.087)       0:08:30.055 ********

TASK [container-engine/containerd-common : containerd-common | check if fedora coreos] *********************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:59:06 -0500 (0:00:02.389)       0:08:32.444 ********

TASK [container-engine/containerd-common : containerd-common | set is_ostree] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:59:06 -0500 (0:00:00.066)       0:08:32.511 ********

TASK [container-engine/containerd-common : containerd-common | gather os specific variables] ***************************
ok: [node1] => (item=/root/13.5/kubespray/roles/container-engine/containerd/vars/../vars/debian.yml)
ok: [node2] => (item=/root/13.5/kubespray/roles/container-engine/containerd/vars/../vars/debian.yml)
ok: [node3] => (item=/root/13.5/kubespray/roles/container-engine/containerd/vars/../vars/debian.yml)
ok: [node4] => (item=/root/13.5/kubespray/roles/container-engine/containerd/vars/../vars/debian.yml)
Monday 09 January 2023  14:59:06 -0500 (0:00:00.087)       0:08:32.629 ********

TASK [container-engine/runc : runc | check if fedora coreos] ***********************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Monday 09 January 2023  14:59:08 -0500 (0:00:02.435)       0:08:35.065 ********

TASK [container-engine/runc : runc | set is_ostree] ********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:59:09 -0500 (0:00:00.073)       0:08:35.138 ********

TASK [container-engine/runc : runc | Uninstall runc package managed by package manager] ********************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:59:15 -0500 (0:00:06.578)       0:08:41.717 ********

TASK [container-engine/runc : runc | Download runc binary] *************************************************************
included: /root/13.5/kubespray/roles/container-engine/runc/tasks/../../../download/tasks/download_file.yml for node1, node2, node3, node4
Monday 09 January 2023  14:59:15 -0500 (0:00:00.104)       0:08:41.821 ********

TASK [container-engine/runc : prep_download | Set a few facts] *********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:59:15 -0500 (0:00:00.073)       0:08:41.895 ********

TASK [container-engine/runc : download_file | Starting download of file] ***********************************************
ok: [node1] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64"
}
ok: [node2] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64"
}
ok: [node3] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64"
}
ok: [node4] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64"
}
Monday 09 January 2023  14:59:16 -0500 (0:00:00.347)       0:08:42.243 ********

TASK [container-engine/runc : download_file | Set pathname of cached file] *********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:59:16 -0500 (0:00:00.353)       0:08:42.596 ********

TASK [container-engine/runc : download_file | Create dest directory on node] *******************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:59:18 -0500 (0:00:02.432)       0:08:45.029 ********
Monday 09 January 2023  14:59:18 -0500 (0:00:00.033)       0:08:45.063 ********
Monday 09 January 2023  14:59:19 -0500 (0:00:00.281)       0:08:45.345 ********

TASK [container-engine/runc : download_file | Validate mirrors] ********************************************************
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  14:59:24 -0500 (0:00:05.186)       0:08:50.531 ********

TASK [container-engine/runc : download_file | Get the list of working mirrors] *****************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:59:24 -0500 (0:00:00.120)       0:08:50.651 ********

TASK [container-engine/runc : download_file | Download item] ***********************************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:59:31 -0500 (0:00:06.757)       0:08:57.409 ********
Monday 09 January 2023  14:59:31 -0500 (0:00:00.063)       0:08:57.472 ********
Monday 09 January 2023  14:59:31 -0500 (0:00:00.066)       0:08:57.538 ********
Monday 09 January 2023  14:59:31 -0500 (0:00:00.064)       0:08:57.603 ********

TASK [container-engine/runc : download_file | Extract file archives] ***************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Monday 09 January 2023  14:59:31 -0500 (0:00:00.115)       0:08:57.718 ********
Monday 09 January 2023  14:59:31 -0500 (0:00:00.340)       0:08:58.059 ********

TASK [container-engine/runc : Copy runc binary from download dir] ******************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:59:35 -0500 (0:00:03.262)       0:09:01.322 ********

TASK [container-engine/runc : runc | Remove orphaned binary] ***********************************************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:59:37 -0500 (0:00:02.402)       0:09:03.724 ********

TASK [container-engine/crictl : install crictĺ] ************************************************************************
included: /root/13.5/kubespray/roles/container-engine/crictl/tasks/crictl.yml for node1, node2, node3, node4
Monday 09 January 2023  14:59:37 -0500 (0:00:00.092)       0:09:03.817 ********

TASK [container-engine/crictl : crictl | Download crictl] **************************************************************
included: /root/13.5/kubespray/roles/container-engine/crictl/tasks/../../../download/tasks/download_file.yml for node1, node2, node3, node4
Monday 09 January 2023  14:59:37 -0500 (0:00:00.106)       0:09:03.923 ********

TASK [container-engine/crictl : prep_download | Set a few facts] *******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:59:37 -0500 (0:00:00.074)       0:09:03.997 ********

TASK [container-engine/crictl : download_file | Starting download of file] *********************************************
ok: [node1] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.25.0/crictl-v1.25.0-linux-amd64.tar.gz"
}
ok: [node2] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.25.0/crictl-v1.25.0-linux-amd64.tar.gz"
}
ok: [node4] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.25.0/crictl-v1.25.0-linux-amd64.tar.gz"
}
ok: [node3] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.25.0/crictl-v1.25.0-linux-amd64.tar.gz"
}
Monday 09 January 2023  14:59:38 -0500 (0:00:00.328)       0:09:04.326 ********

TASK [container-engine/crictl : download_file | Set pathname of cached file] *******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:59:38 -0500 (0:00:00.338)       0:09:04.665 ********

TASK [container-engine/crictl : download_file | Create dest directory on node] *****************************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Monday 09 January 2023  14:59:41 -0500 (0:00:03.140)       0:09:07.806 ********
Monday 09 January 2023  14:59:41 -0500 (0:00:00.038)       0:09:07.844 ********
Monday 09 January 2023  14:59:42 -0500 (0:00:00.300)       0:09:08.145 ********

TASK [container-engine/crictl : download_file | Validate mirrors] ******************************************************
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  14:59:46 -0500 (0:00:03.993)       0:09:12.139 ********

TASK [container-engine/crictl : download_file | Get the list of working mirrors] ***************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  14:59:46 -0500 (0:00:00.116)       0:09:12.256 ********

TASK [container-engine/crictl : download_file | Download item] *********************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Monday 09 January 2023  14:59:52 -0500 (0:00:06.102)       0:09:18.359 ********
Monday 09 January 2023  14:59:52 -0500 (0:00:00.063)       0:09:18.422 ********
Monday 09 January 2023  14:59:52 -0500 (0:00:00.055)       0:09:18.478 ********
Monday 09 January 2023  14:59:52 -0500 (0:00:00.061)       0:09:18.539 ********

TASK [container-engine/crictl : download_file | Extract file archives] *************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Monday 09 January 2023  14:59:52 -0500 (0:00:00.106)       0:09:18.645 ********

TASK [container-engine/crictl : extract_file | Unpacking archive] ******************************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  15:00:13 -0500 (0:00:20.913)       0:09:39.559 ********

TASK [container-engine/crictl : Install crictl config] *****************************************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  15:00:17 -0500 (0:00:04.350)       0:09:43.910 ********

TASK [container-engine/crictl : Copy crictl binary from download dir] **************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Monday 09 January 2023  15:00:21 -0500 (0:00:03.786)       0:09:47.696 ********

TASK [container-engine/nerdctl : nerdctl | Download nerdctl] ***********************************************************
included: /root/13.5/kubespray/roles/container-engine/nerdctl/tasks/../../../download/tasks/download_file.yml for node1, node2, node3, node4
Monday 09 January 2023  15:00:21 -0500 (0:00:00.069)       0:09:47.775 ********

TASK [container-engine/nerdctl : prep_download | Set a few facts] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:00:21 -0500 (0:00:00.054)       0:09:47.830 ********

TASK [container-engine/nerdctl : download_file | Starting download of file] ********************************************
ok: [node1] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.0.0/nerdctl-1.0.0-linux-amd64.tar.gz"
}
ok: [node2] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.0.0/nerdctl-1.0.0-linux-amd64.tar.gz"
}
ok: [node3] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.0.0/nerdctl-1.0.0-linux-amd64.tar.gz"
}
ok: [node4] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.0.0/nerdctl-1.0.0-linux-amd64.tar.gz"
}
Monday 09 January 2023  15:00:22 -0500 (0:00:00.291)       0:09:48.121 ********

TASK [container-engine/nerdctl : download_file | Set pathname of cached file] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:00:22 -0500 (0:00:00.288)       0:09:48.410 ********

TASK [container-engine/nerdctl : download_file | Create dest directory on node] ****************************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:00:26 -0500 (0:00:04.066)       0:09:52.476 ********
Monday 09 January 2023  15:00:26 -0500 (0:00:00.031)       0:09:52.508 ********
Monday 09 January 2023  15:00:26 -0500 (0:00:00.267)       0:09:52.776 ********

TASK [container-engine/nerdctl : download_file | Validate mirrors] *****************************************************
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:00:32 -0500 (0:00:06.215)       0:09:58.992 ********

TASK [container-engine/nerdctl : download_file | Get the list of working mirrors] **************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:00:33 -0500 (0:00:00.114)       0:09:59.107 ********

TASK [container-engine/nerdctl : download_file | Download item] ********************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Monday 09 January 2023  15:00:42 -0500 (0:00:09.549)       0:10:08.656 ********
Monday 09 January 2023  15:00:42 -0500 (0:00:00.061)       0:10:08.717 ********
Monday 09 January 2023  15:00:42 -0500 (0:00:00.055)       0:10:08.773 ********
Monday 09 January 2023  15:00:42 -0500 (0:00:00.058)       0:10:08.833 ********

TASK [container-engine/nerdctl : download_file | Extract file archives] ************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Monday 09 January 2023  15:00:42 -0500 (0:00:00.095)       0:10:08.928 ********

TASK [container-engine/nerdctl : extract_file | Unpacking archive] *****************************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  15:00:59 -0500 (0:00:16.899)       0:10:25.828 ********

TASK [container-engine/nerdctl : nerdctl | Copy nerdctl binary from download dir] **************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:01:04 -0500 (0:00:04.803)       0:10:30.631 ********

TASK [container-engine/nerdctl : nerdctl | Create configuration dir] ***************************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:01:08 -0500 (0:00:03.596)       0:10:34.228 ********

TASK [container-engine/nerdctl : nerdctl | Install nerdctl configuration] **********************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:01:14 -0500 (0:00:06.049)       0:10:40.277 ********
Monday 09 January 2023  15:01:14 -0500 (0:00:00.048)       0:10:40.326 ********

TASK [container-engine/containerd : containerd | Remove any package manager controlled containerd package] *************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:01:20 -0500 (0:00:06.469)       0:10:46.795 ********
Monday 09 January 2023  15:01:20 -0500 (0:00:00.046)       0:10:46.842 ********

TASK [container-engine/containerd : containerd | Remove containerd repository] *****************************************
ok: [node2] => (item=deb https://download.docker.com/linux/debian bullseye stable
)
ok: [node3] => (item=deb https://download.docker.com/linux/debian bullseye stable
)
ok: [node4] => (item=deb https://download.docker.com/linux/debian bullseye stable
)
ok: [node1] => (item=deb https://download.docker.com/linux/debian bullseye stable
)
Monday 09 January 2023  15:01:26 -0500 (0:00:05.547)       0:10:52.390 ********

TASK [container-engine/containerd : containerd | Download containerd] **************************************************
included: /root/13.5/kubespray/roles/container-engine/containerd/tasks/../../../download/tasks/download_file.yml for node1, node2, node3, node4
Monday 09 January 2023  15:01:26 -0500 (0:00:00.090)       0:10:52.481 ********

TASK [container-engine/containerd : prep_download | Set a few facts] ***************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:01:26 -0500 (0:00:00.059)       0:10:52.540 ********

TASK [container-engine/containerd : download_file | Starting download of file] *****************************************
ok: [node1] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-amd64.tar.gz"
}
ok: [node2] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-amd64.tar.gz"
}
ok: [node3] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-amd64.tar.gz"
}
ok: [node4] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-amd64.tar.gz"
}
Monday 09 January 2023  15:01:26 -0500 (0:00:00.298)       0:10:52.838 ********

TASK [container-engine/containerd : download_file | Set pathname of cached file] ***************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:01:27 -0500 (0:00:00.305)       0:10:53.144 ********

TASK [container-engine/containerd : download_file | Create dest directory on node] *************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:01:29 -0500 (0:00:02.761)       0:10:55.905 ********
Monday 09 January 2023  15:01:29 -0500 (0:00:00.028)       0:10:55.934 ********
Monday 09 January 2023  15:01:30 -0500 (0:00:00.253)       0:10:56.188 ********

TASK [container-engine/containerd : download_file | Validate mirrors] **************************************************
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:01:35 -0500 (0:00:05.318)       0:11:01.507 ********

TASK [container-engine/containerd : download_file | Get the list of working mirrors] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:01:35 -0500 (0:00:00.094)       0:11:01.602 ********

TASK [container-engine/containerd : download_file | Download item] *****************************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  15:01:51 -0500 (0:00:15.957)       0:11:17.559 ********
Monday 09 January 2023  15:01:51 -0500 (0:00:00.057)       0:11:17.617 ********
Monday 09 January 2023  15:01:51 -0500 (0:00:00.055)       0:11:17.673 ********
Monday 09 January 2023  15:01:51 -0500 (0:00:00.053)       0:11:17.726 ********

TASK [container-engine/containerd : download_file | Extract file archives] *********************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Monday 09 January 2023  15:01:51 -0500 (0:00:00.173)       0:11:17.900 ********
Monday 09 January 2023  15:01:52 -0500 (0:00:00.303)       0:11:18.203 ********

TASK [container-engine/containerd : containerd | Unpack containerd archive] ********************************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Monday 09 January 2023  15:02:31 -0500 (0:00:39.809)       0:11:58.013 ********

TASK [container-engine/containerd : containerd | Remove orphaned binary] ***********************************************
ok: [node4] => (item=containerd)
ok: [node2] => (item=containerd)
ok: [node3] => (item=containerd)
ok: [node4] => (item=containerd-shim)
ok: [node2] => (item=containerd-shim)
ok: [node4] => (item=containerd-shim-runc-v1)
ok: [node3] => (item=containerd-shim)
ok: [node2] => (item=containerd-shim-runc-v1)
ok: [node1] => (item=containerd)
ok: [node4] => (item=containerd-shim-runc-v2)
ok: [node2] => (item=containerd-shim-runc-v2)
ok: [node3] => (item=containerd-shim-runc-v1)
ok: [node4] => (item=ctr)
ok: [node2] => (item=ctr)
ok: [node3] => (item=containerd-shim-runc-v2)
ok: [node1] => (item=containerd-shim)
ok: [node3] => (item=ctr)
ok: [node1] => (item=containerd-shim-runc-v1)
ok: [node1] => (item=containerd-shim-runc-v2)
ok: [node1] => (item=ctr)
Monday 09 January 2023  15:02:43 -0500 (0:00:11.639)       0:12:09.652 ********

TASK [container-engine/containerd : containerd | Generate systemd service for containerd] ******************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Monday 09 January 2023  15:02:48 -0500 (0:00:04.929)       0:12:14.582 ********

TASK [container-engine/containerd : containerd | Ensure containerd directories exist] **********************************
changed: [node2] => (item=/etc/systemd/system/containerd.service.d)
changed: [node3] => (item=/etc/systemd/system/containerd.service.d)
changed: [node4] => (item=/etc/systemd/system/containerd.service.d)
changed: [node3] => (item=/etc/containerd)
changed: [node2] => (item=/etc/containerd)
changed: [node4] => (item=/etc/containerd)
changed: [node2] => (item=/var/lib/containerd)
changed: [node3] => (item=/var/lib/containerd)
changed: [node1] => (item=/etc/systemd/system/containerd.service.d)
changed: [node4] => (item=/var/lib/containerd)
changed: [node2] => (item=/run/containerd)
changed: [node3] => (item=/run/containerd)
changed: [node4] => (item=/run/containerd)
changed: [node1] => (item=/etc/containerd)
changed: [node1] => (item=/var/lib/containerd)
changed: [node1] => (item=/run/containerd)
Monday 09 January 2023  15:02:56 -0500 (0:00:07.504)       0:12:22.086 ********
Monday 09 January 2023  15:02:56 -0500 (0:00:00.054)       0:12:22.140 ********

TASK [container-engine/containerd : containerd | Generate default base_runtime_spec] ***********************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:02:58 -0500 (0:00:02.215)       0:12:24.356 ********

TASK [container-engine/containerd : containerd | Store generated default base_runtime_spec] ****************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:02:58 -0500 (0:00:00.064)       0:12:24.420 ********

TASK [container-engine/containerd : containerd | Write base_runtime_specs] *********************************************
changed: [node2] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.0.2-dev', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
changed: [node3] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.0.2-dev', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
changed: [node4] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.0.2-dev', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
changed: [node1] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.0.2-dev', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
Monday 09 January 2023  15:03:02 -0500 (0:00:03.880)       0:12:28.300 ********

TASK [container-engine/containerd : containerd | Copy containerd config file] ******************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:03:06 -0500 (0:00:03.930)       0:12:32.231 ********
[WARNING]: flush_handlers task does not support when conditional
Monday 09 January 2023  15:03:06 -0500 (0:00:00.000)       0:12:32.231 ********
Monday 09 January 2023  15:03:06 -0500 (0:00:00.057)       0:12:32.289 ********
Monday 09 January 2023  15:03:06 -0500 (0:00:00.053)       0:12:32.343 ********
Monday 09 January 2023  15:03:06 -0500 (0:00:00.051)       0:12:32.394 ********
Monday 09 January 2023  15:03:06 -0500 (0:00:00.050)       0:12:32.445 ********

RUNNING HANDLER [container-engine/containerd : restart containerd] *****************************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  15:03:08 -0500 (0:00:02.008)       0:12:34.454 ********

RUNNING HANDLER [container-engine/containerd : Containerd | restart containerd] ****************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  15:03:14 -0500 (0:00:06.195)       0:12:40.650 ********

RUNNING HANDLER [container-engine/containerd : Containerd | wait for containerd] ***************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:03:16 -0500 (0:00:02.403)       0:12:43.053 ********

TASK [container-engine/containerd : containerd | Ensure containerd is started and enabled] *****************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:03:21 -0500 (0:00:04.292)       0:12:47.345 ********
Monday 09 January 2023  15:03:21 -0500 (0:00:00.052)       0:12:47.398 ********
Monday 09 January 2023  15:03:21 -0500 (0:00:00.050)       0:12:47.449 ********
Monday 09 January 2023  15:03:21 -0500 (0:00:00.172)       0:12:47.626 ********
Monday 09 January 2023  15:03:21 -0500 (0:00:00.062)       0:12:47.689 ********
Monday 09 January 2023  15:03:21 -0500 (0:00:00.055)       0:12:47.744 ********
Monday 09 January 2023  15:03:21 -0500 (0:00:00.054)       0:12:47.798 ********
Monday 09 January 2023  15:03:21 -0500 (0:00:00.054)       0:12:47.853 ********
Monday 09 January 2023  15:03:21 -0500 (0:00:00.052)       0:12:47.905 ********
Monday 09 January 2023  15:03:21 -0500 (0:00:00.080)       0:12:47.988 ********
Monday 09 January 2023  15:03:21 -0500 (0:00:00.051)       0:12:48.040 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.055)       0:12:48.096 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.052)       0:12:48.149 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.076)       0:12:48.226 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.048)       0:12:48.278 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.052)       0:12:48.331 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.058)       0:12:48.390 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.054)       0:12:48.444 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.052)       0:12:48.497 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.053)       0:12:48.550 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.057)       0:12:48.607 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.054)       0:12:48.662 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.054)       0:12:48.717 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.055)       0:12:48.773 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.065)       0:12:48.839 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.053)       0:12:48.893 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.066)       0:12:48.959 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.050)       0:12:49.010 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.006)       0:12:49.016 ********
Monday 09 January 2023  15:03:22 -0500 (0:00:00.050)       0:12:49.067 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.052)       0:12:49.119 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.051)       0:12:49.171 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.053)       0:12:49.225 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.054)       0:12:49.279 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.050)       0:12:49.330 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.059)       0:12:49.390 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.052)       0:12:49.443 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.051)       0:12:49.494 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.007)       0:12:49.501 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.089)       0:12:49.591 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.053)       0:12:49.644 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.053)       0:12:49.698 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.062)       0:12:49.760 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.068)       0:12:49.829 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:03:23 -0500 (0:00:00.065)       0:12:49.894 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.026)       0:12:49.921 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.020)       0:12:49.941 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.056)       0:12:49.998 ********
Monday 09 January 2023  15:03:23 -0500 (0:00:00.056)       0:12:50.054 ********

TASK [download : prep_download | Register docker images info] **********************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:03:27 -0500 (0:00:03.264)       0:12:53.320 ********

TASK [download : prep_download | Create staging directory on remote node] **********************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:03:29 -0500 (0:00:02.387)       0:12:55.707 ********
Monday 09 January 2023  15:03:29 -0500 (0:00:00.021)       0:12:55.729 ********

TASK [download : download | Get kubeadm binary and list of required images] ********************************************
included: /root/13.5/kubespray/roles/download/tasks/prep_kubeadm_images.yml for node1
Monday 09 January 2023  15:03:29 -0500 (0:00:00.084)       0:12:55.813 ********
Monday 09 January 2023  15:03:30 -0500 (0:00:00.284)       0:12:56.098 ********

TASK [download : prep_kubeadm_images | Download kubeadm binary] ********************************************************
included: /root/13.5/kubespray/roles/download/tasks/download_file.yml for node1
Monday 09 January 2023  15:03:30 -0500 (0:00:00.292)       0:12:56.402 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
Monday 09 January 2023  15:03:30 -0500 (0:00:00.039)       0:12:56.442 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubeadm"
}
Monday 09 January 2023  15:03:30 -0500 (0:00:00.285)       0:12:56.727 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
Monday 09 January 2023  15:03:30 -0500 (0:00:00.282)       0:12:57.009 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
changed: [node1]
Monday 09 January 2023  15:03:33 -0500 (0:00:02.258)       0:12:59.268 ********
Monday 09 January 2023  15:03:33 -0500 (0:00:00.028)       0:12:59.296 ********
Monday 09 January 2023  15:03:33 -0500 (0:00:00.384)       0:12:59.681 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:03:36 -0500 (0:00:03.248)       0:13:02.930 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
Monday 09 January 2023  15:03:36 -0500 (0:00:00.045)       0:13:02.975 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node1]
Monday 09 January 2023  15:03:44 -0500 (0:00:07.602)       0:13:10.578 ********
Monday 09 January 2023  15:03:44 -0500 (0:00:00.031)       0:13:10.610 ********
Monday 09 January 2023  15:03:44 -0500 (0:00:00.034)       0:13:10.644 ********
Monday 09 January 2023  15:03:44 -0500 (0:00:00.032)       0:13:10.676 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1
Monday 09 January 2023  15:03:44 -0500 (0:00:00.056)       0:13:10.732 ********
Monday 09 January 2023  15:03:44 -0500 (0:00:00.281)       0:13:11.013 ********
[WARNING]: noop task does not support when conditional

TASK [download : prep_kubeadm_images | Create kubeadm config] **********************************************************
changed: [node1]
Monday 09 January 2023  15:03:49 -0500 (0:00:04.305)       0:13:15.320 ********

TASK [download : prep_kubeadm_images | Copy kubeadm binary from download dir to system path] ***************************
changed: [node1]
Monday 09 January 2023  15:03:52 -0500 (0:00:02.846)       0:13:18.167 ********

TASK [download : prep_kubeadm_images | Set kubeadm binary permissions] *************************************************
ok: [node1]
Monday 09 January 2023  15:03:53 -0500 (0:00:01.674)       0:13:19.842 ********

TASK [download : prep_kubeadm_images | Generate list of required images] ***********************************************
ok: [node1]
Monday 09 January 2023  15:03:56 -0500 (0:00:02.339)       0:13:22.182 ********

TASK [download : prep_kubeadm_images | Parse list of images] ***********************************************************
ok: [node1] => (item=registry.k8s.io/kube-apiserver:v1.25.5)
ok: [node1] => (item=registry.k8s.io/kube-controller-manager:v1.25.5)
ok: [node1] => (item=registry.k8s.io/kube-scheduler:v1.25.5)
ok: [node1] => (item=registry.k8s.io/kube-proxy:v1.25.5)
Monday 09 January 2023  15:03:56 -0500 (0:00:00.070)       0:13:22.252 ********

TASK [download : prep_kubeadm_images | Convert list of images to dict for later use] ***********************************
ok: [node1]
Monday 09 January 2023  15:03:56 -0500 (0:00:00.025)       0:13:22.278 ********

TASK [download : download | Download files / images] *******************************************************************
included: /root/13.5/kubespray/roles/download/tasks/download_file.yml for node3, node2, node4, node1 => (item={'key': 'cni', 'value': {'enabled': True, 'file': True, 'version': 'v1.1.1', 'dest': '/tmp/releases/cni-plugins-linux-amd64-v1.1.1.tgz', 'sha256': 'b275772da4026d2161bf8a8b41ed4786754c8a93ebfb6564006d5da7f23831e5', 'url': 'https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_file.yml for node3, node2, node4, node1 => (item={'key': 'kubeadm', 'value': {'enabled': True, 'file': True, 'version': 'v1.25.5', 'dest': '/tmp/releases/kubeadm-v1.25.5-amd64', 'sha256': 'af0b25c7a995c2d208ef0b9d24b70fe6f390ebb1e3987f4e0f548854ba9a3b87', 'url': 'https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubeadm', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_file.yml for node3, node2, node4, node1 => (item={'key': 'kubelet', 'value': {'enabled': True, 'file': True, 'version': 'v1.25.5', 'dest': '/tmp/releases/kubelet-v1.25.5-amd64', 'sha256': '16b23e1254830805b892cfccf2687eb3edb4ea54ffbadb8cc2eee6d3b1fab8e6', 'url': 'https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubelet', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_file.yml for node3, node2, node4, node1 => (item={'key': 'crictl', 'value': {'file': True, 'enabled': True, 'version': 'v1.25.0', 'dest': '/tmp/releases/crictl-v1.25.0-linux-amd64.tar.gz', 'sha256': '86ab210c007f521ac4cdcbcf0ae3fb2e10923e65f16de83e0e1db191a07f0235', 'url': 'https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.25.0/crictl-v1.25.0-linux-amd64.tar.gz', 'unarchive': True, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_file.yml for node3, node2, node4, node1 => (item={'key': 'runc', 'value': {'file': True, 'enabled': True, 'version': 'v1.1.4', 'dest': '/tmp/releases/runc', 'sha256': 'db772be63147a4e747b4fe286c7c16a2edc4a8458bd3092ea46aaee77750e8ce', 'url': 'https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_file.yml for node3, node2, node4, node1 => (item={'key': 'containerd', 'value': {'enabled': True, 'file': True, 'version': '1.6.15', 'dest': '/tmp/releases/containerd-1.6.15-linux-amd64.tar.gz', 'sha256': '191bb4f6e4afc237efc5c85b5866b6fdfed731bde12cceaa6017a9c7f8aeda02', 'url': 'https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-amd64.tar.gz', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_file.yml for node3, node2, node4, node1 => (item={'key': 'nerdctl', 'value': {'file': True, 'enabled': True, 'version': '1.0.0', 'dest': '/tmp/releases/nerdctl-1.0.0-linux-amd64.tar.gz', 'sha256': '3e993d714e6b88d1803a58d9ff5a00d121f0544c35efed3a3789e19d6ab36964', 'url': 'https://github.com/containerd/nerdctl/releases/download/v1.0.0/nerdctl-1.0.0-linux-amd64.tar.gz', 'unarchive': True, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_file.yml for node3, node2, node4, node1 => (item={'key': 'calicoctl', 'value': {'enabled': True, 'file': True, 'version': 'v3.24.5', 'dest': '/tmp/releases/calicoctl', 'sha256': '01e6c8a2371050f9edd0ade9dcde89da054e84d8e96bd4ba8cf82806c8d3e8e7', 'url': 'https://github.com/projectcalico/calico/releases/download/v3.24.5/calicoctl-linux-amd64', 'mirrors': ['https://github.com/projectcalico/calico/releases/download/v3.24.5/calicoctl-linux-amd64'], 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_container.yml for node3, node2, node4, node1 => (item={'key': 'calico_node', 'value': {'enabled': True, 'container': True, 'repo': 'quay.io/calico/node', 'tag': 'v3.24.5', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_container.yml for node3, node2, node4, node1 => (item={'key': 'calico_cni', 'value': {'enabled': True, 'container': True, 'repo': 'quay.io/calico/cni', 'tag': 'v3.24.5', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_container.yml for node3, node2, node4, node1 => (item={'key': 'calico_flexvol', 'value': {'enabled': True, 'container': True, 'repo': 'quay.io/calico/pod2daemon-flexvol', 'tag': 'v3.24.5', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_container.yml for node3, node2, node4, node1 => (item={'key': 'calico_policy', 'value': {'enabled': True, 'container': True, 'repo': 'quay.io/calico/kube-controllers', 'tag': 'v3.24.5', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_container.yml for node3, node2, node4, node1 => (item={'key': 'pod_infra', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/pause', 'tag': '3.7', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_container.yml for node3, node2, node4 => (item={'key': 'nginx', 'value': {'enabled': True, 'container': True, 'repo': 'docker.io/library/nginx', 'tag': '1.23.2-alpine', 'sha256': '', 'groups': ['kube_node']}})
included: /root/13.5/kubespray/roles/download/tasks/download_container.yml for node3, node2, node4, node1 => (item={'key': 'coredns', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/coredns/coredns', 'tag': 'v1.9.3', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_container.yml for node3, node2, node4, node1 => (item={'key': 'nodelocaldns', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/dns/k8s-dns-node-cache', 'tag': '1.21.1', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.5/kubespray/roles/download/tasks/download_container.yml for node3, node2, node4, node1 => (item={'key': 'kubeadm_kube-apiserver', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/kube-apiserver', 'tag': 'v1.25.5', 'groups': 'k8s_cluster'}})
included: /root/13.5/kubespray/roles/download/tasks/download_container.yml for node3, node2, node4, node1 => (item={'key': 'kubeadm_kube-controller-manager', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/kube-controller-manager', 'tag': 'v1.25.5', 'groups': 'k8s_cluster'}})
included: /root/13.5/kubespray/roles/download/tasks/download_container.yml for node3, node2, node4, node1 => (item={'key': 'kubeadm_kube-scheduler', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/kube-scheduler', 'tag': 'v1.25.5', 'groups': 'k8s_cluster'}})
included: /root/13.5/kubespray/roles/download/tasks/download_container.yml for node3, node2, node4, node1 => (item={'key': 'kubeadm_kube-proxy', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/kube-proxy', 'tag': 'v1.25.5', 'groups': 'k8s_cluster'}})
included: /root/13.5/kubespray/roles/download/tasks/download_file.yml for node1 => (item={'key': 'etcd', 'value': {'container': False, 'file': True, 'enabled': True, 'version': 'v3.5.6', 'dest': '/tmp/releases/etcd-v3.5.6-linux-amd64.tar.gz', 'repo': 'quay.io/coreos/etcd', 'tag': 'v3.5.6', 'sha256': '4db32e3bc06dd0999e2171f76a87c1cffed8369475ec7aa7abee9023635670fb', 'url': 'https://github.com/etcd-io/etcd/releases/download/v3.5.6/etcd-v3.5.6-linux-amd64.tar.gz', 'unarchive': True, 'owner': 'root', 'mode': '0755', 'groups': ['etcd']}})
included: /root/13.5/kubespray/roles/download/tasks/download_file.yml for node1 => (item={'key': 'kubectl', 'value': {'enabled': True, 'file': True, 'version': 'v1.25.5', 'dest': '/tmp/releases/kubectl-v1.25.5-amd64', 'sha256': '6a660cd44db3d4bfe1563f6689cbe2ffb28ee4baf3532e04fff2d7b909081c29', 'url': 'https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubectl', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['kube_control_plane']}})
included: /root/13.5/kubespray/roles/download/tasks/download_file.yml for node1 => (item={'key': 'calico_crds', 'value': {'file': True, 'enabled': True, 'version': 'v3.24.5', 'dest': '/tmp/releases/calico-v3.24.5-kdd-crds/v3.24.5.tar.gz', 'sha256': '10320b45ebcf4335703d692adacc96cdd3a27de62b4599238604bd7b0bedccc3', 'url': 'https://github.com/projectcalico/calico/archive/v3.24.5.tar.gz', 'unarchive': True, 'unarchive_extra_opts': ['--strip=3', '--wildcards', '*/libcalico-go/config/crd/'], 'owner': 'root', 'mode': '0755', 'groups': ['kube_control_plane']}})
included: /root/13.5/kubespray/roles/download/tasks/download_container.yml for node1 => (item={'key': 'dnsautoscaler', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/cpa/cluster-proportional-autoscaler-amd64', 'tag': '1.8.5', 'sha256': '', 'groups': ['kube_control_plane']}})
Monday 09 January 2023  15:03:57 -0500 (0:00:01.512)       0:13:23.791 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:03:57 -0500 (0:00:00.068)       0:13:23.859 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz"
}
ok: [node2] => {
    "msg": "https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz"
}
ok: [node3] => {
    "msg": "https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz"
}
ok: [node4] => {
    "msg": "https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz"
}
Monday 09 January 2023  15:03:57 -0500 (0:00:00.062)       0:13:23.922 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:03:57 -0500 (0:00:00.062)       0:13:23.985 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
changed: [node2]
changed: [node4]
changed: [node3]
ok: [node1]
Monday 09 January 2023  15:03:59 -0500 (0:00:01.891)       0:13:25.876 ********
Monday 09 January 2023  15:03:59 -0500 (0:00:00.031)       0:13:25.908 ********
Monday 09 January 2023  15:03:59 -0500 (0:00:00.033)       0:13:25.941 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:04:31 -0500 (0:00:32.036)       0:13:57.978 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:04:32 -0500 (0:00:00.114)       0:13:58.092 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  15:04:40 -0500 (0:00:08.885)       0:14:06.978 ********
Monday 09 January 2023  15:04:40 -0500 (0:00:00.057)       0:14:07.035 ********
Monday 09 January 2023  15:04:41 -0500 (0:00:00.057)       0:14:07.093 ********
Monday 09 January 2023  15:04:41 -0500 (0:00:00.057)       0:14:07.151 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Monday 09 January 2023  15:04:41 -0500 (0:00:00.106)       0:14:07.283 ********
Monday 09 January 2023  15:04:41 -0500 (0:00:00.065)       0:14:07.349 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:04:41 -0500 (0:00:00.068)       0:14:07.417 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubeadm"
}
ok: [node2] => {
    "msg": "https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubeadm"
}
ok: [node3] => {
    "msg": "https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubeadm"
}
ok: [node4] => {
    "msg": "https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubeadm"
}
Monday 09 January 2023  15:04:41 -0500 (0:00:00.082)       0:14:07.500 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:04:41 -0500 (0:00:00.071)       0:14:07.572 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:04:43 -0500 (0:00:02.385)       0:14:09.958 ********
Monday 09 January 2023  15:04:43 -0500 (0:00:00.027)       0:14:09.986 ********
Monday 09 January 2023  15:04:43 -0500 (0:00:00.031)       0:14:10.017 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:04:46 -0500 (0:00:02.652)       0:14:12.670 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:04:46 -0500 (0:00:00.109)       0:14:12.779 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node3]
changed: [node4]
changed: [node2]
ok: [node1]
Monday 09 January 2023  15:04:50 -0500 (0:00:03.917)       0:14:16.696 ********
Monday 09 January 2023  15:04:50 -0500 (0:00:00.055)       0:14:16.752 ********
Monday 09 January 2023  15:04:50 -0500 (0:00:00.057)       0:14:16.810 ********
Monday 09 January 2023  15:04:50 -0500 (0:00:00.050)       0:14:16.861 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Monday 09 January 2023  15:04:50 -0500 (0:00:00.118)       0:14:16.979 ********
Monday 09 January 2023  15:04:50 -0500 (0:00:00.060)       0:14:17.040 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:04:51 -0500 (0:00:00.061)       0:14:17.103 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubelet"
}
ok: [node2] => {
    "msg": "https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubelet"
}
ok: [node3] => {
    "msg": "https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubelet"
}
ok: [node4] => {
    "msg": "https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubelet"
}
Monday 09 January 2023  15:04:51 -0500 (0:00:00.058)       0:14:17.161 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:04:51 -0500 (0:00:00.070)       0:14:17.233 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:04:53 -0500 (0:00:02.351)       0:14:19.590 ********
Monday 09 January 2023  15:04:53 -0500 (0:00:00.027)       0:14:19.617 ********
Monday 09 January 2023  15:04:53 -0500 (0:00:00.020)       0:14:19.648 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:04:56 -0500 (0:00:02.758)       0:14:22.406 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:04:56 -0500 (0:00:00.195)       0:14:22.603 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node4]
changed: [node3]
changed: [node2]
changed: [node1]
Monday 09 January 2023  15:05:09 -0500 (0:00:13.059)       0:14:35.664 ********
Monday 09 January 2023  15:05:09 -0500 (0:00:00.057)       0:14:35.722 ********
Monday 09 January 2023  15:05:09 -0500 (0:00:00.054)       0:14:35.776 ********
Monday 09 January 2023  15:05:09 -0500 (0:00:00.057)       0:14:35.833 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Monday 09 January 2023  15:05:09 -0500 (0:00:00.121)       0:14:35.954 ********
Monday 09 January 2023  15:05:09 -0500 (0:00:00.056)       0:14:36.011 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:05:10 -0500 (0:00:00.066)       0:14:36.077 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.25.0/crictl-v1.25.0-linux-amd64.tar.gz"
}
ok: [node2] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.25.0/crictl-v1.25.0-linux-amd64.tar.gz"
}
ok: [node3] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.25.0/crictl-v1.25.0-linux-amd64.tar.gz"
}
ok: [node4] => {
    "msg": "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.25.0/crictl-v1.25.0-linux-amd64.tar.gz"
}
Monday 09 January 2023  15:05:10 -0500 (0:00:00.065)       0:14:36.143 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:05:10 -0500 (0:00:00.060)       0:14:36.204 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Monday 09 January 2023  15:05:11 -0500 (0:00:01.856)       0:14:38.060 ********
Monday 09 January 2023  15:05:12 -0500 (0:00:00.031)       0:14:38.092 ********
Monday 09 January 2023  15:05:12 -0500 (0:00:00.035)       0:14:38.128 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:05:15 -0500 (0:00:03.199)       0:14:41.327 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:05:15 -0500 (0:00:00.103)       0:14:41.431 ********

TASK [download : download_file | Download item] ************************************************************************
ok: [node4]
ok: [node3]
ok: [node2]
ok: [node1]
Monday 09 January 2023  15:05:18 -0500 (0:00:03.040)       0:14:44.472 ********
Monday 09 January 2023  15:05:18 -0500 (0:00:00.051)       0:14:44.524 ********
Monday 09 January 2023  15:05:18 -0500 (0:00:00.049)       0:14:44.574 ********
Monday 09 January 2023  15:05:18 -0500 (0:00:00.052)       0:14:44.626 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Monday 09 January 2023  15:05:18 -0500 (0:00:00.099)       0:14:44.738 ********

TASK [download : extract_file | Unpacking archive] *********************************************************************
ok: [node4]
ok: [node3]
ok: [node2]
ok: [node1]
Monday 09 January 2023  15:05:27 -0500 (0:00:09.319)       0:14:54.057 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:05:28 -0500 (0:00:00.062)       0:14:54.120 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64"
}
ok: [node2] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64"
}
ok: [node3] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64"
}
ok: [node4] => {
    "msg": "https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64"
}
Monday 09 January 2023  15:05:28 -0500 (0:00:00.062)       0:14:54.182 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:05:28 -0500 (0:00:00.063)       0:14:54.246 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node4]
ok: [node2]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:05:29 -0500 (0:00:01.789)       0:14:56.036 ********
Monday 09 January 2023  15:05:29 -0500 (0:00:00.026)       0:14:56.063 ********
Monday 09 January 2023  15:05:30 -0500 (0:00:00.037)       0:14:56.101 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:05:33 -0500 (0:00:03.011)       0:14:59.112 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:05:33 -0500 (0:00:00.115)       0:14:59.227 ********

TASK [download : download_file | Download item] ************************************************************************
ok: [node4]
ok: [node3]
ok: [node2]
ok: [node1]
Monday 09 January 2023  15:05:35 -0500 (0:00:02.775)       0:15:02.003 ********
Monday 09 January 2023  15:05:35 -0500 (0:00:00.062)       0:15:02.066 ********
Monday 09 January 2023  15:05:36 -0500 (0:00:00.140)       0:15:02.231 ********
Monday 09 January 2023  15:05:36 -0500 (0:00:00.056)       0:15:02.288 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Monday 09 January 2023  15:05:36 -0500 (0:00:00.108)       0:15:02.396 ********
Monday 09 January 2023  15:05:36 -0500 (0:00:00.059)       0:15:02.456 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:05:36 -0500 (0:00:00.065)       0:15:02.521 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-amd64.tar.gz"
}
ok: [node2] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-amd64.tar.gz"
}
ok: [node3] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-amd64.tar.gz"
}
ok: [node4] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-amd64.tar.gz"
}
Monday 09 January 2023  15:05:36 -0500 (0:00:00.065)       0:15:02.587 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:05:36 -0500 (0:00:00.068)       0:15:02.656 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:05:38 -0500 (0:00:02.334)       0:15:04.990 ********
Monday 09 January 2023  15:05:38 -0500 (0:00:00.027)       0:15:05.017 ********
Monday 09 January 2023  15:05:38 -0500 (0:00:00.031)       0:15:05.048 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:05:42 -0500 (0:00:03.366)       0:15:08.415 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:05:42 -0500 (0:00:00.104)       0:15:08.519 ********

TASK [download : download_file | Download item] ************************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:05:45 -0500 (0:00:03.116)       0:15:11.636 ********
Monday 09 January 2023  15:05:45 -0500 (0:00:00.052)       0:15:11.688 ********
Monday 09 January 2023  15:05:45 -0500 (0:00:00.053)       0:15:11.742 ********
Monday 09 January 2023  15:05:45 -0500 (0:00:00.049)       0:15:11.791 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Monday 09 January 2023  15:05:45 -0500 (0:00:00.113)       0:15:11.904 ********
Monday 09 January 2023  15:05:45 -0500 (0:00:00.063)       0:15:11.968 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:05:45 -0500 (0:00:00.062)       0:15:12.030 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.0.0/nerdctl-1.0.0-linux-amd64.tar.gz"
}
ok: [node2] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.0.0/nerdctl-1.0.0-linux-amd64.tar.gz"
}
ok: [node3] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.0.0/nerdctl-1.0.0-linux-amd64.tar.gz"
}
ok: [node4] => {
    "msg": "https://github.com/containerd/nerdctl/releases/download/v1.0.0/nerdctl-1.0.0-linux-amd64.tar.gz"
}
Monday 09 January 2023  15:05:46 -0500 (0:00:00.061)       0:15:12.092 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:05:46 -0500 (0:00:00.072)       0:15:12.164 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:05:48 -0500 (0:00:02.031)       0:15:14.196 ********
Monday 09 January 2023  15:05:48 -0500 (0:00:00.025)       0:15:14.224 ********
Monday 09 January 2023  15:05:48 -0500 (0:00:00.030)       0:15:14.255 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:05:52 -0500 (0:00:04.076)       0:15:18.332 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:05:52 -0500 (0:00:00.100)       0:15:18.433 ********

TASK [download : download_file | Download item] ************************************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:05:55 -0500 (0:00:02.849)       0:15:21.282 ********
Monday 09 January 2023  15:05:55 -0500 (0:00:00.061)       0:15:21.344 ********
Monday 09 January 2023  15:05:55 -0500 (0:00:00.064)       0:15:21.408 ********
Monday 09 January 2023  15:05:55 -0500 (0:00:00.057)       0:15:21.466 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Monday 09 January 2023  15:05:55 -0500 (0:00:00.120)       0:15:21.586 ********

TASK [download : extract_file | Unpacking archive] *********************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:06:06 -0500 (0:00:10.589)       0:15:32.176 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:06:06 -0500 (0:00:00.057)       0:15:32.234 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://github.com/projectcalico/calico/releases/download/v3.24.5/calicoctl-linux-amd64"
}
ok: [node2] => {
    "msg": "https://github.com/projectcalico/calico/releases/download/v3.24.5/calicoctl-linux-amd64"
}
ok: [node3] => {
    "msg": "https://github.com/projectcalico/calico/releases/download/v3.24.5/calicoctl-linux-amd64"
}
ok: [node4] => {
    "msg": "https://github.com/projectcalico/calico/releases/download/v3.24.5/calicoctl-linux-amd64"
}
Monday 09 January 2023  15:06:06 -0500 (0:00:00.060)       0:15:32.295 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:06:06 -0500 (0:00:00.061)       0:15:32.357 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:06:08 -0500 (0:00:02.171)       0:15:34.529 ********
Monday 09 January 2023  15:06:08 -0500 (0:00:00.031)       0:15:34.560 ********
Monday 09 January 2023  15:06:08 -0500 (0:00:00.033)       0:15:34.593 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:06:11 -0500 (0:00:03.316)       0:15:37.918 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:06:11 -0500 (0:00:00.099)       0:15:38.027 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node4]
changed: [node3]
changed: [node2]
changed: [node1]
Monday 09 January 2023  15:06:24 -0500 (0:00:12.371)       0:15:50.398 ********
Monday 09 January 2023  15:06:24 -0500 (0:00:00.054)       0:15:50.452 ********
Monday 09 January 2023  15:06:24 -0500 (0:00:00.050)       0:15:50.502 ********
Monday 09 January 2023  15:06:24 -0500 (0:00:00.058)       0:15:50.561 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Monday 09 January 2023  15:06:24 -0500 (0:00:00.092)       0:15:50.683 ********
Monday 09 January 2023  15:06:24 -0500 (0:00:00.060)       0:15:50.743 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:06:24 -0500 (0:00:00.058)       0:15:50.801 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node1] => {
    "msg": "quay.io/calico/node"
}
ok: [node2] => {
    "msg": "quay.io/calico/node"
}
ok: [node3] => {
    "msg": "quay.io/calico/node"
}
ok: [node4] => {
    "msg": "quay.io/calico/node"
}
Monday 09 January 2023  15:06:24 -0500 (0:00:00.067)       0:15:50.868 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:06:24 -0500 (0:00:00.071)       0:15:50.939 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:06:24 -0500 (0:00:00.066)       0:15:51.005 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:06:24 -0500 (0:00:00.064)       0:15:51.070 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:06:25 -0500 (0:00:00.065)       0:15:51.135 ********
Monday 09 January 2023  15:06:25 -0500 (0:00:00.052)       0:15:51.188 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:06:25 -0500 (0:00:00.066)       0:15:51.254 ********
Monday 09 January 2023  15:06:25 -0500 (0:00:00.057)       0:15:51.312 ********
Monday 09 January 2023  15:06:25 -0500 (0:00:00.049)       0:15:51.361 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:06:25 -0500 (0:00:00.062)       0:15:51.424 ********
Monday 09 January 2023  15:06:25 -0500 (0:00:00.055)       0:15:51.479 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.5/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Monday 09 January 2023  15:06:25 -0500 (0:00:00.123)       0:15:51.603 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:06:28 -0500 (0:00:03.349)       0:15:54.952 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:06:28 -0500 (0:00:00.068)       0:15:55.021 ********
Monday 09 January 2023  15:06:28 -0500 (0:00:00.051)       0:15:55.072 ********

TASK [download : debug] ************************************************************************************************
ok: [node1] => {
    "msg": "Pull quay.io/calico/node:v3.24.5 required is: True"
}
ok: [node2] => {
    "msg": "Pull quay.io/calico/node:v3.24.5 required is: True"
}
ok: [node3] => {
    "msg": "Pull quay.io/calico/node:v3.24.5 required is: True"
}
ok: [node4] => {
    "msg": "Pull quay.io/calico/node:v3.24.5 required is: True"
}
Monday 09 January 2023  15:06:29 -0500 (0:00:00.066)       0:15:55.138 ********
Monday 09 January 2023  15:06:29 -0500 (0:00:00.070)       0:15:55.209 ********
Monday 09 January 2023  15:06:29 -0500 (0:00:00.051)       0:15:55.261 ********
Monday 09 January 2023  15:06:29 -0500 (0:00:00.061)       0:15:55.322 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node4]
changed: [node3]
changed: [node2]
changed: [node1]
Monday 09 January 2023  15:07:16 -0500 (0:00:47.680)       0:16:43.003 ********
Monday 09 January 2023  15:07:16 -0500 (0:00:00.024)       0:16:43.028 ********
Monday 09 January 2023  15:07:17 -0500 (0:00:00.050)       0:16:43.079 ********
Monday 09 January 2023  15:07:17 -0500 (0:00:00.049)       0:16:43.128 ********
Monday 09 January 2023  15:07:17 -0500 (0:00:00.052)       0:16:43.181 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node4]
ok: [node2]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:07:19 -0500 (0:00:01.910)       0:16:45.091 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:07:19 -0500 (0:00:00.156)       0:16:45.248 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node1] => {
    "msg": "quay.io/calico/cni"
}
ok: [node2] => {
    "msg": "quay.io/calico/cni"
}
ok: [node3] => {
    "msg": "quay.io/calico/cni"
}
ok: [node4] => {
    "msg": "quay.io/calico/cni"
}
Monday 09 January 2023  15:07:19 -0500 (0:00:00.059)       0:16:45.308 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:07:19 -0500 (0:00:00.064)       0:16:45.372 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:07:19 -0500 (0:00:00.062)       0:16:45.434 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:07:19 -0500 (0:00:00.059)       0:16:45.494 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:07:19 -0500 (0:00:00.071)       0:16:45.566 ********
Monday 09 January 2023  15:07:19 -0500 (0:00:00.060)       0:16:45.626 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:07:19 -0500 (0:00:00.067)       0:16:45.693 ********
Monday 09 January 2023  15:07:19 -0500 (0:00:00.049)       0:16:45.743 ********
Monday 09 January 2023  15:07:19 -0500 (0:00:00.053)       0:16:45.796 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:07:19 -0500 (0:00:00.062)       0:16:45.858 ********
Monday 09 January 2023  15:07:19 -0500 (0:00:00.047)       0:16:45.906 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.5/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Monday 09 January 2023  15:07:19 -0500 (0:00:00.127)       0:16:46.034 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:07:23 -0500 (0:00:03.462)       0:16:49.496 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:07:23 -0500 (0:00:00.060)       0:16:49.556 ********
Monday 09 January 2023  15:07:23 -0500 (0:00:00.049)       0:16:49.606 ********

TASK [download : debug] ************************************************************************************************
ok: [node1] => {
    "msg": "Pull quay.io/calico/cni:v3.24.5 required is: True"
}
ok: [node2] => {
    "msg": "Pull quay.io/calico/cni:v3.24.5 required is: True"
}
ok: [node3] => {
    "msg": "Pull quay.io/calico/cni:v3.24.5 required is: True"
}
ok: [node4] => {
    "msg": "Pull quay.io/calico/cni:v3.24.5 required is: True"
}
Monday 09 January 2023  15:07:23 -0500 (0:00:00.069)       0:16:49.675 ********
Monday 09 January 2023  15:07:23 -0500 (0:00:00.060)       0:16:49.736 ********
Monday 09 January 2023  15:07:23 -0500 (0:00:00.049)       0:16:49.785 ********
Monday 09 January 2023  15:07:23 -0500 (0:00:00.062)       0:16:49.848 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:07:57 -0500 (0:00:33.867)       0:17:23.716 ********
Monday 09 January 2023  15:07:57 -0500 (0:00:00.022)       0:17:23.738 ********
Monday 09 January 2023  15:07:57 -0500 (0:00:00.051)       0:17:23.789 ********
Monday 09 January 2023  15:07:57 -0500 (0:00:00.056)       0:17:23.846 ********
Monday 09 January 2023  15:07:57 -0500 (0:00:00.049)       0:17:23.895 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Monday 09 January 2023  15:08:00 -0500 (0:00:03.167)       0:17:27.062 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:01 -0500 (0:00:00.062)       0:17:27.125 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node1] => {
    "msg": "quay.io/calico/pod2daemon-flexvol"
}
ok: [node2] => {
    "msg": "quay.io/calico/pod2daemon-flexvol"
}
ok: [node3] => {
    "msg": "quay.io/calico/pod2daemon-flexvol"
}
ok: [node4] => {
    "msg": "quay.io/calico/pod2daemon-flexvol"
}
Monday 09 January 2023  15:08:01 -0500 (0:00:00.067)       0:17:27.193 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:01 -0500 (0:00:00.067)       0:17:27.260 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:01 -0500 (0:00:00.063)       0:17:27.324 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:01 -0500 (0:00:00.065)       0:17:27.389 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:01 -0500 (0:00:00.063)       0:17:27.453 ********
Monday 09 January 2023  15:08:01 -0500 (0:00:00.053)       0:17:27.507 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:01 -0500 (0:00:00.063)       0:17:27.571 ********
Monday 09 January 2023  15:08:01 -0500 (0:00:00.048)       0:17:27.620 ********
Monday 09 January 2023  15:08:01 -0500 (0:00:00.050)       0:17:27.670 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:01 -0500 (0:00:00.065)       0:17:27.736 ********
Monday 09 January 2023  15:08:01 -0500 (0:00:00.049)       0:17:27.788 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.5/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Monday 09 January 2023  15:08:01 -0500 (0:00:00.130)       0:17:27.918 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node4]
ok: [node2]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:08:05 -0500 (0:00:03.520)       0:17:31.439 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:05 -0500 (0:00:00.061)       0:17:31.501 ********
Monday 09 January 2023  15:08:05 -0500 (0:00:00.053)       0:17:31.555 ********

TASK [download : debug] ************************************************************************************************
ok: [node1] => {
    "msg": "Pull quay.io/calico/pod2daemon-flexvol:v3.24.5 required is: True"
}
ok: [node2] => {
    "msg": "Pull quay.io/calico/pod2daemon-flexvol:v3.24.5 required is: True"
}
ok: [node3] => {
    "msg": "Pull quay.io/calico/pod2daemon-flexvol:v3.24.5 required is: True"
}
ok: [node4] => {
    "msg": "Pull quay.io/calico/pod2daemon-flexvol:v3.24.5 required is: True"
}
Monday 09 January 2023  15:08:05 -0500 (0:00:00.065)       0:17:31.620 ********
Monday 09 January 2023  15:08:05 -0500 (0:00:00.057)       0:17:31.677 ********
Monday 09 January 2023  15:08:05 -0500 (0:00:00.048)       0:17:31.726 ********
Monday 09 January 2023  15:08:05 -0500 (0:00:00.061)       0:17:31.788 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Monday 09 January 2023  15:08:19 -0500 (0:00:13.795)       0:17:45.583 ********
Monday 09 January 2023  15:08:19 -0500 (0:00:00.021)       0:17:45.605 ********
Monday 09 January 2023  15:08:19 -0500 (0:00:00.149)       0:17:45.754 ********
Monday 09 January 2023  15:08:19 -0500 (0:00:00.051)       0:17:45.805 ********
Monday 09 January 2023  15:08:19 -0500 (0:00:00.048)       0:17:45.853 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node4]
ok: [node3]
ok: [node2]
ok: [node1]
Monday 09 January 2023  15:08:21 -0500 (0:00:02.051)       0:17:47.904 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:21 -0500 (0:00:00.058)       0:17:47.963 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node1] => {
    "msg": "quay.io/calico/kube-controllers"
}
ok: [node2] => {
    "msg": "quay.io/calico/kube-controllers"
}
ok: [node3] => {
    "msg": "quay.io/calico/kube-controllers"
}
ok: [node4] => {
    "msg": "quay.io/calico/kube-controllers"
}
Monday 09 January 2023  15:08:21 -0500 (0:00:00.061)       0:17:48.024 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:22 -0500 (0:00:00.061)       0:17:48.086 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:22 -0500 (0:00:00.070)       0:17:48.157 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:22 -0500 (0:00:00.061)       0:17:48.218 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:22 -0500 (0:00:00.062)       0:17:48.280 ********
Monday 09 January 2023  15:08:22 -0500 (0:00:00.052)       0:17:48.333 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:22 -0500 (0:00:00.067)       0:17:48.400 ********
Monday 09 January 2023  15:08:22 -0500 (0:00:00.047)       0:17:48.448 ********
Monday 09 January 2023  15:08:22 -0500 (0:00:00.053)       0:17:48.502 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:22 -0500 (0:00:00.064)       0:17:48.566 ********
Monday 09 January 2023  15:08:22 -0500 (0:00:00.050)       0:17:48.616 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.5/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Monday 09 January 2023  15:08:22 -0500 (0:00:00.125)       0:17:48.741 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node4]
ok: [node2]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:08:25 -0500 (0:00:02.732)       0:17:51.473 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:25 -0500 (0:00:00.062)       0:17:51.536 ********
Monday 09 January 2023  15:08:25 -0500 (0:00:00.053)       0:17:51.590 ********

TASK [download : debug] ************************************************************************************************
ok: [node1] => {
    "msg": "Pull quay.io/calico/kube-controllers:v3.24.5 required is: True"
}
ok: [node2] => {
    "msg": "Pull quay.io/calico/kube-controllers:v3.24.5 required is: True"
}
ok: [node3] => {
    "msg": "Pull quay.io/calico/kube-controllers:v3.24.5 required is: True"
}
ok: [node4] => {
    "msg": "Pull quay.io/calico/kube-controllers:v3.24.5 required is: True"
}
Monday 09 January 2023  15:08:25 -0500 (0:00:00.070)       0:17:51.661 ********
Monday 09 January 2023  15:08:25 -0500 (0:00:00.059)       0:17:51.721 ********
Monday 09 January 2023  15:08:25 -0500 (0:00:00.048)       0:17:51.769 ********
Monday 09 January 2023  15:08:25 -0500 (0:00:00.058)       0:17:51.827 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:08:44 -0500 (0:00:18.349)       0:18:10.177 ********
Monday 09 January 2023  15:08:44 -0500 (0:00:00.023)       0:18:10.200 ********
Monday 09 January 2023  15:08:44 -0500 (0:00:00.054)       0:18:10.255 ********
Monday 09 January 2023  15:08:44 -0500 (0:00:00.057)       0:18:10.312 ********
Monday 09 January 2023  15:08:44 -0500 (0:00:00.050)       0:18:10.363 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:08:46 -0500 (0:00:01.875)       0:18:12.238 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:46 -0500 (0:00:00.061)       0:18:12.300 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node1] => {
    "msg": "registry.k8s.io/pause"
}
ok: [node2] => {
    "msg": "registry.k8s.io/pause"
}
ok: [node3] => {
    "msg": "registry.k8s.io/pause"
}
ok: [node4] => {
    "msg": "registry.k8s.io/pause"
}
Monday 09 January 2023  15:08:46 -0500 (0:00:00.062)       0:18:12.363 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:46 -0500 (0:00:00.072)       0:18:12.436 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:46 -0500 (0:00:00.061)       0:18:12.498 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:46 -0500 (0:00:00.065)       0:18:12.563 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:46 -0500 (0:00:00.067)       0:18:12.631 ********
Monday 09 January 2023  15:08:46 -0500 (0:00:00.057)       0:18:12.689 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:46 -0500 (0:00:00.064)       0:18:12.753 ********
Monday 09 January 2023  15:08:46 -0500 (0:00:00.065)       0:18:12.819 ********
Monday 09 January 2023  15:08:46 -0500 (0:00:00.052)       0:18:12.871 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:46 -0500 (0:00:00.070)       0:18:12.942 ********
Monday 09 January 2023  15:08:46 -0500 (0:00:00.055)       0:18:12.997 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.5/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Monday 09 January 2023  15:08:47 -0500 (0:00:00.134)       0:18:13.132 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:08:51 -0500 (0:00:04.701)       0:18:17.833 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:51 -0500 (0:00:00.064)       0:18:17.899 ********
Monday 09 January 2023  15:08:51 -0500 (0:00:00.057)       0:18:17.957 ********

TASK [download : debug] ************************************************************************************************
ok: [node1] => {
    "msg": "Pull registry.k8s.io/pause:3.7 required is: True"
}
ok: [node2] => {
    "msg": "Pull registry.k8s.io/pause:3.7 required is: True"
}
ok: [node3] => {
    "msg": "Pull registry.k8s.io/pause:3.7 required is: True"
}
ok: [node4] => {
    "msg": "Pull registry.k8s.io/pause:3.7 required is: True"
}
Monday 09 January 2023  15:08:51 -0500 (0:00:00.063)       0:18:18.020 ********
Monday 09 January 2023  15:08:52 -0500 (0:00:00.064)       0:18:18.085 ********
Monday 09 January 2023  15:08:52 -0500 (0:00:00.051)       0:18:18.137 ********
Monday 09 January 2023  15:08:52 -0500 (0:00:00.058)       0:18:18.195 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:08:56 -0500 (0:00:03.895)       0:18:22.091 ********
Monday 09 January 2023  15:08:56 -0500 (0:00:00.022)       0:18:22.113 ********
Monday 09 January 2023  15:08:56 -0500 (0:00:00.166)       0:18:22.280 ********
Monday 09 January 2023  15:08:56 -0500 (0:00:00.057)       0:18:22.338 ********
Monday 09 January 2023  15:08:56 -0500 (0:00:00.053)       0:18:22.391 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:08:59 -0500 (0:00:03.059)       0:18:25.451 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:59 -0500 (0:00:00.057)       0:18:25.508 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node2] => {
    "msg": "docker.io/library/nginx"
}
ok: [node3] => {
    "msg": "docker.io/library/nginx"
}
ok: [node4] => {
    "msg": "docker.io/library/nginx"
}
Monday 09 January 2023  15:08:59 -0500 (0:00:00.058)       0:18:25.567 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:59 -0500 (0:00:00.054)       0:18:25.621 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:59 -0500 (0:00:00.056)       0:18:25.678 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:59 -0500 (0:00:00.057)       0:18:25.736 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:59 -0500 (0:00:00.054)       0:18:25.790 ********
Monday 09 January 2023  15:08:59 -0500 (0:00:00.050)       0:18:25.840 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:59 -0500 (0:00:00.056)       0:18:25.896 ********
Monday 09 January 2023  15:08:59 -0500 (0:00:00.047)       0:18:25.944 ********
Monday 09 January 2023  15:08:59 -0500 (0:00:00.052)       0:18:25.996 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:08:59 -0500 (0:00:00.059)       0:18:26.056 ********
Monday 09 January 2023  15:09:00 -0500 (0:00:00.048)       0:18:26.105 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.5/kubespray/roles/download/tasks/check_pull_required.yml for node2, node3, node4
Monday 09 January 2023  15:09:00 -0500 (0:00:00.107)       0:18:26.213 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node4]
ok: [node2]
ok: [node3]
Monday 09 January 2023  15:09:03 -0500 (0:00:03.027)       0:18:29.241 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:03 -0500 (0:00:00.062)       0:18:29.303 ********
Monday 09 January 2023  15:09:03 -0500 (0:00:00.048)       0:18:29.351 ********

TASK [download : debug] ************************************************************************************************
ok: [node2] => {
    "msg": "Pull docker.io/library/nginx:1.23.2-alpine required is: True"
}
ok: [node3] => {
    "msg": "Pull docker.io/library/nginx:1.23.2-alpine required is: True"
}
ok: [node4] => {
    "msg": "Pull docker.io/library/nginx:1.23.2-alpine required is: True"
}
Monday 09 January 2023  15:09:03 -0500 (0:00:00.057)       0:18:29.409 ********
Monday 09 January 2023  15:09:03 -0500 (0:00:00.053)       0:18:29.463 ********
Monday 09 January 2023  15:09:03 -0500 (0:00:00.048)       0:18:29.511 ********
Monday 09 January 2023  15:09:03 -0500 (0:00:00.055)       0:18:29.567 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node4]
changed: [node2]
changed: [node3]
Monday 09 January 2023  15:09:15 -0500 (0:00:12.013)       0:18:41.581 ********
Monday 09 January 2023  15:09:15 -0500 (0:00:00.029)       0:18:41.610 ********
Monday 09 January 2023  15:09:15 -0500 (0:00:00.051)       0:18:41.662 ********
Monday 09 January 2023  15:09:15 -0500 (0:00:00.050)       0:18:41.712 ********
Monday 09 January 2023  15:09:15 -0500 (0:00:00.046)       0:18:41.758 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node3]
ok: [node4]
ok: [node2]
Monday 09 January 2023  15:09:16 -0500 (0:00:00.870)       0:18:42.629 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:16 -0500 (0:00:00.061)       0:18:42.691 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node1] => {
    "msg": "registry.k8s.io/coredns/coredns"
}
ok: [node2] => {
    "msg": "registry.k8s.io/coredns/coredns"
}
ok: [node3] => {
    "msg": "registry.k8s.io/coredns/coredns"
}
ok: [node4] => {
    "msg": "registry.k8s.io/coredns/coredns"
}
Monday 09 January 2023  15:09:16 -0500 (0:00:00.060)       0:18:42.751 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:16 -0500 (0:00:00.063)       0:18:42.815 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:16 -0500 (0:00:00.070)       0:18:42.885 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:16 -0500 (0:00:00.062)       0:18:42.948 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:16 -0500 (0:00:00.061)       0:18:43.010 ********
Monday 09 January 2023  15:09:16 -0500 (0:00:00.051)       0:18:43.064 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:17 -0500 (0:00:00.064)       0:18:43.128 ********
Monday 09 January 2023  15:09:17 -0500 (0:00:00.051)       0:18:43.180 ********
Monday 09 January 2023  15:09:17 -0500 (0:00:00.056)       0:18:43.236 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:17 -0500 (0:00:00.066)       0:18:43.303 ********
Monday 09 January 2023  15:09:17 -0500 (0:00:00.052)       0:18:43.356 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.5/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Monday 09 January 2023  15:09:17 -0500 (0:00:00.124)       0:18:43.480 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:09:23 -0500 (0:00:05.782)       0:18:49.263 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:23 -0500 (0:00:00.066)       0:18:49.329 ********
Monday 09 January 2023  15:09:23 -0500 (0:00:00.054)       0:18:49.383 ********

TASK [download : debug] ************************************************************************************************
ok: [node1] => {
    "msg": "Pull registry.k8s.io/coredns/coredns:v1.9.3 required is: True"
}
ok: [node2] => {
    "msg": "Pull registry.k8s.io/coredns/coredns:v1.9.3 required is: True"
}
ok: [node3] => {
    "msg": "Pull registry.k8s.io/coredns/coredns:v1.9.3 required is: True"
}
ok: [node4] => {
    "msg": "Pull registry.k8s.io/coredns/coredns:v1.9.3 required is: True"
}
Monday 09 January 2023  15:09:23 -0500 (0:00:00.062)       0:18:49.447 ********
Monday 09 January 2023  15:09:23 -0500 (0:00:00.060)       0:18:49.508 ********
Monday 09 January 2023  15:09:23 -0500 (0:00:00.053)       0:18:49.563 ********
Monday 09 January 2023  15:09:23 -0500 (0:00:00.067)       0:18:49.630 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Monday 09 January 2023  15:09:44 -0500 (0:00:21.210)       0:19:10.841 ********
Monday 09 January 2023  15:09:44 -0500 (0:00:00.023)       0:19:10.864 ********
Monday 09 January 2023  15:09:44 -0500 (0:00:00.053)       0:19:10.918 ********
Monday 09 January 2023  15:09:44 -0500 (0:00:00.044)       0:19:10.965 ********
Monday 09 January 2023  15:09:44 -0500 (0:00:00.050)       0:19:11.020 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:09:46 -0500 (0:00:01.769)       0:19:12.790 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:46 -0500 (0:00:00.056)       0:19:12.847 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node1] => {
    "msg": "registry.k8s.io/dns/k8s-dns-node-cache"
}
ok: [node2] => {
    "msg": "registry.k8s.io/dns/k8s-dns-node-cache"
}
ok: [node3] => {
    "msg": "registry.k8s.io/dns/k8s-dns-node-cache"
}
ok: [node4] => {
    "msg": "registry.k8s.io/dns/k8s-dns-node-cache"
}
Monday 09 January 2023  15:09:46 -0500 (0:00:00.060)       0:19:12.907 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:46 -0500 (0:00:00.064)       0:19:12.971 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:46 -0500 (0:00:00.060)       0:19:13.032 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:47 -0500 (0:00:00.058)       0:19:13.090 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:47 -0500 (0:00:00.069)       0:19:13.159 ********
Monday 09 January 2023  15:09:47 -0500 (0:00:00.049)       0:19:13.209 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:47 -0500 (0:00:00.060)       0:19:13.270 ********
Monday 09 January 2023  15:09:47 -0500 (0:00:00.053)       0:19:13.324 ********
Monday 09 January 2023  15:09:47 -0500 (0:00:00.047)       0:19:13.371 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:47 -0500 (0:00:00.073)       0:19:13.445 ********
Monday 09 January 2023  15:09:47 -0500 (0:00:00.052)       0:19:13.497 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.5/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Monday 09 January 2023  15:09:47 -0500 (0:00:00.124)       0:19:13.621 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:09:51 -0500 (0:00:04.288)       0:19:17.910 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:09:51 -0500 (0:00:00.065)       0:19:17.975 ********
Monday 09 January 2023  15:09:51 -0500 (0:00:00.050)       0:19:18.026 ********

TASK [download : debug] ************************************************************************************************
ok: [node1] => {
    "msg": "Pull registry.k8s.io/dns/k8s-dns-node-cache:1.21.1 required is: True"
}
ok: [node2] => {
    "msg": "Pull registry.k8s.io/dns/k8s-dns-node-cache:1.21.1 required is: True"
}
ok: [node3] => {
    "msg": "Pull registry.k8s.io/dns/k8s-dns-node-cache:1.21.1 required is: True"
}
ok: [node4] => {
    "msg": "Pull registry.k8s.io/dns/k8s-dns-node-cache:1.21.1 required is: True"
}
Monday 09 January 2023  15:09:52 -0500 (0:00:00.069)       0:19:18.095 ********
Monday 09 January 2023  15:09:52 -0500 (0:00:00.065)       0:19:18.161 ********
Monday 09 January 2023  15:09:52 -0500 (0:00:00.051)       0:19:18.213 ********
Monday 09 January 2023  15:09:52 -0500 (0:00:00.064)       0:19:18.278 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:10:13 -0500 (0:00:20.903)       0:19:39.182 ********
Monday 09 January 2023  15:10:13 -0500 (0:00:00.023)       0:19:39.205 ********
Monday 09 January 2023  15:10:13 -0500 (0:00:00.055)       0:19:39.261 ********
Monday 09 January 2023  15:10:13 -0500 (0:00:00.055)       0:19:39.317 ********
Monday 09 January 2023  15:10:13 -0500 (0:00:00.054)       0:19:39.371 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node4]
ok: [node2]
ok: [node1]
ok: [node3]
Monday 09 January 2023  15:10:15 -0500 (0:00:02.210)       0:19:41.588 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:15 -0500 (0:00:00.063)       0:19:41.652 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node1] => {
    "msg": "registry.k8s.io/kube-apiserver"
}
ok: [node2] => {
    "msg": "registry.k8s.io/kube-apiserver"
}
ok: [node3] => {
    "msg": "registry.k8s.io/kube-apiserver"
}
ok: [node4] => {
    "msg": "registry.k8s.io/kube-apiserver"
}
Monday 09 January 2023  15:10:15 -0500 (0:00:00.066)       0:19:41.719 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:15 -0500 (0:00:00.061)       0:19:41.780 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:15 -0500 (0:00:00.068)       0:19:41.849 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:15 -0500 (0:00:00.064)       0:19:41.913 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:15 -0500 (0:00:00.059)       0:19:41.973 ********
Monday 09 January 2023  15:10:15 -0500 (0:00:00.052)       0:19:42.025 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:16 -0500 (0:00:00.066)       0:19:42.092 ********
Monday 09 January 2023  15:10:16 -0500 (0:00:00.053)       0:19:42.146 ********
Monday 09 January 2023  15:10:16 -0500 (0:00:00.052)       0:19:42.199 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:16 -0500 (0:00:00.067)       0:19:42.266 ********
Monday 09 January 2023  15:10:16 -0500 (0:00:00.049)       0:19:42.316 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.5/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Monday 09 January 2023  15:10:16 -0500 (0:00:00.137)       0:19:42.454 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:10:19 -0500 (0:00:03.242)       0:19:45.696 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:19 -0500 (0:00:00.061)       0:19:45.757 ********
Monday 09 January 2023  15:10:19 -0500 (0:00:00.054)       0:19:45.811 ********

TASK [download : debug] ************************************************************************************************
ok: [node1] => {
    "msg": "Pull registry.k8s.io/kube-apiserver:v1.25.5 required is: True"
}
ok: [node2] => {
    "msg": "Pull registry.k8s.io/kube-apiserver:v1.25.5 required is: True"
}
ok: [node3] => {
    "msg": "Pull registry.k8s.io/kube-apiserver:v1.25.5 required is: True"
}
ok: [node4] => {
    "msg": "Pull registry.k8s.io/kube-apiserver:v1.25.5 required is: True"
}
Monday 09 January 2023  15:10:19 -0500 (0:00:00.063)       0:19:45.875 ********
Monday 09 January 2023  15:10:19 -0500 (0:00:00.066)       0:19:45.941 ********
Monday 09 January 2023  15:10:19 -0500 (0:00:00.050)       0:19:45.992 ********
Monday 09 January 2023  15:10:19 -0500 (0:00:00.059)       0:19:46.052 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:10:38 -0500 (0:00:18.869)       0:20:04.922 ********
Monday 09 January 2023  15:10:38 -0500 (0:00:00.022)       0:20:04.944 ********
Monday 09 January 2023  15:10:38 -0500 (0:00:00.062)       0:20:05.007 ********
Monday 09 January 2023  15:10:38 -0500 (0:00:00.057)       0:20:05.064 ********
Monday 09 January 2023  15:10:39 -0500 (0:00:00.060)       0:20:05.124 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node4]
ok: [node3]
ok: [node2]
ok: [node1]
Monday 09 January 2023  15:10:41 -0500 (0:00:02.280)       0:20:07.405 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:41 -0500 (0:00:00.064)       0:20:07.469 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node1] => {
    "msg": "registry.k8s.io/kube-controller-manager"
}
ok: [node2] => {
    "msg": "registry.k8s.io/kube-controller-manager"
}
ok: [node3] => {
    "msg": "registry.k8s.io/kube-controller-manager"
}
ok: [node4] => {
    "msg": "registry.k8s.io/kube-controller-manager"
}
Monday 09 January 2023  15:10:41 -0500 (0:00:00.064)       0:20:07.534 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:41 -0500 (0:00:00.071)       0:20:07.606 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:41 -0500 (0:00:00.063)       0:20:07.669 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:41 -0500 (0:00:00.057)       0:20:07.727 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:41 -0500 (0:00:00.060)       0:20:07.788 ********
Monday 09 January 2023  15:10:41 -0500 (0:00:00.049)       0:20:07.837 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:41 -0500 (0:00:00.064)       0:20:07.902 ********
Monday 09 January 2023  15:10:41 -0500 (0:00:00.051)       0:20:07.954 ********
Monday 09 January 2023  15:10:41 -0500 (0:00:00.049)       0:20:08.003 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:41 -0500 (0:00:00.059)       0:20:08.063 ********
Monday 09 January 2023  15:10:42 -0500 (0:00:00.050)       0:20:08.113 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.5/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Monday 09 January 2023  15:10:42 -0500 (0:00:00.120)       0:20:08.234 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node4]
ok: [node2]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:10:47 -0500 (0:00:05.547)       0:20:13.782 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:10:47 -0500 (0:00:00.059)       0:20:13.841 ********
Monday 09 January 2023  15:10:47 -0500 (0:00:00.048)       0:20:13.890 ********

TASK [download : debug] ************************************************************************************************
ok: [node1] => {
    "msg": "Pull registry.k8s.io/kube-controller-manager:v1.25.5 required is: True"
}
ok: [node2] => {
    "msg": "Pull registry.k8s.io/kube-controller-manager:v1.25.5 required is: True"
}
ok: [node3] => {
    "msg": "Pull registry.k8s.io/kube-controller-manager:v1.25.5 required is: True"
}
ok: [node4] => {
    "msg": "Pull registry.k8s.io/kube-controller-manager:v1.25.5 required is: True"
}
Monday 09 January 2023  15:10:47 -0500 (0:00:00.062)       0:20:13.953 ********
Monday 09 January 2023  15:10:47 -0500 (0:00:00.058)       0:20:14.011 ********
Monday 09 January 2023  15:10:47 -0500 (0:00:00.048)       0:20:14.060 ********
Monday 09 January 2023  15:10:48 -0500 (0:00:00.061)       0:20:14.121 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node2]
changed: [node4]
changed: [node1]
changed: [node3]
Monday 09 January 2023  15:11:08 -0500 (0:00:20.770)       0:20:34.892 ********
Monday 09 January 2023  15:11:08 -0500 (0:00:00.025)       0:20:34.919 ********
Monday 09 January 2023  15:11:08 -0500 (0:00:00.054)       0:20:34.977 ********
Monday 09 January 2023  15:11:08 -0500 (0:00:00.055)       0:20:35.033 ********
Monday 09 January 2023  15:11:09 -0500 (0:00:00.061)       0:20:35.095 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node4]
ok: [node2]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:11:11 -0500 (0:00:02.508)       0:20:37.603 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:11 -0500 (0:00:00.065)       0:20:37.668 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node1] => {
    "msg": "registry.k8s.io/kube-scheduler"
}
ok: [node2] => {
    "msg": "registry.k8s.io/kube-scheduler"
}
ok: [node3] => {
    "msg": "registry.k8s.io/kube-scheduler"
}
ok: [node4] => {
    "msg": "registry.k8s.io/kube-scheduler"
}
Monday 09 January 2023  15:11:11 -0500 (0:00:00.062)       0:20:37.730 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:11 -0500 (0:00:00.061)       0:20:37.792 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:11 -0500 (0:00:00.060)       0:20:37.852 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:11 -0500 (0:00:00.061)       0:20:37.915 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:11 -0500 (0:00:00.060)       0:20:37.976 ********
Monday 09 January 2023  15:11:11 -0500 (0:00:00.051)       0:20:38.027 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:12 -0500 (0:00:00.065)       0:20:38.093 ********
Monday 09 January 2023  15:11:12 -0500 (0:00:00.051)       0:20:38.145 ********
Monday 09 January 2023  15:11:12 -0500 (0:00:00.049)       0:20:38.194 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:12 -0500 (0:00:00.070)       0:20:38.265 ********
Monday 09 January 2023  15:11:12 -0500 (0:00:00.050)       0:20:38.316 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.5/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Monday 09 January 2023  15:11:12 -0500 (0:00:00.125)       0:20:38.442 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node4]
ok: [node2]
ok: [node1]
ok: [node3]
Monday 09 January 2023  15:11:16 -0500 (0:00:03.868)       0:20:42.310 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:16 -0500 (0:00:00.060)       0:20:42.371 ********
Monday 09 January 2023  15:11:16 -0500 (0:00:00.052)       0:20:42.423 ********

TASK [download : debug] ************************************************************************************************
ok: [node1] => {
    "msg": "Pull registry.k8s.io/kube-scheduler:v1.25.5 required is: True"
}
ok: [node2] => {
    "msg": "Pull registry.k8s.io/kube-scheduler:v1.25.5 required is: True"
}
ok: [node3] => {
    "msg": "Pull registry.k8s.io/kube-scheduler:v1.25.5 required is: True"
}
ok: [node4] => {
    "msg": "Pull registry.k8s.io/kube-scheduler:v1.25.5 required is: True"
}
Monday 09 January 2023  15:11:16 -0500 (0:00:00.065)       0:20:42.488 ********
Monday 09 January 2023  15:11:16 -0500 (0:00:00.156)       0:20:42.645 ********
Monday 09 January 2023  15:11:16 -0500 (0:00:00.048)       0:20:42.693 ********
Monday 09 January 2023  15:11:16 -0500 (0:00:00.055)       0:20:42.749 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node4]
changed: [node2]
changed: [node1]
changed: [node3]
Monday 09 January 2023  15:11:25 -0500 (0:00:09.230)       0:20:51.980 ********
Monday 09 January 2023  15:11:25 -0500 (0:00:00.024)       0:20:52.005 ********
Monday 09 January 2023  15:11:25 -0500 (0:00:00.048)       0:20:52.055 ********
Monday 09 January 2023  15:11:26 -0500 (0:00:00.051)       0:20:52.106 ********
Monday 09 January 2023  15:11:26 -0500 (0:00:00.050)       0:20:52.157 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node2]
ok: [node4]
ok: [node1]
ok: [node3]
Monday 09 January 2023  15:11:28 -0500 (0:00:02.156)       0:20:54.313 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:28 -0500 (0:00:00.063)       0:20:54.377 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node1] => {
    "msg": "registry.k8s.io/kube-proxy"
}
ok: [node2] => {
    "msg": "registry.k8s.io/kube-proxy"
}
ok: [node3] => {
    "msg": "registry.k8s.io/kube-proxy"
}
ok: [node4] => {
    "msg": "registry.k8s.io/kube-proxy"
}
Monday 09 January 2023  15:11:28 -0500 (0:00:00.062)       0:20:54.440 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:28 -0500 (0:00:00.058)       0:20:54.499 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:28 -0500 (0:00:00.062)       0:20:54.562 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:28 -0500 (0:00:00.063)       0:20:54.625 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:28 -0500 (0:00:00.061)       0:20:54.687 ********
Monday 09 January 2023  15:11:28 -0500 (0:00:00.052)       0:20:54.739 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:28 -0500 (0:00:00.062)       0:20:54.802 ********
Monday 09 January 2023  15:11:28 -0500 (0:00:00.051)       0:20:54.853 ********
Monday 09 January 2023  15:11:28 -0500 (0:00:00.054)       0:20:54.908 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:28 -0500 (0:00:00.061)       0:20:54.970 ********
Monday 09 January 2023  15:11:28 -0500 (0:00:00.055)       0:20:55.025 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.5/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Monday 09 January 2023  15:11:29 -0500 (0:00:00.124)       0:20:55.150 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node2]
ok: [node4]
ok: [node1]
ok: [node3]
Monday 09 January 2023  15:11:34 -0500 (0:00:05.156)       0:21:00.307 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:11:34 -0500 (0:00:00.065)       0:21:00.372 ********
Monday 09 January 2023  15:11:34 -0500 (0:00:00.051)       0:21:00.423 ********

TASK [download : debug] ************************************************************************************************
ok: [node1] => {
    "msg": "Pull registry.k8s.io/kube-proxy:v1.25.5 required is: True"
}
ok: [node2] => {
    "msg": "Pull registry.k8s.io/kube-proxy:v1.25.5 required is: True"
}
ok: [node3] => {
    "msg": "Pull registry.k8s.io/kube-proxy:v1.25.5 required is: True"
}
ok: [node4] => {
    "msg": "Pull registry.k8s.io/kube-proxy:v1.25.5 required is: True"
}
Monday 09 January 2023  15:11:34 -0500 (0:00:00.063)       0:21:00.487 ********
Monday 09 January 2023  15:11:34 -0500 (0:00:00.063)       0:21:00.551 ********
Monday 09 January 2023  15:11:34 -0500 (0:00:00.049)       0:21:00.600 ********
Monday 09 January 2023  15:11:34 -0500 (0:00:00.058)       0:21:00.659 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:11:47 -0500 (0:00:12.963)       0:21:13.640 ********
Monday 09 January 2023  15:11:47 -0500 (0:00:00.019)       0:21:13.659 ********
Monday 09 January 2023  15:11:47 -0500 (0:00:00.055)       0:21:13.715 ********
Monday 09 January 2023  15:11:47 -0500 (0:00:00.050)       0:21:13.766 ********
Monday 09 January 2023  15:11:47 -0500 (0:00:00.050)       0:21:13.816 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:11:50 -0500 (0:00:02.265)       0:21:16.082 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
Monday 09 January 2023  15:11:50 -0500 (0:00:00.034)       0:21:16.117 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://github.com/etcd-io/etcd/releases/download/v3.5.6/etcd-v3.5.6-linux-amd64.tar.gz"
}
Monday 09 January 2023  15:11:50 -0500 (0:00:00.034)       0:21:16.151 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
Monday 09 January 2023  15:11:50 -0500 (0:00:00.032)       0:21:16.184 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node1]
Monday 09 January 2023  15:11:52 -0500 (0:00:02.002)       0:21:18.187 ********
Monday 09 January 2023  15:11:52 -0500 (0:00:00.019)       0:21:18.214 ********
Monday 09 January 2023  15:11:52 -0500 (0:00:00.033)       0:21:18.247 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:11:56 -0500 (0:00:04.258)       0:21:22.510 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
Monday 09 January 2023  15:11:56 -0500 (0:00:00.042)       0:21:22.554 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node1]
Monday 09 January 2023  15:12:06 -0500 (0:00:09.937)       0:21:32.491 ********
Monday 09 January 2023  15:12:06 -0500 (0:00:00.035)       0:21:32.527 ********
Monday 09 January 2023  15:12:06 -0500 (0:00:00.034)       0:21:32.561 ********
Monday 09 January 2023  15:12:06 -0500 (0:00:00.034)       0:21:32.596 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1
Monday 09 January 2023  15:12:06 -0500 (0:00:00.060)       0:21:32.656 ********

TASK [download : extract_file | Unpacking archive] *********************************************************************
changed: [node1]
Monday 09 January 2023  15:12:29 -0500 (0:00:22.417)       0:21:55.074 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
Monday 09 January 2023  15:12:29 -0500 (0:00:00.036)       0:21:55.110 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubectl"
}
Monday 09 January 2023  15:12:29 -0500 (0:00:00.033)       0:21:55.144 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
Monday 09 January 2023  15:12:29 -0500 (0:00:00.032)       0:21:55.177 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node1]
Monday 09 January 2023  15:12:32 -0500 (0:00:03.299)       0:21:58.476 ********
Monday 09 January 2023  15:12:32 -0500 (0:00:00.025)       0:21:58.501 ********
Monday 09 January 2023  15:12:32 -0500 (0:00:00.031)       0:21:58.533 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:12:36 -0500 (0:00:04.132)       0:22:02.665 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
Monday 09 January 2023  15:12:36 -0500 (0:00:00.041)       0:22:02.707 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node1]
Monday 09 January 2023  15:12:50 -0500 (0:00:13.693)       0:22:16.400 ********
Monday 09 January 2023  15:12:50 -0500 (0:00:00.031)       0:22:16.432 ********
Monday 09 January 2023  15:12:50 -0500 (0:00:00.033)       0:22:16.466 ********
Monday 09 January 2023  15:12:50 -0500 (0:00:00.035)       0:22:16.502 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1
Monday 09 January 2023  15:12:50 -0500 (0:00:00.051)       0:22:16.553 ********
Monday 09 January 2023  15:12:50 -0500 (0:00:00.031)       0:22:16.585 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
Monday 09 January 2023  15:12:50 -0500 (0:00:00.036)       0:22:16.621 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://github.com/projectcalico/calico/archive/v3.24.5.tar.gz"
}
Monday 09 January 2023  15:12:50 -0500 (0:00:00.032)       0:22:16.658 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
Monday 09 January 2023  15:12:50 -0500 (0:00:00.037)       0:22:16.695 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
changed: [node1]
Monday 09 January 2023  15:12:53 -0500 (0:00:02.401)       0:22:19.097 ********
Monday 09 January 2023  15:12:53 -0500 (0:00:00.024)       0:22:19.122 ********
Monday 09 January 2023  15:12:53 -0500 (0:00:00.031)       0:22:19.153 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Monday 09 January 2023  15:12:57 -0500 (0:00:04.444)       0:22:23.597 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
Monday 09 January 2023  15:12:57 -0500 (0:00:00.036)       0:22:23.638 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node1]
Monday 09 January 2023  15:13:05 -0500 (0:00:07.446)       0:22:31.084 ********
Monday 09 January 2023  15:13:05 -0500 (0:00:00.032)       0:22:31.117 ********
Monday 09 January 2023  15:13:05 -0500 (0:00:00.031)       0:22:31.148 ********
Monday 09 January 2023  15:13:05 -0500 (0:00:00.029)       0:22:31.184 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.5/kubespray/roles/download/tasks/extract_file.yml for node1
Monday 09 January 2023  15:13:05 -0500 (0:00:00.052)       0:22:31.237 ********

TASK [download : extract_file | Unpacking archive] *********************************************************************
changed: [node1]
Monday 09 January 2023  15:13:18 -0500 (0:00:12.893)       0:22:44.130 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
Monday 09 January 2023  15:13:18 -0500 (0:00:00.035)       0:22:44.167 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node1] => {
    "msg": "registry.k8s.io/cpa/cluster-proportional-autoscaler-amd64"
}
Monday 09 January 2023  15:13:18 -0500 (0:00:00.039)       0:22:44.207 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
Monday 09 January 2023  15:13:18 -0500 (0:00:00.034)       0:22:44.241 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
Monday 09 January 2023  15:13:18 -0500 (0:00:00.035)       0:22:44.277 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
Monday 09 January 2023  15:13:18 -0500 (0:00:00.037)       0:22:44.314 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
Monday 09 January 2023  15:13:18 -0500 (0:00:00.035)       0:22:44.350 ********
Monday 09 January 2023  15:13:18 -0500 (0:00:00.033)       0:22:44.384 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
Monday 09 January 2023  15:13:18 -0500 (0:00:00.035)       0:22:44.419 ********
Monday 09 January 2023  15:13:18 -0500 (0:00:00.032)       0:22:44.452 ********
Monday 09 January 2023  15:13:18 -0500 (0:00:00.031)       0:22:44.483 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
Monday 09 January 2023  15:13:18 -0500 (0:00:00.042)       0:22:44.526 ********
Monday 09 January 2023  15:13:18 -0500 (0:00:00.036)       0:22:44.562 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.5/kubespray/roles/download/tasks/check_pull_required.yml for node1
Monday 09 January 2023  15:13:18 -0500 (0:00:00.063)       0:22:44.625 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node1]
Monday 09 January 2023  15:13:22 -0500 (0:00:03.914)       0:22:48.540 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
Monday 09 January 2023  15:13:22 -0500 (0:00:00.033)       0:22:48.573 ********
Monday 09 January 2023  15:13:22 -0500 (0:00:00.032)       0:22:48.606 ********

TASK [download : debug] ************************************************************************************************
ok: [node1] => {
    "msg": "Pull registry.k8s.io/cpa/cluster-proportional-autoscaler-amd64:1.8.5 required is: True"
}
Monday 09 January 2023  15:13:22 -0500 (0:00:00.038)       0:22:48.644 ********
Monday 09 January 2023  15:13:22 -0500 (0:00:00.030)       0:22:48.675 ********
Monday 09 January 2023  15:13:22 -0500 (0:00:00.033)       0:22:48.708 ********
Monday 09 January 2023  15:13:22 -0500 (0:00:00.049)       0:22:48.758 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node1]
Monday 09 January 2023  15:13:32 -0500 (0:00:10.095)       0:22:58.853 ********
Monday 09 January 2023  15:13:32 -0500 (0:00:00.021)       0:22:58.875 ********
Monday 09 January 2023  15:13:32 -0500 (0:00:00.032)       0:22:58.907 ********
Monday 09 January 2023  15:13:32 -0500 (0:00:00.029)       0:22:58.937 ********
Monday 09 January 2023  15:13:32 -0500 (0:00:00.035)       0:22:58.973 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node1]

PLAY [etcd:kube_control_plane] *****************************************************************************************
Monday 09 January 2023  15:13:34 -0500 (0:00:01.940)       0:23:00.914 ********
Monday 09 January 2023  15:13:34 -0500 (0:00:00.020)       0:23:00.934 ********
Monday 09 January 2023  15:13:34 -0500 (0:00:00.020)       0:23:00.954 ********
Monday 09 January 2023  15:13:34 -0500 (0:00:00.017)       0:23:00.972 ********
Monday 09 January 2023  15:13:34 -0500 (0:00:00.017)       0:23:00.990 ********
Monday 09 January 2023  15:13:34 -0500 (0:00:00.018)       0:23:01.008 ********
Monday 09 January 2023  15:13:34 -0500 (0:00:00.016)       0:23:01.024 ********
Monday 09 January 2023  15:13:34 -0500 (0:00:00.020)       0:23:01.045 ********
Monday 09 January 2023  15:13:34 -0500 (0:00:00.017)       0:23:01.062 ********
Monday 09 January 2023  15:13:35 -0500 (0:00:00.023)       0:23:01.085 ********
Monday 09 January 2023  15:13:35 -0500 (0:00:00.649)       0:23:01.735 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Monday 09 January 2023  15:13:35 -0500 (0:00:00.053)       0:23:01.788 ********
Monday 09 January 2023  15:13:35 -0500 (0:00:00.036)       0:23:01.825 ********
Monday 09 January 2023  15:13:35 -0500 (0:00:00.018)       0:23:01.843 ********
Monday 09 January 2023  15:13:35 -0500 (0:00:00.019)       0:23:01.863 ********
Monday 09 January 2023  15:13:35 -0500 (0:00:00.017)       0:23:01.880 ********
Monday 09 January 2023  15:13:35 -0500 (0:00:00.016)       0:23:01.897 ********
Monday 09 January 2023  15:13:35 -0500 (0:00:00.021)       0:23:01.919 ********

TASK [adduser : User | Create User Group] ******************************************************************************
changed: [node1]
Monday 09 January 2023  15:13:37 -0500 (0:00:02.018)       0:23:03.937 ********

TASK [adduser : User | Create User] ************************************************************************************
changed: [node1]
Monday 09 January 2023  15:13:40 -0500 (0:00:02.671)       0:23:06.609 ********

TASK [adduser : User | Create User Group] ******************************************************************************
ok: [node1]
Monday 09 January 2023  15:13:42 -0500 (0:00:01.725)       0:23:08.335 ********

TASK [adduser : User | Create User] ************************************************************************************
ok: [node1]
Monday 09 January 2023  15:13:44 -0500 (0:00:01.906)       0:23:10.241 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.5/kubespray/roles/etcd/tasks/check_certs.yml for node1
Monday 09 January 2023  15:13:44 -0500 (0:00:00.039)       0:23:10.280 ********

TASK [etcd : Check_certs | Register certs that have already been generated on first etcd node] *************************
[WARNING]: Skipped '/etc/ssl/etcd/ssl' path due to this access issue: '/etc/ssl/etcd/ssl' is not a directory
ok: [node1]
Monday 09 January 2023  15:13:46 -0500 (0:00:01.858)       0:23:12.138 ********

TASK [etcd : Check_certs | Set default value for 'sync_certs', 'gen_certs' and 'etcd_secret_changed' to false] *********
ok: [node1]
Monday 09 January 2023  15:13:46 -0500 (0:00:00.024)       0:23:12.163 ********

TASK [etcd : Check certs | Register ca and etcd admin/member certs on etcd hosts] **************************************
ok: [node1] => (item=ca.pem)
ok: [node1] => (item=member-node1.pem)
ok: [node1] => (item=member-node1-key.pem)
ok: [node1] => (item=admin-node1.pem)
ok: [node1] => (item=admin-node1-key.pem)
Monday 09 January 2023  15:13:54 -0500 (0:00:08.305)       0:23:20.469 ********

TASK [etcd : Check certs | Register ca and etcd node certs on kubernetes hosts] ****************************************
ok: [node1] => (item=ca.pem)
ok: [node1] => (item=node-node1.pem)
ok: [node1] => (item=node-node1-key.pem)
Monday 09 January 2023  15:13:59 -0500 (0:00:05.107)       0:23:25.577 ********

TASK [etcd : Check_certs | Set 'gen_certs' to true if expected certificates are not on the first etcd node(1/2)] *******
ok: [node1] => (item=/etc/ssl/etcd/ssl/ca.pem)
ok: [node1] => (item=/etc/ssl/etcd/ssl/admin-node1.pem)
ok: [node1] => (item=/etc/ssl/etcd/ssl/admin-node1-key.pem)
ok: [node1] => (item=/etc/ssl/etcd/ssl/member-node1.pem)
ok: [node1] => (item=/etc/ssl/etcd/ssl/member-node1-key.pem)
ok: [node1] => (item=/etc/ssl/etcd/ssl/node-node1.pem)
ok: [node1] => (item=/etc/ssl/etcd/ssl/node-node1-key.pem)
Monday 09 January 2023  15:13:59 -0500 (0:00:00.093)       0:23:25.671 ********
Monday 09 January 2023  15:13:59 -0500 (0:00:00.102)       0:23:25.774 ********

TASK [etcd : Check_certs | Set 'gen_master_certs' object to track whether member and admin certs exist on first etcd node] ***
ok: [node1]
Monday 09 January 2023  15:13:59 -0500 (0:00:00.027)       0:23:25.801 ********

TASK [etcd : Check_certs | Set 'gen_node_certs' object to track whether node certs exist on first etcd node] ***********
ok: [node1]
Monday 09 January 2023  15:13:59 -0500 (0:00:00.028)       0:23:25.830 ********

TASK [etcd : Check_certs | Set 'etcd_member_requires_sync' to true if ca or member/admin cert and key don't exist on etcd member or checksum doesn't match] ***
ok: [node1]
Monday 09 January 2023  15:13:59 -0500 (0:00:00.046)       0:23:25.877 ********
Monday 09 January 2023  15:13:59 -0500 (0:00:00.016)       0:23:25.894 ********

TASK [etcd : Check_certs | Set 'sync_certs' to true] *******************************************************************
ok: [node1]
Monday 09 January 2023  15:13:59 -0500 (0:00:00.028)       0:23:25.922 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.5/kubespray/roles/etcd/tasks/gen_certs_script.yml for node1
Monday 09 January 2023  15:13:59 -0500 (0:00:00.038)       0:23:25.960 ********

TASK [etcd : Gen_certs | create etcd cert dir] *************************************************************************
changed: [node1]
Monday 09 January 2023  15:14:03 -0500 (0:00:03.164)       0:23:29.124 ********

TASK [etcd : Gen_certs | create etcd script dir (on node1)] ************************************************************
changed: [node1]
Monday 09 January 2023  15:14:05 -0500 (0:00:02.230)       0:23:31.354 ********

TASK [etcd : Gen_certs | write openssl config] *************************************************************************
changed: [node1]
Monday 09 January 2023  15:14:09 -0500 (0:00:04.145)       0:23:35.499 ********

TASK [etcd : Gen_certs | copy certs generation script] *****************************************************************
changed: [node1]
Monday 09 January 2023  15:14:13 -0500 (0:00:03.584)       0:23:39.084 ********

TASK [etcd : Gen_certs | run cert generation script for etcd and kube control plane nodes] *****************************
changed: [node1]
Monday 09 January 2023  15:14:17 -0500 (0:00:04.258)       0:23:43.342 ********
Monday 09 January 2023  15:14:17 -0500 (0:00:00.038)       0:23:43.381 ********
Monday 09 January 2023  15:14:17 -0500 (0:00:00.065)       0:23:43.448 ********
Monday 09 January 2023  15:14:17 -0500 (0:00:00.082)       0:23:43.531 ********
Monday 09 January 2023  15:14:17 -0500 (0:00:00.057)       0:23:43.588 ********
Monday 09 January 2023  15:14:17 -0500 (0:00:00.051)       0:23:43.640 ********
Monday 09 January 2023  15:14:17 -0500 (0:00:00.013)       0:23:43.658 ********
Monday 09 January 2023  15:14:17 -0500 (0:00:00.020)       0:23:43.678 ********

TASK [etcd : Gen_certs | check certificate permissions] ****************************************************************
changed: [node1]
Monday 09 January 2023  15:14:19 -0500 (0:00:01.609)       0:23:45.288 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.5/kubespray/roles/etcd/tasks/upd_ca_trust.yml for node1
Monday 09 January 2023  15:14:19 -0500 (0:00:00.033)       0:23:45.321 ********

TASK [etcd : Gen_certs | target ca-certificate store file] *************************************************************
ok: [node1]
Monday 09 January 2023  15:14:19 -0500 (0:00:00.026)       0:23:45.348 ********

TASK [etcd : Gen_certs | add CA to trusted CA dir] *********************************************************************
changed: [node1]
Monday 09 January 2023  15:14:21 -0500 (0:00:02.355)       0:23:47.703 ********

TASK [etcd : Gen_certs | update ca-certificates (Debian/Ubuntu/SUSE/Flatcar)] ******************************************
changed: [node1]
Monday 09 January 2023  15:14:27 -0500 (0:00:05.961)       0:23:53.665 ********
Monday 09 January 2023  15:14:27 -0500 (0:00:00.018)       0:23:53.683 ********
Monday 09 January 2023  15:14:27 -0500 (0:00:00.019)       0:23:53.703 ********
Monday 09 January 2023  15:14:27 -0500 (0:00:00.018)       0:23:53.721 ********
Monday 09 January 2023  15:14:27 -0500 (0:00:00.019)       0:23:53.741 ********
Monday 09 January 2023  15:14:27 -0500 (0:00:00.020)       0:23:53.761 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.5/kubespray/roles/etcd/tasks/install_host.yml for node1
Monday 09 January 2023  15:14:27 -0500 (0:00:00.034)       0:23:53.796 ********

TASK [etcd : Get currently-deployed etcd version] **********************************************************************
fatal: [node1]: FAILED! => {"changed": false, "cmd": "/usr/local/bin/etcd --version", "msg": "[Errno 2] No such file or directory: b'/usr/local/bin/etcd'", "rc": 2, "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
...ignoring
Monday 09 January 2023  15:14:29 -0500 (0:00:01.593)       0:23:55.390 ********

TASK [etcd : Restart etcd if necessary] ********************************************************************************
changed: [node1]
Monday 09 January 2023  15:14:31 -0500 (0:00:01.898)       0:23:57.289 ********
Monday 09 January 2023  15:14:31 -0500 (0:00:00.017)       0:23:57.307 ********

TASK [etcd : install | Copy etcd and etcdctl binary from download dir] *************************************************
changed: [node1] => (item=etcd)
changed: [node1] => (item=etcdctl)
Monday 09 January 2023  15:14:35 -0500 (0:00:04.417)       0:24:01.724 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.5/kubespray/roles/etcd/tasks/configure.yml for node1
Monday 09 January 2023  15:14:35 -0500 (0:00:00.044)       0:24:01.769 ********

TASK [etcd : Configure | Check if etcd cluster is healthy] *************************************************************
ok: [node1]
Monday 09 January 2023  15:14:42 -0500 (0:00:07.166)       0:24:08.936 ********
Monday 09 January 2023  15:14:42 -0500 (0:00:00.017)       0:24:08.953 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.5/kubespray/roles/etcd/tasks/refresh_config.yml for node1
Monday 09 January 2023  15:14:42 -0500 (0:00:00.033)       0:24:08.988 ********

TASK [etcd : Refresh config | Create etcd config file] *****************************************************************
changed: [node1]
Monday 09 January 2023  15:14:47 -0500 (0:00:04.233)       0:24:13.222 ********
Monday 09 January 2023  15:14:47 -0500 (0:00:00.015)       0:24:13.238 ********

TASK [etcd : Configure | Copy etcd.service systemd file] ***************************************************************
changed: [node1]
Monday 09 January 2023  15:14:51 -0500 (0:00:04.334)       0:24:17.572 ********
Monday 09 January 2023  15:14:51 -0500 (0:00:00.021)       0:24:17.593 ********

TASK [etcd : Configure | reload systemd] *******************************************************************************
ok: [node1]
Monday 09 January 2023  15:14:56 -0500 (0:00:04.706)       0:24:22.300 ********

TASK [etcd : Configure | Ensure etcd is running] ***********************************************************************
changed: [node1]
Monday 09 January 2023  15:15:02 -0500 (0:00:06.273)       0:24:28.573 ********
Monday 09 January 2023  15:15:02 -0500 (0:00:00.026)       0:24:28.599 ********

TASK [etcd : Configure | Wait for etcd cluster to be healthy] **********************************************************
ok: [node1]
Monday 09 January 2023  15:15:07 -0500 (0:00:04.491)       0:24:33.091 ********
Monday 09 January 2023  15:15:07 -0500 (0:00:00.018)       0:24:33.109 ********

TASK [etcd : Configure | Check if member is in etcd cluster] ***********************************************************
ok: [node1]
Monday 09 January 2023  15:15:09 -0500 (0:00:02.566)       0:24:35.676 ********
Monday 09 January 2023  15:15:09 -0500 (0:00:00.018)       0:24:35.695 ********
Monday 09 January 2023  15:15:09 -0500 (0:00:00.020)       0:24:35.715 ********
Monday 09 January 2023  15:15:09 -0500 (0:00:00.018)       0:24:35.733 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.5/kubespray/roles/etcd/tasks/refresh_config.yml for node1
Monday 09 January 2023  15:15:09 -0500 (0:00:00.040)       0:24:35.774 ********

TASK [etcd : Refresh config | Create etcd config file] *****************************************************************
changed: [node1]
Monday 09 January 2023  15:15:15 -0500 (0:00:06.243)       0:24:42.018 ********
Monday 09 January 2023  15:15:15 -0500 (0:00:00.016)       0:24:42.035 ********
Monday 09 January 2023  15:15:15 -0500 (0:00:00.018)       0:24:42.053 ********
Monday 09 January 2023  15:15:16 -0500 (0:00:00.018)       0:24:42.072 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.5/kubespray/roles/etcd/tasks/refresh_config.yml for node1
Monday 09 January 2023  15:15:16 -0500 (0:00:00.036)       0:24:42.109 ********

TASK [etcd : Refresh config | Create etcd config file] *****************************************************************
ok: [node1]
Monday 09 January 2023  15:15:19 -0500 (0:00:03.870)       0:24:45.979 ********
Monday 09 January 2023  15:15:19 -0500 (0:00:00.022)       0:24:46.001 ********

RUNNING HANDLER [etcd : restart etcd] **********************************************************************************
changed: [node1]
Monday 09 January 2023  15:15:22 -0500 (0:00:02.176)       0:24:48.178 ********

RUNNING HANDLER [etcd : Backup etcd data] ******************************************************************************
changed: [node1]
Monday 09 January 2023  15:15:24 -0500 (0:00:02.140)       0:24:50.318 ********

RUNNING HANDLER [etcd : Refresh Time Fact] *****************************************************************************
ok: [node1]
Monday 09 January 2023  15:15:30 -0500 (0:00:05.876)       0:24:56.195 ********

RUNNING HANDLER [etcd : Set Backup Directory] **************************************************************************
ok: [node1]
Monday 09 January 2023  15:15:30 -0500 (0:00:00.025)       0:24:56.220 ********

RUNNING HANDLER [etcd : Create Backup Directory] ***********************************************************************
changed: [node1]
Monday 09 January 2023  15:15:33 -0500 (0:00:02.939)       0:24:59.160 ********

RUNNING HANDLER [etcd : Stat etcd v2 data directory] *******************************************************************
ok: [node1]
Monday 09 January 2023  15:15:36 -0500 (0:00:03.134)       0:25:02.295 ********

RUNNING HANDLER [etcd : Backup etcd v2 data] ***************************************************************************
changed: [node1]
Monday 09 January 2023  15:15:39 -0500 (0:00:02.900)       0:25:05.195 ********

RUNNING HANDLER [etcd : Backup etcd v3 data] ***************************************************************************
changed: [node1]
Monday 09 January 2023  15:15:42 -0500 (0:00:03.195)       0:25:08.391 ********

RUNNING HANDLER [etcd : etcd | reload systemd] *************************************************************************
ok: [node1]
Monday 09 January 2023  15:15:47 -0500 (0:00:04.957)       0:25:13.348 ********

RUNNING HANDLER [etcd : reload etcd] ***********************************************************************************
changed: [node1]
Monday 09 January 2023  15:15:59 -0500 (0:00:12.329)       0:25:25.678 ********

RUNNING HANDLER [etcd : wait for etcd up] ******************************************************************************
ok: [node1]
Monday 09 January 2023  15:16:04 -0500 (0:00:04.781)       0:25:30.459 ********

RUNNING HANDLER [etcd : Cleanup etcd backups] **************************************************************************
changed: [node1]
Monday 09 January 2023  15:16:06 -0500 (0:00:02.431)       0:25:32.891 ********
Monday 09 January 2023  15:16:06 -0500 (0:00:00.016)       0:25:32.908 ********

RUNNING HANDLER [etcd : set etcd_secret_changed] ***********************************************************************
ok: [node1]

PLAY [k8s_cluster] *****************************************************************************************************
Monday 09 January 2023  15:16:06 -0500 (0:00:00.057)       0:25:32.966 ********
Monday 09 January 2023  15:16:06 -0500 (0:00:00.049)       0:25:33.016 ********
Monday 09 January 2023  15:16:06 -0500 (0:00:00.019)       0:25:33.035 ********
Monday 09 January 2023  15:16:06 -0500 (0:00:00.017)       0:25:33.053 ********
Monday 09 January 2023  15:16:07 -0500 (0:00:00.042)       0:25:33.096 ********
Monday 09 January 2023  15:16:07 -0500 (0:00:00.049)       0:25:33.145 ********
Monday 09 January 2023  15:16:07 -0500 (0:00:00.050)       0:25:33.195 ********
Monday 09 January 2023  15:16:07 -0500 (0:00:00.049)       0:25:33.245 ********
Monday 09 January 2023  15:16:07 -0500 (0:00:00.016)       0:25:33.263 ********
Monday 09 January 2023  15:16:07 -0500 (0:00:00.048)       0:25:33.311 ********
Monday 09 January 2023  15:16:07 -0500 (0:00:00.666)       0:25:33.977 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node2] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node3] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node4] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Monday 09 January 2023  15:16:07 -0500 (0:00:00.080)       0:25:34.058 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.029)       0:25:34.087 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.016)       0:25:34.104 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.048)       0:25:34.153 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.016)       0:25:34.170 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.049)       0:25:34.220 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.065)       0:25:34.286 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.057)       0:25:34.343 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.085)       0:25:34.429 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.052)       0:25:34.482 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.082)       0:25:34.564 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.054)       0:25:34.619 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.054)       0:25:34.674 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.050)       0:25:34.725 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.051)       0:25:34.776 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.048)       0:25:34.824 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.048)       0:25:34.873 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.056)       0:25:34.929 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.046)       0:25:34.976 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.049)       0:25:35.025 ********
Monday 09 January 2023  15:16:08 -0500 (0:00:00.054)       0:25:35.079 ********
Monday 09 January 2023  15:16:09 -0500 (0:00:00.048)       0:25:35.128 ********

PLAY [k8s_cluster] *****************************************************************************************************
Monday 09 January 2023  15:16:09 -0500 (0:00:00.118)       0:25:35.247 ********
Monday 09 January 2023  15:16:09 -0500 (0:00:00.051)       0:25:35.299 ********
Monday 09 January 2023  15:16:09 -0500 (0:00:00.019)       0:25:35.319 ********
Monday 09 January 2023  15:16:09 -0500 (0:00:00.017)       0:25:35.336 ********
Monday 09 January 2023  15:16:09 -0500 (0:00:00.049)       0:25:35.386 ********
Monday 09 January 2023  15:16:09 -0500 (0:00:00.126)       0:25:35.512 ********
Monday 09 January 2023  15:16:09 -0500 (0:00:00.045)       0:25:35.558 ********
Monday 09 January 2023  15:16:09 -0500 (0:00:00.047)       0:25:35.605 ********
Monday 09 January 2023  15:16:09 -0500 (0:00:00.015)       0:25:35.621 ********
Monday 09 January 2023  15:16:09 -0500 (0:00:00.047)       0:25:35.669 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.672)       0:25:36.344 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node2] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node3] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node4] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Monday 09 January 2023  15:16:10 -0500 (0:00:00.080)       0:25:36.425 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.028)       0:25:36.457 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.018)       0:25:36.475 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.038)       0:25:36.525 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.016)       0:25:36.541 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.045)       0:25:36.587 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.054)       0:25:36.654 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.040)       0:25:36.695 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.041)       0:25:36.736 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.045)       0:25:36.782 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.039)       0:25:36.821 ********

TASK [kubernetes/node : set kubelet_cgroup_driver_detected fact for containerd] ****************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:16:10 -0500 (0:00:00.048)       0:25:36.871 ********

TASK [kubernetes/node : set kubelet_cgroup_driver] *********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:16:10 -0500 (0:00:00.054)       0:25:36.926 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.041)       0:25:36.968 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.033)       0:25:37.006 ********
Monday 09 January 2023  15:16:10 -0500 (0:00:00.055)       0:25:37.063 ********

TASK [kubernetes/node : Pre-upgrade | check if kubelet container exists] ***********************************************
ok: [node4]
ok: [node3]
ok: [node2]
ok: [node1]
Monday 09 January 2023  15:16:17 -0500 (0:00:06.182)       0:25:43.245 ********
Monday 09 January 2023  15:16:17 -0500 (0:00:00.046)       0:25:43.292 ********
Monday 09 January 2023  15:16:17 -0500 (0:00:00.048)       0:25:43.340 ********
Monday 09 January 2023  15:16:17 -0500 (0:00:00.044)       0:25:43.385 ********

TASK [kubernetes/node : Ensure /var/lib/cni exists] ********************************************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:16:19 -0500 (0:00:02.552)       0:25:45.937 ********

TASK [kubernetes/node : install | Copy kubeadm binary from download dir] ***********************************************
changed: [node4]
changed: [node2]
changed: [node3]
Monday 09 January 2023  15:16:21 -0500 (0:00:02.002)       0:25:47.940 ********

TASK [kubernetes/node : install | Copy kubelet binary from download dir] ***********************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:16:28 -0500 (0:00:06.884)       0:25:54.825 ********
Monday 09 January 2023  15:16:28 -0500 (0:00:00.046)       0:25:54.871 ********
Monday 09 January 2023  15:16:28 -0500 (0:00:00.043)       0:25:54.915 ********

TASK [kubernetes/node : haproxy | Cleanup potentially deployed haproxy] ************************************************
ok: [node2]
ok: [node4]
ok: [node3]
Monday 09 January 2023  15:16:30 -0500 (0:00:01.988)       0:25:56.903 ********

TASK [kubernetes/node : nginx-proxy | Make nginx directory] ************************************************************
changed: [node2]
changed: [node4]
changed: [node3]
Monday 09 January 2023  15:16:32 -0500 (0:00:01.842)       0:25:58.746 ********

TASK [kubernetes/node : nginx-proxy | Write nginx-proxy configuration] *************************************************
changed: [node2]
changed: [node4]
changed: [node3]
Monday 09 January 2023  15:16:35 -0500 (0:00:03.315)       0:26:02.061 ********

TASK [kubernetes/node : nginx-proxy | Get checksum from config] ********************************************************
ok: [node2]
ok: [node4]
ok: [node3]
Monday 09 January 2023  15:16:37 -0500 (0:00:01.717)       0:26:03.779 ********

TASK [kubernetes/node : nginx-proxy | Write static pod] ****************************************************************
changed: [node2]
changed: [node4]
changed: [node3]
Monday 09 January 2023  15:16:40 -0500 (0:00:02.944)       0:26:06.724 ********
Monday 09 January 2023  15:16:40 -0500 (0:00:00.047)       0:26:06.771 ********
Monday 09 January 2023  15:16:40 -0500 (0:00:00.050)       0:26:06.822 ********
Monday 09 January 2023  15:16:40 -0500 (0:00:00.050)       0:26:06.872 ********
Monday 09 January 2023  15:16:40 -0500 (0:00:00.048)       0:26:06.920 ********
Monday 09 January 2023  15:16:40 -0500 (0:00:00.045)       0:26:06.966 ********

TASK [kubernetes/node : Ensure nodePort range is reserved] *************************************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:16:43 -0500 (0:00:02.113)       0:26:09.079 ********

TASK [kubernetes/node : Verify if br_netfilter module exists] **********************************************************
ok: [node4]
ok: [node2]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:16:44 -0500 (0:00:01.783)       0:26:10.863 ********

TASK [kubernetes/node : Verify br_netfilter module path exists] ********************************************************
ok: [node4]
ok: [node2]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:16:46 -0500 (0:00:01.819)       0:26:12.683 ********

TASK [kubernetes/node : Enable br_netfilter module] ********************************************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:16:48 -0500 (0:00:02.355)       0:26:15.038 ********

TASK [kubernetes/node : Persist br_netfilter module] *******************************************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:16:52 -0500 (0:00:03.699)       0:26:18.738 ********

TASK [kubernetes/node : Check if bridge-nf-call-iptables key exists] ***************************************************
ok: [node4]
ok: [node2]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:16:54 -0500 (0:00:02.195)       0:26:20.933 ********

TASK [kubernetes/node : Enable bridge-nf-call tables] ******************************************************************
changed: [node4] => (item=net.bridge.bridge-nf-call-iptables)
changed: [node2] => (item=net.bridge.bridge-nf-call-iptables)
changed: [node3] => (item=net.bridge.bridge-nf-call-iptables)
changed: [node4] => (item=net.bridge.bridge-nf-call-arptables)
changed: [node1] => (item=net.bridge.bridge-nf-call-iptables)
changed: [node2] => (item=net.bridge.bridge-nf-call-arptables)
changed: [node3] => (item=net.bridge.bridge-nf-call-arptables)
changed: [node4] => (item=net.bridge.bridge-nf-call-ip6tables)
changed: [node2] => (item=net.bridge.bridge-nf-call-ip6tables)
changed: [node3] => (item=net.bridge.bridge-nf-call-ip6tables)
changed: [node1] => (item=net.bridge.bridge-nf-call-arptables)
changed: [node1] => (item=net.bridge.bridge-nf-call-ip6tables)
Monday 09 January 2023  15:17:01 -0500 (0:00:06.261)       0:26:27.195 ********

TASK [kubernetes/node : Modprobe Kernel Module for IPVS] ***************************************************************
changed: [node4] => (item=ip_vs)
changed: [node2] => (item=ip_vs)
changed: [node4] => (item=ip_vs_rr)
changed: [node3] => (item=ip_vs)
changed: [node2] => (item=ip_vs_rr)
changed: [node4] => (item=ip_vs_wrr)
changed: [node1] => (item=ip_vs)
changed: [node3] => (item=ip_vs_rr)
changed: [node4] => (item=ip_vs_sh)
changed: [node2] => (item=ip_vs_wrr)
changed: [node2] => (item=ip_vs_sh)
changed: [node3] => (item=ip_vs_wrr)
changed: [node3] => (item=ip_vs_sh)
changed: [node1] => (item=ip_vs_rr)
changed: [node1] => (item=ip_vs_wrr)
changed: [node1] => (item=ip_vs_sh)
Monday 09 January 2023  15:17:13 -0500 (0:00:12.092)       0:26:39.287 ********

TASK [kubernetes/node : Modprobe nf_conntrack_ipv4] ********************************************************************
fatal: [node4]: FAILED! => {"changed": false, "msg": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "name": "nf_conntrack_ipv4", "params": "", "rc": 1, "state": "present", "stderr": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "stderr_lines": ["modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64"], "stdout": "", "stdout_lines": []}
...ignoring
fatal: [node2]: FAILED! => {"changed": false, "msg": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "name": "nf_conntrack_ipv4", "params": "", "rc": 1, "state": "present", "stderr": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "stderr_lines": ["modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64"], "stdout": "", "stdout_lines": []}
...ignoring
fatal: [node3]: FAILED! => {"changed": false, "msg": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "name": "nf_conntrack_ipv4", "params": "", "rc": 1, "state": "present", "stderr": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "stderr_lines": ["modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64"], "stdout": "", "stdout_lines": []}
...ignoring
fatal: [node1]: FAILED! => {"changed": false, "msg": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "name": "nf_conntrack_ipv4", "params": "", "rc": 1, "state": "present", "stderr": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "stderr_lines": ["modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64"], "stdout": "", "stdout_lines": []}
...ignoring
Monday 09 January 2023  15:17:15 -0500 (0:00:02.451)       0:26:41.739 ********

TASK [kubernetes/node : Persist ip_vs modules] *************************************************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:17:20 -0500 (0:00:04.369)       0:26:46.108 ********
Monday 09 January 2023  15:17:20 -0500 (0:00:00.055)       0:26:46.164 ********
Monday 09 January 2023  15:17:20 -0500 (0:00:00.045)       0:26:46.210 ********
Monday 09 January 2023  15:17:20 -0500 (0:00:00.059)       0:26:46.269 ********
Monday 09 January 2023  15:17:20 -0500 (0:00:00.048)       0:26:46.318 ********

TASK [kubernetes/node : Set kubelet api version to v1beta1] ************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:17:20 -0500 (0:00:00.060)       0:26:46.379 ********

TASK [kubernetes/node : Write kubelet environment config file (kubeadm)] ***********************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:17:25 -0500 (0:00:04.722)       0:26:51.104 ********

TASK [kubernetes/node : Write kubelet config file] *********************************************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:17:30 -0500 (0:00:05.670)       0:26:56.775 ********

TASK [kubernetes/node : Write kubelet systemd init file] ***************************************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:17:35 -0500 (0:00:04.481)       0:27:01.257 ********
Monday 09 January 2023  15:17:35 -0500 (0:00:00.000)       0:27:01.257 ********

RUNNING HANDLER [kubernetes/node : Node | restart kubelet] *************************************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:17:37 -0500 (0:00:02.271)       0:27:03.529 ********

RUNNING HANDLER [kubernetes/node : Kubelet | reload systemd] ***********************************************************
ok: [node4]
ok: [node2]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:17:42 -0500 (0:00:05.452)       0:27:08.982 ********

RUNNING HANDLER [kubernetes/node : Kubelet | restart kubelet] **********************************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:17:46 -0500 (0:00:03.638)       0:27:12.620 ********

TASK [kubernetes/node : Enable kubelet] ********************************************************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:17:52 -0500 (0:00:05.529)       0:27:18.150 ********

RUNNING HANDLER [kubernetes/node : Kubelet | restart kubelet] **********************************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]

PLAY [kube_control_plane] **********************************************************************************************
Monday 09 January 2023  15:17:55 -0500 (0:00:03.690)       0:27:21.841 ********
Monday 09 January 2023  15:17:55 -0500 (0:00:00.034)       0:27:21.875 ********
Monday 09 January 2023  15:17:55 -0500 (0:00:00.031)       0:27:21.907 ********
Monday 09 January 2023  15:17:55 -0500 (0:00:00.023)       0:27:21.933 ********
Monday 09 January 2023  15:17:55 -0500 (0:00:00.028)       0:27:21.961 ********
Monday 09 January 2023  15:17:55 -0500 (0:00:00.027)       0:27:21.989 ********
Monday 09 January 2023  15:17:55 -0500 (0:00:00.028)       0:27:22.017 ********
Monday 09 January 2023  15:17:55 -0500 (0:00:00.030)       0:27:22.048 ********
Monday 09 January 2023  15:17:55 -0500 (0:00:00.025)       0:27:22.074 ********
Monday 09 January 2023  15:17:56 -0500 (0:00:00.027)       0:27:22.102 ********
Monday 09 January 2023  15:17:56 -0500 (0:00:00.813)       0:27:22.915 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Monday 09 January 2023  15:17:56 -0500 (0:00:00.080)       0:27:22.996 ********
Monday 09 January 2023  15:17:56 -0500 (0:00:00.048)       0:27:23.045 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.031)       0:27:23.076 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.031)       0:27:23.107 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.022)       0:27:23.136 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.027)       0:27:23.163 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.044)       0:27:23.208 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.036)       0:27:23.244 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.024)       0:27:23.269 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.026)       0:27:23.295 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.019)       0:27:23.315 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.029)       0:27:23.345 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.040)       0:27:23.385 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.036)       0:27:23.422 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.023)       0:27:23.463 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.053)       0:27:23.517 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.036)       0:27:23.553 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.027)       0:27:23.581 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.032)       0:27:23.613 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.025)       0:27:23.639 ********
Monday 09 January 2023  15:17:57 -0500 (0:00:00.035)       0:27:23.674 ********

TASK [kubernetes/control-plane : Pre-upgrade | Delete master manifests if etcd secrets changed] ************************
ok: [node1] => (item=kube-apiserver)
ok: [node1] => (item=kube-controller-manager)
ok: [node1] => (item=kube-scheduler)
Monday 09 January 2023  15:18:05 -0500 (0:00:08.147)       0:27:31.822 ********
Monday 09 January 2023  15:18:05 -0500 (0:00:00.037)       0:27:31.859 ********
Monday 09 January 2023  15:18:05 -0500 (0:00:00.029)       0:27:31.889 ********
Monday 09 January 2023  15:18:05 -0500 (0:00:00.029)       0:27:31.919 ********

TASK [kubernetes/control-plane : Create kube-scheduler config] *********************************************************
changed: [node1]
Monday 09 January 2023  15:18:10 -0500 (0:00:04.569)       0:27:36.488 ********
Monday 09 January 2023  15:18:10 -0500 (0:00:00.026)       0:27:36.515 ********
Monday 09 January 2023  15:18:10 -0500 (0:00:00.022)       0:27:36.538 ********
Monday 09 January 2023  15:18:10 -0500 (0:00:00.018)       0:27:36.557 ********
Monday 09 January 2023  15:18:10 -0500 (0:00:00.059)       0:27:36.618 ********
Monday 09 January 2023  15:18:10 -0500 (0:00:00.026)       0:27:36.644 ********
Monday 09 January 2023  15:18:10 -0500 (0:00:00.026)       0:27:36.671 ********

TASK [kubernetes/control-plane : Install | Copy kubectl binary from download dir] **************************************
changed: [node1]
Monday 09 January 2023  15:18:14 -0500 (0:00:03.839)       0:27:40.510 ********

TASK [kubernetes/control-plane : Install kubectl bash completion] ******************************************************
changed: [node1]
Monday 09 January 2023  15:18:17 -0500 (0:00:02.953)       0:27:43.463 ********

TASK [kubernetes/control-plane : Set kubectl bash completion file permissions] *****************************************
changed: [node1]
Monday 09 January 2023  15:18:19 -0500 (0:00:02.310)       0:27:45.774 ********
Monday 09 January 2023  15:18:19 -0500 (0:00:00.020)       0:27:45.794 ********

TASK [kubernetes/control-plane : Check which kube-control nodes are already members of the cluster] ********************
fatal: [node1]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/kubectl", "get", "nodes", "--selector=node-role.kubernetes.io/control-plane", "-o", "json"], "delta": "0:00:00.462558", "end": "2023-01-09 20:18:22.176607", "msg": "non-zero return code", "rc": 1, "start": "2023-01-09 20:18:21.714049", "stderr": "The connection to the server localhost:8080 was refused - did you specify the right host or port?", "stderr_lines": ["The connection to the server localhost:8080 was refused - did you specify the right host or port?"], "stdout": "", "stdout_lines": []}
...ignoring
Monday 09 January 2023  15:18:22 -0500 (0:00:02.665)       0:27:48.459 ********
Monday 09 January 2023  15:18:22 -0500 (0:00:00.021)       0:27:48.481 ********

TASK [kubernetes/control-plane : Set fact first_kube_control_plane] ****************************************************
ok: [node1]
Monday 09 January 2023  15:18:22 -0500 (0:00:00.029)       0:27:48.511 ********
Monday 09 January 2023  15:18:22 -0500 (0:00:00.017)       0:27:48.529 ********

TASK [kubernetes/control-plane : kubeadm | Check if kubeadm has already run] *******************************************
ok: [node1]
Monday 09 January 2023  15:18:24 -0500 (0:00:02.242)       0:27:50.771 ********
Monday 09 January 2023  15:18:24 -0500 (0:00:00.033)       0:27:50.805 ********
Monday 09 January 2023  15:18:24 -0500 (0:00:00.028)       0:27:50.833 ********

TASK [kubernetes/control-plane : kubeadm | aggregate all SANs] *********************************************************
ok: [node1]
Monday 09 January 2023  15:18:24 -0500 (0:00:00.113)       0:27:50.946 ********
Monday 09 January 2023  15:18:24 -0500 (0:00:00.018)       0:27:50.965 ********
Monday 09 January 2023  15:18:24 -0500 (0:00:00.020)       0:27:50.986 ********
Monday 09 January 2023  15:18:24 -0500 (0:00:00.018)       0:27:51.005 ********
Monday 09 January 2023  15:18:24 -0500 (0:00:00.019)       0:27:51.024 ********

TASK [kubernetes/control-plane : Set kubeadm api version to v1beta3] ***************************************************
ok: [node1]
Monday 09 January 2023  15:18:24 -0500 (0:00:00.024)       0:27:51.049 ********

TASK [kubernetes/control-plane : kubeadm | Create kubeadm config] ******************************************************
changed: [node1]
Monday 09 January 2023  15:18:29 -0500 (0:00:04.771)       0:27:55.820 ********
Monday 09 January 2023  15:18:29 -0500 (0:00:00.016)       0:27:55.836 ********
Monday 09 January 2023  15:18:29 -0500 (0:00:00.018)       0:27:55.855 ********
Monday 09 January 2023  15:18:29 -0500 (0:00:00.016)       0:27:55.871 ********
Monday 09 January 2023  15:18:29 -0500 (0:00:00.020)       0:27:55.891 ********
Monday 09 January 2023  15:18:29 -0500 (0:00:00.020)       0:27:55.912 ********
Monday 09 January 2023  15:18:29 -0500 (0:00:00.016)       0:27:55.929 ********
Monday 09 January 2023  15:18:29 -0500 (0:00:00.018)       0:27:55.947 ********
Monday 09 January 2023  15:18:29 -0500 (0:00:00.020)       0:27:55.967 ********

TASK [kubernetes/control-plane : kubeadm | Initialize first master] ****************************************************
changed: [node1]
Monday 09 January 2023  15:20:17 -0500 (0:01:47.123)       0:29:43.091 ********
Monday 09 January 2023  15:20:17 -0500 (0:00:00.435)       0:29:43.526 ********
Monday 09 January 2023  15:20:17 -0500 (0:00:00.024)       0:29:43.551 ********

TASK [kubernetes/control-plane : Create kubeadm token for joining nodes with 24h expiration (default)] *****************
ok: [node1]
Monday 09 January 2023  15:20:20 -0500 (0:00:03.432)       0:29:46.983 ********

TASK [kubernetes/control-plane : Set kubeadm_token] ********************************************************************
ok: [node1]
Monday 09 January 2023  15:20:20 -0500 (0:00:00.028)       0:29:47.011 ********
Monday 09 January 2023  15:20:20 -0500 (0:00:00.017)       0:29:47.029 ********

TASK [kubernetes/control-plane : kubeadm | Join other masters] *********************************************************
included: /root/13.5/kubespray/roles/kubernetes/control-plane/tasks/kubeadm-secondary.yml for node1
Monday 09 January 2023  15:20:20 -0500 (0:00:00.038)       0:29:47.067 ********

TASK [kubernetes/control-plane : Set kubeadm_discovery_address] ********************************************************
ok: [node1]
Monday 09 January 2023  15:20:21 -0500 (0:00:00.064)       0:29:47.131 ********

TASK [kubernetes/control-plane : Upload certificates so they are fresh and not expired] ********************************
changed: [node1]
Monday 09 January 2023  15:20:24 -0500 (0:00:03.771)       0:29:50.902 ********

TASK [kubernetes/control-plane : Parse certificate key if not set] *****************************************************
ok: [node1]
Monday 09 January 2023  15:20:24 -0500 (0:00:00.047)       0:29:50.950 ********
Monday 09 January 2023  15:20:24 -0500 (0:00:00.016)       0:29:50.967 ********

TASK [kubernetes/control-plane : Wait for k8s apiserver] ***************************************************************
ok: [node1]
Monday 09 January 2023  15:20:27 -0500 (0:00:02.618)       0:29:53.585 ********

TASK [kubernetes/control-plane : check already run] ********************************************************************
ok: [node1] => {
    "msg": false
}
Monday 09 January 2023  15:20:27 -0500 (0:00:00.020)       0:29:53.606 ********
Monday 09 January 2023  15:20:27 -0500 (0:00:00.014)       0:29:53.629 ********
Monday 09 January 2023  15:20:27 -0500 (0:00:00.017)       0:29:53.647 ********
Monday 09 January 2023  15:20:27 -0500 (0:00:00.025)       0:29:53.673 ********
Monday 09 January 2023  15:20:27 -0500 (0:00:00.022)       0:29:53.695 ********
Monday 09 January 2023  15:20:27 -0500 (0:00:00.016)       0:29:53.712 ********

TASK [kubernetes/control-plane : Include kubeadm secondary server apiserver fixes] *************************************
included: /root/13.5/kubespray/roles/kubernetes/control-plane/tasks/kubeadm-fix-apiserver.yml for node1
Monday 09 January 2023  15:20:27 -0500 (0:00:00.037)       0:29:53.750 ********

TASK [kubernetes/control-plane : Update server field in component kubeconfigs] *****************************************
changed: [node1] => (item=admin.conf)
changed: [node1] => (item=controller-manager.conf)
changed: [node1] => (item=kubelet.conf)
changed: [node1] => (item=scheduler.conf)
Monday 09 January 2023  15:20:39 -0500 (0:00:12.143)       0:30:05.893 ********

TASK [kubernetes/control-plane : Update etcd-servers for apiserver] ****************************************************
ok: [node1]
Monday 09 January 2023  15:20:42 -0500 (0:00:02.991)       0:30:08.884 ********

TASK [kubernetes/control-plane : Include kubelet client cert rotation fixes] *******************************************
included: /root/13.5/kubespray/roles/kubernetes/control-plane/tasks/kubelet-fix-client-cert-rotation.yml for node1
Monday 09 January 2023  15:20:42 -0500 (0:00:00.041)       0:30:08.926 ********

TASK [kubernetes/control-plane : Fixup kubelet client cert rotation 1/2] ***********************************************
ok: [node1]
Monday 09 January 2023  15:20:44 -0500 (0:00:01.836)       0:30:10.762 ********

TASK [kubernetes/control-plane : Fixup kubelet client cert rotation 2/2] ***********************************************
ok: [node1]
Monday 09 January 2023  15:20:46 -0500 (0:00:01.766)       0:30:12.528 ********

TASK [kubernetes/control-plane : Install script to renew K8S control plane certificates] *******************************
changed: [node1]
Monday 09 January 2023  15:20:51 -0500 (0:00:04.910)       0:30:17.439 ********
Monday 09 January 2023  15:20:51 -0500 (0:00:00.020)       0:30:17.459 ********
Monday 09 January 2023  15:20:51 -0500 (0:00:00.023)       0:30:17.483 ********

TASK [kubernetes/client : Set external kube-apiserver endpoint] ********************************************************
ok: [node1]
Monday 09 January 2023  15:20:51 -0500 (0:00:00.029)       0:30:17.512 ********

TASK [kubernetes/client : Create kube config dir for current/ansible become user] **************************************
changed: [node1]
Monday 09 January 2023  15:20:54 -0500 (0:00:02.718)       0:30:20.230 ********

TASK [kubernetes/client : Copy admin kubeconfig to current/ansible become user home] ***********************************
changed: [node1]
Monday 09 January 2023  15:20:56 -0500 (0:00:01.941)       0:30:22.172 ********
Monday 09 January 2023  15:20:56 -0500 (0:00:00.016)       0:30:22.189 ********

TASK [kubernetes/client : Wait for k8s apiserver] **********************************************************************
ok: [node1]
Monday 09 January 2023  15:20:58 -0500 (0:00:01.973)       0:30:24.162 ********
Monday 09 January 2023  15:20:58 -0500 (0:00:00.016)       0:30:24.178 ********
Monday 09 January 2023  15:20:58 -0500 (0:00:00.015)       0:30:24.193 ********
Monday 09 January 2023  15:20:58 -0500 (0:00:00.018)       0:30:24.212 ********
Monday 09 January 2023  15:20:58 -0500 (0:00:00.031)       0:30:24.243 ********
Monday 09 January 2023  15:20:58 -0500 (0:00:00.018)       0:30:24.261 ********
Monday 09 January 2023  15:20:58 -0500 (0:00:00.022)       0:30:24.284 ********

TASK [kubernetes-apps/cluster_roles : Kubernetes Apps | Wait for kube-apiserver] ***************************************
ok: [node1]
Monday 09 January 2023  15:21:05 -0500 (0:00:07.769)       0:30:32.053 ********

TASK [kubernetes-apps/cluster_roles : Kubernetes Apps | Add ClusterRoleBinding to admit nodes] *************************
changed: [node1]
Monday 09 January 2023  15:21:11 -0500 (0:00:05.024)       0:30:37.081 ********

TASK [kubernetes-apps/cluster_roles : Apply workaround to allow all nodes with cert O=system:nodes to register] ********
ok: [node1]
Monday 09 January 2023  15:21:24 -0500 (0:00:13.978)       0:30:51.060 ********
Monday 09 January 2023  15:21:25 -0500 (0:00:00.019)       0:30:51.079 ********
Monday 09 January 2023  15:21:25 -0500 (0:00:00.020)       0:30:51.099 ********
Monday 09 January 2023  15:21:25 -0500 (0:00:00.020)       0:30:51.120 ********
Monday 09 January 2023  15:21:25 -0500 (0:00:00.018)       0:30:51.138 ********
Monday 09 January 2023  15:21:25 -0500 (0:00:00.020)       0:30:51.158 ********

TASK [kubernetes-apps/cluster_roles : PriorityClass | Copy k8s-cluster-critical-pc.yml file] ***************************
changed: [node1]
Monday 09 January 2023  15:21:32 -0500 (0:00:07.307)       0:30:58.467 ********

TASK [kubernetes-apps/cluster_roles : PriorityClass | Create k8s-cluster-critical] *************************************
ok: [node1]
Monday 09 January 2023  15:21:37 -0500 (0:00:05.446)       0:31:03.914 ********

RUNNING HANDLER [kubernetes/control-plane : Master | restart kubelet] **************************************************
changed: [node1]
Monday 09 January 2023  15:21:40 -0500 (0:00:03.101)       0:31:07.015 ********

RUNNING HANDLER [kubernetes/control-plane : Master | wait for master static pods] **************************************
changed: [node1]
Monday 09 January 2023  15:21:42 -0500 (0:00:01.951)       0:31:08.966 ********

RUNNING HANDLER [kubernetes/control-plane : Master | Restart kube-scheduler] *******************************************
changed: [node1]
Monday 09 January 2023  15:21:45 -0500 (0:00:02.466)       0:31:11.433 ********

RUNNING HANDLER [kubernetes/control-plane : Master | Restart kube-controller-manager] **********************************
changed: [node1]
Monday 09 January 2023  15:21:47 -0500 (0:00:02.486)       0:31:13.919 ********

RUNNING HANDLER [kubernetes/control-plane : Master | reload systemd] ***************************************************
ok: [node1]
Monday 09 January 2023  15:21:53 -0500 (0:00:05.803)       0:31:19.723 ********

RUNNING HANDLER [kubernetes/control-plane : Master | reload kubelet] ***************************************************
changed: [node1]
Monday 09 January 2023  15:21:58 -0500 (0:00:04.460)       0:31:24.183 ********
Monday 09 January 2023  15:21:58 -0500 (0:00:00.016)       0:31:24.200 ********
FAILED - RETRYING: [node1]: Master | Remove scheduler container containerd/crio (10 retries left).

RUNNING HANDLER [kubernetes/control-plane : Master | Remove scheduler container containerd/crio] ***********************
changed: [node1]
Monday 09 January 2023  15:22:13 -0500 (0:00:15.807)       0:31:40.007 ********
Monday 09 January 2023  15:22:13 -0500 (0:00:00.016)       0:31:40.024 ********

RUNNING HANDLER [kubernetes/control-plane : Master | Remove controller manager container containerd/crio] **************
changed: [node1]
Monday 09 January 2023  15:22:23 -0500 (0:00:09.519)       0:31:49.544 ********

RUNNING HANDLER [kubernetes/control-plane : Master | wait for kube-scheduler] ******************************************
ok: [node1]
Monday 09 January 2023  15:22:34 -0500 (0:00:10.786)       0:32:00.330 ********
FAILED - RETRYING: [node1]: Master | wait for kube-controller-manager (60 retries left).

RUNNING HANDLER [kubernetes/control-plane : Master | wait for kube-controller-manager] *********************************
ok: [node1]
Monday 09 January 2023  15:22:45 -0500 (0:00:11.486)       0:32:11.816 ********

RUNNING HANDLER [kubernetes/control-plane : Master | wait for the apiserver to be running] *****************************
ok: [node1]

PLAY [k8s_cluster] *****************************************************************************************************
Monday 09 January 2023  15:22:49 -0500 (0:00:03.396)       0:32:15.213 ********
Monday 09 January 2023  15:22:49 -0500 (0:00:00.058)       0:32:15.271 ********
Monday 09 January 2023  15:22:49 -0500 (0:00:00.025)       0:32:15.296 ********
Monday 09 January 2023  15:22:49 -0500 (0:00:00.019)       0:32:15.316 ********
Monday 09 January 2023  15:22:49 -0500 (0:00:00.056)       0:32:15.373 ********
Monday 09 January 2023  15:22:49 -0500 (0:00:00.056)       0:32:15.429 ********
Monday 09 January 2023  15:22:49 -0500 (0:00:00.051)       0:32:15.481 ********
Monday 09 January 2023  15:22:49 -0500 (0:00:00.061)       0:32:15.542 ********
Monday 09 January 2023  15:22:49 -0500 (0:00:00.021)       0:32:15.563 ********
Monday 09 January 2023  15:22:49 -0500 (0:00:00.051)       0:32:15.615 ********
Monday 09 January 2023  15:22:50 -0500 (0:00:00.706)       0:32:16.322 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node2] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node3] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node4] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Monday 09 January 2023  15:22:50 -0500 (0:00:00.090)       0:32:16.412 ********
Monday 09 January 2023  15:22:50 -0500 (0:00:00.034)       0:32:16.446 ********
Monday 09 January 2023  15:22:50 -0500 (0:00:00.018)       0:32:16.465 ********
Monday 09 January 2023  15:22:50 -0500 (0:00:00.052)       0:32:16.517 ********
Monday 09 January 2023  15:22:50 -0500 (0:00:00.018)       0:32:16.536 ********
Monday 09 January 2023  15:22:50 -0500 (0:00:00.136)       0:32:16.672 ********
Monday 09 January 2023  15:22:50 -0500 (0:00:00.073)       0:32:16.746 ********

TASK [kubernetes/kubeadm : Set kubeadm_discovery_address] **************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:22:50 -0500 (0:00:00.095)       0:32:16.842 ********

TASK [kubernetes/kubeadm : Check if kubelet.conf exists] ***************************************************************
ok: [node4]
ok: [node2]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:22:53 -0500 (0:00:02.888)       0:32:19.730 ********

TASK [kubernetes/kubeadm : Check if kubeadm CA cert is accessible] *****************************************************
ok: [node1]
Monday 09 January 2023  15:22:55 -0500 (0:00:01.821)       0:32:21.552 ********

TASK [kubernetes/kubeadm : Calculate kubeadm CA cert hash] *************************************************************
ok: [node1]
Monday 09 January 2023  15:22:59 -0500 (0:00:03.593)       0:32:25.145 ********

TASK [kubernetes/kubeadm : Create kubeadm token for joining nodes with 24h expiration (default)] ***********************
ok: [node2 -> node1(62.84.117.40)]
ok: [node3 -> node1(62.84.117.40)]
ok: [node4 -> node1(62.84.117.40)]
Monday 09 January 2023  15:23:10 -0500 (0:00:10.976)       0:32:36.122 ********

TASK [kubernetes/kubeadm : Set kubeadm_token to generated token] *******************************************************
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:23:10 -0500 (0:00:00.058)       0:32:36.180 ********

TASK [kubernetes/kubeadm : Set kubeadm api version to v1beta3] *********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:23:10 -0500 (0:00:00.056)       0:32:36.237 ********

TASK [kubernetes/kubeadm : Create kubeadm client config] ***************************************************************
changed: [node4]
changed: [node2]
changed: [node3]
Monday 09 January 2023  15:23:13 -0500 (0:00:02.850)       0:32:39.088 ********
Monday 09 January 2023  15:23:13 -0500 (0:00:00.049)       0:32:39.137 ********
Monday 09 January 2023  15:23:13 -0500 (0:00:00.047)       0:32:39.184 ********

TASK [kubernetes/kubeadm : Join to cluster] ****************************************************************************
changed: [node3]
changed: [node2]
changed: [node4]
Monday 09 January 2023  15:23:38 -0500 (0:00:24.889)       0:33:04.074 ********
Monday 09 January 2023  15:23:38 -0500 (0:00:00.049)       0:33:04.124 ********

TASK [kubernetes/kubeadm : Update server field in kubelet kubeconfig] **************************************************
changed: [node2]
changed: [node4]
changed: [node3]
Monday 09 January 2023  15:23:41 -0500 (0:00:03.505)       0:33:07.629 ********

TASK [kubernetes/kubeadm : Update server field in kube-proxy kubeconfig] ***********************************************
changed: [node1]
Monday 09 January 2023  15:23:46 -0500 (0:00:04.834)       0:33:12.464 ********

TASK [kubernetes/kubeadm : Set ca.crt file permission] *****************************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:23:48 -0500 (0:00:02.467)       0:33:14.931 ********

TASK [kubernetes/kubeadm : Restart all kube-proxy pods to ensure that they load the new configmap] *********************
changed: [node1]
Monday 09 January 2023  15:23:53 -0500 (0:00:04.499)       0:33:19.431 ********
Monday 09 January 2023  15:23:53 -0500 (0:00:00.076)       0:33:19.508 ********

TASK [kubernetes/node-label : Kubernetes Apps | Wait for kube-apiserver] ***********************************************
ok: [node1]
Monday 09 January 2023  15:23:58 -0500 (0:00:05.100)       0:33:24.608 ********

TASK [kubernetes/node-label : Set role node label to empty list] *******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:23:58 -0500 (0:00:00.058)       0:33:24.666 ********
Monday 09 January 2023  15:23:58 -0500 (0:00:00.046)       0:33:24.713 ********

TASK [kubernetes/node-label : Set inventory node label to empty list] **************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:23:58 -0500 (0:00:00.055)       0:33:24.769 ********
Monday 09 January 2023  15:23:58 -0500 (0:00:00.048)       0:33:24.817 ********

TASK [kubernetes/node-label : debug] ***********************************************************************************
ok: [node1] => {
    "role_node_labels": []
}
ok: [node2] => {
    "role_node_labels": []
}
ok: [node3] => {
    "role_node_labels": []
}
ok: [node4] => {
    "role_node_labels": []
}
Monday 09 January 2023  15:23:58 -0500 (0:00:00.059)       0:33:24.877 ********

TASK [kubernetes/node-label : debug] ***********************************************************************************
ok: [node1] => {
    "inventory_node_labels": []
}
ok: [node2] => {
    "inventory_node_labels": []
}
ok: [node3] => {
    "inventory_node_labels": []
}
ok: [node4] => {
    "inventory_node_labels": []
}
Monday 09 January 2023  15:23:58 -0500 (0:00:00.057)       0:33:24.934 ********
Monday 09 January 2023  15:23:58 -0500 (0:00:00.103)       0:33:25.038 ********

TASK [network_plugin/cni : CNI | make sure /opt/cni/bin exists] ********************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:24:04 -0500 (0:00:05.427)       0:33:30.465 ********

TASK [network_plugin/cni : CNI | Copy cni plugins] *********************************************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:24:34 -0500 (0:00:29.818)       0:34:00.284 ********
Monday 09 January 2023  15:24:34 -0500 (0:00:00.051)       0:34:00.336 ********
Monday 09 January 2023  15:24:34 -0500 (0:00:00.048)       0:34:00.385 ********
Monday 09 January 2023  15:24:34 -0500 (0:00:00.059)       0:34:00.444 ********
Monday 09 January 2023  15:24:34 -0500 (0:00:00.049)       0:34:00.494 ********
Monday 09 January 2023  15:24:34 -0500 (0:00:00.049)       0:34:00.544 ********
Monday 09 January 2023  15:24:34 -0500 (0:00:00.048)       0:34:00.594 ********
Monday 09 January 2023  15:24:34 -0500 (0:00:00.214)       0:34:00.809 ********
Monday 09 January 2023  15:24:34 -0500 (0:00:00.052)       0:34:00.862 ********
Monday 09 January 2023  15:24:34 -0500 (0:00:00.047)       0:34:00.910 ********
Monday 09 January 2023  15:24:34 -0500 (0:00:00.079)       0:34:00.990 ********

TASK [network_plugin/calico : Slurp CNI config] ************************************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:24:37 -0500 (0:00:03.038)       0:34:04.029 ********
Monday 09 January 2023  15:24:38 -0500 (0:00:00.049)       0:34:04.078 ********
Monday 09 January 2023  15:24:38 -0500 (0:00:00.056)       0:34:04.134 ********
Monday 09 January 2023  15:24:38 -0500 (0:00:00.087)       0:34:04.222 ********

TASK [network_plugin/calico : Calico | Gather os specific variables] ***************************************************
ok: [node1] => (item=/root/13.5/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
ok: [node2] => (item=/root/13.5/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
ok: [node3] => (item=/root/13.5/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
ok: [node4] => (item=/root/13.5/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
Monday 09 January 2023  15:24:38 -0500 (0:00:00.072)       0:34:04.294 ********
Monday 09 January 2023  15:24:38 -0500 (0:00:00.048)       0:34:04.343 ********

TASK [network_plugin/calico : include_tasks] ***************************************************************************
included: /root/13.5/kubespray/roles/network_plugin/calico/tasks/install.yml for node1, node2, node3, node4
Monday 09 January 2023  15:24:38 -0500 (0:00:00.138)       0:34:04.483 ********
Monday 09 January 2023  15:24:38 -0500 (0:00:00.053)       0:34:04.537 ********

TASK [network_plugin/calico : Calico | Copy calicoctl binary from download dir] ****************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:24:43 -0500 (0:00:04.778)       0:34:09.315 ********

TASK [network_plugin/calico : Calico | Write Calico cni config] ********************************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:24:47 -0500 (0:00:04.566)       0:34:13.882 ********
Monday 09 January 2023  15:24:47 -0500 (0:00:00.049)       0:34:13.932 ********
Monday 09 January 2023  15:24:47 -0500 (0:00:00.061)       0:34:13.993 ********
Monday 09 January 2023  15:24:47 -0500 (0:00:00.049)       0:34:14.042 ********
Monday 09 January 2023  15:24:48 -0500 (0:00:00.049)       0:34:14.092 ********

TASK [network_plugin/calico : Calico | Install calicoctl wrapper script] ***********************************************
changed: [node2]
changed: [node3]
changed: [node4]
changed: [node1]
Monday 09 January 2023  15:24:52 -0500 (0:00:04.556)       0:34:18.649 ********
Monday 09 January 2023  15:24:52 -0500 (0:00:00.018)       0:34:18.667 ********

TASK [network_plugin/calico : Calico | Check if calico network pool has already been configured] ***********************
ok: [node1]
Monday 09 January 2023  15:24:55 -0500 (0:00:02.530)       0:34:21.200 ********
Monday 09 January 2023  15:24:55 -0500 (0:00:00.055)       0:34:21.256 ********
Monday 09 January 2023  15:24:55 -0500 (0:00:00.049)       0:34:21.306 ********
Monday 09 January 2023  15:24:55 -0500 (0:00:00.048)       0:34:21.354 ********

TASK [network_plugin/calico : Calico | Check if extra directory is needed] *********************************************
ok: [node1]
Monday 09 January 2023  15:24:57 -0500 (0:00:02.181)       0:34:23.535 ********
Monday 09 January 2023  15:24:57 -0500 (0:00:00.047)       0:34:23.583 ********

TASK [network_plugin/calico : Calico | Set kdd path when calico > v3.22.2] *********************************************
ok: [node1]
Monday 09 January 2023  15:24:57 -0500 (0:00:00.053)       0:34:23.637 ********

TASK [network_plugin/calico : Calico | Create calico manifests for kdd] ************************************************
changed: [node1]
Monday 09 January 2023  15:24:59 -0500 (0:00:02.288)       0:34:25.925 ********

TASK [network_plugin/calico : Calico | Create Calico Kubernetes datastore resources] ***********************************
ok: [node1]
Monday 09 January 2023  15:25:15 -0500 (0:00:15.284)       0:34:41.210 ********

TASK [network_plugin/calico : Calico | Get existing FelixConfiguration] ************************************************
fatal: [node1]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/calicoctl.sh", "get", "felixconfig", "default", "-o", "json"], "delta": "0:00:00.838297", "end": "2023-01-09 20:25:18.312733", "msg": "non-zero return code", "rc": 1, "start": "2023-01-09 20:25:17.474436", "stderr": "resource does not exist: FelixConfiguration(default) with error: felixconfigurations.crd.projectcalico.org \"default\" not found", "stderr_lines": ["resource does not exist: FelixConfiguration(default) with error: felixconfigurations.crd.projectcalico.org \"default\" not found"], "stdout": "null", "stdout_lines": ["null"]}
...ignoring
Monday 09 January 2023  15:25:18 -0500 (0:00:03.406)       0:34:44.617 ********

TASK [network_plugin/calico : Calico | Set kubespray FelixConfiguration] ***********************************************
ok: [node1]
Monday 09 January 2023  15:25:18 -0500 (0:00:00.055)       0:34:44.672 ********
Monday 09 January 2023  15:25:18 -0500 (0:00:00.048)       0:34:44.720 ********

TASK [network_plugin/calico : Calico | Configure calico FelixConfiguration] ********************************************
ok: [node1]
Monday 09 January 2023  15:25:21 -0500 (0:00:03.262)       0:34:47.983 ********

TASK [network_plugin/calico : Calico | Get existing calico network pool] ***********************************************
fatal: [node1]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/calicoctl.sh", "get", "ippool", "default-pool", "-o", "json"], "delta": "0:00:01.436537", "end": "2023-01-09 20:25:25.390727", "msg": "non-zero return code", "rc": 1, "start": "2023-01-09 20:25:23.954190", "stderr": "resource does not exist: IPPool(default-pool) with error: ippools.crd.projectcalico.org \"default-pool\" not found", "stderr_lines": ["resource does not exist: IPPool(default-pool) with error: ippools.crd.projectcalico.org \"default-pool\" not found"], "stdout": "null", "stdout_lines": ["null"]}
...ignoring
Monday 09 January 2023  15:25:25 -0500 (0:00:03.722)       0:34:51.706 ********

TASK [network_plugin/calico : Calico | Set kubespray calico network pool] **********************************************
ok: [node1]
Monday 09 January 2023  15:25:25 -0500 (0:00:00.052)       0:34:51.758 ********
Monday 09 January 2023  15:25:25 -0500 (0:00:00.046)       0:34:51.805 ********

TASK [network_plugin/calico : Calico | Configure calico network pool] **************************************************
ok: [node1]
Monday 09 January 2023  15:25:28 -0500 (0:00:02.572)       0:34:54.378 ********
Monday 09 January 2023  15:25:28 -0500 (0:00:00.068)       0:34:54.446 ********
Monday 09 January 2023  15:25:28 -0500 (0:00:00.047)       0:34:54.494 ********
Monday 09 January 2023  15:25:28 -0500 (0:00:00.047)       0:34:54.542 ********
Monday 09 January 2023  15:25:28 -0500 (0:00:00.050)       0:34:54.593 ********
Monday 09 January 2023  15:25:28 -0500 (0:00:00.013)       0:34:54.606 ********
Monday 09 January 2023  15:25:28 -0500 (0:00:00.011)       0:34:54.621 ********
Monday 09 January 2023  15:25:28 -0500 (0:00:00.020)       0:34:54.642 ********

TASK [network_plugin/calico : Calico | Get existing BGP Configuration] *************************************************
fatal: [node1]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/calicoctl.sh", "get", "bgpconfig", "default", "-o", "json"], "delta": "0:00:00.270386", "end": "2023-01-09 20:25:32.080099", "msg": "non-zero return code", "rc": 1, "start": "2023-01-09 20:25:31.809713", "stderr": "resource does not exist: BGPConfiguration(default) with error: bgpconfigurations.crd.projectcalico.org \"default\" not found", "stderr_lines": ["resource does not exist: BGPConfiguration(default) with error: bgpconfigurations.crd.projectcalico.org \"default\" not found"], "stdout": "null", "stdout_lines": ["null"]}
...ignoring
Monday 09 January 2023  15:25:32 -0500 (0:00:03.690)       0:34:58.332 ********

TASK [network_plugin/calico : Calico | Set kubespray BGP Configuration] ************************************************
ok: [node1]
Monday 09 January 2023  15:25:32 -0500 (0:00:00.046)       0:34:58.379 ********
Monday 09 January 2023  15:25:32 -0500 (0:00:00.063)       0:34:58.443 ********

TASK [network_plugin/calico : Calico | Set up BGP Configuration] *******************************************************
ok: [node1]
Monday 09 January 2023  15:25:35 -0500 (0:00:03.266)       0:35:01.710 ********

TASK [network_plugin/calico : Calico | Create calico manifests] ********************************************************
changed: [node1] => (item={'name': 'calico-config', 'file': 'calico-config.yml', 'type': 'cm'})
changed: [node1] => (item={'name': 'calico-node', 'file': 'calico-node.yml', 'type': 'ds'})
changed: [node1] => (item={'name': 'calico', 'file': 'calico-node-sa.yml', 'type': 'sa'})
changed: [node1] => (item={'name': 'calico', 'file': 'calico-cr.yml', 'type': 'clusterrole'})
changed: [node1] => (item={'name': 'calico', 'file': 'calico-crb.yml', 'type': 'clusterrolebinding'})
changed: [node1] => (item={'name': 'kubernetes-services-endpoint', 'file': 'kubernetes-services-endpoint.yml', 'type': 'cm'})
Monday 09 January 2023  15:26:17 -0500 (0:00:41.555)       0:35:43.265 ********
Monday 09 January 2023  15:26:17 -0500 (0:00:00.055)       0:35:43.321 ********
Monday 09 January 2023  15:26:17 -0500 (0:00:00.053)       0:35:43.375 ********
Monday 09 January 2023  15:26:17 -0500 (0:00:00.050)       0:35:43.426 ********
Monday 09 January 2023  15:26:17 -0500 (0:00:00.051)       0:35:43.479 ********

TASK [network_plugin/calico : Start Calico resources] ******************************************************************
ok: [node1] => (item=calico-config.yml)
ok: [node1] => (item=calico-node.yml)
ok: [node1] => (item=calico-node-sa.yml)
ok: [node1] => (item=calico-cr.yml)
ok: [node1] => (item=calico-crb.yml)
ok: [node1] => (item=kubernetes-services-endpoint.yml)
Monday 09 January 2023  15:27:02 -0500 (0:00:44.684)       0:36:28.163 ********
Monday 09 January 2023  15:27:02 -0500 (0:00:00.058)       0:36:28.222 ********

TASK [network_plugin/calico : Wait for calico kubeconfig to be created] ************************************************
ok: [node4]
ok: [node2]
ok: [node3]
Monday 09 January 2023  15:27:09 -0500 (0:00:07.599)       0:36:35.821 ********

TASK [network_plugin/calico : Calico | Create Calico ipam manifests] ***************************************************
changed: [node1] => (item={'name': 'calico', 'file': 'calico-ipamconfig.yml', 'type': 'ipam'})
Monday 09 January 2023  15:27:18 -0500 (0:00:08.974)       0:36:44.795 ********

TASK [network_plugin/calico : Calico | Create ipamconfig resources] ****************************************************
ok: [node1]
Monday 09 January 2023  15:27:34 -0500 (0:00:15.668)       0:37:00.463 ********
Monday 09 January 2023  15:27:34 -0500 (0:00:00.053)       0:37:00.517 ********
Monday 09 January 2023  15:27:34 -0500 (0:00:00.086)       0:37:00.604 ********
Monday 09 January 2023  15:27:34 -0500 (0:00:00.049)       0:37:00.653 ********
Monday 09 January 2023  15:27:34 -0500 (0:00:00.078)       0:37:00.731 ********
Monday 09 January 2023  15:27:34 -0500 (0:00:00.047)       0:37:00.779 ********
Monday 09 January 2023  15:27:34 -0500 (0:00:00.076)       0:37:00.856 ********
Monday 09 January 2023  15:27:34 -0500 (0:00:00.049)       0:37:00.906 ********
Monday 09 January 2023  15:27:34 -0500 (0:00:00.049)       0:37:00.955 ********
Monday 09 January 2023  15:27:34 -0500 (0:00:00.064)       0:37:01.020 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.056)       0:37:01.077 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.048)       0:37:01.125 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.143)       0:37:01.268 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.016)       0:37:01.285 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.103)       0:37:01.389 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.056)       0:37:01.445 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.085)       0:37:01.531 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.084)       0:37:01.616 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.052)       0:37:01.669 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.056)       0:37:01.725 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.051)       0:37:01.777 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.052)       0:37:01.830 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.072)       0:37:01.902 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.048)       0:37:01.950 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.058)       0:37:02.008 ********
Monday 09 January 2023  15:27:35 -0500 (0:00:00.056)       0:37:02.064 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.051)       0:37:02.116 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.060)       0:37:02.177 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.061)       0:37:02.238 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.051)       0:37:02.290 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.107)       0:37:02.398 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.049)       0:37:02.448 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.096)       0:37:02.544 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.052)       0:37:02.596 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.061)       0:37:02.658 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.063)       0:37:02.722 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.059)       0:37:02.781 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.066)       0:37:02.848 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.050)       0:37:02.899 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.049)       0:37:02.948 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.047)       0:37:02.995 ********
Monday 09 January 2023  15:27:36 -0500 (0:00:00.049)       0:37:03.045 ********
Monday 09 January 2023  15:27:37 -0500 (0:00:00.058)       0:37:03.103 ********
Monday 09 January 2023  15:27:37 -0500 (0:00:00.050)       0:37:03.154 ********
Monday 09 January 2023  15:27:37 -0500 (0:00:00.062)       0:37:03.216 ********
Monday 09 January 2023  15:27:37 -0500 (0:00:00.105)       0:37:03.322 ********

RUNNING HANDLER [kubernetes/kubeadm : Kubeadm | restart kubelet] *******************************************************
changed: [node2]
changed: [node4]
changed: [node3]
Monday 09 January 2023  15:27:38 -0500 (0:00:01.410)       0:37:04.733 ********

RUNNING HANDLER [kubernetes/kubeadm : Kubeadm | reload systemd] ********************************************************
ok: [node2]
ok: [node4]
ok: [node3]
Monday 09 January 2023  15:27:41 -0500 (0:00:02.644)       0:37:07.378 ********

RUNNING HANDLER [kubernetes/kubeadm : Kubeadm | reload kubelet] ********************************************************
changed: [node4]
changed: [node3]
changed: [node2]
Monday 09 January 2023  15:27:42 -0500 (0:00:01.538)       0:37:08.916 ********

PLAY [calico_rr] *******************************************************************************************************
skipping: no hosts matched

PLAY [kube_control_plane[0]] *******************************************************************************************
Monday 09 January 2023  15:27:42 -0500 (0:00:00.080)       0:37:08.997 ********
Monday 09 January 2023  15:27:42 -0500 (0:00:00.022)       0:37:09.019 ********
Monday 09 January 2023  15:27:42 -0500 (0:00:00.020)       0:37:09.039 ********
Monday 09 January 2023  15:27:42 -0500 (0:00:00.017)       0:37:09.057 ********
Monday 09 January 2023  15:27:43 -0500 (0:00:00.023)       0:37:09.081 ********
Monday 09 January 2023  15:27:43 -0500 (0:00:00.017)       0:37:09.098 ********
Monday 09 January 2023  15:27:43 -0500 (0:00:00.017)       0:37:09.115 ********
Monday 09 January 2023  15:27:43 -0500 (0:00:00.017)       0:37:09.132 ********
Monday 09 January 2023  15:27:43 -0500 (0:00:00.019)       0:37:09.152 ********
Monday 09 January 2023  15:27:43 -0500 (0:00:00.019)       0:37:09.172 ********
Monday 09 January 2023  15:27:43 -0500 (0:00:00.639)       0:37:09.811 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Monday 09 January 2023  15:27:43 -0500 (0:00:00.030)       0:37:09.842 ********
Monday 09 January 2023  15:27:43 -0500 (0:00:00.032)       0:37:09.900 ********
Monday 09 January 2023  15:27:43 -0500 (0:00:00.017)       0:37:09.918 ********
Monday 09 January 2023  15:27:43 -0500 (0:00:00.018)       0:37:09.936 ********
Monday 09 January 2023  15:27:43 -0500 (0:00:00.019)       0:37:09.956 ********
Monday 09 January 2023  15:27:43 -0500 (0:00:00.019)       0:37:09.975 ********
Monday 09 January 2023  15:27:43 -0500 (0:00:00.022)       0:37:09.998 ********

TASK [win_nodes/kubernetes_patch : Ensure that user manifests directory exists] ****************************************
changed: [node1]
Monday 09 January 2023  15:27:47 -0500 (0:00:03.498)       0:37:13.497 ********

TASK [win_nodes/kubernetes_patch : Check current nodeselector for kube-proxy daemonset] ********************************
ok: [node1]
Monday 09 January 2023  15:27:53 -0500 (0:00:05.684)       0:37:19.181 ********

TASK [win_nodes/kubernetes_patch : Apply nodeselector patch for kube-proxy daemonset] **********************************
changed: [node1]
Monday 09 January 2023  15:27:57 -0500 (0:00:04.528)       0:37:23.709 ********

TASK [win_nodes/kubernetes_patch : debug] ******************************************************************************
ok: [node1] => {
    "msg": [
        "daemonset.apps/kube-proxy patched (no change)"
    ]
}
Monday 09 January 2023  15:27:57 -0500 (0:00:00.030)       0:37:23.740 ********

TASK [win_nodes/kubernetes_patch : debug] ******************************************************************************
ok: [node1] => {
    "msg": []
}

PLAY [kube_control_plane] **********************************************************************************************
Monday 09 January 2023  15:27:57 -0500 (0:00:00.213)       0:37:23.954 ********
Monday 09 January 2023  15:27:57 -0500 (0:00:00.015)       0:37:23.976 ********
Monday 09 January 2023  15:27:57 -0500 (0:00:00.021)       0:37:23.998 ********
Monday 09 January 2023  15:27:57 -0500 (0:00:00.019)       0:37:24.018 ********
Monday 09 January 2023  15:27:57 -0500 (0:00:00.018)       0:37:24.036 ********
Monday 09 January 2023  15:27:57 -0500 (0:00:00.017)       0:37:24.054 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.019)       0:37:24.074 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.035)       0:37:24.109 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.019)       0:37:24.129 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.020)       0:37:24.149 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.567)       0:37:24.716 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Monday 09 January 2023  15:27:58 -0500 (0:00:00.059)       0:37:24.776 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.034)       0:37:24.811 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.018)       0:37:24.829 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.021)       0:37:24.851 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.018)       0:37:24.869 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.022)       0:37:24.892 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.029)       0:37:24.921 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.017)       0:37:24.939 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.014)       0:37:24.954 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.017)       0:37:24.971 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.026)       0:37:24.998 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.039)       0:37:25.038 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.017)       0:37:25.056 ********
Monday 09 January 2023  15:27:58 -0500 (0:00:00.018)       0:37:25.076 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.033)       0:37:25.109 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.016)       0:37:25.128 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.017)       0:37:25.145 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.036)       0:37:25.182 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.019)       0:37:25.201 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.043)       0:37:25.244 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.058)       0:37:25.303 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.023)       0:37:25.327 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.025)       0:37:25.352 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.035)       0:37:25.387 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.018)       0:37:25.406 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.038)       0:37:25.444 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.026)       0:37:25.471 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.034)       0:37:25.505 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.046)       0:37:25.552 ********
Monday 09 January 2023  15:27:59 -0500 (0:00:00.020)       0:37:25.572 ********

TASK [policy_controller/calico : Create calico-kube-controllers manifests] *********************************************
changed: [node1] => (item={'name': 'calico-kube-controllers', 'file': 'calico-kube-controllers.yml', 'type': 'deployment'})
changed: [node1] => (item={'name': 'calico-kube-controllers', 'file': 'calico-kube-sa.yml', 'type': 'sa'})
changed: [node1] => (item={'name': 'calico-kube-controllers', 'file': 'calico-kube-cr.yml', 'type': 'clusterrole'})
changed: [node1] => (item={'name': 'calico-kube-controllers', 'file': 'calico-kube-crb.yml', 'type': 'clusterrolebinding'})
Monday 09 January 2023  15:28:28 -0500 (0:00:29.433)       0:37:55.006 ********

TASK [policy_controller/calico : Start of Calico kube controllers] *****************************************************
ok: [node1] => (item=calico-kube-controllers.yml)
ok: [node1] => (item=calico-kube-sa.yml)
ok: [node1] => (item=calico-kube-cr.yml)
ok: [node1] => (item=calico-kube-crb.yml)
Monday 09 January 2023  15:29:00 -0500 (0:00:31.536)       0:38:26.542 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.017)       0:38:26.560 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.017)       0:38:26.577 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.019)       0:38:26.596 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.017)       0:38:26.613 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.030)       0:38:26.644 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.016)       0:38:26.661 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.020)       0:38:26.681 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.016)       0:38:26.698 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.016)       0:38:26.714 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.022)       0:38:26.737 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.027)       0:38:26.764 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.018)       0:38:26.783 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.031)       0:38:26.814 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.044)       0:38:26.858 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.027)       0:38:26.885 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.019)       0:38:26.905 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.017)       0:38:26.923 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.018)       0:38:26.942 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.026)       0:38:26.968 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.017)       0:38:26.986 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.017)       0:38:27.003 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.019)       0:38:27.023 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.020)       0:38:27.044 ********
Monday 09 January 2023  15:29:00 -0500 (0:00:00.015)       0:38:27.059 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.017)       0:38:27.077 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.016)       0:38:27.094 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.023)       0:38:27.117 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.016)       0:38:27.133 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.015)       0:38:27.149 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.018)       0:38:27.167 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.016)       0:38:27.184 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.021)       0:38:27.205 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.016)       0:38:27.221 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.018)       0:38:27.240 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.023)       0:38:27.264 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.022)       0:38:27.286 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.017)       0:38:27.303 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.015)       0:38:27.319 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.015)       0:38:27.335 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.022)       0:38:27.357 ********
Monday 09 January 2023  15:29:01 -0500 (0:00:00.035)       0:38:27.393 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Wait for kube-apiserver] *********************************************
ok: [node1]
Monday 09 January 2023  15:29:10 -0500 (0:00:09.480)       0:38:36.873 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Register coredns deployment annotation `createdby`] ******************
fatal: [node1]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/kubectl", "--kubeconfig", "/etc/kubernetes/admin.conf", "get", "deploy", "-n", "kube-system", "coredns", "-o", "jsonpath={ .spec.template.metadata.annotations.createdby }"], "delta": "0:00:01.728541", "end": "2023-01-09 20:29:15.808639", "msg": "non-zero return code", "rc": 1, "start": "2023-01-09 20:29:14.080098", "stderr": "Error from server (NotFound): deployments.apps \"coredns\" not found", "stderr_lines": ["Error from server (NotFound): deployments.apps \"coredns\" not found"], "stdout": "", "stdout_lines": []}
...ignoring
Monday 09 January 2023  15:29:16 -0500 (0:00:05.437)       0:38:42.310 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Register coredns service annotation `createdby`] *********************
fatal: [node1]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/kubectl", "--kubeconfig", "/etc/kubernetes/admin.conf", "get", "svc", "-n", "kube-system", "coredns", "-o", "jsonpath={ .metadata.annotations.createdby }"], "delta": "0:00:01.870486", "end": "2023-01-09 20:29:20.501616", "msg": "non-zero return code", "rc": 1, "start": "2023-01-09 20:29:18.631130", "stderr": "Error from server (NotFound): services \"coredns\" not found", "stderr_lines": ["Error from server (NotFound): services \"coredns\" not found"], "stdout": "", "stdout_lines": []}
...ignoring
Monday 09 January 2023  15:29:20 -0500 (0:00:04.576)       0:38:46.886 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Delete kubeadm CoreDNS] **********************************************
ok: [node1]
Monday 09 January 2023  15:29:25 -0500 (0:00:05.161)       0:38:52.048 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Delete kubeadm Kube-DNS service] *************************************
ok: [node1]
Monday 09 January 2023  15:29:30 -0500 (0:00:04.669)       0:38:56.718 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Lay Down CoreDNS templates] ******************************************
changed: [node1] => (item={'name': 'coredns', 'file': 'coredns-clusterrole.yml', 'type': 'clusterrole'})
changed: [node1] => (item={'name': 'coredns', 'file': 'coredns-clusterrolebinding.yml', 'type': 'clusterrolebinding'})
changed: [node1] => (item={'name': 'coredns', 'file': 'coredns-config.yml', 'type': 'configmap'})
changed: [node1] => (item={'name': 'coredns', 'file': 'coredns-deployment.yml', 'type': 'deployment'})
changed: [node1] => (item={'name': 'coredns', 'file': 'coredns-sa.yml', 'type': 'sa'})
changed: [node1] => (item={'name': 'coredns', 'file': 'coredns-svc.yml', 'type': 'svc'})
changed: [node1] => (item={'name': 'dns-autoscaler', 'file': 'dns-autoscaler.yml', 'type': 'deployment'})
changed: [node1] => (item={'name': 'dns-autoscaler', 'file': 'dns-autoscaler-clusterrole.yml', 'type': 'clusterrole'})
changed: [node1] => (item={'name': 'dns-autoscaler', 'file': 'dns-autoscaler-clusterrolebinding.yml', 'type': 'clusterrolebinding'})
changed: [node1] => (item={'name': 'dns-autoscaler', 'file': 'dns-autoscaler-sa.yml', 'type': 'sa'})
Monday 09 January 2023  15:30:51 -0500 (0:01:20.555)       0:40:17.273 ********
Monday 09 January 2023  15:30:51 -0500 (0:00:00.046)       0:40:17.320 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | set up necessary nodelocaldns parameters] ****************************
ok: [node1]
Monday 09 January 2023  15:30:51 -0500 (0:00:00.081)       0:40:17.407 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Lay Down nodelocaldns Template] **************************************
changed: [node1] => (item={'name': 'nodelocaldns', 'file': 'nodelocaldns-config.yml', 'type': 'configmap'})
changed: [node1] => (item={'name': 'nodelocaldns', 'file': 'nodelocaldns-sa.yml', 'type': 'sa'})
changed: [node1] => (item={'name': 'nodelocaldns', 'file': 'nodelocaldns-daemonset.yml', 'type': 'daemonset'})
Monday 09 January 2023  15:31:14 -0500 (0:00:23.236)       0:40:40.643 ********
Monday 09 January 2023  15:31:14 -0500 (0:00:00.022)       0:40:40.666 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Start Resources] *****************************************************
ok: [node1] => (item=coredns-clusterrole.yml)
ok: [node1] => (item=coredns-clusterrolebinding.yml)
ok: [node1] => (item=coredns-config.yml)
ok: [node1] => (item=coredns-deployment.yml)
ok: [node1] => (item=coredns-sa.yml)
ok: [node1] => (item=coredns-svc.yml)
ok: [node1] => (item=dns-autoscaler.yml)
ok: [node1] => (item=dns-autoscaler-clusterrole.yml)
ok: [node1] => (item=dns-autoscaler-clusterrolebinding.yml)
ok: [node1] => (item=dns-autoscaler-sa.yml)
ok: [node1] => (item=nodelocaldns-config.yml)
ok: [node1] => (item=nodelocaldns-sa.yml)
ok: [node1] => (item=nodelocaldns-daemonset.yml)
Monday 09 January 2023  15:32:41 -0500 (0:01:26.589)       0:42:07.263 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.027)       0:42:07.290 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.025)       0:42:07.315 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.023)       0:42:07.339 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.021)       0:42:07.361 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.018)       0:42:07.379 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.017)       0:42:07.397 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.018)       0:42:07.416 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.020)       0:42:07.436 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.020)       0:42:07.457 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.036)       0:42:07.493 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.017)       0:42:07.511 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.017)       0:42:07.528 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.016)       0:42:07.544 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.026)       0:42:07.570 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.017)       0:42:07.588 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.016)       0:42:07.604 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.017)       0:42:07.622 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.019)       0:42:07.642 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.017)       0:42:07.659 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.020)       0:42:07.680 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.022)       0:42:07.703 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.014)       0:42:07.728 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.022)       0:42:07.753 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.016)       0:42:07.773 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.015)       0:42:07.792 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.024)       0:42:07.816 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.017)       0:42:07.833 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.015)       0:42:07.849 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.015)       0:42:07.864 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.019)       0:42:07.883 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.016)       0:42:07.899 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.018)       0:42:07.918 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.015)       0:42:07.934 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.018)       0:42:07.953 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.022)       0:42:07.975 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.017)       0:42:07.993 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.016)       0:42:08.010 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.026)       0:42:08.036 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.016)       0:42:08.052 ********
Monday 09 January 2023  15:32:41 -0500 (0:00:00.016)       0:42:08.068 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.016)       0:42:08.084 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.016)       0:42:08.101 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.020)       0:42:08.122 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.026)       0:42:08.148 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.023)       0:42:08.171 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.029)       0:42:08.200 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.009)       0:42:08.218 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.027)       0:42:08.245 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.017)       0:42:08.263 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.015)       0:42:08.279 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.032)       0:42:08.311 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.045)       0:42:08.356 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.024)       0:42:08.381 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.033)       0:42:08.415 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.023)       0:42:08.439 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.016)       0:42:08.455 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.015)       0:42:08.471 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.033)       0:42:08.505 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.038)       0:42:08.543 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.015)       0:42:08.559 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.016)       0:42:08.575 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.016)       0:42:08.592 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.023)       0:42:08.616 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.031)       0:42:08.648 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.017)       0:42:08.667 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.015)       0:42:08.682 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.026)       0:42:08.708 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.124)       0:42:08.832 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.015)       0:42:08.848 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.020)       0:42:08.868 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.032)       0:42:08.901 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.017)       0:42:08.919 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.017)       0:42:08.937 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.038)       0:42:08.976 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.017)       0:42:08.994 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.024)       0:42:09.019 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.025)       0:42:09.045 ********
Monday 09 January 2023  15:32:42 -0500 (0:00:00.023)       0:42:09.068 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.018)       0:42:09.087 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.021)       0:42:09.108 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.017)       0:42:09.126 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.024)       0:42:09.150 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.015)       0:42:09.167 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.026)       0:42:09.194 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.016)       0:42:09.212 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.032)       0:42:09.244 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.019)       0:42:09.263 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.027)       0:42:09.290 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.035)       0:42:09.326 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.018)       0:42:09.345 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.032)       0:42:09.378 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.015)       0:42:09.395 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.016)       0:42:09.412 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.017)       0:42:09.430 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.027)       0:42:09.458 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.018)       0:42:09.476 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.018)       0:42:09.495 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.014)       0:42:09.512 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.017)       0:42:09.539 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.018)       0:42:09.558 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.025)       0:42:09.584 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.016)       0:42:09.601 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.035)       0:42:09.636 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.021)       0:42:09.658 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.015)       0:42:09.674 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.017)       0:42:09.691 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.016)       0:42:09.707 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.032)       0:42:09.740 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.025)       0:42:09.778 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.019)       0:42:09.797 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.019)       0:42:09.817 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.019)       0:42:09.836 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.016)       0:42:09.852 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.016)       0:42:09.869 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.024)       0:42:09.894 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.016)       0:42:09.910 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.018)       0:42:09.929 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.019)       0:42:09.949 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.020)       0:42:09.969 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.015)       0:42:09.985 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.016)       0:42:10.002 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.017)       0:42:10.020 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.015)       0:42:10.036 ********
Monday 09 January 2023  15:32:43 -0500 (0:00:00.023)       0:42:10.059 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.017)       0:42:10.076 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.015)       0:42:10.092 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.016)       0:42:10.108 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.015)       0:42:10.123 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.018)       0:42:10.142 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.015)       0:42:10.158 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.020)       0:42:10.179 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.026)       0:42:10.205 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.014)       0:42:10.220 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.016)       0:42:10.236 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.018)       0:42:10.254 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.017)       0:42:10.271 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.018)       0:42:10.290 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.019)       0:42:10.309 ********

PLAY [Apply resolv.conf changes now that cluster DNS is up] ************************************************************
Monday 09 January 2023  15:32:44 -0500 (0:00:00.118)       0:42:10.428 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.046)       0:42:10.474 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.021)       0:42:10.496 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.018)       0:42:10.514 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.043)       0:42:10.558 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.045)       0:42:10.603 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.048)       0:42:10.652 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.051)       0:42:10.704 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.017)       0:42:10.721 ********
Monday 09 January 2023  15:32:44 -0500 (0:00:00.045)       0:42:10.767 ********
Monday 09 January 2023  15:32:45 -0500 (0:00:00.682)       0:42:11.449 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node2] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node3] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
ok: [node4] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Monday 09 January 2023  15:32:45 -0500 (0:00:00.085)       0:42:11.535 ********
Monday 09 January 2023  15:32:45 -0500 (0:00:00.032)       0:42:11.567 ********
Monday 09 January 2023  15:32:45 -0500 (0:00:00.016)       0:42:11.584 ********
Monday 09 January 2023  15:32:45 -0500 (0:00:00.047)       0:42:11.631 ********
Monday 09 January 2023  15:32:45 -0500 (0:00:00.022)       0:42:11.654 ********
Monday 09 January 2023  15:32:45 -0500 (0:00:00.055)       0:42:11.710 ********
Monday 09 January 2023  15:32:45 -0500 (0:00:00.075)       0:42:11.785 ********

TASK [adduser : User | Create User Group] ******************************************************************************
ok: [node4]
ok: [node1]
ok: [node2]
ok: [node3]
Monday 09 January 2023  15:32:50 -0500 (0:00:05.059)       0:42:16.844 ********

TASK [adduser : User | Create User] ************************************************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:32:55 -0500 (0:00:05.221)       0:42:22.066 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.055)       0:42:22.123 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.053)       0:42:22.177 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.049)       0:42:22.226 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.055)       0:42:22.282 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.019)       0:42:22.301 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.020)       0:42:22.322 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.047)       0:42:22.371 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.136)       0:42:22.507 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.050)       0:42:22.559 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.043)       0:42:22.603 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.035)       0:42:22.639 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.050)       0:42:22.692 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.051)       0:42:22.744 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.050)       0:42:22.794 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.050)       0:42:22.844 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.050)       0:42:22.895 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.045)       0:42:22.941 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.048)       0:42:22.989 ********
Monday 09 January 2023  15:32:56 -0500 (0:00:00.048)       0:42:23.038 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.049)       0:42:23.087 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.046)       0:42:23.134 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.047)       0:42:23.182 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.043)       0:42:23.230 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.021)       0:42:23.251 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.033)       0:42:23.285 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.017)       0:42:23.302 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.016)       0:42:23.319 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.018)       0:42:23.339 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.019)       0:42:23.359 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.028)       0:42:23.388 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.021)       0:42:23.410 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.049)       0:42:23.460 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.013)       0:42:23.476 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.055)       0:42:23.532 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.016)       0:42:23.549 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.018)       0:42:23.567 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.049)       0:42:23.617 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.055)       0:42:23.672 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.048)       0:42:23.720 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.058)       0:42:23.779 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.017)       0:42:23.796 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.056)       0:42:23.853 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.052)       0:42:23.905 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.050)       0:42:23.956 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.053)       0:42:24.010 ********
Monday 09 January 2023  15:32:57 -0500 (0:00:00.051)       0:42:24.062 ********

TASK [kubernetes/preinstall : check if booted with ostree] *************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:33:04 -0500 (0:00:06.233)       0:42:30.295 ********

TASK [kubernetes/preinstall : set is_fedora_coreos] ********************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:33:08 -0500 (0:00:04.445)       0:42:34.740 ********

TASK [kubernetes/preinstall : set is_fedora_coreos] ********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:33:08 -0500 (0:00:00.059)       0:42:34.800 ********

TASK [kubernetes/preinstall : check resolvconf] ************************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:33:14 -0500 (0:00:05.614)       0:42:40.415 ********

TASK [kubernetes/preinstall : check existence of /etc/resolvconf/resolv.conf.d] ****************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:33:17 -0500 (0:00:03.124)       0:42:43.540 ********

TASK [kubernetes/preinstall : check status of /etc/resolv.conf] ********************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Monday 09 January 2023  15:33:20 -0500 (0:00:02.988)       0:42:46.528 ********

TASK [kubernetes/preinstall : get content of /etc/resolv.conf] *********************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:33:24 -0500 (0:00:03.805)       0:42:50.334 ********

TASK [kubernetes/preinstall : get currently configured nameservers] ****************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:33:24 -0500 (0:00:00.096)       0:42:50.431 ********

TASK [kubernetes/preinstall : Stop if /etc/resolv.conf not configured nameservers] *************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node2] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node3] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [node4] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  15:33:24 -0500 (0:00:00.068)       0:42:50.499 ********

TASK [kubernetes/preinstall : NetworkManager | Check if host has NetworkManager] ***************************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:33:36 -0500 (0:00:11.846)       0:43:02.346 ********

TASK [kubernetes/preinstall : check systemd-resolved] ******************************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:33:41 -0500 (0:00:05.483)       0:43:07.830 ********

TASK [kubernetes/preinstall : set default dns if remove_default_searchdomains is false] ********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:33:41 -0500 (0:00:00.062)       0:43:07.893 ********

TASK [kubernetes/preinstall : set dns facts] ***************************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:33:41 -0500 (0:00:00.067)       0:43:07.960 ********

TASK [kubernetes/preinstall : check if kubelet is configured] **********************************************************
ok: [node4]
ok: [node3]
ok: [node2]
ok: [node1]
Monday 09 January 2023  15:33:44 -0500 (0:00:02.719)       0:43:10.680 ********

TASK [kubernetes/preinstall : check if early DNS configuration stage] **************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:33:44 -0500 (0:00:00.052)       0:43:10.732 ********

TASK [kubernetes/preinstall : target resolv.conf files] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:33:44 -0500 (0:00:00.054)       0:43:10.787 ********
Monday 09 January 2023  15:33:44 -0500 (0:00:00.049)       0:43:10.836 ********

TASK [kubernetes/preinstall : check if /etc/dhclient.conf exists] ******************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:33:48 -0500 (0:00:03.482)       0:43:14.319 ********
Monday 09 January 2023  15:33:48 -0500 (0:00:00.053)       0:43:14.372 ********

TASK [kubernetes/preinstall : check if /etc/dhcp/dhclient.conf exists] *************************************************
ok: [node2]
ok: [node3]
ok: [node4]
ok: [node1]
Monday 09 January 2023  15:33:51 -0500 (0:00:02.862)       0:43:17.234 ********

TASK [kubernetes/preinstall : target dhclient conf file for /etc/dhcp/dhclient.conf] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:33:51 -0500 (0:00:00.055)       0:43:17.290 ********
Monday 09 January 2023  15:33:51 -0500 (0:00:00.049)       0:43:17.340 ********

TASK [kubernetes/preinstall : target dhclient hook file for Debian family] *********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:33:51 -0500 (0:00:00.056)       0:43:17.396 ********

TASK [kubernetes/preinstall : generate search domains to resolvconf] ***************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:33:51 -0500 (0:00:00.060)       0:43:17.457 ********

TASK [kubernetes/preinstall : pick coredns cluster IP or default resolver] *********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:33:51 -0500 (0:00:00.109)       0:43:17.566 ********

TASK [kubernetes/preinstall : generate nameservers for resolvconf, including cluster DNS] ******************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Monday 09 January 2023  15:33:51 -0500 (0:00:00.064)       0:43:17.631 ********
Monday 09 January 2023  15:33:51 -0500 (0:00:00.045)       0:43:17.677 ********

TASK [kubernetes/preinstall : gather os specific variables] ************************************************************
ok: [node1] => (item=/root/13.5/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
ok: [node2] => (item=/root/13.5/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
ok: [node3] => (item=/root/13.5/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
ok: [node4] => (item=/root/13.5/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
Monday 09 January 2023  15:33:51 -0500 (0:00:00.067)       0:43:17.744 ********
Monday 09 January 2023  15:33:51 -0500 (0:00:00.054)       0:43:17.798 ********

TASK [kubernetes/preinstall : check /usr readonly] *********************************************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:33:55 -0500 (0:00:03.317)       0:43:21.116 ********
Monday 09 January 2023  15:33:55 -0500 (0:00:00.048)       0:43:21.165 ********
Monday 09 January 2023  15:33:55 -0500 (0:00:00.046)       0:43:21.211 ********
Monday 09 January 2023  15:33:55 -0500 (0:00:00.043)       0:43:21.255 ********
Monday 09 January 2023  15:33:55 -0500 (0:00:00.079)       0:43:21.335 ********
Monday 09 January 2023  15:33:55 -0500 (0:00:00.050)       0:43:21.385 ********
Monday 09 January 2023  15:33:55 -0500 (0:00:00.044)       0:43:21.430 ********
Monday 09 January 2023  15:33:55 -0500 (0:00:00.049)       0:43:21.479 ********
Monday 09 January 2023  15:33:55 -0500 (0:00:00.056)       0:43:21.536 ********
Monday 09 January 2023  15:33:55 -0500 (0:00:00.056)       0:43:21.593 ********
Monday 09 January 2023  15:33:55 -0500 (0:00:00.056)       0:43:21.649 ********

TASK [kubernetes/preinstall : Add domain/search/nameservers/options to resolv.conf] ************************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:33:58 -0500 (0:00:02.826)       0:43:24.476 ********

TASK [kubernetes/preinstall : Remove search/domain/nameserver options before block] ************************************
ok: [node2] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'options\\s'])
Monday 09 January 2023  15:34:11 -0500 (0:00:12.655)       0:43:37.132 ********

TASK [kubernetes/preinstall : Remove search/domain/nameserver options after block] *************************************
ok: [node4] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'options\\s'])
Monday 09 January 2023  15:34:20 -0500 (0:00:09.940)       0:43:47.072 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.054)       0:43:47.127 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.055)       0:43:47.182 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.047)       0:43:47.230 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.049)       0:43:47.280 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.045)       0:43:47.325 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.052)       0:43:47.378 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.051)       0:43:47.429 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.052)       0:43:47.481 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.054)       0:43:47.535 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.052)       0:43:47.588 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.044)       0:43:47.632 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.048)       0:43:47.681 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.049)       0:43:47.731 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.048)       0:43:47.779 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.045)       0:43:47.825 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.051)       0:43:47.877 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.047)       0:43:47.925 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.046)       0:43:47.971 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.048)       0:43:48.020 ********
Monday 09 January 2023  15:34:21 -0500 (0:00:00.044)       0:43:48.064 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.052)       0:43:48.117 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.058)       0:43:48.175 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.047)       0:43:48.223 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.055)       0:43:48.279 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.138)       0:43:48.417 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.048)       0:43:48.466 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.043)       0:43:48.510 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.055)       0:43:48.565 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.044)       0:43:48.612 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.049)       0:43:48.661 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.047)       0:43:48.709 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.072)       0:43:48.781 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.046)       0:43:48.828 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.045)       0:43:48.873 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.044)       0:43:48.918 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.046)       0:43:48.965 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.053)       0:43:49.019 ********
Monday 09 January 2023  15:34:22 -0500 (0:00:00.047)       0:43:49.066 ********
Monday 09 January 2023  15:34:23 -0500 (0:00:00.047)       0:43:49.113 ********
Monday 09 January 2023  15:34:23 -0500 (0:00:00.052)       0:43:49.165 ********
Monday 09 January 2023  15:34:23 -0500 (0:00:00.046)       0:43:49.212 ********
Monday 09 January 2023  15:34:23 -0500 (0:00:00.045)       0:43:49.258 ********
Monday 09 January 2023  15:34:23 -0500 (0:00:00.047)       0:43:49.306 ********
Monday 09 January 2023  15:34:23 -0500 (0:00:00.015)       0:43:49.324 ********
Monday 09 January 2023  15:34:23 -0500 (0:00:00.045)       0:43:49.370 ********
Monday 09 January 2023  15:34:23 -0500 (0:00:00.051)       0:43:49.421 ********
Monday 09 January 2023  15:34:23 -0500 (0:00:00.047)       0:43:49.470 ********
Monday 09 January 2023  15:34:23 -0500 (0:00:00.050)       0:43:49.520 ********
Monday 09 January 2023  15:34:23 -0500 (0:00:00.064)       0:43:49.584 ********
Monday 09 January 2023  15:34:23 -0500 (0:00:00.061)       0:43:49.645 ********
Monday 09 January 2023  15:34:23 -0500 (0:00:00.045)       0:43:49.691 ********

TASK [kubernetes/preinstall : Configure dhclient to supersede search/domain/nameservers] *******************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:34:25 -0500 (0:00:01.780)       0:43:51.472 ********

TASK [kubernetes/preinstall : Configure dhclient hooks for resolv.conf (non-RH)] ***************************************
ok: [node2]
ok: [node4]
ok: [node3]
ok: [node1]
Monday 09 January 2023  15:34:31 -0500 (0:00:06.576)       0:43:58.049 ********
Monday 09 January 2023  15:34:32 -0500 (0:00:00.055)       0:43:58.104 ********
Monday 09 January 2023  15:34:32 -0500 (0:00:00.050)       0:43:58.154 ********
Monday 09 January 2023  15:34:32 -0500 (0:00:00.051)       0:43:58.206 ********
Monday 09 January 2023  15:34:32 -0500 (0:00:00.000)       0:43:58.207 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | propagate resolvconf to k8s components] **************************
changed: [node2]
changed: [node4]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:34:34 -0500 (0:00:01.932)       0:44:00.139 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | reload kubelet] **************************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]
Monday 09 January 2023  15:34:39 -0500 (0:00:05.647)       0:44:05.786 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | kube-apiserver configured] ***************************************
ok: [node1]
Monday 09 January 2023  15:34:42 -0500 (0:00:02.896)       0:44:08.682 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | kube-controller configured] **************************************
ok: [node1]
Monday 09 January 2023  15:34:45 -0500 (0:00:03.283)       0:44:11.966 ********
Monday 09 January 2023  15:34:45 -0500 (0:00:00.056)       0:44:12.022 ********
Monday 09 January 2023  15:34:46 -0500 (0:00:00.052)       0:44:12.074 ********
Monday 09 January 2023  15:34:46 -0500 (0:00:00.047)       0:44:12.122 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | restart kube-apiserver crio/containerd] **************************
changed: [node1]
Monday 09 January 2023  15:35:10 -0500 (0:00:24.843)       0:44:36.965 ********
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (60 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (59 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (58 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (57 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (56 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (55 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (54 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (53 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (52 retries left).

RUNNING HANDLER [kubernetes/preinstall : Preinstall | wait for the apiserver to be running] ****************************
ok: [node1]
Monday 09 January 2023  15:36:56 -0500 (0:01:45.915)       0:46:22.880 ********
Monday 09 January 2023  15:36:56 -0500 (0:00:00.051)       0:46:22.931 ********
Monday 09 January 2023  15:36:56 -0500 (0:00:00.045)       0:46:22.977 ********
Monday 09 January 2023  15:36:57 -0500 (0:00:00.138)       0:46:23.115 ********
Monday 09 January 2023  15:36:57 -0500 (0:00:00.044)       0:46:23.160 ********
Monday 09 January 2023  15:36:57 -0500 (0:00:00.042)       0:46:23.202 ********
Monday 09 January 2023  15:36:57 -0500 (0:00:00.049)       0:46:23.252 ********
Monday 09 January 2023  15:36:57 -0500 (0:00:00.048)       0:46:23.300 ********
Monday 09 January 2023  15:36:57 -0500 (0:00:00.047)       0:46:23.348 ********

TASK [Run calico checks] ***********************************************************************************************
Monday 09 January 2023  15:36:57 -0500 (0:00:00.383)       0:46:23.750 ********

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (ipip)] ******************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  15:36:57 -0500 (0:00:00.035)       0:46:23.786 ********

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (ipip_mode)] *************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  15:36:57 -0500 (0:00:00.033)       0:46:23.819 ********

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (calcio_ipam_autoallocateblocks)] ****
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  15:36:57 -0500 (0:00:00.036)       0:46:23.856 ********
Monday 09 January 2023  15:36:57 -0500 (0:00:00.027)       0:46:23.884 ********

TASK [network_plugin/calico : Stop if supported Calico versions] *******************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  15:36:57 -0500 (0:00:00.033)       0:46:23.917 ********
ASYNC OK on node1: jid=247949152079.26505

TASK [network_plugin/calico : Get current calico cluster version] ******************************************************
ok: [node1]
Monday 09 January 2023  15:37:10 -0500 (0:00:12.730)       0:46:36.647 ********

TASK [network_plugin/calico : Check that current calico version is enough for upgrade] *********************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  15:37:10 -0500 (0:00:00.037)       0:46:36.685 ********
Monday 09 January 2023  15:37:10 -0500 (0:00:00.033)       0:46:36.719 ********
Monday 09 January 2023  15:37:10 -0500 (0:00:00.029)       0:46:36.748 ********

TASK [network_plugin/calico : Check vars defined correctly] ************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  15:37:10 -0500 (0:00:00.032)       0:46:36.780 ********

TASK [network_plugin/calico : Check calico network backend defined correctly] ******************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  15:37:10 -0500 (0:00:00.034)       0:46:36.815 ********

TASK [network_plugin/calico : Check ipip and vxlan mode defined correctly] *********************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  15:37:10 -0500 (0:00:00.034)       0:46:36.849 ********
Monday 09 January 2023  15:37:10 -0500 (0:00:00.025)       0:46:36.875 ********

TASK [network_plugin/calico : Check ipip and vxlan mode if simultaneously enabled] *************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  15:37:10 -0500 (0:00:00.034)       0:46:36.910 ********

TASK [network_plugin/calico : Get Calico default-pool configuration] ***************************************************
ok: [node1]
Monday 09 January 2023  15:37:12 -0500 (0:00:01.969)       0:46:38.880 ********

TASK [network_plugin/calico : Set calico_pool_conf] ********************************************************************
ok: [node1]
Monday 09 January 2023  15:37:12 -0500 (0:00:00.033)       0:46:38.913 ********

TASK [network_plugin/calico : Check if inventory match current cluster configuration] **********************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Monday 09 January 2023  15:37:12 -0500 (0:00:00.040)       0:46:38.954 ********
Monday 09 January 2023  15:37:12 -0500 (0:00:00.027)       0:46:38.982 ********
Monday 09 January 2023  15:37:12 -0500 (0:00:00.025)       0:46:39.008 ********

PLAY RECAP *************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node1                      : ok=727  changed=144  unreachable=0    failed=0    skipped=1258 rescued=0    ignored=8
node2                      : ok=505  changed=90   unreachable=0    failed=0    skipped=776  rescued=0    ignored=1
node3                      : ok=505  changed=90   unreachable=0    failed=0    skipped=775  rescued=0    ignored=1
node4                      : ok=505  changed=90   unreachable=0    failed=0    skipped=775  rescued=0    ignored=1

Monday 09 January 2023  15:37:13 -0500 (0:00:00.080)       0:46:39.088 ********
===============================================================================
kubernetes/preinstall : Install packages requirements --------------------------------------------------------- 169.15s
kubernetes/control-plane : kubeadm | Initialize first master -------------------------------------------------- 107.12s
kubernetes/preinstall : Preinstall | wait for the apiserver to be running ------------------------------------- 105.92s
bootstrap-os : Update Apt cache -------------------------------------------------------------------------------- 99.75s
kubernetes-apps/ansible : Kubernetes Apps | Start Resources ---------------------------------------------------- 86.59s
kubernetes-apps/ansible : Kubernetes Apps | Lay Down CoreDNS templates ----------------------------------------- 80.56s
download : download_container | Download image if required ----------------------------------------------------- 47.68s
network_plugin/calico : Start Calico resources ----------------------------------------------------------------- 44.68s
network_plugin/calico : Calico | Create calico manifests ------------------------------------------------------- 41.56s
container-engine/containerd : containerd | Unpack containerd archive ------------------------------------------- 39.81s
download : download_container | Download image if required ----------------------------------------------------- 33.87s
download : download_file | Validate mirrors -------------------------------------------------------------------- 32.04s
policy_controller/calico : Start of Calico kube controllers ---------------------------------------------------- 31.54s
network_plugin/cni : CNI | Copy cni plugins -------------------------------------------------------------------- 29.82s
policy_controller/calico : Create calico-kube-controllers manifests -------------------------------------------- 29.43s
kubernetes/kubeadm : Join to cluster --------------------------------------------------------------------------- 24.89s
kubernetes/preinstall : Preinstall | restart kube-apiserver crio/containerd ------------------------------------ 24.84s
kubernetes-apps/ansible : Kubernetes Apps | Lay Down nodelocaldns Template ------------------------------------- 23.24s
download : extract_file | Unpacking archive -------------------------------------------------------------------- 22.42s
download : download_container | Download image if required ----------------------------------------------------- 21.21s

PLAY [Get control plane config] ****************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [node1]

TASK [Copy default admin config] ***************************************************************************************
changed: [node1]

PLAY RECAP *************************************************************************************************************
node1                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

+----------------------+---------------+---------------+---------+--------------+-------------+
|          ID          |     NAME      |    ZONE ID    | STATUS  | EXTERNAL IP  | INTERNAL IP |
+----------------------+---------------+---------------+---------+--------------+-------------+
| fhmi4tv1roiqgjn06m1o | kube-worker-2 | ru-central1-a | RUNNING | 51.250.14.11 | 10.2.0.6    |
| fhmj1tiqg0vfkbjteo6v | kube-worker-1 | ru-central1-a | RUNNING | 51.250.3.40  | 10.2.0.11   |
| fhmmlr985erh7v4qeht8 | kube-master-1 | ru-central1-a | RUNNING | 62.84.117.40 | 10.2.0.16   |
| fhmuqau1i8tsei06nvt9 | kube-worker-3 | ru-central1-a | RUNNING | 51.250.85.66 | 10.2.0.34   |
+----------------------+---------------+---------------+---------+--------------+-------------+

root@debian11:~/13.5# mv ~/.kube/_config_from_node1 ~/.kube/config
root@debian11:~/13.5# nano ~/.kube/config
root@debian11:~/13.5# kubectl get nodes
NAME    STATUS   ROLES           AGE   VERSION
node1   Ready    control-plane   44m   v1.25.5
node2   Ready    <none>          40m   v1.25.5
node3   Ready    <none>          40m   v1.25.5
node4   Ready    <none>          40m   v1.25.5
root@debian11:~/13.5# ./go.sh nfs
--- Add helm repo ---
"stable" already exists with the same configuration, skipping
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈
--- Install NFS-common package ---

PLAY [Install NFS-common library] **************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [node4]
ok: [node2]
ok: [node3]

TASK [try universal package manager plugin] ****************************************************************************
changed: [node2]
changed: [node3]
changed: [node4]

PLAY RECAP *************************************************************************************************************
node2                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node3                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node4                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

--- Install NFS server provisioner ---
Release "nfs-server" does not exist. Installing it now.
WARNING: This chart is deprecated
NAME: nfs-server
LAST DEPLOYED: Mon Jan  9 16:05:01 2023
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
root@debian11:~/13.5#
```
