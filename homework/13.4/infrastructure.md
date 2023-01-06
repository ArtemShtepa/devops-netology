```console
root@debian11:~/13.4# ./go.sh init
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
remote: Enumerating objects: 65758, done.
remote: Counting objects: 100% (190/190), done.
remote: Compressing objects: 100% (155/155), done.
remote: Total 65758 (delta 77), reused 116 (delta 27), pack-reused 65568
Receiving objects: 100% (65758/65758), 20.96 MiB | 4.47 MiB/s, done.
Resolving deltas: 100% (36923/36923), done.
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
Requirement already satisfied: resolvelib<0.6.0,>=0.5.3 in /usr/local/lib/python3.9/dist-packages (from ansible-core==2.12.5->-r kubespray/requirements.txt (line 2)) (0.5.4)
Requirement already satisfied: PyYAML in /usr/lib/python3/dist-packages (from ansible-core==2.12.5->-r kubespray/requirements.txt (line 2)) (5.3.1)
Requirement already satisfied: packaging in /usr/local/lib/python3.9/dist-packages (from ansible-core==2.12.5->-r kubespray/requirements.txt (line 2)) (22.0)
Requirement already satisfied: cffi>=1.12 in /usr/local/lib/python3.9/dist-packages (from cryptography==3.4.8->-r kubespray/requirements.txt (line 3)) (1.15.1)
Requirement already satisfied: pycparser in /usr/local/lib/python3.9/dist-packages (from cffi>=1.12->cryptography==3.4.8->-r kubespray/requirements.txt (line 3)) (2.21)
root@debian11:~/13.4# ./go.sh up

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
yandex_compute_image.os-disk: Creating...
yandex_vpc_network.my-net: Creating...
yandex_vpc_network.my-net: Creation complete after 1s [id=enpn1qdtjepl7f3ubbqr]
yandex_vpc_subnet.my-subnet: Creating...
yandex_vpc_subnet.my-subnet: Creation complete after 1s [id=e9b57bh5r4r7bmvu1e2v]
yandex_compute_image.os-disk: Still creating... [10s elapsed]
yandex_compute_image.os-disk: Creation complete after 11s [id=fd87rsaiqv2evjkrqvju]
module.kube-worker[1].yandex_compute_instance.vm-instance: Creating...
module.kube-master[0].yandex_compute_instance.vm-instance: Creating...
module.kube-worker[2].yandex_compute_instance.vm-instance: Creating...
module.kube-worker[0].yandex_compute_instance.vm-instance: Creating...
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-master[0].yandex_compute_instance.vm-instance: Still creating... [10s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-master[0].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [20s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.kube-master[0].yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Still creating... [30s elapsed]
module.kube-worker[0].yandex_compute_instance.vm-instance: Creation complete after 33s [id=fhm8sj6lq0tbd2gkmfu8]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [40s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [40s elapsed]
module.kube-master[0].yandex_compute_instance.vm-instance: Still creating... [40s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Still creating... [50s elapsed]
module.kube-worker[2].yandex_compute_instance.vm-instance: Still creating... [50s elapsed]
module.kube-master[0].yandex_compute_instance.vm-instance: Still creating... [50s elapsed]
module.kube-worker[1].yandex_compute_instance.vm-instance: Creation complete after 53s [id=fhmc4gfm26rq51qb2o22]
module.kube-master[0].yandex_compute_instance.vm-instance: Creation complete after 57s [id=fhm7mat0c9s1fji8qg8u]
module.kube-worker[2].yandex_compute_instance.vm-instance: Creation complete after 59s [id=fhmaq8ancnu84n5gki0c]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

master_internal_ip = [
  "10.2.0.21",
]
master_ip = [
  "51.250.73.59",
]
worker_internal_ip = [
  "10.2.0.14",
  "10.2.0.7",
  "10.2.0.4",
]
worker_ip = [
  "158.160.40.142",
  "158.160.35.238",
  "158.160.47.243",
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
ok: [localhost] => (item={'id': 'fhm7mat0c9s1fji8qg8u', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2023-01-08T13:13:21Z', 'name': 'kube-master-1', 'description': 'Master Node', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhmb2ad75iu9r030j1ba'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:7b:2b:a0:62', 'subnet_id': 'e9b57bh5r4r7bmvu1e2v', 'primary_v4_address': {'address': '10.2.0.21', 'one_to_one_nat': {'address': '51.250.73.59', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhm7mat0c9s1fji8qg8u.auto.internal', 'scheduling_policy': {}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})
ok: [localhost] => (item={'id': 'fhm8sj6lq0tbd2gkmfu8', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2023-01-08T13:13:21Z', 'name': 'kube-worker-1', 'description': 'Worker Node 1', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhmjs8qs391d3c6s7qi4'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:8e:4c:d5:d0', 'subnet_id': 'e9b57bh5r4r7bmvu1e2v', 'primary_v4_address': {'address': '10.2.0.14', 'one_to_one_nat': {'address': '158.160.40.142', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhm8sj6lq0tbd2gkmfu8.auto.internal', 'scheduling_policy': {}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})
ok: [localhost] => (item={'id': 'fhmaq8ancnu84n5gki0c', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2023-01-08T13:13:21Z', 'name': 'kube-worker-3', 'description': 'Worker Node 3', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhmn9ct56tvv53lgo4g8'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:ad:21:57:65', 'subnet_id': 'e9b57bh5r4r7bmvu1e2v', 'primary_v4_address': {'address': '10.2.0.4', 'one_to_one_nat': {'address': '158.160.47.243', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhmaq8ancnu84n5gki0c.auto.internal', 'scheduling_policy': {}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})
ok: [localhost] => (item={'id': 'fhmc4gfm26rq51qb2o22', 'folder_id': 'b1g3ol70h1opu6hr9kie', 'created_at': '2023-01-08T13:13:21Z', 'name': 'kube-worker-2', 'description': 'Worker Node 2', 'zone_id': 'ru-central1-a', 'platform_id': 'standard-v1', 'resources': {'memory': '2147483648', 'cores': '2', 'core_fraction': '5'}, 'status': 'RUNNING', 'metadata_options': {'gce_http_endpoint': 'ENABLED', 'aws_v1_http_endpoint': 'ENABLED', 'gce_http_token': 'ENABLED', 'aws_v1_http_token': 'ENABLED'}, 'boot_disk': {'mode': 'READ_WRITE', 'device_name': 'debian', 'auto_delete': True, 'disk_id': 'fhme7m2des9ailks5nb4'}, 'network_interfaces': [{'index': '0', 'mac_address': 'd0:0d:c2:41:f6:11', 'subnet_id': 'e9b57bh5r4r7bmvu1e2v', 'primary_v4_address': {'address': '10.2.0.7', 'one_to_one_nat': {'address': '158.160.35.238', 'ip_version': 'IPV4'}}}], 'fqdn': 'fhmc4gfm26rq51qb2o22.auto.internal', 'scheduling_policy': {}, 'network_settings': {'type': 'STANDARD'}, 'placement_policy': {}})

TASK [Check instance count] ********************************************************************************************
ok: [localhost] => {
    "msg": "Total instance count: 4"
}

PLAY [Approve SSH fingerprint] *****************************************************************************************

TASK [Check known_hosts for] *******************************************************************************************
ok: [kube-master-1 -> localhost]
ok: [kube-worker-3 -> localhost]
ok: [kube-worker-1 -> localhost]
ok: [kube-worker-2 -> localhost]

TASK [Skip question for adding host key] *******************************************************************************
ok: [kube-master-1]
ok: [kube-worker-1]
ok: [kube-worker-3]
ok: [kube-worker-2]

TASK [Wait for instances ready] ****************************************************************************************
ok: [kube-worker-2 -> localhost]
ok: [kube-worker-3 -> localhost]
ok: [kube-worker-1 -> localhost]
ok: [kube-master-1 -> localhost]

TASK [Add SSH fingerprint to known host] *******************************************************************************
ok: [kube-worker-2]
ok: [kube-worker-3]
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
| fhm7mat0c9s1fji8qg8u | kube-master-1 | ru-central1-a | RUNNING | 51.250.73.59   | 10.2.0.21   |
| fhm8sj6lq0tbd2gkmfu8 | kube-worker-1 | ru-central1-a | RUNNING | 158.160.40.142 | 10.2.0.14   |
| fhmaq8ancnu84n5gki0c | kube-worker-3 | ru-central1-a | RUNNING | 158.160.47.243 | 10.2.0.4    |
| fhmc4gfm26rq51qb2o22 | kube-worker-2 | ru-central1-a | RUNNING | 158.160.35.238 | 10.2.0.7    |
+----------------------+---------------+---------------+---------+----------------+-------------+

Commands to configure Kubespray (inside kubespray dir):
  declare -a IPS=(maste_ip ... worker_ip ...)
  CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
Manage nodes in inventory/_sample_/hosts.yaml, where _sample_ is your inventory dir.
Don't forget to add Master Node IP address to 'supplementary_addresses_in_ssl_keys'
  list of file 'group_vars/k8s_cluster/k8s-cluster.yml'
root@debian11:~/13.4# cd kubespray/
root@debian11:~/13.4/kubespray# declare -a IPS=(51.250.73.59 158.160.40.142 158.160.35.238 158.160.47.243)
root@debian11:~/13.4/kubespray#  CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
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
root@debian11:~/13.4/kubespray# nano inventory/mycluster/hosts.yaml
root@debian11:~/13.4/kubespray# nano inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
root@debian11:~/13.4/kubespray# cd ..
root@debian11:~/13.4# ./go.sh deploy
[WARNING]: Skipping callback plugin 'ara_default', unable to load

PLAY [localhost] *******************************************************************************************************
Sunday 08 January 2023  08:18:13 -0500 (0:00:00.017)       0:00:00.017 ********

TASK [Check 2.11.0 <= Ansible version < 2.13.0] ************************************************************************
ok: [localhost] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:18:13 -0500 (0:00:00.016)       0:00:00.033 ********

TASK [Check that python netaddr is installed] **************************************************************************
ok: [localhost] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:18:13 -0500 (0:00:00.039)       0:00:00.073 ********

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
Sunday 08 January 2023  08:18:13 -0500 (0:00:00.054)       0:00:00.127 ********
Sunday 08 January 2023  08:18:13 -0500 (0:00:00.071)       0:00:00.199 ********
Sunday 08 January 2023  08:18:13 -0500 (0:00:00.027)       0:00:00.226 ********
Sunday 08 January 2023  08:18:13 -0500 (0:00:00.027)       0:00:00.254 ********
Sunday 08 January 2023  08:18:13 -0500 (0:00:00.058)       0:00:00.313 ********
Sunday 08 January 2023  08:18:13 -0500 (0:00:00.059)       0:00:00.372 ********
Sunday 08 January 2023  08:18:13 -0500 (0:00:00.060)       0:00:00.433 ********
Sunday 08 January 2023  08:18:13 -0500 (0:00:00.066)       0:00:00.500 ********
Sunday 08 January 2023  08:18:13 -0500 (0:00:00.026)       0:00:00.527 ********
Sunday 08 January 2023  08:18:13 -0500 (0:00:00.115)       0:00:00.643 ********
Sunday 08 January 2023  08:18:14 -0500 (0:00:00.596)       0:00:01.305 ********

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
Sunday 08 January 2023  08:18:14 -0500 (0:00:00.112)       0:00:01.418 ********
Sunday 08 January 2023  08:18:14 -0500 (0:00:00.017)       0:00:01.447 ********
Sunday 08 January 2023  08:18:14 -0500 (0:00:00.019)       0:00:01.466 ********
Sunday 08 January 2023  08:18:14 -0500 (0:00:00.052)       0:00:01.518 ********
Sunday 08 January 2023  08:18:14 -0500 (0:00:00.019)       0:00:01.537 ********
Sunday 08 January 2023  08:18:14 -0500 (0:00:00.052)       0:00:01.590 ********
Sunday 08 January 2023  08:18:15 -0500 (0:00:00.151)       0:00:01.741 ********
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword

TASK [bootstrap-os : Fetch /etc/os-release] ****************************************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:18:16 -0500 (0:00:01.509)       0:00:03.256 ********
Sunday 08 January 2023  08:18:16 -0500 (0:00:00.055)       0:00:03.311 ********
Sunday 08 January 2023  08:18:16 -0500 (0:00:00.053)       0:00:03.365 ********
Sunday 08 January 2023  08:18:16 -0500 (0:00:00.051)       0:00:03.416 ********
Sunday 08 January 2023  08:18:16 -0500 (0:00:00.050)       0:00:03.468 ********
Sunday 08 January 2023  08:18:16 -0500 (0:00:00.050)       0:00:03.520 ********
Sunday 08 January 2023  08:18:16 -0500 (0:00:00.102)       0:00:03.623 ********

TASK [bootstrap-os : include_tasks] ************************************************************************************
included: /root/13.4/kubespray/roles/bootstrap-os/tasks/bootstrap-debian.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:18:17 -0500 (0:00:00.102)       0:00:03.726 ********
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword

TASK [bootstrap-os : Check if bootstrap is needed] *********************************************************************
ok: [node3]
ok: [node1]
ok: [node2]
ok: [node4]
Sunday 08 January 2023  08:18:17 -0500 (0:00:00.181)       0:00:03.907 ********
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword

TASK [bootstrap-os : Check http::proxy in apt configuration files] *****************************************************
ok: [node2]
ok: [node1]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:18:17 -0500 (0:00:00.357)       0:00:04.265 ********
Sunday 08 January 2023  08:18:17 -0500 (0:00:00.057)       0:00:04.323 ********
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword

TASK [bootstrap-os : Check https::proxy in apt configuration files] ****************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:18:17 -0500 (0:00:00.183)       0:00:04.507 ********
Sunday 08 January 2023  08:18:17 -0500 (0:00:00.056)       0:00:04.563 ********
Sunday 08 January 2023  08:18:17 -0500 (0:00:00.051)       0:00:04.614 ********
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword
[WARNING]: raw module does not support the environment keyword

TASK [bootstrap-os : Update Apt cache] *********************************************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:19:11 -0500 (0:00:53.328)       0:00:57.948 ********

TASK [bootstrap-os : Set the ansible_python_interpreter fact] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:19:11 -0500 (0:00:00.074)       0:00:58.023 ********

TASK [bootstrap-os : Install dbus for the hostname module] *************************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:19:18 -0500 (0:00:07.587)       0:01:05.616 ********
Sunday 08 January 2023  08:19:18 -0500 (0:00:00.062)       0:01:05.679 ********
Sunday 08 January 2023  08:19:19 -0500 (0:00:00.062)       0:01:05.742 ********

TASK [bootstrap-os : Create remote_tmp for it is used by another module] ***********************************************
changed: [node3]
changed: [node2]
changed: [node1]
changed: [node4]
Sunday 08 January 2023  08:19:21 -0500 (0:00:02.051)       0:01:07.794 ********

TASK [bootstrap-os : Gather host facts to get ansible_os_family] *******************************************************
ok: [node3]
ok: [node1]
ok: [node4]
ok: [node2]
Sunday 08 January 2023  08:19:25 -0500 (0:00:04.884)       0:01:12.678 ********

TASK [bootstrap-os : Assign inventory name to unconfigured hostnames (non-CoreOS, non-Flatcar, Suse and ClearLinux, non-Fedora)] ***
changed: [node4]
changed: [node1]
changed: [node2]
changed: [node3]
Sunday 08 January 2023  08:19:30 -0500 (0:00:04.510)       0:01:17.189 ********
Sunday 08 January 2023  08:19:30 -0500 (0:00:00.057)       0:01:17.247 ********
Sunday 08 January 2023  08:19:30 -0500 (0:00:00.061)       0:01:17.309 ********
Sunday 08 January 2023  08:19:30 -0500 (0:00:00.135)       0:01:17.444 ********

TASK [bootstrap-os : Ensure bash_completion.d folder exists] ***********************************************************
changed: [node4]
changed: [node2]
changed: [node3]
changed: [node1]

PLAY [Gather facts] ****************************************************************************************************
Sunday 08 January 2023  08:19:32 -0500 (0:00:02.064)       0:01:19.509 ********

TASK [Gather minimal facts] ********************************************************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:19:37 -0500 (0:00:04.304)       0:01:23.814 ********

TASK [Gather necessary facts (network)] ********************************************************************************
ok: [node3]
ok: [node1]
ok: [node2]
ok: [node4]
Sunday 08 January 2023  08:19:40 -0500 (0:00:03.715)       0:01:27.529 ********

TASK [Gather necessary facts (hardware)] *******************************************************************************
ok: [node3]
ok: [node1]
ok: [node4]
ok: [node2]

PLAY [k8s_cluster:etcd] ************************************************************************************************
Sunday 08 January 2023  08:19:45 -0500 (0:00:04.541)       0:01:32.072 ********
Sunday 08 January 2023  08:19:45 -0500 (0:00:00.067)       0:01:32.140 ********
Sunday 08 January 2023  08:19:45 -0500 (0:00:00.025)       0:01:32.165 ********
Sunday 08 January 2023  08:19:45 -0500 (0:00:00.023)       0:01:32.189 ********
Sunday 08 January 2023  08:19:45 -0500 (0:00:00.064)       0:01:32.253 ********
Sunday 08 January 2023  08:19:45 -0500 (0:00:00.062)       0:01:32.316 ********
Sunday 08 January 2023  08:19:45 -0500 (0:00:00.141)       0:01:32.457 ********
Sunday 08 January 2023  08:19:45 -0500 (0:00:00.064)       0:01:32.522 ********
Sunday 08 January 2023  08:19:45 -0500 (0:00:00.025)       0:01:32.547 ********
Sunday 08 January 2023  08:19:45 -0500 (0:00:00.069)       0:01:32.616 ********
Sunday 08 January 2023  08:19:46 -0500 (0:00:00.742)       0:01:33.359 ********

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
Sunday 08 January 2023  08:19:46 -0500 (0:00:00.121)       0:01:33.480 ********
Sunday 08 January 2023  08:19:46 -0500 (0:00:00.255)       0:01:33.736 ********

TASK [kubespray-defaults : create fallback_ips_base] *******************************************************************
ok: [node1 -> localhost]
Sunday 08 January 2023  08:19:47 -0500 (0:00:00.071)       0:01:33.808 ********

TASK [kubespray-defaults : set fallback_ips] ***************************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:19:47 -0500 (0:00:00.082)       0:01:33.890 ********
Sunday 08 January 2023  08:19:47 -0500 (0:00:00.030)       0:01:33.921 ********
Sunday 08 January 2023  08:19:47 -0500 (0:00:00.069)       0:01:33.990 ********
Sunday 08 January 2023  08:19:47 -0500 (0:00:00.108)       0:01:34.099 ********

TASK [adduser : User | Create User Group] ******************************************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:19:50 -0500 (0:00:02.684)       0:01:36.783 ********

TASK [adduser : User | Create User] ************************************************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:19:52 -0500 (0:00:02.442)       0:01:39.226 ********

TASK [kubernetes/preinstall : Remove swapfile from /etc/fstab] *********************************************************
ok: [node3] => (item=swap)
ok: [node4] => (item=swap)
ok: [node1] => (item=swap)
ok: [node3] => (item=none)
ok: [node2] => (item=swap)
ok: [node4] => (item=none)
ok: [node1] => (item=none)
ok: [node2] => (item=none)
Sunday 08 January 2023  08:19:55 -0500 (0:00:03.419)       0:01:42.646 ********

TASK [kubernetes/preinstall : check swap] ******************************************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:19:58 -0500 (0:00:02.249)       0:01:44.895 ********
Sunday 08 January 2023  08:19:58 -0500 (0:00:00.066)       0:01:44.961 ********
Sunday 08 January 2023  08:19:58 -0500 (0:00:00.066)       0:01:45.028 ********

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
Sunday 08 January 2023  08:19:58 -0500 (0:00:00.051)       0:01:45.079 ********

TASK [kubernetes/preinstall : Stop if etcd group is empty in external etcd mode] ***************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:19:58 -0500 (0:00:00.039)       0:01:45.119 ********

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
Sunday 08 January 2023  08:19:58 -0500 (0:00:00.157)       0:01:45.277 ********

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
Sunday 08 January 2023  08:19:58 -0500 (0:00:00.081)       0:01:45.358 ********

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
Sunday 08 January 2023  08:19:58 -0500 (0:00:00.080)       0:01:45.439 ********

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
Sunday 08 January 2023  08:19:58 -0500 (0:00:00.083)       0:01:45.523 ********

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
Sunday 08 January 2023  08:19:58 -0500 (0:00:00.090)       0:01:45.613 ********

TASK [kubernetes/preinstall : Stop if even number of etcd hosts] *******************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:19:58 -0500 (0:00:00.068)       0:01:45.682 ********

TASK [kubernetes/preinstall : Stop if memory is too small for masters] *************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:19:59 -0500 (0:00:00.070)       0:01:45.752 ********

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
Sunday 08 January 2023  08:19:59 -0500 (0:00:00.078)       0:01:45.831 ********
Sunday 08 January 2023  08:19:59 -0500 (0:00:00.078)       0:01:45.909 ********
Sunday 08 January 2023  08:19:59 -0500 (0:00:00.068)       0:01:45.978 ********
Sunday 08 January 2023  08:19:59 -0500 (0:00:00.068)       0:01:46.047 ********
Sunday 08 January 2023  08:19:59 -0500 (0:00:00.147)       0:01:46.195 ********
Sunday 08 January 2023  08:19:59 -0500 (0:00:00.066)       0:01:46.262 ********
Sunday 08 January 2023  08:19:59 -0500 (0:00:00.073)       0:01:46.335 ********
Sunday 08 January 2023  08:19:59 -0500 (0:00:00.070)       0:01:46.406 ********

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
Sunday 08 January 2023  08:19:59 -0500 (0:00:00.080)       0:01:46.487 ********
Sunday 08 January 2023  08:19:59 -0500 (0:00:00.070)       0:01:46.557 ********

TASK [kubernetes/preinstall : Check that kube_service_addresses is a network range] ************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:19:59 -0500 (0:00:00.064)       0:01:46.621 ********

TASK [kubernetes/preinstall : Check that kube_pods_subnet is a network range] ******************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:19:59 -0500 (0:00:00.064)       0:01:46.686 ********

TASK [kubernetes/preinstall : Check that kube_pods_subnet does not collide with kube_service_addresses] ****************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.067)       0:01:46.753 ********
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.021)       0:01:46.774 ********

TASK [kubernetes/preinstall : Stop if unknown dns mode] ****************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.034)       0:01:46.809 ********

TASK [kubernetes/preinstall : Stop if unknown kube proxy mode] *********************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.037)       0:01:46.847 ********

TASK [kubernetes/preinstall : Stop if unknown cert_management] *********************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.034)       0:01:46.882 ********

TASK [kubernetes/preinstall : Stop if unknown resolvconf_mode] *********************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.036)       0:01:46.918 ********

TASK [kubernetes/preinstall : Stop if etcd deployment type is not host, docker or kubeadm] *****************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.069)       0:01:46.988 ********

TASK [kubernetes/preinstall : Stop if container manager is not docker, crio or containerd] *****************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.031)       0:01:47.019 ********

TASK [kubernetes/preinstall : Stop if etcd deployment type is not host or kubeadm when container_manager != docker] ****
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.145)       0:01:47.164 ********
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.026)       0:01:47.191 ********
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.026)       0:01:47.217 ********
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.064)       0:01:47.282 ********
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.065)       0:01:47.348 ********
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.067)       0:01:47.415 ********
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.065)       0:01:47.480 ********

TASK [kubernetes/preinstall : Ensure minimum containerd version] *******************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.036)       0:01:47.516 ********
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.071)       0:01:47.588 ********
Sunday 08 January 2023  08:20:00 -0500 (0:00:00.067)       0:01:47.656 ********
Sunday 08 January 2023  08:20:01 -0500 (0:00:00.064)       0:01:47.720 ********
Sunday 08 January 2023  08:20:01 -0500 (0:00:00.065)       0:01:47.785 ********
Sunday 08 January 2023  08:20:01 -0500 (0:00:00.140)       0:01:47.926 ********

TASK [kubernetes/preinstall : check if booted with ostree] *************************************************************
ok: [node4]
ok: [node1]
ok: [node2]
ok: [node3]
Sunday 08 January 2023  08:20:04 -0500 (0:00:02.893)       0:01:50.820 ********

TASK [kubernetes/preinstall : set is_fedora_coreos] ********************************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:20:07 -0500 (0:00:02.970)       0:01:53.796 ********

TASK [kubernetes/preinstall : set is_fedora_coreos] ********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:20:07 -0500 (0:00:00.076)       0:01:53.872 ********

TASK [kubernetes/preinstall : check resolvconf] ************************************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:20:08 -0500 (0:00:01.784)       0:01:55.657 ********

TASK [kubernetes/preinstall : check existence of /etc/resolvconf/resolv.conf.d] ****************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:20:11 -0500 (0:00:02.708)       0:01:58.365 ********

TASK [kubernetes/preinstall : check status of /etc/resolv.conf] ********************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:20:13 -0500 (0:00:01.852)       0:02:00.218 ********

TASK [kubernetes/preinstall : get content of /etc/resolv.conf] *********************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:20:15 -0500 (0:00:02.110)       0:02:02.328 ********

TASK [kubernetes/preinstall : get currently configured nameservers] ****************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:20:15 -0500 (0:00:00.103)       0:02:02.432 ********

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
Sunday 08 January 2023  08:20:15 -0500 (0:00:00.080)       0:02:02.513 ********

TASK [kubernetes/preinstall : NetworkManager | Check if host has NetworkManager] ***************************************
ok: [node4]
ok: [node1]
ok: [node2]
ok: [node3]
Sunday 08 January 2023  08:20:17 -0500 (0:00:02.022)       0:02:04.536 ********

TASK [kubernetes/preinstall : check systemd-resolved] ******************************************************************
ok: [node3]
ok: [node1]
ok: [node4]
ok: [node2]
Sunday 08 January 2023  08:20:20 -0500 (0:00:02.401)       0:02:06.937 ********

TASK [kubernetes/preinstall : set default dns if remove_default_searchdomains is false] ********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:20:20 -0500 (0:00:00.171)       0:02:07.108 ********

TASK [kubernetes/preinstall : set dns facts] ***************************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:20:20 -0500 (0:00:00.074)       0:02:07.183 ********

TASK [kubernetes/preinstall : check if kubelet is configured] **********************************************************
ok: [node3]
ok: [node1]
ok: [node2]
ok: [node4]
Sunday 08 January 2023  08:20:22 -0500 (0:00:02.113)       0:02:09.296 ********

TASK [kubernetes/preinstall : check if early DNS configuration stage] **************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:20:22 -0500 (0:00:00.071)       0:02:09.367 ********

TASK [kubernetes/preinstall : target resolv.conf files] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:20:22 -0500 (0:00:00.074)       0:02:09.442 ********
Sunday 08 January 2023  08:20:22 -0500 (0:00:00.055)       0:02:09.497 ********

TASK [kubernetes/preinstall : check if /etc/dhclient.conf exists] ******************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:20:24 -0500 (0:00:01.980)       0:02:11.477 ********
Sunday 08 January 2023  08:20:24 -0500 (0:00:00.059)       0:02:11.537 ********

TASK [kubernetes/preinstall : check if /etc/dhcp/dhclient.conf exists] *************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:20:26 -0500 (0:00:02.001)       0:02:13.539 ********

TASK [kubernetes/preinstall : target dhclient conf file for /etc/dhcp/dhclient.conf] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:20:26 -0500 (0:00:00.073)       0:02:13.612 ********
Sunday 08 January 2023  08:20:26 -0500 (0:00:00.060)       0:02:13.673 ********

TASK [kubernetes/preinstall : target dhclient hook file for Debian family] *********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:20:27 -0500 (0:00:00.064)       0:02:13.737 ********

TASK [kubernetes/preinstall : generate search domains to resolvconf] ***************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:20:27 -0500 (0:00:00.071)       0:02:13.808 ********

TASK [kubernetes/preinstall : pick coredns cluster IP or default resolver] *********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:20:27 -0500 (0:00:00.105)       0:02:13.914 ********
Sunday 08 January 2023  08:20:27 -0500 (0:00:00.122)       0:02:14.036 ********

TASK [kubernetes/preinstall : generate nameservers for resolvconf, not including cluster DNS] **************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:20:27 -0500 (0:00:00.072)       0:02:14.109 ********

TASK [kubernetes/preinstall : gather os specific variables] ************************************************************
ok: [node1] => (item=/root/13.4/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
ok: [node2] => (item=/root/13.4/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
ok: [node3] => (item=/root/13.4/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
ok: [node4] => (item=/root/13.4/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
Sunday 08 January 2023  08:20:27 -0500 (0:00:00.075)       0:02:14.185 ********
Sunday 08 January 2023  08:20:27 -0500 (0:00:00.056)       0:02:14.242 ********

TASK [kubernetes/preinstall : check /usr readonly] *********************************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:20:29 -0500 (0:00:02.287)       0:02:16.529 ********
Sunday 08 January 2023  08:20:29 -0500 (0:00:00.054)       0:02:16.584 ********
Sunday 08 January 2023  08:20:29 -0500 (0:00:00.059)       0:02:16.644 ********
Sunday 08 January 2023  08:20:30 -0500 (0:00:00.128)       0:02:16.773 ********

TASK [kubernetes/preinstall : Create kubernetes directories] ***********************************************************
changed: [node3] => (item=/etc/kubernetes)
changed: [node1] => (item=/etc/kubernetes)
changed: [node3] => (item=/etc/kubernetes/ssl)
changed: [node4] => (item=/etc/kubernetes)
changed: [node2] => (item=/etc/kubernetes)
changed: [node3] => (item=/etc/kubernetes/manifests)
changed: [node4] => (item=/etc/kubernetes/ssl)
changed: [node3] => (item=/usr/local/bin/kubernetes-scripts)
changed: [node1] => (item=/etc/kubernetes/ssl)
changed: [node2] => (item=/etc/kubernetes/ssl)
changed: [node3] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
changed: [node4] => (item=/etc/kubernetes/manifests)
changed: [node2] => (item=/etc/kubernetes/manifests)
changed: [node1] => (item=/etc/kubernetes/manifests)
changed: [node4] => (item=/usr/local/bin/kubernetes-scripts)
changed: [node2] => (item=/usr/local/bin/kubernetes-scripts)
changed: [node1] => (item=/usr/local/bin/kubernetes-scripts)
changed: [node4] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
changed: [node2] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
changed: [node1] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
Sunday 08 January 2023  08:20:40 -0500 (0:00:10.113)       0:02:26.887 ********

TASK [kubernetes/preinstall : Create other directories] ****************************************************************
ok: [node3] => (item=/usr/local/bin)
ok: [node2] => (item=/usr/local/bin)
ok: [node1] => (item=/usr/local/bin)
ok: [node4] => (item=/usr/local/bin)
Sunday 08 January 2023  08:20:42 -0500 (0:00:02.681)       0:02:29.568 ********

TASK [kubernetes/preinstall : Check if kubernetes kubeadm compat cert dir exists] **************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:20:45 -0500 (0:00:02.371)       0:02:31.939 ********

TASK [kubernetes/preinstall : Create kubernetes kubeadm compat cert dir (kubernetes/kubeadm issue 1498)] ***************
changed: [node3]
changed: [node1]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:20:47 -0500 (0:00:02.737)       0:02:34.677 ********

TASK [kubernetes/preinstall : Create cni directories] ******************************************************************
changed: [node3] => (item=/etc/cni/net.d)
changed: [node3] => (item=/opt/cni/bin)
changed: [node3] => (item=/var/lib/calico)
changed: [node4] => (item=/etc/cni/net.d)
changed: [node2] => (item=/etc/cni/net.d)
changed: [node1] => (item=/etc/cni/net.d)
changed: [node4] => (item=/opt/cni/bin)
changed: [node1] => (item=/opt/cni/bin)
changed: [node2] => (item=/opt/cni/bin)
changed: [node4] => (item=/var/lib/calico)
changed: [node1] => (item=/var/lib/calico)
changed: [node2] => (item=/var/lib/calico)
Sunday 08 January 2023  08:20:55 -0500 (0:00:07.412)       0:02:42.089 ********
Sunday 08 January 2023  08:20:55 -0500 (0:00:00.132)       0:02:42.222 ********
Sunday 08 January 2023  08:20:55 -0500 (0:00:00.057)       0:02:42.280 ********

TASK [kubernetes/preinstall : Add domain/search/nameservers/options to resolv.conf] ************************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  08:20:57 -0500 (0:00:02.070)       0:02:44.350 ********

TASK [kubernetes/preinstall : Remove search/domain/nameserver options before block] ************************************
ok: [node3] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'options\\s'])
Sunday 08 January 2023  08:21:10 -0500 (0:00:12.544)       0:02:56.894 ********

TASK [kubernetes/preinstall : Remove search/domain/nameserver options after block] *************************************
changed: [node3] => (item=['/etc/resolv.conf', 'search\\s'])
changed: [node3] => (item=['/etc/resolv.conf', 'nameserver\\s'])
changed: [node4] => (item=['/etc/resolv.conf', 'search\\s'])
changed: [node3] => (item=['/etc/resolv.conf', 'domain\\s'])
changed: [node1] => (item=['/etc/resolv.conf', 'search\\s'])
changed: [node2] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'options\\s'])
changed: [node4] => (item=['/etc/resolv.conf', 'nameserver\\s'])
changed: [node2] => (item=['/etc/resolv.conf', 'nameserver\\s'])
changed: [node1] => (item=['/etc/resolv.conf', 'nameserver\\s'])
changed: [node4] => (item=['/etc/resolv.conf', 'domain\\s'])
changed: [node1] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'options\\s'])
changed: [node2] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'options\\s'])
Sunday 08 January 2023  08:21:19 -0500 (0:00:09.568)       0:03:06.463 ********
Sunday 08 January 2023  08:21:19 -0500 (0:00:00.058)       0:03:06.521 ********
Sunday 08 January 2023  08:21:19 -0500 (0:00:00.126)       0:03:06.647 ********
Sunday 08 January 2023  08:21:20 -0500 (0:00:00.063)       0:03:06.710 ********
Sunday 08 January 2023  08:21:20 -0500 (0:00:00.057)       0:03:06.768 ********
Sunday 08 January 2023  08:21:20 -0500 (0:00:00.058)       0:03:06.826 ********
Sunday 08 January 2023  08:21:20 -0500 (0:00:00.055)       0:03:06.881 ********
Sunday 08 January 2023  08:21:20 -0500 (0:00:00.057)       0:03:06.939 ********
Sunday 08 January 2023  08:21:20 -0500 (0:00:00.063)       0:03:07.003 ********
Sunday 08 January 2023  08:21:20 -0500 (0:00:00.060)       0:03:07.064 ********
Sunday 08 January 2023  08:21:20 -0500 (0:00:00.057)       0:03:07.121 ********
Sunday 08 January 2023  08:21:20 -0500 (0:00:00.065)       0:03:07.186 ********
Sunday 08 January 2023  08:21:20 -0500 (0:00:00.129)       0:03:07.315 ********
Sunday 08 January 2023  08:21:20 -0500 (0:00:00.059)       0:03:07.375 ********

TASK [kubernetes/preinstall : Update package management cache (APT)] ***************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:21:25 -0500 (0:00:05.301)       0:03:12.676 ********
Sunday 08 January 2023  08:21:26 -0500 (0:00:00.056)       0:03:12.733 ********
Sunday 08 January 2023  08:21:26 -0500 (0:00:00.058)       0:03:12.791 ********
Sunday 08 January 2023  08:21:26 -0500 (0:00:00.057)       0:03:12.849 ********

TASK [kubernetes/preinstall : Update common_required_pkgs with ipvsadm when kube_proxy_mode is ipvs] *******************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:21:26 -0500 (0:00:00.133)       0:03:12.982 ********

TASK [kubernetes/preinstall : Install packages requirements] ***********************************************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  08:24:35 -0500 (0:03:09.591)       0:06:22.574 ********
Sunday 08 January 2023  08:24:35 -0500 (0:00:00.057)       0:06:22.632 ********
Sunday 08 January 2023  08:24:36 -0500 (0:00:00.062)       0:06:22.695 ********
Sunday 08 January 2023  08:24:36 -0500 (0:00:00.056)       0:06:22.751 ********
Sunday 08 January 2023  08:24:36 -0500 (0:00:00.127)       0:06:22.879 ********

TASK [kubernetes/preinstall : Clean previously used sysctl file locations] *********************************************
ok: [node3] => (item=ipv4-ip_forward.conf)
ok: [node1] => (item=ipv4-ip_forward.conf)
ok: [node3] => (item=bridge-nf-call.conf)
ok: [node4] => (item=ipv4-ip_forward.conf)
ok: [node2] => (item=ipv4-ip_forward.conf)
ok: [node4] => (item=bridge-nf-call.conf)
ok: [node1] => (item=bridge-nf-call.conf)
ok: [node2] => (item=bridge-nf-call.conf)
Sunday 08 January 2023  08:24:40 -0500 (0:00:04.375)       0:06:27.255 ********

TASK [kubernetes/preinstall : Stat sysctl file configuration] **********************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:24:42 -0500 (0:00:02.208)       0:06:29.466 ********

TASK [kubernetes/preinstall : Change sysctl file path to link source if linked] ****************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:24:42 -0500 (0:00:00.070)       0:06:29.537 ********

TASK [kubernetes/preinstall : Make sure sysctl file path folder exists] ************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:24:45 -0500 (0:00:02.433)       0:06:31.971 ********

TASK [kubernetes/preinstall : Enable ip forwarding] ********************************************************************
changed: [node3]
changed: [node1]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:24:49 -0500 (0:00:04.076)       0:06:36.052 ********
Sunday 08 January 2023  08:24:49 -0500 (0:00:00.130)       0:06:36.183 ********

TASK [kubernetes/preinstall : Check if we need to set fs.may_detach_mounts] ********************************************
ok: [node3]
ok: [node1]
ok: [node4]
ok: [node2]
Sunday 08 January 2023  08:24:52 -0500 (0:00:02.925)       0:06:39.109 ********
Sunday 08 January 2023  08:24:52 -0500 (0:00:00.057)       0:06:39.166 ********

TASK [kubernetes/preinstall : Ensure kube-bench parameters are set] ****************************************************
changed: [node3] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
changed: [node3] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
changed: [node1] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
changed: [node4] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
changed: [node3] => (item={'name': 'kernel.panic', 'value': 10})
changed: [node2] => (item={'name': 'kernel.keys.root_maxbytes', 'value': 25000000})
changed: [node3] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
changed: [node3] => (item={'name': 'vm.overcommit_memory', 'value': 1})
changed: [node4] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
changed: [node1] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
changed: [node2] => (item={'name': 'kernel.keys.root_maxkeys', 'value': 1000000})
changed: [node3] => (item={'name': 'vm.panic_on_oom', 'value': 0})
changed: [node4] => (item={'name': 'kernel.panic', 'value': 10})
changed: [node2] => (item={'name': 'kernel.panic', 'value': 10})
changed: [node1] => (item={'name': 'kernel.panic', 'value': 10})
changed: [node4] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
changed: [node2] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
changed: [node1] => (item={'name': 'kernel.panic_on_oops', 'value': 1})
changed: [node4] => (item={'name': 'vm.overcommit_memory', 'value': 1})
changed: [node2] => (item={'name': 'vm.overcommit_memory', 'value': 1})
changed: [node4] => (item={'name': 'vm.panic_on_oom', 'value': 0})
changed: [node1] => (item={'name': 'vm.overcommit_memory', 'value': 1})
changed: [node2] => (item={'name': 'vm.panic_on_oom', 'value': 0})
changed: [node1] => (item={'name': 'vm.panic_on_oom', 'value': 0})
Sunday 08 January 2023  08:25:10 -0500 (0:00:18.067)       0:06:57.233 ********

TASK [kubernetes/preinstall : Check dummy module] **********************************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:25:13 -0500 (0:00:02.628)       0:06:59.862 ********
Sunday 08 January 2023  08:25:13 -0500 (0:00:00.051)       0:06:59.913 ********
Sunday 08 January 2023  08:25:13 -0500 (0:00:00.117)       0:07:00.030 ********
Sunday 08 January 2023  08:25:13 -0500 (0:00:00.059)       0:07:00.089 ********
Sunday 08 January 2023  08:25:13 -0500 (0:00:00.057)       0:07:00.147 ********
Sunday 08 January 2023  08:25:13 -0500 (0:00:00.061)       0:07:00.208 ********
Sunday 08 January 2023  08:25:13 -0500 (0:00:00.055)       0:07:00.264 ********
Sunday 08 January 2023  08:25:13 -0500 (0:00:00.055)       0:07:00.319 ********
Sunday 08 January 2023  08:25:13 -0500 (0:00:00.055)       0:07:00.375 ********
Sunday 08 January 2023  08:25:13 -0500 (0:00:00.060)       0:07:00.436 ********
Sunday 08 January 2023  08:25:13 -0500 (0:00:00.060)       0:07:00.497 ********

TASK [kubernetes/preinstall : Hosts | create list from inventory] ******************************************************
ok: [node1 -> localhost]
Sunday 08 January 2023  08:25:14 -0500 (0:00:00.344)       0:07:00.841 ********

TASK [kubernetes/preinstall : Hosts | populate inventory into hosts file] **********************************************
changed: [node3]
changed: [node1]
changed: [node2]
changed: [node4]
Sunday 08 January 2023  08:25:16 -0500 (0:00:02.721)       0:07:03.562 ********
Sunday 08 January 2023  08:25:16 -0500 (0:00:00.063)       0:07:03.625 ********

TASK [kubernetes/preinstall : Hosts | Retrieve hosts file content] *****************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:25:18 -0500 (0:00:02.021)       0:07:05.647 ********

TASK [kubernetes/preinstall : Hosts | Extract existing entries for localhost from hosts file] **************************
ok: [node1] => (item=127.0.0.1 localhost)
ok: [node1] => (item=::1 ip6-localhost ip6-loopback)
ok: [node2] => (item=127.0.0.1 localhost)
ok: [node2] => (item=::1 ip6-localhost ip6-loopback)
ok: [node4] => (item=127.0.0.1 localhost)
ok: [node3] => (item=127.0.0.1 localhost)
ok: [node4] => (item=::1 ip6-localhost ip6-loopback)
ok: [node3] => (item=::1 ip6-localhost ip6-loopback)
Sunday 08 January 2023  08:25:19 -0500 (0:00:00.203)       0:07:05.851 ********

TASK [kubernetes/preinstall : Hosts | Update target hosts file entries dict with required entries] *********************
ok: [node1] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [node1] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [node2] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [node2] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [node3] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [node3] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
ok: [node4] => (item={'key': '127.0.0.1', 'value': {'expected': ['localhost', 'localhost.localdomain']}})
ok: [node4] => (item={'key': '::1', 'value': {'expected': ['localhost6', 'localhost6.localdomain'], 'unexpected': ['localhost', 'localhost.localdomain']}})
Sunday 08 January 2023  08:25:19 -0500 (0:00:00.085)       0:07:05.936 ********

TASK [kubernetes/preinstall : Hosts | Update (if necessary) hosts file] ************************************************
changed: [node3] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [node3] => (item={'key': '::1', 'value': ['ip6-localhost', 'ip6-loopback', 'localhost6', 'localhost6.localdomain']})
changed: [node4] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [node2] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [node1] => (item={'key': '127.0.0.1', 'value': ['localhost', 'localhost.localdomain']})
changed: [node4] => (item={'key': '::1', 'value': ['ip6-localhost', 'ip6-loopback', 'localhost6', 'localhost6.localdomain']})
changed: [node1] => (item={'key': '::1', 'value': ['ip6-localhost', 'ip6-loopback', 'localhost6', 'localhost6.localdomain']})
changed: [node2] => (item={'key': '::1', 'value': ['ip6-localhost', 'ip6-loopback', 'localhost6', 'localhost6.localdomain']})
Sunday 08 January 2023  08:25:24 -0500 (0:00:04.856)       0:07:10.793 ********

TASK [kubernetes/preinstall : Update facts] ****************************************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:25:27 -0500 (0:00:03.617)       0:07:14.410 ********

TASK [kubernetes/preinstall : Configure dhclient to supersede search/domain/nameservers] *******************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Sunday 08 January 2023  08:25:30 -0500 (0:00:02.484)       0:07:16.895 ********

TASK [kubernetes/preinstall : Configure dhclient hooks for resolv.conf (non-RH)] ***************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:25:35 -0500 (0:00:04.976)       0:07:21.871 ********
Sunday 08 January 2023  08:25:35 -0500 (0:00:00.063)       0:07:21.935 ********
Sunday 08 January 2023  08:25:35 -0500 (0:00:00.056)       0:07:21.992 ********
Sunday 08 January 2023  08:25:35 -0500 (0:00:00.057)       0:07:22.049 ********
Sunday 08 January 2023  08:25:35 -0500 (0:00:00.000)       0:07:22.049 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | propagate resolvconf to k8s components] **************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Sunday 08 January 2023  08:25:38 -0500 (0:00:02.665)       0:07:24.714 ********
Sunday 08 January 2023  08:25:38 -0500 (0:00:00.056)       0:07:24.770 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | kube-apiserver configured] ***************************************
ok: [node1]
Sunday 08 January 2023  08:25:39 -0500 (0:00:01.709)       0:07:26.480 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | kube-controller configured] **************************************
ok: [node1]
Sunday 08 January 2023  08:25:42 -0500 (0:00:02.246)       0:07:28.727 ********
Sunday 08 January 2023  08:25:42 -0500 (0:00:00.053)       0:07:28.780 ********
Sunday 08 January 2023  08:25:42 -0500 (0:00:00.058)       0:07:28.839 ********
Sunday 08 January 2023  08:25:42 -0500 (0:00:00.119)       0:07:28.958 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | restart kube-apiserver crio/containerd] **************************
changed: [node1]
Sunday 08 January 2023  08:25:44 -0500 (0:00:02.003)       0:07:30.962 ********
Sunday 08 January 2023  08:25:44 -0500 (0:00:00.072)       0:07:31.035 ********

TASK [kubernetes/preinstall : Check if we are running inside a Azure VM] ***********************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:25:47 -0500 (0:00:03.076)       0:07:34.117 ********
Sunday 08 January 2023  08:25:47 -0500 (0:00:00.057)       0:07:34.175 ********
Sunday 08 January 2023  08:25:47 -0500 (0:00:00.060)       0:07:34.235 ********
Sunday 08 January 2023  08:25:47 -0500 (0:00:00.128)       0:07:34.364 ********
Sunday 08 January 2023  08:25:47 -0500 (0:00:00.059)       0:07:34.424 ********
Sunday 08 January 2023  08:25:47 -0500 (0:00:00.059)       0:07:34.484 ********
Sunday 08 January 2023  08:25:47 -0500 (0:00:00.057)       0:07:34.541 ********
Sunday 08 January 2023  08:25:47 -0500 (0:00:00.056)       0:07:34.598 ********

TASK [Run calico checks] ***********************************************************************************************
Sunday 08 January 2023  08:25:48 -0500 (0:00:00.496)       0:07:35.098 ********

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (ipip)] ******************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:25:48 -0500 (0:00:00.038)       0:07:35.137 ********

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (ipip_mode)] *************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:25:48 -0500 (0:00:00.043)       0:07:35.180 ********

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (calcio_ipam_autoallocateblocks)] ****
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:25:48 -0500 (0:00:00.041)       0:07:35.222 ********
Sunday 08 January 2023  08:25:48 -0500 (0:00:00.033)       0:07:35.256 ********

TASK [network_plugin/calico : Stop if supported Calico versions] *******************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:25:48 -0500 (0:00:00.042)       0:07:35.299 ********
ASYNC FAILED on node1: jid=507578686560.8079

TASK [network_plugin/calico : Get current calico cluster version] ******************************************************
ok: [node1]
Sunday 08 January 2023  08:25:54 -0500 (0:00:06.329)       0:07:41.628 ********
Sunday 08 January 2023  08:25:54 -0500 (0:00:00.034)       0:07:41.663 ********
Sunday 08 January 2023  08:25:55 -0500 (0:00:00.033)       0:07:41.696 ********
Sunday 08 January 2023  08:25:55 -0500 (0:00:00.105)       0:07:41.801 ********

TASK [network_plugin/calico : Check vars defined correctly] ************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:25:55 -0500 (0:00:00.045)       0:07:41.847 ********

TASK [network_plugin/calico : Check calico network backend defined correctly] ******************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:25:55 -0500 (0:00:00.039)       0:07:41.886 ********

TASK [network_plugin/calico : Check ipip and vxlan mode defined correctly] *********************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:25:55 -0500 (0:00:00.046)       0:07:41.932 ********
Sunday 08 January 2023  08:25:55 -0500 (0:00:00.030)       0:07:41.963 ********

TASK [network_plugin/calico : Check ipip and vxlan mode if simultaneously enabled] *************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  08:25:55 -0500 (0:00:00.044)       0:07:42.008 ********

TASK [network_plugin/calico : Get Calico default-pool configuration] ***************************************************
ok: [node1]
Sunday 08 January 2023  08:25:55 -0500 (0:00:00.616)       0:07:42.625 ********
Sunday 08 January 2023  08:25:55 -0500 (0:00:00.032)       0:07:42.657 ********
Sunday 08 January 2023  08:25:55 -0500 (0:00:00.032)       0:07:42.690 ********
Sunday 08 January 2023  08:25:56 -0500 (0:00:00.029)       0:07:42.719 ********
Sunday 08 January 2023  08:25:56 -0500 (0:00:00.031)       0:07:42.751 ********
Sunday 08 January 2023  08:25:56 -0500 (0:00:00.089)       0:07:42.840 ********

TASK [container-engine/validate-container-engine : validate-container-engine | check if fedora coreos] *****************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:25:58 -0500 (0:00:01.860)       0:07:44.700 ********

TASK [container-engine/validate-container-engine : validate-container-engine | set is_ostree] **************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:25:58 -0500 (0:00:00.070)       0:07:44.771 ********

TASK [container-engine/validate-container-engine : Ensure kubelet systemd unit exists] *********************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:25:59 -0500 (0:00:01.639)       0:07:46.410 ********

TASK [container-engine/validate-container-engine : Populate service facts] *********************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:26:14 -0500 (0:00:14.412)       0:08:00.822 ********

TASK [container-engine/validate-container-engine : Check if containerd is installed] ***********************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:26:16 -0500 (0:00:02.844)       0:08:03.667 ********

TASK [container-engine/validate-container-engine : Check if docker is installed] ***************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:26:19 -0500 (0:00:02.071)       0:08:05.739 ********

TASK [container-engine/validate-container-engine : Check if crio is installed] *****************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:26:21 -0500 (0:00:02.341)       0:08:08.080 ********
Sunday 08 January 2023  08:26:21 -0500 (0:00:00.050)       0:08:08.131 ********
Sunday 08 January 2023  08:26:21 -0500 (0:00:00.054)       0:08:08.185 ********
Sunday 08 January 2023  08:26:21 -0500 (0:00:00.052)       0:08:08.237 ********
Sunday 08 January 2023  08:26:21 -0500 (0:00:00.053)       0:08:08.291 ********
Sunday 08 January 2023  08:26:21 -0500 (0:00:00.180)       0:08:08.471 ********
Sunday 08 January 2023  08:26:21 -0500 (0:00:00.055)       0:08:08.527 ********
Sunday 08 January 2023  08:26:21 -0500 (0:00:00.052)       0:08:08.579 ********
Sunday 08 January 2023  08:26:21 -0500 (0:00:00.053)       0:08:08.633 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.166)       0:08:08.800 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.051)       0:08:08.851 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.081)       0:08:08.932 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.082)       0:08:09.015 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.055)       0:08:09.071 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.056)       0:08:09.128 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.049)       0:08:09.178 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.083)       0:08:09.261 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.052)       0:08:09.313 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.058)       0:08:09.372 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.055)       0:08:09.427 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.107)       0:08:09.535 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.056)       0:08:09.591 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.053)       0:08:09.645 ********
Sunday 08 January 2023  08:26:22 -0500 (0:00:00.045)       0:08:09.698 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.055)       0:08:09.753 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.099)       0:08:09.853 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.057)       0:08:09.910 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.052)       0:08:09.963 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.047)       0:08:10.010 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.046)       0:08:10.056 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.053)       0:08:10.109 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.081)       0:08:10.191 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.054)       0:08:10.245 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.052)       0:08:10.298 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.056)       0:08:10.355 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.054)       0:08:10.409 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.151)       0:08:10.560 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.055)       0:08:10.616 ********
Sunday 08 January 2023  08:26:23 -0500 (0:00:00.057)       0:08:10.674 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.059)       0:08:10.733 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.053)       0:08:10.786 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.055)       0:08:10.842 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.099)       0:08:10.941 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.081)       0:08:11.023 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.055)       0:08:11.078 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.049)       0:08:11.128 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.082)       0:08:11.211 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.054)       0:08:11.266 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.055)       0:08:11.321 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.049)       0:08:11.380 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.056)       0:08:11.436 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.060)       0:08:11.497 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.093)       0:08:11.591 ********
Sunday 08 January 2023  08:26:24 -0500 (0:00:00.057)       0:08:11.649 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.057)       0:08:11.706 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.055)       0:08:11.762 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.053)       0:08:11.816 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.051)       0:08:11.899 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.054)       0:08:11.954 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.054)       0:08:12.009 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.053)       0:08:12.062 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.049)       0:08:12.111 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.052)       0:08:12.170 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.057)       0:08:12.227 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.061)       0:08:12.288 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.052)       0:08:12.341 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.068)       0:08:12.410 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.054)       0:08:12.465 ********
Sunday 08 January 2023  08:26:25 -0500 (0:00:00.188)       0:08:12.654 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.050)       0:08:12.704 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.049)       0:08:12.754 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.050)       0:08:12.804 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.051)       0:08:12.856 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.054)       0:08:12.910 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.060)       0:08:12.971 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.075)       0:08:13.046 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.052)       0:08:13.098 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.050)       0:08:13.148 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.085)       0:08:13.234 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.048)       0:08:13.287 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.080)       0:08:13.367 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.054)       0:08:13.422 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.079)       0:08:13.501 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.082)       0:08:13.584 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.046)       0:08:13.635 ********
Sunday 08 January 2023  08:26:26 -0500 (0:00:00.049)       0:08:13.685 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.050)       0:08:13.736 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.054)       0:08:13.790 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.047)       0:08:13.838 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.077)       0:08:13.915 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.046)       0:08:13.961 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.047)       0:08:14.009 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.045)       0:08:14.055 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.050)       0:08:14.106 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.078)       0:08:14.184 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.050)       0:08:14.235 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.047)       0:08:14.283 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.050)       0:08:14.334 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.052)       0:08:14.386 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.048)       0:08:14.434 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.119)       0:08:14.554 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.045)       0:08:14.600 ********
Sunday 08 January 2023  08:26:27 -0500 (0:00:00.056)       0:08:14.656 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.051)       0:08:14.708 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.052)       0:08:14.760 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.049)       0:08:14.810 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.047)       0:08:14.858 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.051)       0:08:14.909 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.049)       0:08:14.958 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.052)       0:08:15.011 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.054)       0:08:15.065 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.049)       0:08:15.114 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.054)       0:08:15.169 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.056)       0:08:15.226 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.065)       0:08:15.292 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.062)       0:08:15.355 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.046)       0:08:15.401 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.053)       0:08:15.455 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.048)       0:08:15.503 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.065)       0:08:15.568 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.048)       0:08:15.617 ********
Sunday 08 January 2023  08:26:28 -0500 (0:00:00.049)       0:08:15.666 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.064)       0:08:15.731 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.047)       0:08:15.778 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.049)       0:08:15.828 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.052)       0:08:15.880 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.050)       0:08:15.931 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.057)       0:08:15.988 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.050)       0:08:16.039 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.049)       0:08:16.088 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.043)       0:08:16.132 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.051)       0:08:16.183 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.051)       0:08:16.235 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.064)       0:08:16.299 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.048)       0:08:16.348 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.049)       0:08:16.397 ********
Sunday 08 January 2023  08:26:29 -0500 (0:00:00.080)       0:08:16.478 ********

TASK [container-engine/containerd-common : containerd-common | check if fedora coreos] *********************************
ok: [node4]
ok: [node3]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:26:31 -0500 (0:00:01.834)       0:08:18.312 ********

TASK [container-engine/containerd-common : containerd-common | set is_ostree] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:26:31 -0500 (0:00:00.060)       0:08:18.373 ********

TASK [container-engine/containerd-common : containerd-common | gather os specific variables] ***************************
ok: [node1] => (item=/root/13.4/kubespray/roles/container-engine/containerd/vars/../vars/debian.yml)
ok: [node2] => (item=/root/13.4/kubespray/roles/container-engine/containerd/vars/../vars/debian.yml)
ok: [node3] => (item=/root/13.4/kubespray/roles/container-engine/containerd/vars/../vars/debian.yml)
ok: [node4] => (item=/root/13.4/kubespray/roles/container-engine/containerd/vars/../vars/debian.yml)
Sunday 08 January 2023  08:26:31 -0500 (0:00:00.109)       0:08:18.482 ********

TASK [container-engine/runc : runc | check if fedora coreos] ***********************************************************
ok: [node3]
ok: [node1]
ok: [node4]
ok: [node2]
Sunday 08 January 2023  08:26:33 -0500 (0:00:01.375)       0:08:19.858 ********

TASK [container-engine/runc : runc | set is_ostree] ********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:26:33 -0500 (0:00:00.060)       0:08:19.919 ********

TASK [container-engine/runc : runc | Uninstall runc package managed by package manager] ********************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:26:36 -0500 (0:00:03.625)       0:08:23.544 ********

TASK [container-engine/runc : runc | Download runc binary] *************************************************************
included: /root/13.4/kubespray/roles/container-engine/runc/tasks/../../../download/tasks/download_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:26:36 -0500 (0:00:00.092)       0:08:23.637 ********

TASK [container-engine/runc : prep_download | Set a few facts] *********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:26:37 -0500 (0:00:00.070)       0:08:23.708 ********

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
Sunday 08 January 2023  08:26:37 -0500 (0:00:00.304)       0:08:24.012 ********

TASK [container-engine/runc : download_file | Set pathname of cached file] *********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:26:37 -0500 (0:00:00.328)       0:08:24.340 ********

TASK [container-engine/runc : download_file | Create dest directory on node] *******************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Sunday 08 January 2023  08:26:39 -0500 (0:00:01.900)       0:08:26.240 ********
Sunday 08 January 2023  08:26:39 -0500 (0:00:00.032)       0:08:26.273 ********
Sunday 08 January 2023  08:26:39 -0500 (0:00:00.266)       0:08:26.540 ********

TASK [container-engine/runc : download_file | Validate mirrors] ********************************************************
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:26:43 -0500 (0:00:03.620)       0:08:30.160 ********

TASK [container-engine/runc : download_file | Get the list of working mirrors] *****************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:26:43 -0500 (0:00:00.107)       0:08:30.268 ********

TASK [container-engine/runc : download_file | Download item] ***********************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:26:49 -0500 (0:00:05.633)       0:08:35.901 ********
Sunday 08 January 2023  08:26:49 -0500 (0:00:00.058)       0:08:35.959 ********
Sunday 08 January 2023  08:26:49 -0500 (0:00:00.131)       0:08:36.091 ********
Sunday 08 January 2023  08:26:49 -0500 (0:00:00.053)       0:08:36.145 ********

TASK [container-engine/runc : download_file | Extract file archives] ***************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:26:49 -0500 (0:00:00.108)       0:08:36.253 ********
Sunday 08 January 2023  08:26:49 -0500 (0:00:00.312)       0:08:36.565 ********

TASK [container-engine/runc : Copy runc binary from download dir] ******************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:26:52 -0500 (0:00:02.461)       0:08:39.030 ********

TASK [container-engine/runc : runc | Remove orphaned binary] ***********************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:26:54 -0500 (0:00:02.450)       0:08:41.481 ********

TASK [container-engine/crictl : install crictĺ] ************************************************************************
included: /root/13.4/kubespray/roles/container-engine/crictl/tasks/crictl.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:26:54 -0500 (0:00:00.092)       0:08:41.573 ********

TASK [container-engine/crictl : crictl | Download crictl] **************************************************************
included: /root/13.4/kubespray/roles/container-engine/crictl/tasks/../../../download/tasks/download_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:26:54 -0500 (0:00:00.106)       0:08:41.679 ********

TASK [container-engine/crictl : prep_download | Set a few facts] *******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:26:55 -0500 (0:00:00.068)       0:08:41.748 ********

TASK [container-engine/crictl : download_file | Starting download of file] *********************************************
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
Sunday 08 January 2023  08:26:55 -0500 (0:00:00.314)       0:08:42.062 ********

TASK [container-engine/crictl : download_file | Set pathname of cached file] *******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:26:55 -0500 (0:00:00.320)       0:08:42.383 ********

TASK [container-engine/crictl : download_file | Create dest directory on node] *****************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:26:57 -0500 (0:00:02.152)       0:08:44.535 ********
Sunday 08 January 2023  08:26:57 -0500 (0:00:00.039)       0:08:44.574 ********
Sunday 08 January 2023  08:26:58 -0500 (0:00:00.283)       0:08:44.858 ********

TASK [container-engine/crictl : download_file | Validate mirrors] ******************************************************
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:27:02 -0500 (0:00:04.085)       0:08:48.957 ********

TASK [container-engine/crictl : download_file | Get the list of working mirrors] ***************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:27:02 -0500 (0:00:00.109)       0:08:49.067 ********

TASK [container-engine/crictl : download_file | Download item] *********************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:27:07 -0500 (0:00:05.467)       0:08:54.535 ********
Sunday 08 January 2023  08:27:07 -0500 (0:00:00.058)       0:08:54.593 ********
Sunday 08 January 2023  08:27:07 -0500 (0:00:00.053)       0:08:54.652 ********
Sunday 08 January 2023  08:27:08 -0500 (0:00:00.065)       0:08:54.717 ********

TASK [container-engine/crictl : download_file | Extract file archives] *************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:27:08 -0500 (0:00:00.107)       0:08:54.825 ********

TASK [container-engine/crictl : extract_file | Unpacking archive] ******************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:27:23 -0500 (0:00:15.194)       0:09:10.021 ********

TASK [container-engine/crictl : Install crictl config] *****************************************************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  08:27:27 -0500 (0:00:03.963)       0:09:13.985 ********

TASK [container-engine/crictl : Copy crictl binary from download dir] **************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Sunday 08 January 2023  08:27:29 -0500 (0:00:02.107)       0:09:16.092 ********

TASK [container-engine/nerdctl : nerdctl | Download nerdctl] ***********************************************************
included: /root/13.4/kubespray/roles/container-engine/nerdctl/tasks/../../../download/tasks/download_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:27:29 -0500 (0:00:00.094)       0:09:16.186 ********

TASK [container-engine/nerdctl : prep_download | Set a few facts] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:27:29 -0500 (0:00:00.060)       0:09:16.246 ********

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
Sunday 08 January 2023  08:27:29 -0500 (0:00:00.322)       0:09:16.569 ********

TASK [container-engine/nerdctl : download_file | Set pathname of cached file] ******************************************
ok: [node1]
ok: [node2]
ok: [node4]
ok: [node3]
Sunday 08 January 2023  08:27:30 -0500 (0:00:00.309)       0:09:16.878 ********

TASK [container-engine/nerdctl : download_file | Create dest directory on node] ****************************************
ok: [node4]
ok: [node1]
ok: [node2]
ok: [node3]
Sunday 08 January 2023  08:27:32 -0500 (0:00:01.872)       0:09:18.752 ********
Sunday 08 January 2023  08:27:32 -0500 (0:00:00.031)       0:09:18.784 ********
Sunday 08 January 2023  08:27:32 -0500 (0:00:00.264)       0:09:19.048 ********

TASK [container-engine/nerdctl : download_file | Validate mirrors] *****************************************************
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:27:36 -0500 (0:00:03.663)       0:09:22.712 ********

TASK [container-engine/nerdctl : download_file | Get the list of working mirrors] **************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:27:36 -0500 (0:00:00.184)       0:09:22.896 ********

TASK [container-engine/nerdctl : download_file | Download item] ********************************************************
changed: [node4]
changed: [node3]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:27:39 -0500 (0:00:03.405)       0:09:26.302 ********
Sunday 08 January 2023  08:27:39 -0500 (0:00:00.057)       0:09:26.360 ********
Sunday 08 January 2023  08:27:39 -0500 (0:00:00.055)       0:09:26.415 ********
Sunday 08 January 2023  08:27:39 -0500 (0:00:00.057)       0:09:26.473 ********

TASK [container-engine/nerdctl : download_file | Extract file archives] ************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:27:39 -0500 (0:00:00.086)       0:09:26.573 ********

TASK [container-engine/nerdctl : extract_file | Unpacking archive] *****************************************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  08:27:47 -0500 (0:00:07.965)       0:09:34.538 ********

TASK [container-engine/nerdctl : nerdctl | Copy nerdctl binary from download dir] **************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:27:49 -0500 (0:00:02.070)       0:09:36.608 ********

TASK [container-engine/nerdctl : nerdctl | Create configuration dir] ***************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Sunday 08 January 2023  08:27:51 -0500 (0:00:01.540)       0:09:38.149 ********

TASK [container-engine/nerdctl : nerdctl | Install nerdctl configuration] **********************************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  08:27:55 -0500 (0:00:03.847)       0:09:41.997 ********
Sunday 08 January 2023  08:27:55 -0500 (0:00:00.053)       0:09:42.050 ********

TASK [container-engine/containerd : containerd | Remove any package manager controlled containerd package] *************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:27:58 -0500 (0:00:03.435)       0:09:45.485 ********
Sunday 08 January 2023  08:27:58 -0500 (0:00:00.049)       0:09:45.535 ********

TASK [container-engine/containerd : containerd | Remove containerd repository] *****************************************
ok: [node3] => (item=deb https://download.docker.com/linux/debian bullseye stable
)
ok: [node4] => (item=deb https://download.docker.com/linux/debian bullseye stable
)
ok: [node1] => (item=deb https://download.docker.com/linux/debian bullseye stable
)
ok: [node2] => (item=deb https://download.docker.com/linux/debian bullseye stable
)
Sunday 08 January 2023  08:28:02 -0500 (0:00:03.344)       0:09:48.879 ********

TASK [container-engine/containerd : containerd | Download containerd] **************************************************
included: /root/13.4/kubespray/roles/container-engine/containerd/tasks/../../../download/tasks/download_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:28:02 -0500 (0:00:00.095)       0:09:48.974 ********

TASK [container-engine/containerd : prep_download | Set a few facts] ***************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:28:02 -0500 (0:00:00.064)       0:09:49.039 ********

TASK [container-engine/containerd : download_file | Starting download of file] *****************************************
ok: [node1] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz"
}
ok: [node2] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz"
}
ok: [node3] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz"
}
ok: [node4] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz"
}
Sunday 08 January 2023  08:28:02 -0500 (0:00:00.323)       0:09:49.362 ********

TASK [container-engine/containerd : download_file | Set pathname of cached file] ***************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:28:02 -0500 (0:00:00.311)       0:09:49.673 ********

TASK [container-engine/containerd : download_file | Create dest directory on node] *************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:28:04 -0500 (0:00:01.961)       0:09:51.635 ********
Sunday 08 January 2023  08:28:04 -0500 (0:00:00.032)       0:09:51.668 ********
Sunday 08 January 2023  08:28:05 -0500 (0:00:00.340)       0:09:52.008 ********

TASK [container-engine/containerd : download_file | Validate mirrors] **************************************************
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:28:08 -0500 (0:00:03.152)       0:09:55.160 ********

TASK [container-engine/containerd : download_file | Get the list of working mirrors] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:28:08 -0500 (0:00:00.105)       0:09:55.266 ********

TASK [container-engine/containerd : download_file | Download item] *****************************************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  08:28:23 -0500 (0:00:14.855)       0:10:10.121 ********
Sunday 08 January 2023  08:28:23 -0500 (0:00:00.057)       0:10:10.179 ********
Sunday 08 January 2023  08:28:23 -0500 (0:00:00.054)       0:10:10.234 ********
Sunday 08 January 2023  08:28:23 -0500 (0:00:00.054)       0:10:10.288 ********

TASK [container-engine/containerd : download_file | Extract file archives] *********************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:28:23 -0500 (0:00:00.101)       0:10:10.390 ********
Sunday 08 January 2023  08:28:24 -0500 (0:00:00.305)       0:10:10.696 ********

TASK [container-engine/containerd : containerd | Unpack containerd archive] ********************************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  08:28:47 -0500 (0:00:23.868)       0:10:34.565 ********

TASK [container-engine/containerd : containerd | Remove orphaned binary] ***********************************************
ok: [node3] => (item=containerd)
ok: [node4] => (item=containerd)
ok: [node1] => (item=containerd)
ok: [node2] => (item=containerd)
ok: [node3] => (item=containerd-shim)
ok: [node4] => (item=containerd-shim)
ok: [node3] => (item=containerd-shim-runc-v1)
ok: [node1] => (item=containerd-shim)
ok: [node2] => (item=containerd-shim)
ok: [node4] => (item=containerd-shim-runc-v1)
ok: [node3] => (item=containerd-shim-runc-v2)
ok: [node1] => (item=containerd-shim-runc-v1)
ok: [node2] => (item=containerd-shim-runc-v1)
ok: [node4] => (item=containerd-shim-runc-v2)
ok: [node3] => (item=ctr)
ok: [node1] => (item=containerd-shim-runc-v2)
ok: [node2] => (item=containerd-shim-runc-v2)
ok: [node4] => (item=ctr)
ok: [node1] => (item=ctr)
ok: [node2] => (item=ctr)
Sunday 08 January 2023  08:28:54 -0500 (0:00:07.086)       0:10:41.651 ********

TASK [container-engine/containerd : containerd | Generate systemd service for containerd] ******************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  08:28:57 -0500 (0:00:02.818)       0:10:44.470 ********

TASK [container-engine/containerd : containerd | Ensure containerd directories exist] **********************************
changed: [node3] => (item=/etc/systemd/system/containerd.service.d)
changed: [node2] => (item=/etc/systemd/system/containerd.service.d)
changed: [node4] => (item=/etc/systemd/system/containerd.service.d)
changed: [node1] => (item=/etc/systemd/system/containerd.service.d)
changed: [node3] => (item=/etc/containerd)
changed: [node2] => (item=/etc/containerd)
changed: [node1] => (item=/etc/containerd)
changed: [node4] => (item=/etc/containerd)
changed: [node3] => (item=/var/lib/containerd)
changed: [node2] => (item=/var/lib/containerd)
changed: [node4] => (item=/var/lib/containerd)
changed: [node3] => (item=/run/containerd)
changed: [node1] => (item=/var/lib/containerd)
changed: [node2] => (item=/run/containerd)
changed: [node4] => (item=/run/containerd)
changed: [node1] => (item=/run/containerd)
Sunday 08 January 2023  08:29:05 -0500 (0:00:07.692)       0:10:52.163 ********
Sunday 08 January 2023  08:29:05 -0500 (0:00:00.054)       0:10:52.217 ********

TASK [container-engine/containerd : containerd | Generate default base_runtime_spec] ***********************************
ok: [node3]
ok: [node2]
ok: [node1]
ok: [node4]
Sunday 08 January 2023  08:29:07 -0500 (0:00:02.039)       0:10:54.257 ********

TASK [container-engine/containerd : containerd | Store generated default base_runtime_spec] ****************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:29:07 -0500 (0:00:00.056)       0:10:54.314 ********

TASK [container-engine/containerd : containerd | Write base_runtime_specs] *********************************************
changed: [node4] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.0.2-dev', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
changed: [node3] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.0.2-dev', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
changed: [node2] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.0.2-dev', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
changed: [node1] => (item={'key': 'cri-base.json', 'value': {'ociVersion': '1.0.2-dev', 'process': {'user': {'uid': 0, 'gid': 0}, 'cwd': '/', 'capabilities': {'bounding': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'effective': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE'], 'permitted': ['CAP_CHOWN', 'CAP_DAC_OVERRIDE', 'CAP_FSETID', 'CAP_FOWNER', 'CAP_MKNOD', 'CAP_NET_RAW', 'CAP_SETGID', 'CAP_SETUID', 'CAP_SETFCAP', 'CAP_SETPCAP', 'CAP_NET_BIND_SERVICE', 'CAP_SYS_CHROOT', 'CAP_KILL', 'CAP_AUDIT_WRITE']}, 'rlimits': [{'type': 'RLIMIT_NOFILE', 'hard': 65535, 'soft': 65535}], 'noNewPrivileges': True}, 'root': {'path': 'rootfs'}, 'mounts': [{'destination': '/proc', 'type': 'proc', 'source': 'proc', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/dev', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}, {'destination': '/dev/pts', 'type': 'devpts', 'source': 'devpts', 'options': ['nosuid', 'noexec', 'newinstance', 'ptmxmode=0666', 'mode=0620', 'gid=5']}, {'destination': '/dev/shm', 'type': 'tmpfs', 'source': 'shm', 'options': ['nosuid', 'noexec', 'nodev', 'mode=1777', 'size=65536k']}, {'destination': '/dev/mqueue', 'type': 'mqueue', 'source': 'mqueue', 'options': ['nosuid', 'noexec', 'nodev']}, {'destination': '/sys', 'type': 'sysfs', 'source': 'sysfs', 'options': ['nosuid', 'noexec', 'nodev', 'ro']}, {'destination': '/run', 'type': 'tmpfs', 'source': 'tmpfs', 'options': ['nosuid', 'strictatime', 'mode=755', 'size=65536k']}], 'linux': {'resources': {'devices': [{'allow': False, 'access': 'rwm'}]}, 'cgroupsPath': '/default', 'namespaces': [{'type': 'pid'}, {'type': 'ipc'}, {'type': 'uts'}, {'type': 'mount'}, {'type': 'network'}], 'maskedPaths': ['/proc/acpi', '/proc/asound', '/proc/kcore', '/proc/keys', '/proc/latency_stats', '/proc/timer_list', '/proc/timer_stats', '/proc/sched_debug', '/sys/firmware', '/proc/scsi'], 'readonlyPaths': ['/proc/bus', '/proc/fs', '/proc/irq', '/proc/sys', '/proc/sysrq-trigger']}}})
Sunday 08 January 2023  08:29:11 -0500 (0:00:03.630)       0:10:57.944 ********

TASK [container-engine/containerd : containerd | Copy containerd config file] ******************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:29:14 -0500 (0:00:02.961)       0:11:00.906 ********
[WARNING]: flush_handlers task does not support when conditional
Sunday 08 January 2023  08:29:14 -0500 (0:00:00.000)       0:11:00.906 ********
Sunday 08 January 2023  08:29:14 -0500 (0:00:00.050)       0:11:00.956 ********
Sunday 08 January 2023  08:29:14 -0500 (0:00:00.050)       0:11:01.006 ********
Sunday 08 January 2023  08:29:14 -0500 (0:00:00.048)       0:11:01.055 ********
Sunday 08 January 2023  08:29:14 -0500 (0:00:00.048)       0:11:01.104 ********

RUNNING HANDLER [container-engine/containerd : restart containerd] *****************************************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  08:29:16 -0500 (0:00:01.932)       0:11:03.037 ********

RUNNING HANDLER [container-engine/containerd : Containerd | restart containerd] ****************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:29:22 -0500 (0:00:06.161)       0:11:09.198 ********

RUNNING HANDLER [container-engine/containerd : Containerd | wait for containerd] ***************************************
changed: [node4]
changed: [node3]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  08:29:24 -0500 (0:00:01.852)       0:11:11.051 ********

TASK [container-engine/containerd : containerd | Ensure containerd is started and enabled] *****************************
ok: [node4]
ok: [node3]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:29:27 -0500 (0:00:03.266)       0:11:14.317 ********
Sunday 08 January 2023  08:29:27 -0500 (0:00:00.053)       0:11:14.370 ********
Sunday 08 January 2023  08:29:27 -0500 (0:00:00.048)       0:11:14.419 ********
Sunday 08 January 2023  08:29:27 -0500 (0:00:00.098)       0:11:14.518 ********
Sunday 08 January 2023  08:29:27 -0500 (0:00:00.063)       0:11:14.581 ********
Sunday 08 January 2023  08:29:27 -0500 (0:00:00.048)       0:11:14.630 ********
Sunday 08 January 2023  08:29:27 -0500 (0:00:00.047)       0:11:14.677 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.049)       0:11:14.730 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.052)       0:11:14.782 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.082)       0:11:14.865 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.054)       0:11:14.919 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.080)       0:11:14.999 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.052)       0:11:15.052 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.066)       0:11:15.119 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.048)       0:11:15.167 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.051)       0:11:15.218 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.050)       0:11:15.269 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.048)       0:11:15.317 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.130)       0:11:15.448 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.046)       0:11:15.497 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.056)       0:11:15.554 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.053)       0:11:15.608 ********
Sunday 08 January 2023  08:29:28 -0500 (0:00:00.049)       0:11:15.657 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.054)       0:11:15.712 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.061)       0:11:15.773 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.056)       0:11:15.830 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.066)       0:11:15.896 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.050)       0:11:15.946 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.008)       0:11:15.955 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.045)       0:11:16.000 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.050)       0:11:16.050 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.050)       0:11:16.101 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.051)       0:11:16.152 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.049)       0:11:16.202 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.048)       0:11:16.250 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.046)       0:11:16.297 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.050)       0:11:16.347 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.047)       0:11:16.395 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.011)       0:11:16.406 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.072)       0:11:16.488 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.058)       0:11:16.546 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.049)       0:11:16.596 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.062)       0:11:16.658 ********
Sunday 08 January 2023  08:29:29 -0500 (0:00:00.070)       0:11:16.729 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:29:30 -0500 (0:00:00.059)       0:11:16.789 ********
Sunday 08 January 2023  08:29:30 -0500 (0:00:00.024)       0:11:16.813 ********
Sunday 08 January 2023  08:29:30 -0500 (0:00:00.019)       0:11:16.833 ********
Sunday 08 January 2023  08:29:30 -0500 (0:00:00.052)       0:11:16.885 ********
Sunday 08 January 2023  08:29:30 -0500 (0:00:00.053)       0:11:16.939 ********

TASK [download : prep_download | Register docker images info] **********************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:29:32 -0500 (0:00:01.976)       0:11:18.915 ********

TASK [download : prep_download | Create staging directory on remote node] **********************************************
changed: [node3]
changed: [node1]
changed: [node2]
changed: [node4]
Sunday 08 January 2023  08:29:34 -0500 (0:00:01.777)       0:11:20.693 ********
Sunday 08 January 2023  08:29:34 -0500 (0:00:00.021)       0:11:20.714 ********

TASK [download : download | Get kubeadm binary and list of required images] ********************************************
included: /root/13.4/kubespray/roles/download/tasks/prep_kubeadm_images.yml for node1
Sunday 08 January 2023  08:29:34 -0500 (0:00:00.079)       0:11:20.794 ********
Sunday 08 January 2023  08:29:34 -0500 (0:00:00.256)       0:11:21.051 ********

TASK [download : prep_kubeadm_images | Download kubeadm binary] ********************************************************
included: /root/13.4/kubespray/roles/download/tasks/download_file.yml for node1
Sunday 08 January 2023  08:29:34 -0500 (0:00:00.365)       0:11:21.416 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
Sunday 08 January 2023  08:29:34 -0500 (0:00:00.036)       0:11:21.453 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubeadm"
}
Sunday 08 January 2023  08:29:35 -0500 (0:00:00.261)       0:11:21.715 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
Sunday 08 January 2023  08:29:35 -0500 (0:00:00.264)       0:11:21.979 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
changed: [node1]
Sunday 08 January 2023  08:29:38 -0500 (0:00:03.567)       0:11:25.547 ********
Sunday 08 January 2023  08:29:38 -0500 (0:00:00.028)       0:11:25.575 ********
Sunday 08 January 2023  08:29:39 -0500 (0:00:00.268)       0:11:25.844 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:29:43 -0500 (0:00:04.489)       0:11:30.334 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
Sunday 08 January 2023  08:29:43 -0500 (0:00:00.041)       0:11:30.376 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node1]
Sunday 08 January 2023  08:30:06 -0500 (0:00:23.234)       0:11:53.610 ********
Sunday 08 January 2023  08:30:06 -0500 (0:00:00.034)       0:11:53.644 ********
Sunday 08 January 2023  08:30:06 -0500 (0:00:00.031)       0:11:53.676 ********
Sunday 08 January 2023  08:30:07 -0500 (0:00:00.036)       0:11:53.712 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1
Sunday 08 January 2023  08:30:07 -0500 (0:00:00.051)       0:11:53.763 ********
Sunday 08 January 2023  08:30:07 -0500 (0:00:00.251)       0:11:54.015 ********
[WARNING]: noop task does not support when conditional

TASK [download : prep_kubeadm_images | Create kubeadm config] **********************************************************
changed: [node1]
Sunday 08 January 2023  08:30:13 -0500 (0:00:06.066)       0:12:00.082 ********

TASK [download : prep_kubeadm_images | Copy kubeadm binary from download dir to system path] ***************************
changed: [node1]
Sunday 08 January 2023  08:30:18 -0500 (0:00:04.829)       0:12:04.911 ********

TASK [download : prep_kubeadm_images | Set kubeadm binary permissions] *************************************************
ok: [node1]
Sunday 08 January 2023  08:30:21 -0500 (0:00:03.418)       0:12:08.330 ********

TASK [download : prep_kubeadm_images | Generate list of required images] ***********************************************
ok: [node1]
Sunday 08 January 2023  08:30:25 -0500 (0:00:03.469)       0:12:11.799 ********

TASK [download : prep_kubeadm_images | Parse list of images] ***********************************************************
ok: [node1] => (item=registry.k8s.io/kube-apiserver:v1.25.5)
ok: [node1] => (item=registry.k8s.io/kube-controller-manager:v1.25.5)
ok: [node1] => (item=registry.k8s.io/kube-scheduler:v1.25.5)
ok: [node1] => (item=registry.k8s.io/kube-proxy:v1.25.5)
Sunday 08 January 2023  08:30:25 -0500 (0:00:00.066)       0:12:11.865 ********

TASK [download : prep_kubeadm_images | Convert list of images to dict for later use] ***********************************
ok: [node1]
Sunday 08 January 2023  08:30:25 -0500 (0:00:00.028)       0:12:11.894 ********

TASK [download : download | Download files / images] *******************************************************************
included: /root/13.4/kubespray/roles/download/tasks/download_file.yml for node1 => (item={'key': 'etcd', 'value': {'container': False, 'file': True, 'enabled': True, 'version': 'v3.5.6', 'dest': '/tmp/releases/etcd-v3.5.6-linux-amd64.tar.gz', 'repo': 'quay.io/coreos/etcd', 'tag': 'v3.5.6', 'sha256': '4db32e3bc06dd0999e2171f76a87c1cffed8369475ec7aa7abee9023635670fb', 'url': 'https://github.com/etcd-io/etcd/releases/download/v3.5.6/etcd-v3.5.6-linux-amd64.tar.gz', 'unarchive': True, 'owner': 'root', 'mode': '0755', 'groups': ['etcd']}})
included: /root/13.4/kubespray/roles/download/tasks/download_file.yml for node1, node4, node3, node2 => (item={'key': 'cni', 'value': {'enabled': True, 'file': True, 'version': 'v1.1.1', 'dest': '/tmp/releases/cni-plugins-linux-amd64-v1.1.1.tgz', 'sha256': 'b275772da4026d2161bf8a8b41ed4786754c8a93ebfb6564006d5da7f23831e5', 'url': 'https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_file.yml for node1, node4, node3, node2 => (item={'key': 'kubeadm', 'value': {'enabled': True, 'file': True, 'version': 'v1.25.5', 'dest': '/tmp/releases/kubeadm-v1.25.5-amd64', 'sha256': 'af0b25c7a995c2d208ef0b9d24b70fe6f390ebb1e3987f4e0f548854ba9a3b87', 'url': 'https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubeadm', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_file.yml for node1, node4, node3, node2 => (item={'key': 'kubelet', 'value': {'enabled': True, 'file': True, 'version': 'v1.25.5', 'dest': '/tmp/releases/kubelet-v1.25.5-amd64', 'sha256': '16b23e1254830805b892cfccf2687eb3edb4ea54ffbadb8cc2eee6d3b1fab8e6', 'url': 'https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubelet', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_file.yml for node1 => (item={'key': 'kubectl', 'value': {'enabled': True, 'file': True, 'version': 'v1.25.5', 'dest': '/tmp/releases/kubectl-v1.25.5-amd64', 'sha256': '6a660cd44db3d4bfe1563f6689cbe2ffb28ee4baf3532e04fff2d7b909081c29', 'url': 'https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubectl', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['kube_control_plane']}})
included: /root/13.4/kubespray/roles/download/tasks/download_file.yml for node1, node4, node3, node2 => (item={'key': 'crictl', 'value': {'file': True, 'enabled': True, 'version': 'v1.25.0', 'dest': '/tmp/releases/crictl-v1.25.0-linux-amd64.tar.gz', 'sha256': '86ab210c007f521ac4cdcbcf0ae3fb2e10923e65f16de83e0e1db191a07f0235', 'url': 'https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.25.0/crictl-v1.25.0-linux-amd64.tar.gz', 'unarchive': True, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_file.yml for node1, node4, node3, node2 => (item={'key': 'runc', 'value': {'file': True, 'enabled': True, 'version': 'v1.1.4', 'dest': '/tmp/releases/runc', 'sha256': 'db772be63147a4e747b4fe286c7c16a2edc4a8458bd3092ea46aaee77750e8ce', 'url': 'https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_file.yml for node1, node4, node3, node2 => (item={'key': 'containerd', 'value': {'enabled': True, 'file': True, 'version': '1.6.14', 'dest': '/tmp/releases/containerd-1.6.14-linux-amd64.tar.gz', 'sha256': '7da626d46c4edcae1eefe6d48dc6521db3e594a402715afcddc6ac9e67e1bfcd', 'url': 'https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz', 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_file.yml for node1, node4, node3, node2 => (item={'key': 'nerdctl', 'value': {'file': True, 'enabled': True, 'version': '1.0.0', 'dest': '/tmp/releases/nerdctl-1.0.0-linux-amd64.tar.gz', 'sha256': '3e993d714e6b88d1803a58d9ff5a00d121f0544c35efed3a3789e19d6ab36964', 'url': 'https://github.com/containerd/nerdctl/releases/download/v1.0.0/nerdctl-1.0.0-linux-amd64.tar.gz', 'unarchive': True, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_file.yml for node1, node4, node3, node2 => (item={'key': 'calicoctl', 'value': {'enabled': True, 'file': True, 'version': 'v3.24.5', 'dest': '/tmp/releases/calicoctl', 'sha256': '01e6c8a2371050f9edd0ade9dcde89da054e84d8e96bd4ba8cf82806c8d3e8e7', 'url': 'https://github.com/projectcalico/calico/releases/download/v3.24.5/calicoctl-linux-amd64', 'mirrors': ['https://github.com/projectcalico/calico/releases/download/v3.24.5/calicoctl-linux-amd64'], 'unarchive': False, 'owner': 'root', 'mode': '0755', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_container.yml for node1, node4, node3, node2 => (item={'key': 'calico_node', 'value': {'enabled': True, 'container': True, 'repo': 'quay.io/calico/node', 'tag': 'v3.24.5', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_container.yml for node1, node4, node3, node2 => (item={'key': 'calico_cni', 'value': {'enabled': True, 'container': True, 'repo': 'quay.io/calico/cni', 'tag': 'v3.24.5', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_container.yml for node1, node4, node3, node2 => (item={'key': 'calico_flexvol', 'value': {'enabled': True, 'container': True, 'repo': 'quay.io/calico/pod2daemon-flexvol', 'tag': 'v3.24.5', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_container.yml for node1, node4, node3, node2 => (item={'key': 'calico_policy', 'value': {'enabled': True, 'container': True, 'repo': 'quay.io/calico/kube-controllers', 'tag': 'v3.24.5', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_file.yml for node1 => (item={'key': 'calico_crds', 'value': {'file': True, 'enabled': True, 'version': 'v3.24.5', 'dest': '/tmp/releases/calico-v3.24.5-kdd-crds/v3.24.5.tar.gz', 'sha256': '10320b45ebcf4335703d692adacc96cdd3a27de62b4599238604bd7b0bedccc3', 'url': 'https://github.com/projectcalico/calico/archive/v3.24.5.tar.gz', 'unarchive': True, 'unarchive_extra_opts': ['--strip=3', '--wildcards', '*/libcalico-go/config/crd/'], 'owner': 'root', 'mode': '0755', 'groups': ['kube_control_plane']}})
included: /root/13.4/kubespray/roles/download/tasks/download_container.yml for node1, node4, node3, node2 => (item={'key': 'pod_infra', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/pause', 'tag': '3.7', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_container.yml for node1, node4, node3, node2 => (item={'key': 'coredns', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/coredns/coredns', 'tag': 'v1.9.3', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_container.yml for node1, node4, node3, node2 => (item={'key': 'nodelocaldns', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/dns/k8s-dns-node-cache', 'tag': '1.21.1', 'sha256': '', 'groups': ['k8s_cluster']}})
included: /root/13.4/kubespray/roles/download/tasks/download_container.yml for node1 => (item={'key': 'dnsautoscaler', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/cpa/cluster-proportional-autoscaler-amd64', 'tag': '1.8.5', 'sha256': '', 'groups': ['kube_control_plane']}})
included: /root/13.4/kubespray/roles/download/tasks/download_container.yml for node1, node4, node3, node2 => (item={'key': 'kubeadm_kube-apiserver', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/kube-apiserver', 'tag': 'v1.25.5', 'groups': 'k8s_cluster'}})
included: /root/13.4/kubespray/roles/download/tasks/download_container.yml for node1, node4, node3, node2 => (item={'key': 'kubeadm_kube-controller-manager', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/kube-controller-manager', 'tag': 'v1.25.5', 'groups': 'k8s_cluster'}})
included: /root/13.4/kubespray/roles/download/tasks/download_container.yml for node1, node4, node3, node2 => (item={'key': 'kubeadm_kube-scheduler', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/kube-scheduler', 'tag': 'v1.25.5', 'groups': 'k8s_cluster'}})
included: /root/13.4/kubespray/roles/download/tasks/download_container.yml for node1, node4, node3, node2 => (item={'key': 'kubeadm_kube-proxy', 'value': {'enabled': True, 'container': True, 'repo': 'registry.k8s.io/kube-proxy', 'tag': 'v1.25.5', 'groups': 'k8s_cluster'}})
included: /root/13.4/kubespray/roles/download/tasks/download_container.yml for node4, node3, node2 => (item={'key': 'nginx', 'value': {'enabled': True, 'container': True, 'repo': 'docker.io/library/nginx', 'tag': '1.23.2-alpine', 'sha256': '', 'groups': ['kube_node']}})
Sunday 08 January 2023  08:30:26 -0500 (0:00:01.491)       0:12:13.385 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
Sunday 08 January 2023  08:30:26 -0500 (0:00:00.034)       0:12:13.420 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://github.com/etcd-io/etcd/releases/download/v3.5.6/etcd-v3.5.6-linux-amd64.tar.gz"
}
Sunday 08 January 2023  08:30:26 -0500 (0:00:00.033)       0:12:13.453 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
Sunday 08 January 2023  08:30:26 -0500 (0:00:00.033)       0:12:13.486 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node1]
Sunday 08 January 2023  08:30:29 -0500 (0:00:03.060)       0:12:16.547 ********
Sunday 08 January 2023  08:30:29 -0500 (0:00:00.028)       0:12:16.575 ********
Sunday 08 January 2023  08:30:29 -0500 (0:00:00.031)       0:12:16.606 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:30:35 -0500 (0:00:05.480)       0:12:22.086 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
Sunday 08 January 2023  08:30:35 -0500 (0:00:00.042)       0:12:22.129 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node1]
Sunday 08 January 2023  08:30:46 -0500 (0:00:10.817)       0:12:32.947 ********
Sunday 08 January 2023  08:30:46 -0500 (0:00:00.033)       0:12:32.980 ********
Sunday 08 January 2023  08:30:46 -0500 (0:00:00.031)       0:12:33.012 ********
Sunday 08 January 2023  08:30:46 -0500 (0:00:00.034)       0:12:33.047 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1
Sunday 08 January 2023  08:30:46 -0500 (0:00:00.052)       0:12:33.099 ********

TASK [download : extract_file | Unpacking archive] *********************************************************************
changed: [node1]
Sunday 08 January 2023  08:31:10 -0500 (0:00:24.547)       0:12:57.650 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:31:11 -0500 (0:00:00.064)       0:12:57.714 ********

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
Sunday 08 January 2023  08:31:11 -0500 (0:00:00.063)       0:12:57.778 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:31:11 -0500 (0:00:00.061)       0:12:57.840 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
changed: [node3]
changed: [node4]
ok: [node1]
changed: [node2]
Sunday 08 January 2023  08:31:15 -0500 (0:00:04.699)       0:13:02.540 ********
Sunday 08 January 2023  08:31:15 -0500 (0:00:00.029)       0:13:02.569 ********
Sunday 08 January 2023  08:31:15 -0500 (0:00:00.033)       0:13:02.603 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:31:22 -0500 (0:00:06.607)       0:13:09.210 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:31:22 -0500 (0:00:00.105)       0:13:09.315 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:31:47 -0500 (0:00:25.211)       0:13:34.527 ********
Sunday 08 January 2023  08:31:47 -0500 (0:00:00.052)       0:13:34.579 ********
Sunday 08 January 2023  08:31:47 -0500 (0:00:00.051)       0:13:34.631 ********
Sunday 08 January 2023  08:31:47 -0500 (0:00:00.048)       0:13:34.680 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:31:48 -0500 (0:00:00.107)       0:13:34.788 ********
Sunday 08 January 2023  08:31:48 -0500 (0:00:00.051)       0:13:34.839 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:31:48 -0500 (0:00:00.064)       0:13:34.903 ********

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
Sunday 08 January 2023  08:31:48 -0500 (0:00:00.059)       0:13:34.963 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:31:48 -0500 (0:00:00.063)       0:13:35.027 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:31:52 -0500 (0:00:03.825)       0:13:38.852 ********
Sunday 08 January 2023  08:31:52 -0500 (0:00:00.032)       0:13:38.885 ********
Sunday 08 January 2023  08:31:52 -0500 (0:00:00.036)       0:13:38.922 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:31:57 -0500 (0:00:05.727)       0:13:44.649 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:31:58 -0500 (0:00:00.156)       0:13:44.806 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node3]
ok: [node1]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:32:16 -0500 (0:00:18.514)       0:14:03.320 ********
Sunday 08 January 2023  08:32:16 -0500 (0:00:00.047)       0:14:03.368 ********
Sunday 08 January 2023  08:32:16 -0500 (0:00:00.051)       0:14:03.420 ********
Sunday 08 January 2023  08:32:16 -0500 (0:00:00.049)       0:14:03.469 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:32:16 -0500 (0:00:00.195)       0:14:03.665 ********
Sunday 08 January 2023  08:32:17 -0500 (0:00:00.056)       0:14:03.721 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:32:17 -0500 (0:00:00.058)       0:14:03.779 ********

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
Sunday 08 January 2023  08:32:17 -0500 (0:00:00.062)       0:14:03.841 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:32:17 -0500 (0:00:00.064)       0:14:03.905 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:32:20 -0500 (0:00:03.136)       0:14:07.042 ********
Sunday 08 January 2023  08:32:20 -0500 (0:00:00.030)       0:14:07.073 ********
Sunday 08 January 2023  08:32:20 -0500 (0:00:00.036)       0:14:07.109 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:32:24 -0500 (0:00:04.406)       0:14:11.516 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:32:24 -0500 (0:00:00.100)       0:14:11.617 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:32:44 -0500 (0:00:19.279)       0:14:30.896 ********
Sunday 08 January 2023  08:32:44 -0500 (0:00:00.053)       0:14:30.950 ********
Sunday 08 January 2023  08:32:44 -0500 (0:00:00.046)       0:14:30.996 ********
Sunday 08 January 2023  08:32:44 -0500 (0:00:00.051)       0:14:31.048 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:32:44 -0500 (0:00:00.104)       0:14:31.153 ********
Sunday 08 January 2023  08:32:44 -0500 (0:00:00.050)       0:14:31.206 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
Sunday 08 January 2023  08:32:44 -0500 (0:00:00.035)       0:14:31.241 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://storage.googleapis.com/kubernetes-release/release/v1.25.5/bin/linux/amd64/kubectl"
}
Sunday 08 January 2023  08:32:44 -0500 (0:00:00.033)       0:14:31.275 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
Sunday 08 January 2023  08:32:44 -0500 (0:00:00.033)       0:14:31.308 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node1]
Sunday 08 January 2023  08:32:46 -0500 (0:00:02.138)       0:14:33.450 ********
Sunday 08 January 2023  08:32:46 -0500 (0:00:00.028)       0:14:33.479 ********
Sunday 08 January 2023  08:32:46 -0500 (0:00:00.031)       0:14:33.511 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:32:49 -0500 (0:00:02.467)       0:14:35.978 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
Sunday 08 January 2023  08:32:49 -0500 (0:00:00.044)       0:14:36.023 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node1]
Sunday 08 January 2023  08:32:55 -0500 (0:00:05.945)       0:14:41.969 ********
Sunday 08 January 2023  08:32:55 -0500 (0:00:00.033)       0:14:42.002 ********
Sunday 08 January 2023  08:32:55 -0500 (0:00:00.034)       0:14:42.037 ********
Sunday 08 January 2023  08:32:55 -0500 (0:00:00.034)       0:14:42.072 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1
Sunday 08 January 2023  08:32:55 -0500 (0:00:00.061)       0:14:42.133 ********
Sunday 08 January 2023  08:32:55 -0500 (0:00:00.032)       0:14:42.165 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:32:55 -0500 (0:00:00.065)       0:14:42.231 ********

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
Sunday 08 January 2023  08:32:55 -0500 (0:00:00.065)       0:14:42.296 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:32:55 -0500 (0:00:00.060)       0:14:42.357 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:33:00 -0500 (0:00:04.504)       0:14:46.861 ********
Sunday 08 January 2023  08:33:00 -0500 (0:00:00.028)       0:14:46.889 ********
Sunday 08 January 2023  08:33:00 -0500 (0:00:00.032)       0:14:46.922 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:33:07 -0500 (0:00:07.044)       0:14:53.981 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:33:07 -0500 (0:00:00.101)       0:14:54.082 ********

TASK [download : download_file | Download item] ************************************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:33:12 -0500 (0:00:05.437)       0:14:59.520 ********
Sunday 08 January 2023  08:33:12 -0500 (0:00:00.053)       0:14:59.573 ********
Sunday 08 January 2023  08:33:12 -0500 (0:00:00.052)       0:14:59.626 ********
Sunday 08 January 2023  08:33:12 -0500 (0:00:00.051)       0:14:59.677 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:33:13 -0500 (0:00:00.107)       0:14:59.784 ********

TASK [download : extract_file | Unpacking archive] *********************************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:33:27 -0500 (0:00:14.674)       0:15:14.459 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:33:27 -0500 (0:00:00.060)       0:15:14.519 ********

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
Sunday 08 January 2023  08:33:27 -0500 (0:00:00.060)       0:15:14.579 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:33:27 -0500 (0:00:00.065)       0:15:14.645 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:33:30 -0500 (0:00:02.885)       0:15:17.530 ********
Sunday 08 January 2023  08:33:30 -0500 (0:00:00.028)       0:15:17.558 ********
Sunday 08 January 2023  08:33:30 -0500 (0:00:00.033)       0:15:17.591 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:33:35 -0500 (0:00:04.232)       0:15:21.824 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:33:35 -0500 (0:00:00.101)       0:15:21.926 ********

TASK [download : download_file | Download item] ************************************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:33:38 -0500 (0:00:03.431)       0:15:25.357 ********
Sunday 08 January 2023  08:33:38 -0500 (0:00:00.046)       0:15:25.404 ********
Sunday 08 January 2023  08:33:38 -0500 (0:00:00.049)       0:15:25.454 ********
Sunday 08 January 2023  08:33:38 -0500 (0:00:00.050)       0:15:25.505 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:33:38 -0500 (0:00:00.109)       0:15:25.614 ********
Sunday 08 January 2023  08:33:38 -0500 (0:00:00.048)       0:15:25.667 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:33:39 -0500 (0:00:00.059)       0:15:25.731 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz"
}
ok: [node2] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz"
}
ok: [node3] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz"
}
ok: [node4] => {
    "msg": "https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz"
}
Sunday 08 January 2023  08:33:39 -0500 (0:00:00.057)       0:15:25.788 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:33:39 -0500 (0:00:00.054)       0:15:25.847 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:33:41 -0500 (0:00:02.369)       0:15:28.217 ********
Sunday 08 January 2023  08:33:41 -0500 (0:00:00.027)       0:15:28.246 ********
Sunday 08 January 2023  08:33:41 -0500 (0:00:00.035)       0:15:28.281 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:33:45 -0500 (0:00:03.853)       0:15:32.134 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:33:45 -0500 (0:00:00.092)       0:15:32.233 ********

TASK [download : download_file | Download item] ************************************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:33:50 -0500 (0:00:05.184)       0:15:37.418 ********
Sunday 08 January 2023  08:33:50 -0500 (0:00:00.050)       0:15:37.468 ********
Sunday 08 January 2023  08:33:50 -0500 (0:00:00.050)       0:15:37.519 ********
Sunday 08 January 2023  08:33:50 -0500 (0:00:00.049)       0:15:37.568 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:33:50 -0500 (0:00:00.112)       0:15:37.681 ********
Sunday 08 January 2023  08:33:51 -0500 (0:00:00.056)       0:15:37.737 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:33:51 -0500 (0:00:00.064)       0:15:37.801 ********

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
Sunday 08 January 2023  08:33:51 -0500 (0:00:00.063)       0:15:37.864 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:33:51 -0500 (0:00:00.064)       0:15:37.929 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node3]
ok: [node1]
ok: [node2]
ok: [node4]
Sunday 08 January 2023  08:33:53 -0500 (0:00:02.350)       0:15:40.279 ********
Sunday 08 January 2023  08:33:53 -0500 (0:00:00.027)       0:15:40.307 ********
Sunday 08 January 2023  08:33:53 -0500 (0:00:00.030)       0:15:40.338 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:33:56 -0500 (0:00:03.213)       0:15:43.551 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:33:56 -0500 (0:00:00.104)       0:15:43.656 ********

TASK [download : download_file | Download item] ************************************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:34:00 -0500 (0:00:03.350)       0:15:47.007 ********
Sunday 08 January 2023  08:34:00 -0500 (0:00:00.046)       0:15:47.053 ********
Sunday 08 January 2023  08:34:00 -0500 (0:00:00.048)       0:15:47.102 ********
Sunday 08 January 2023  08:34:00 -0500 (0:00:00.047)       0:15:47.149 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:34:00 -0500 (0:00:00.108)       0:15:47.257 ********

TASK [download : extract_file | Unpacking archive] *********************************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:34:12 -0500 (0:00:12.045)       0:15:59.303 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:34:12 -0500 (0:00:00.061)       0:15:59.365 ********

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
Sunday 08 January 2023  08:34:12 -0500 (0:00:00.064)       0:15:59.429 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:34:12 -0500 (0:00:00.058)       0:15:59.488 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
ok: [node3]
ok: [node1]
ok: [node4]
ok: [node2]
Sunday 08 January 2023  08:34:14 -0500 (0:00:02.160)       0:16:01.649 ********
Sunday 08 January 2023  08:34:15 -0500 (0:00:00.116)       0:16:01.766 ********
Sunday 08 January 2023  08:34:15 -0500 (0:00:00.031)       0:16:01.797 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node3] => (item=None)
ok: [node3 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node4] => (item=None)
ok: [node4 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
ok: [node2] => (item=None)
ok: [node2 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:34:18 -0500 (0:00:03.733)       0:16:05.530 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:34:18 -0500 (0:00:00.106)       0:16:05.636 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node1]
changed: [node3]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:34:32 -0500 (0:00:13.398)       0:16:19.038 ********
Sunday 08 January 2023  08:34:32 -0500 (0:00:00.052)       0:16:19.090 ********
Sunday 08 January 2023  08:34:32 -0500 (0:00:00.049)       0:16:19.139 ********
Sunday 08 January 2023  08:34:32 -0500 (0:00:00.047)       0:16:19.187 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:34:32 -0500 (0:00:00.105)       0:16:19.293 ********
Sunday 08 January 2023  08:34:32 -0500 (0:00:00.052)       0:16:19.345 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:34:32 -0500 (0:00:00.054)       0:16:19.399 ********

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
Sunday 08 January 2023  08:34:32 -0500 (0:00:00.065)       0:16:19.465 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:34:32 -0500 (0:00:00.057)       0:16:19.524 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:34:32 -0500 (0:00:00.069)       0:16:19.594 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:34:32 -0500 (0:00:00.059)       0:16:19.653 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:34:33 -0500 (0:00:00.059)       0:16:19.713 ********
Sunday 08 January 2023  08:34:33 -0500 (0:00:00.053)       0:16:19.766 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:34:33 -0500 (0:00:00.058)       0:16:19.825 ********
Sunday 08 January 2023  08:34:33 -0500 (0:00:00.055)       0:16:19.881 ********
Sunday 08 January 2023  08:34:33 -0500 (0:00:00.053)       0:16:19.934 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:34:33 -0500 (0:00:00.067)       0:16:20.001 ********
Sunday 08 January 2023  08:34:33 -0500 (0:00:00.052)       0:16:20.053 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.4/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:34:33 -0500 (0:00:00.122)       0:16:20.176 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Sunday 08 January 2023  08:34:35 -0500 (0:00:02.021)       0:16:22.197 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:34:35 -0500 (0:00:00.058)       0:16:22.255 ********
Sunday 08 January 2023  08:34:35 -0500 (0:00:00.053)       0:16:22.308 ********

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
Sunday 08 January 2023  08:34:35 -0500 (0:00:00.057)       0:16:22.366 ********
Sunday 08 January 2023  08:34:35 -0500 (0:00:00.059)       0:16:22.425 ********
Sunday 08 January 2023  08:34:35 -0500 (0:00:00.139)       0:16:22.565 ********
Sunday 08 January 2023  08:34:35 -0500 (0:00:00.057)       0:16:22.622 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:35:23 -0500 (0:00:47.400)       0:17:10.022 ********
Sunday 08 January 2023  08:35:23 -0500 (0:00:00.021)       0:17:10.044 ********
Sunday 08 January 2023  08:35:23 -0500 (0:00:00.052)       0:17:10.096 ********
Sunday 08 January 2023  08:35:23 -0500 (0:00:00.052)       0:17:10.148 ********
Sunday 08 January 2023  08:35:23 -0500 (0:00:00.047)       0:17:10.196 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:35:25 -0500 (0:00:02.445)       0:17:12.641 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:35:26 -0500 (0:00:00.063)       0:17:12.705 ********

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
Sunday 08 January 2023  08:35:26 -0500 (0:00:00.062)       0:17:12.768 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:35:26 -0500 (0:00:00.056)       0:17:12.825 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:35:26 -0500 (0:00:00.065)       0:17:12.890 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:35:26 -0500 (0:00:00.060)       0:17:12.951 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:35:26 -0500 (0:00:00.059)       0:17:13.010 ********
Sunday 08 January 2023  08:35:26 -0500 (0:00:00.048)       0:17:13.059 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:35:26 -0500 (0:00:00.060)       0:17:13.120 ********
Sunday 08 January 2023  08:35:26 -0500 (0:00:00.052)       0:17:13.172 ********
Sunday 08 January 2023  08:35:26 -0500 (0:00:00.050)       0:17:13.222 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:35:26 -0500 (0:00:00.067)       0:17:13.289 ********
Sunday 08 January 2023  08:35:26 -0500 (0:00:00.050)       0:17:13.339 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.4/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:35:26 -0500 (0:00:00.124)       0:17:13.464 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Sunday 08 January 2023  08:35:30 -0500 (0:00:03.670)       0:17:17.135 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:35:30 -0500 (0:00:00.061)       0:17:17.196 ********
Sunday 08 January 2023  08:35:30 -0500 (0:00:00.050)       0:17:17.249 ********

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
Sunday 08 January 2023  08:35:30 -0500 (0:00:00.062)       0:17:17.311 ********
Sunday 08 January 2023  08:35:30 -0500 (0:00:00.061)       0:17:17.373 ********
Sunday 08 January 2023  08:35:30 -0500 (0:00:00.057)       0:17:17.431 ********
Sunday 08 January 2023  08:35:30 -0500 (0:00:00.059)       0:17:17.490 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:37:04 -0500 (0:01:33.445)       0:18:50.936 ********
Sunday 08 January 2023  08:37:04 -0500 (0:00:00.024)       0:18:50.961 ********
Sunday 08 January 2023  08:37:04 -0500 (0:00:00.038)       0:18:51.010 ********
Sunday 08 January 2023  08:37:04 -0500 (0:00:00.052)       0:18:51.062 ********
Sunday 08 January 2023  08:37:04 -0500 (0:00:00.052)       0:18:51.114 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:37:09 -0500 (0:00:05.050)       0:18:56.164 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:09 -0500 (0:00:00.055)       0:18:56.219 ********

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
Sunday 08 January 2023  08:37:09 -0500 (0:00:00.059)       0:18:56.282 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:09 -0500 (0:00:00.062)       0:18:56.345 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:09 -0500 (0:00:00.061)       0:18:56.407 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:09 -0500 (0:00:00.060)       0:18:56.471 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:09 -0500 (0:00:00.057)       0:18:56.529 ********
Sunday 08 January 2023  08:37:09 -0500 (0:00:00.053)       0:18:56.582 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:09 -0500 (0:00:00.063)       0:18:56.645 ********
Sunday 08 January 2023  08:37:09 -0500 (0:00:00.053)       0:18:56.699 ********
Sunday 08 January 2023  08:37:10 -0500 (0:00:00.049)       0:18:56.748 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:10 -0500 (0:00:00.060)       0:18:56.809 ********
Sunday 08 January 2023  08:37:10 -0500 (0:00:00.053)       0:18:56.862 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.4/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:37:10 -0500 (0:00:00.130)       0:18:56.992 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:37:14 -0500 (0:00:04.365)       0:19:01.358 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:14 -0500 (0:00:00.067)       0:19:01.426 ********
Sunday 08 January 2023  08:37:14 -0500 (0:00:00.048)       0:19:01.474 ********

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
Sunday 08 January 2023  08:37:14 -0500 (0:00:00.062)       0:19:01.537 ********
Sunday 08 January 2023  08:37:14 -0500 (0:00:00.063)       0:19:01.601 ********
Sunday 08 January 2023  08:37:14 -0500 (0:00:00.049)       0:19:01.650 ********
Sunday 08 January 2023  08:37:15 -0500 (0:00:00.060)       0:19:01.711 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:37:36 -0500 (0:00:21.286)       0:19:22.997 ********
Sunday 08 January 2023  08:37:36 -0500 (0:00:00.022)       0:19:23.020 ********
Sunday 08 January 2023  08:37:36 -0500 (0:00:00.048)       0:19:23.068 ********
Sunday 08 January 2023  08:37:36 -0500 (0:00:00.056)       0:19:23.124 ********
Sunday 08 January 2023  08:37:36 -0500 (0:00:00.042)       0:19:23.173 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:37:39 -0500 (0:00:03.279)       0:19:26.453 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:39 -0500 (0:00:00.060)       0:19:26.513 ********

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
Sunday 08 January 2023  08:37:39 -0500 (0:00:00.064)       0:19:26.577 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:40 -0500 (0:00:00.162)       0:19:26.740 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:40 -0500 (0:00:00.061)       0:19:26.802 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:40 -0500 (0:00:00.063)       0:19:26.866 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:40 -0500 (0:00:00.060)       0:19:26.926 ********
Sunday 08 January 2023  08:37:40 -0500 (0:00:00.053)       0:19:26.980 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:40 -0500 (0:00:00.063)       0:19:27.044 ********
Sunday 08 January 2023  08:37:40 -0500 (0:00:00.051)       0:19:27.095 ********
Sunday 08 January 2023  08:37:40 -0500 (0:00:00.054)       0:19:27.150 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:40 -0500 (0:00:00.060)       0:19:27.210 ********
Sunday 08 January 2023  08:37:40 -0500 (0:00:00.088)       0:19:27.299 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.4/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:37:40 -0500 (0:00:00.125)       0:19:27.425 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:37:45 -0500 (0:00:05.198)       0:19:32.623 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:37:45 -0500 (0:00:00.062)       0:19:32.686 ********
Sunday 08 January 2023  08:37:46 -0500 (0:00:00.051)       0:19:32.737 ********

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
Sunday 08 January 2023  08:37:46 -0500 (0:00:00.064)       0:19:32.801 ********
Sunday 08 January 2023  08:37:46 -0500 (0:00:00.060)       0:19:32.861 ********
Sunday 08 January 2023  08:37:46 -0500 (0:00:00.047)       0:19:32.909 ********
Sunday 08 January 2023  08:37:46 -0500 (0:00:00.059)       0:19:32.968 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:38:24 -0500 (0:00:37.959)       0:20:10.928 ********
Sunday 08 January 2023  08:38:24 -0500 (0:00:00.021)       0:20:10.949 ********
Sunday 08 January 2023  08:38:24 -0500 (0:00:00.050)       0:20:11.000 ********
Sunday 08 January 2023  08:38:24 -0500 (0:00:00.048)       0:20:11.048 ********
Sunday 08 January 2023  08:38:24 -0500 (0:00:00.050)       0:20:11.099 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:38:26 -0500 (0:00:02.522)       0:20:13.621 ********

TASK [download : prep_download | Set a few facts] **********************************************************************
ok: [node1]
Sunday 08 January 2023  08:38:26 -0500 (0:00:00.035)       0:20:13.656 ********

TASK [download : download_file | Starting download of file] ************************************************************
ok: [node1] => {
    "msg": "https://github.com/projectcalico/calico/archive/v3.24.5.tar.gz"
}
Sunday 08 January 2023  08:38:27 -0500 (0:00:00.035)       0:20:13.692 ********

TASK [download : download_file | Set pathname of cached file] **********************************************************
ok: [node1]
Sunday 08 January 2023  08:38:27 -0500 (0:00:00.033)       0:20:13.725 ********

TASK [download : download_file | Create dest directory on node] ********************************************************
changed: [node1]
Sunday 08 January 2023  08:38:28 -0500 (0:00:01.446)       0:20:15.172 ********
Sunday 08 January 2023  08:38:28 -0500 (0:00:00.027)       0:20:15.200 ********
Sunday 08 January 2023  08:38:28 -0500 (0:00:00.032)       0:20:15.232 ********

TASK [download : download_file | Validate mirrors] *********************************************************************
ok: [node1] => (item=None)
ok: [node1 -> {{ download_delegate if download_force_cache else inventory_hostname }}]
Sunday 08 January 2023  08:38:32 -0500 (0:00:04.089)       0:20:19.322 ********

TASK [download : download_file | Get the list of working mirrors] ******************************************************
ok: [node1]
Sunday 08 January 2023  08:38:32 -0500 (0:00:00.043)       0:20:19.366 ********

TASK [download : download_file | Download item] ************************************************************************
changed: [node1]
Sunday 08 January 2023  08:38:38 -0500 (0:00:05.531)       0:20:24.897 ********
Sunday 08 January 2023  08:38:38 -0500 (0:00:00.022)       0:20:24.931 ********
Sunday 08 January 2023  08:38:38 -0500 (0:00:00.036)       0:20:24.968 ********
Sunday 08 January 2023  08:38:38 -0500 (0:00:00.035)       0:20:25.003 ********

TASK [download : download_file | Extract file archives] ****************************************************************
included: /root/13.4/kubespray/roles/download/tasks/extract_file.yml for node1
Sunday 08 January 2023  08:38:38 -0500 (0:00:00.058)       0:20:25.061 ********

TASK [download : extract_file | Unpacking archive] *********************************************************************
changed: [node1]
Sunday 08 January 2023  08:38:49 -0500 (0:00:11.038)       0:20:36.099 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:38:49 -0500 (0:00:00.063)       0:20:36.163 ********

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
Sunday 08 January 2023  08:38:49 -0500 (0:00:00.069)       0:20:36.232 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:38:49 -0500 (0:00:00.057)       0:20:36.290 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:38:49 -0500 (0:00:00.062)       0:20:36.353 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:38:49 -0500 (0:00:00.061)       0:20:36.414 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:38:49 -0500 (0:00:00.061)       0:20:36.476 ********
Sunday 08 January 2023  08:38:49 -0500 (0:00:00.049)       0:20:36.526 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:38:49 -0500 (0:00:00.058)       0:20:36.585 ********
Sunday 08 January 2023  08:38:49 -0500 (0:00:00.054)       0:20:36.639 ********
Sunday 08 January 2023  08:38:50 -0500 (0:00:00.053)       0:20:36.693 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:38:50 -0500 (0:00:00.068)       0:20:36.762 ********
Sunday 08 January 2023  08:38:50 -0500 (0:00:00.049)       0:20:36.811 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.4/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:38:50 -0500 (0:00:00.083)       0:20:36.933 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:38:53 -0500 (0:00:03.186)       0:20:40.120 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:38:53 -0500 (0:00:00.057)       0:20:40.177 ********
Sunday 08 January 2023  08:38:53 -0500 (0:00:00.054)       0:20:40.232 ********

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
Sunday 08 January 2023  08:38:53 -0500 (0:00:00.062)       0:20:40.294 ********
Sunday 08 January 2023  08:38:53 -0500 (0:00:00.055)       0:20:40.350 ********
Sunday 08 January 2023  08:38:53 -0500 (0:00:00.051)       0:20:40.401 ********
Sunday 08 January 2023  08:38:53 -0500 (0:00:00.057)       0:20:40.459 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node1]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:39:00 -0500 (0:00:06.644)       0:20:47.104 ********
Sunday 08 January 2023  08:39:00 -0500 (0:00:00.025)       0:20:47.129 ********
Sunday 08 January 2023  08:39:00 -0500 (0:00:00.053)       0:20:47.182 ********
Sunday 08 January 2023  08:39:00 -0500 (0:00:00.051)       0:20:47.233 ********
Sunday 08 January 2023  08:39:00 -0500 (0:00:00.050)       0:20:47.284 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:39:03 -0500 (0:00:02.843)       0:20:50.127 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:03 -0500 (0:00:00.062)       0:20:50.190 ********

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
Sunday 08 January 2023  08:39:03 -0500 (0:00:00.059)       0:20:50.249 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:03 -0500 (0:00:00.057)       0:20:50.307 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:03 -0500 (0:00:00.061)       0:20:50.368 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:03 -0500 (0:00:00.056)       0:20:50.424 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:03 -0500 (0:00:00.062)       0:20:50.491 ********
Sunday 08 January 2023  08:39:03 -0500 (0:00:00.048)       0:20:50.540 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:03 -0500 (0:00:00.059)       0:20:50.605 ********
Sunday 08 January 2023  08:39:03 -0500 (0:00:00.050)       0:20:50.655 ********
Sunday 08 January 2023  08:39:04 -0500 (0:00:00.052)       0:20:50.707 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:04 -0500 (0:00:00.065)       0:20:50.773 ********
Sunday 08 January 2023  08:39:04 -0500 (0:00:00.052)       0:20:50.825 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.4/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:39:04 -0500 (0:00:00.124)       0:20:50.950 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:39:08 -0500 (0:00:04.349)       0:20:55.300 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:08 -0500 (0:00:00.058)       0:20:55.360 ********
Sunday 08 January 2023  08:39:08 -0500 (0:00:00.047)       0:20:55.407 ********

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
Sunday 08 January 2023  08:39:08 -0500 (0:00:00.065)       0:20:55.473 ********
Sunday 08 January 2023  08:39:08 -0500 (0:00:00.058)       0:20:55.531 ********
Sunday 08 January 2023  08:39:08 -0500 (0:00:00.055)       0:20:55.586 ********
Sunday 08 January 2023  08:39:08 -0500 (0:00:00.060)       0:20:55.647 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:39:22 -0500 (0:00:13.983)       0:21:09.631 ********
Sunday 08 January 2023  08:39:22 -0500 (0:00:00.024)       0:21:09.656 ********
Sunday 08 January 2023  08:39:23 -0500 (0:00:00.051)       0:21:09.708 ********
Sunday 08 January 2023  08:39:23 -0500 (0:00:00.053)       0:21:09.762 ********
Sunday 08 January 2023  08:39:23 -0500 (0:00:00.051)       0:21:09.813 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:39:25 -0500 (0:00:02.067)       0:21:11.881 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:25 -0500 (0:00:00.066)       0:21:11.950 ********

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
Sunday 08 January 2023  08:39:25 -0500 (0:00:00.060)       0:21:12.010 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:25 -0500 (0:00:00.058)       0:21:12.070 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:25 -0500 (0:00:00.064)       0:21:12.135 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:25 -0500 (0:00:00.059)       0:21:12.194 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:25 -0500 (0:00:00.062)       0:21:12.256 ********
Sunday 08 January 2023  08:39:25 -0500 (0:00:00.048)       0:21:12.304 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:25 -0500 (0:00:00.064)       0:21:12.369 ********
Sunday 08 January 2023  08:39:25 -0500 (0:00:00.051)       0:21:12.420 ********
Sunday 08 January 2023  08:39:25 -0500 (0:00:00.047)       0:21:12.470 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:25 -0500 (0:00:00.161)       0:21:12.631 ********
Sunday 08 January 2023  08:39:25 -0500 (0:00:00.043)       0:21:12.682 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.4/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:39:26 -0500 (0:00:00.122)       0:21:12.804 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:39:31 -0500 (0:00:05.404)       0:21:18.209 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:39:31 -0500 (0:00:00.058)       0:21:18.267 ********
Sunday 08 January 2023  08:39:31 -0500 (0:00:00.050)       0:21:18.318 ********

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
Sunday 08 January 2023  08:39:31 -0500 (0:00:00.064)       0:21:18.382 ********
Sunday 08 January 2023  08:39:31 -0500 (0:00:00.059)       0:21:18.442 ********
Sunday 08 January 2023  08:39:31 -0500 (0:00:00.050)       0:21:18.493 ********
Sunday 08 January 2023  08:39:31 -0500 (0:00:00.062)       0:21:18.556 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:40:19 -0500 (0:00:47.362)       0:22:05.918 ********
Sunday 08 January 2023  08:40:19 -0500 (0:00:00.023)       0:22:05.942 ********
Sunday 08 January 2023  08:40:19 -0500 (0:00:00.051)       0:22:05.993 ********
Sunday 08 January 2023  08:40:19 -0500 (0:00:00.049)       0:22:06.043 ********
Sunday 08 January 2023  08:40:19 -0500 (0:00:00.053)       0:22:06.096 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Sunday 08 January 2023  08:40:22 -0500 (0:00:02.860)       0:22:08.957 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
Sunday 08 January 2023  08:40:22 -0500 (0:00:00.036)       0:22:08.993 ********

TASK [download : set_container_facts | Display the name of the image being processed] **********************************
ok: [node1] => {
    "msg": "registry.k8s.io/cpa/cluster-proportional-autoscaler-amd64"
}
Sunday 08 January 2023  08:40:22 -0500 (0:00:00.031)       0:22:09.025 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
Sunday 08 January 2023  08:40:22 -0500 (0:00:00.036)       0:22:09.061 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
Sunday 08 January 2023  08:40:22 -0500 (0:00:00.035)       0:22:09.097 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
Sunday 08 January 2023  08:40:22 -0500 (0:00:00.031)       0:22:09.128 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
Sunday 08 January 2023  08:40:22 -0500 (0:00:00.035)       0:22:09.164 ********
Sunday 08 January 2023  08:40:22 -0500 (0:00:00.035)       0:22:09.199 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
Sunday 08 January 2023  08:40:22 -0500 (0:00:00.041)       0:22:09.241 ********
Sunday 08 January 2023  08:40:22 -0500 (0:00:00.033)       0:22:09.274 ********
Sunday 08 January 2023  08:40:22 -0500 (0:00:00.031)       0:22:09.306 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
Sunday 08 January 2023  08:40:22 -0500 (0:00:00.038)       0:22:09.344 ********
Sunday 08 January 2023  08:40:22 -0500 (0:00:00.034)       0:22:09.378 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.4/kubespray/roles/download/tasks/check_pull_required.yml for node1
Sunday 08 January 2023  08:40:22 -0500 (0:00:00.064)       0:22:09.443 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node1]
Sunday 08 January 2023  08:40:26 -0500 (0:00:03.796)       0:22:13.244 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
Sunday 08 January 2023  08:40:26 -0500 (0:00:00.026)       0:22:13.277 ********
Sunday 08 January 2023  08:40:26 -0500 (0:00:00.037)       0:22:13.314 ********

TASK [download : debug] ************************************************************************************************
ok: [node1] => {
    "msg": "Pull registry.k8s.io/cpa/cluster-proportional-autoscaler-amd64:1.8.5 required is: True"
}
Sunday 08 January 2023  08:40:26 -0500 (0:00:00.035)       0:22:13.351 ********
Sunday 08 January 2023  08:40:26 -0500 (0:00:00.124)       0:22:13.475 ********
Sunday 08 January 2023  08:40:26 -0500 (0:00:00.032)       0:22:13.510 ********
Sunday 08 January 2023  08:40:26 -0500 (0:00:00.053)       0:22:13.563 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node1]
Sunday 08 January 2023  08:40:40 -0500 (0:00:13.512)       0:22:27.076 ********
Sunday 08 January 2023  08:40:40 -0500 (0:00:00.025)       0:22:27.101 ********
Sunday 08 January 2023  08:40:40 -0500 (0:00:00.035)       0:22:27.136 ********
Sunday 08 January 2023  08:40:40 -0500 (0:00:00.032)       0:22:27.169 ********
Sunday 08 January 2023  08:40:40 -0500 (0:00:00.037)       0:22:27.206 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node1]
Sunday 08 January 2023  08:40:42 -0500 (0:00:01.546)       0:22:28.753 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:40:42 -0500 (0:00:00.061)       0:22:28.814 ********

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
Sunday 08 January 2023  08:40:42 -0500 (0:00:00.070)       0:22:28.884 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:40:42 -0500 (0:00:00.061)       0:22:28.946 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:40:42 -0500 (0:00:00.058)       0:22:29.004 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:40:42 -0500 (0:00:00.059)       0:22:29.064 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:40:42 -0500 (0:00:00.056)       0:22:29.121 ********
Sunday 08 January 2023  08:40:42 -0500 (0:00:00.052)       0:22:29.174 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:40:42 -0500 (0:00:00.064)       0:22:29.238 ********
Sunday 08 January 2023  08:40:42 -0500 (0:00:00.047)       0:22:29.286 ********
Sunday 08 January 2023  08:40:42 -0500 (0:00:00.045)       0:22:29.338 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:40:42 -0500 (0:00:00.061)       0:22:29.399 ********
Sunday 08 January 2023  08:40:42 -0500 (0:00:00.051)       0:22:29.451 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.4/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:40:42 -0500 (0:00:00.126)       0:22:29.578 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:40:48 -0500 (0:00:05.851)       0:22:35.429 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:40:48 -0500 (0:00:00.064)       0:22:35.493 ********
Sunday 08 January 2023  08:40:48 -0500 (0:00:00.064)       0:22:35.557 ********

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
Sunday 08 January 2023  08:40:48 -0500 (0:00:00.060)       0:22:35.618 ********
Sunday 08 January 2023  08:40:48 -0500 (0:00:00.062)       0:22:35.681 ********
Sunday 08 January 2023  08:40:49 -0500 (0:00:00.049)       0:22:35.730 ********
Sunday 08 January 2023  08:40:49 -0500 (0:00:00.060)       0:22:35.790 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:41:26 -0500 (0:00:37.461)       0:23:13.252 ********
Sunday 08 January 2023  08:41:26 -0500 (0:00:00.022)       0:23:13.275 ********
Sunday 08 January 2023  08:41:26 -0500 (0:00:00.148)       0:23:13.423 ********
Sunday 08 January 2023  08:41:26 -0500 (0:00:00.049)       0:23:13.472 ********
Sunday 08 January 2023  08:41:26 -0500 (0:00:00.055)       0:23:13.527 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node3]
ok: [node1]
ok: [node4]
ok: [node2]
Sunday 08 January 2023  08:41:31 -0500 (0:00:04.949)       0:23:18.477 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:41:31 -0500 (0:00:00.058)       0:23:18.537 ********

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
Sunday 08 January 2023  08:41:31 -0500 (0:00:00.062)       0:23:18.599 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:41:31 -0500 (0:00:00.067)       0:23:18.667 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:41:32 -0500 (0:00:00.059)       0:23:18.726 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:41:32 -0500 (0:00:00.064)       0:23:18.791 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:41:32 -0500 (0:00:00.057)       0:23:18.848 ********
Sunday 08 January 2023  08:41:32 -0500 (0:00:00.048)       0:23:18.896 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:41:32 -0500 (0:00:00.061)       0:23:18.958 ********
Sunday 08 January 2023  08:41:32 -0500 (0:00:00.051)       0:23:19.010 ********
Sunday 08 January 2023  08:41:32 -0500 (0:00:00.053)       0:23:19.063 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:41:32 -0500 (0:00:00.061)       0:23:19.125 ********
Sunday 08 January 2023  08:41:32 -0500 (0:00:00.052)       0:23:19.177 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.4/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:41:32 -0500 (0:00:00.121)       0:23:19.299 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:41:40 -0500 (0:00:08.252)       0:23:27.551 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:41:40 -0500 (0:00:00.060)       0:23:27.611 ********
Sunday 08 January 2023  08:41:40 -0500 (0:00:00.048)       0:23:27.660 ********

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
Sunday 08 January 2023  08:41:41 -0500 (0:00:00.065)       0:23:27.726 ********
Sunday 08 January 2023  08:41:41 -0500 (0:00:00.064)       0:23:27.790 ********
Sunday 08 January 2023  08:41:41 -0500 (0:00:00.046)       0:23:27.837 ********
Sunday 08 January 2023  08:41:41 -0500 (0:00:00.061)       0:23:27.898 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:42:29 -0500 (0:00:48.699)       0:24:16.598 ********
Sunday 08 January 2023  08:42:29 -0500 (0:00:00.022)       0:24:16.620 ********
Sunday 08 January 2023  08:42:29 -0500 (0:00:00.051)       0:24:16.672 ********
Sunday 08 January 2023  08:42:30 -0500 (0:00:00.048)       0:24:16.721 ********
Sunday 08 January 2023  08:42:30 -0500 (0:00:00.055)       0:24:16.776 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Sunday 08 January 2023  08:42:33 -0500 (0:00:02.959)       0:24:19.735 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:42:33 -0500 (0:00:00.059)       0:24:19.795 ********

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
Sunday 08 January 2023  08:42:33 -0500 (0:00:00.071)       0:24:19.866 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:42:33 -0500 (0:00:00.058)       0:24:19.924 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:42:33 -0500 (0:00:00.058)       0:24:19.988 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:42:33 -0500 (0:00:00.160)       0:24:20.148 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:42:33 -0500 (0:00:00.061)       0:24:20.209 ********
Sunday 08 January 2023  08:42:33 -0500 (0:00:00.054)       0:24:20.264 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:42:33 -0500 (0:00:00.060)       0:24:20.324 ********
Sunday 08 January 2023  08:42:33 -0500 (0:00:00.210)       0:24:20.535 ********
Sunday 08 January 2023  08:42:33 -0500 (0:00:00.055)       0:24:20.590 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:42:33 -0500 (0:00:00.064)       0:24:20.654 ********
Sunday 08 January 2023  08:42:34 -0500 (0:00:00.056)       0:24:20.711 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.4/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:42:34 -0500 (0:00:00.124)       0:24:20.836 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:42:40 -0500 (0:00:06.102)       0:24:26.938 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:42:40 -0500 (0:00:00.063)       0:24:27.002 ********
Sunday 08 January 2023  08:42:40 -0500 (0:00:00.051)       0:24:27.053 ********

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
Sunday 08 January 2023  08:42:40 -0500 (0:00:00.060)       0:24:27.114 ********
Sunday 08 January 2023  08:42:40 -0500 (0:00:00.059)       0:24:27.173 ********
Sunday 08 January 2023  08:42:40 -0500 (0:00:00.048)       0:24:27.222 ********
Sunday 08 January 2023  08:42:40 -0500 (0:00:00.059)       0:24:27.282 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Sunday 08 January 2023  08:42:56 -0500 (0:00:16.214)       0:24:43.496 ********
Sunday 08 January 2023  08:42:56 -0500 (0:00:00.024)       0:24:43.520 ********
Sunday 08 January 2023  08:42:56 -0500 (0:00:00.052)       0:24:43.573 ********
Sunday 08 January 2023  08:42:56 -0500 (0:00:00.048)       0:24:43.621 ********
Sunday 08 January 2023  08:42:56 -0500 (0:00:00.053)       0:24:43.675 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node3]
ok: [node1]
ok: [node2]
ok: [node4]
Sunday 08 January 2023  08:42:59 -0500 (0:00:02.894)       0:24:46.570 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:42:59 -0500 (0:00:00.057)       0:24:46.628 ********

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
Sunday 08 January 2023  08:43:00 -0500 (0:00:00.065)       0:24:46.694 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:00 -0500 (0:00:00.062)       0:24:46.756 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:00 -0500 (0:00:00.058)       0:24:46.815 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:00 -0500 (0:00:00.063)       0:24:46.878 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:00 -0500 (0:00:00.061)       0:24:46.939 ********
Sunday 08 January 2023  08:43:00 -0500 (0:00:00.051)       0:24:46.991 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:00 -0500 (0:00:00.062)       0:24:47.053 ********
Sunday 08 January 2023  08:43:00 -0500 (0:00:00.047)       0:24:47.100 ********
Sunday 08 January 2023  08:43:00 -0500 (0:00:00.053)       0:24:47.154 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:00 -0500 (0:00:00.060)       0:24:47.216 ********
Sunday 08 January 2023  08:43:00 -0500 (0:00:00.131)       0:24:47.347 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.4/kubespray/roles/download/tasks/check_pull_required.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:43:00 -0500 (0:00:00.127)       0:24:47.474 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:43:07 -0500 (0:00:06.988)       0:24:54.464 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:07 -0500 (0:00:00.067)       0:24:54.532 ********
Sunday 08 January 2023  08:43:07 -0500 (0:00:00.049)       0:24:54.581 ********

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
Sunday 08 January 2023  08:43:07 -0500 (0:00:00.061)       0:24:54.643 ********
Sunday 08 January 2023  08:43:08 -0500 (0:00:00.060)       0:24:54.703 ********
Sunday 08 January 2023  08:43:08 -0500 (0:00:00.046)       0:24:54.749 ********
Sunday 08 January 2023  08:43:08 -0500 (0:00:00.061)       0:24:54.811 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:43:28 -0500 (0:00:20.342)       0:25:15.153 ********
Sunday 08 January 2023  08:43:28 -0500 (0:00:00.027)       0:25:15.181 ********
Sunday 08 January 2023  08:43:28 -0500 (0:00:00.053)       0:25:15.234 ********
Sunday 08 January 2023  08:43:28 -0500 (0:00:00.055)       0:25:15.289 ********
Sunday 08 January 2023  08:43:28 -0500 (0:00:00.046)       0:25:15.336 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:43:31 -0500 (0:00:02.774)       0:25:18.111 ********

TASK [download : set default values for flag variables] ****************************************************************
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:31 -0500 (0:00:00.058)       0:25:18.169 ********

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
Sunday 08 January 2023  08:43:31 -0500 (0:00:00.045)       0:25:18.224 ********

TASK [download : set_container_facts | Set if containers should be pulled by digest] ***********************************
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:31 -0500 (0:00:00.051)       0:25:18.287 ********

TASK [download : set_container_facts | Define by what name to pull the image] ******************************************
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:31 -0500 (0:00:00.055)       0:25:18.342 ********

TASK [download : set_container_facts | Define file name of image] ******************************************************
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:31 -0500 (0:00:00.054)       0:25:18.396 ********

TASK [download : set_container_facts | Define path of image] ***********************************************************
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:31 -0500 (0:00:00.059)       0:25:18.456 ********
Sunday 08 January 2023  08:43:31 -0500 (0:00:00.045)       0:25:18.501 ********

TASK [download : Set image save/load command for containerd] ***********************************************************
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:31 -0500 (0:00:00.060)       0:25:18.562 ********
Sunday 08 January 2023  08:43:31 -0500 (0:00:00.045)       0:25:18.607 ********
Sunday 08 January 2023  08:43:31 -0500 (0:00:00.051)       0:25:18.659 ********

TASK [download : Set image save/load command for containerd on localhost] **********************************************
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:32 -0500 (0:00:00.060)       0:25:18.719 ********
Sunday 08 January 2023  08:43:32 -0500 (0:00:00.046)       0:25:18.765 ********

TASK [download : download_container | Prepare container download] ******************************************************
included: /root/13.4/kubespray/roles/download/tasks/check_pull_required.yml for node2, node3, node4
Sunday 08 January 2023  08:43:32 -0500 (0:00:00.102)       0:25:18.868 ********

TASK [download : check_pull_required |  Generate a list of information about the images on a node] *********************
ok: [node3]
ok: [node4]
ok: [node2]
Sunday 08 January 2023  08:43:37 -0500 (0:00:05.042)       0:25:23.911 ********

TASK [download : check_pull_required | Set pull_required if the desired image is not yet loaded] ***********************
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:43:37 -0500 (0:00:00.056)       0:25:23.967 ********
Sunday 08 January 2023  08:43:37 -0500 (0:00:00.049)       0:25:24.016 ********

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
Sunday 08 January 2023  08:43:37 -0500 (0:00:00.042)       0:25:24.072 ********
Sunday 08 January 2023  08:43:37 -0500 (0:00:00.142)       0:25:24.215 ********
Sunday 08 January 2023  08:43:37 -0500 (0:00:00.049)       0:25:24.265 ********
Sunday 08 January 2023  08:43:37 -0500 (0:00:00.052)       0:25:24.318 ********

TASK [download : download_container | Download image if required] ******************************************************
changed: [node3]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:44:00 -0500 (0:00:23.187)       0:25:47.506 ********
Sunday 08 January 2023  08:44:00 -0500 (0:00:00.028)       0:25:47.534 ********
Sunday 08 January 2023  08:44:00 -0500 (0:00:00.050)       0:25:47.584 ********
Sunday 08 January 2023  08:44:00 -0500 (0:00:00.049)       0:25:47.634 ********
Sunday 08 January 2023  08:44:00 -0500 (0:00:00.032)       0:25:47.679 ********

TASK [download : download_container | Remove container image from cache] ***********************************************
ok: [node2]
ok: [node3]
ok: [node4]

PLAY [etcd:kube_control_plane] *****************************************************************************************
Sunday 08 January 2023  08:44:03 -0500 (0:00:02.493)       0:25:50.172 ********
Sunday 08 January 2023  08:44:03 -0500 (0:00:00.020)       0:25:50.192 ********
Sunday 08 January 2023  08:44:03 -0500 (0:00:00.019)       0:25:50.211 ********
Sunday 08 January 2023  08:44:03 -0500 (0:00:00.018)       0:25:50.230 ********
Sunday 08 January 2023  08:44:03 -0500 (0:00:00.018)       0:25:50.249 ********
Sunday 08 January 2023  08:44:03 -0500 (0:00:00.016)       0:25:50.266 ********
Sunday 08 January 2023  08:44:03 -0500 (0:00:00.018)       0:25:50.284 ********
Sunday 08 January 2023  08:44:03 -0500 (0:00:00.019)       0:25:50.304 ********
Sunday 08 January 2023  08:44:03 -0500 (0:00:00.018)       0:25:50.322 ********
Sunday 08 January 2023  08:44:03 -0500 (0:00:00.016)       0:25:50.338 ********
Sunday 08 January 2023  08:44:04 -0500 (0:00:00.524)       0:25:50.862 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Sunday 08 January 2023  08:44:04 -0500 (0:00:00.052)       0:25:50.915 ********
Sunday 08 January 2023  08:44:04 -0500 (0:00:00.032)       0:25:50.948 ********
Sunday 08 January 2023  08:44:04 -0500 (0:00:00.018)       0:25:50.966 ********
Sunday 08 January 2023  08:44:04 -0500 (0:00:00.019)       0:25:50.986 ********
Sunday 08 January 2023  08:44:04 -0500 (0:00:00.016)       0:25:51.002 ********
Sunday 08 January 2023  08:44:04 -0500 (0:00:00.018)       0:25:51.020 ********
Sunday 08 January 2023  08:44:04 -0500 (0:00:00.024)       0:25:51.045 ********

TASK [adduser : User | Create User Group] ******************************************************************************
changed: [node1]
Sunday 08 January 2023  08:44:06 -0500 (0:00:02.344)       0:25:53.389 ********

TASK [adduser : User | Create User] ************************************************************************************
changed: [node1]
Sunday 08 January 2023  08:44:09 -0500 (0:00:02.844)       0:25:56.234 ********

TASK [adduser : User | Create User Group] ******************************************************************************
ok: [node1]
Sunday 08 January 2023  08:44:11 -0500 (0:00:02.377)       0:25:58.611 ********

TASK [adduser : User | Create User] ************************************************************************************
ok: [node1]
Sunday 08 January 2023  08:44:13 -0500 (0:00:02.036)       0:26:00.648 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.4/kubespray/roles/etcd/tasks/check_certs.yml for node1
Sunday 08 January 2023  08:44:14 -0500 (0:00:00.049)       0:26:00.697 ********

TASK [etcd : Check_certs | Register certs that have already been generated on first etcd node] *************************
[WARNING]: Skipped '/etc/ssl/etcd/ssl' path due to this access issue: '/etc/ssl/etcd/ssl' is not a directory
ok: [node1]
Sunday 08 January 2023  08:44:15 -0500 (0:00:01.304)       0:26:02.002 ********

TASK [etcd : Check_certs | Set default value for 'sync_certs', 'gen_certs' and 'etcd_secret_changed' to false] *********
ok: [node1]
Sunday 08 January 2023  08:44:15 -0500 (0:00:00.021)       0:26:02.024 ********

TASK [etcd : Check certs | Register ca and etcd admin/member certs on etcd hosts] **************************************
ok: [node1] => (item=ca.pem)
ok: [node1] => (item=member-node1.pem)
ok: [node1] => (item=member-node1-key.pem)
ok: [node1] => (item=admin-node1.pem)
ok: [node1] => (item=admin-node1-key.pem)
Sunday 08 January 2023  08:44:26 -0500 (0:00:11.092)       0:26:13.117 ********

TASK [etcd : Check certs | Register ca and etcd node certs on kubernetes hosts] ****************************************
ok: [node1] => (item=ca.pem)
ok: [node1] => (item=node-node1.pem)
ok: [node1] => (item=node-node1-key.pem)
Sunday 08 January 2023  08:44:32 -0500 (0:00:05.594)       0:26:18.712 ********

TASK [etcd : Check_certs | Set 'gen_certs' to true if expected certificates are not on the first etcd node(1/2)] *******
ok: [node1] => (item=/etc/ssl/etcd/ssl/ca.pem)
ok: [node1] => (item=/etc/ssl/etcd/ssl/admin-node1.pem)
ok: [node1] => (item=/etc/ssl/etcd/ssl/admin-node1-key.pem)
ok: [node1] => (item=/etc/ssl/etcd/ssl/member-node1.pem)
ok: [node1] => (item=/etc/ssl/etcd/ssl/member-node1-key.pem)
ok: [node1] => (item=/etc/ssl/etcd/ssl/node-node1.pem)
ok: [node1] => (item=/etc/ssl/etcd/ssl/node-node1-key.pem)
Sunday 08 January 2023  08:44:32 -0500 (0:00:00.090)       0:26:18.802 ********
Sunday 08 January 2023  08:44:32 -0500 (0:00:00.089)       0:26:18.891 ********

TASK [etcd : Check_certs | Set 'gen_master_certs' object to track whether member and admin certs exist on first etcd node] ***
ok: [node1]
Sunday 08 January 2023  08:44:32 -0500 (0:00:00.028)       0:26:18.920 ********

TASK [etcd : Check_certs | Set 'gen_node_certs' object to track whether node certs exist on first etcd node] ***********
ok: [node1]
Sunday 08 January 2023  08:44:32 -0500 (0:00:00.029)       0:26:18.950 ********

TASK [etcd : Check_certs | Set 'etcd_member_requires_sync' to true if ca or member/admin cert and key don't exist on etcd member or checksum doesn't match] ***
ok: [node1]
Sunday 08 January 2023  08:44:32 -0500 (0:00:00.045)       0:26:18.996 ********
Sunday 08 January 2023  08:44:32 -0500 (0:00:00.017)       0:26:19.014 ********

TASK [etcd : Check_certs | Set 'sync_certs' to true] *******************************************************************
ok: [node1]
Sunday 08 January 2023  08:44:32 -0500 (0:00:00.028)       0:26:19.042 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.4/kubespray/roles/etcd/tasks/gen_certs_script.yml for node1
Sunday 08 January 2023  08:44:32 -0500 (0:00:00.039)       0:26:19.082 ********

TASK [etcd : Gen_certs | create etcd cert dir] *************************************************************************
changed: [node1]
Sunday 08 January 2023  08:44:34 -0500 (0:00:01.975)       0:26:21.058 ********

TASK [etcd : Gen_certs | create etcd script dir (on node1)] ************************************************************
changed: [node1]
Sunday 08 January 2023  08:44:36 -0500 (0:00:01.645)       0:26:22.703 ********

TASK [etcd : Gen_certs | write openssl config] *************************************************************************
changed: [node1]
Sunday 08 January 2023  08:44:38 -0500 (0:00:02.883)       0:26:25.586 ********

TASK [etcd : Gen_certs | copy certs generation script] *****************************************************************
changed: [node1]
Sunday 08 January 2023  08:44:42 -0500 (0:00:03.484)       0:26:29.071 ********

TASK [etcd : Gen_certs | run cert generation script for etcd and kube control plane nodes] *****************************
changed: [node1]
Sunday 08 January 2023  08:44:44 -0500 (0:00:02.071)       0:26:31.142 ********
Sunday 08 January 2023  08:44:44 -0500 (0:00:00.038)       0:26:31.181 ********
Sunday 08 January 2023  08:44:44 -0500 (0:00:00.061)       0:26:31.247 ********
Sunday 08 January 2023  08:44:44 -0500 (0:00:00.286)       0:26:31.533 ********
Sunday 08 January 2023  08:44:44 -0500 (0:00:00.055)       0:26:31.589 ********
Sunday 08 January 2023  08:44:44 -0500 (0:00:00.055)       0:26:31.644 ********
Sunday 08 January 2023  08:44:44 -0500 (0:00:00.018)       0:26:31.663 ********
Sunday 08 January 2023  08:44:44 -0500 (0:00:00.020)       0:26:31.684 ********

TASK [etcd : Gen_certs | check certificate permissions] ****************************************************************
changed: [node1]
Sunday 08 January 2023  08:44:46 -0500 (0:00:02.002)       0:26:33.686 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.4/kubespray/roles/etcd/tasks/upd_ca_trust.yml for node1
Sunday 08 January 2023  08:44:47 -0500 (0:00:00.037)       0:26:33.724 ********

TASK [etcd : Gen_certs | target ca-certificate store file] *************************************************************
ok: [node1]
Sunday 08 January 2023  08:44:47 -0500 (0:00:00.024)       0:26:33.748 ********

TASK [etcd : Gen_certs | add CA to trusted CA dir] *********************************************************************
changed: [node1]
Sunday 08 January 2023  08:44:48 -0500 (0:00:01.536)       0:26:35.285 ********

TASK [etcd : Gen_certs | update ca-certificates (Debian/Ubuntu/SUSE/Flatcar)] ******************************************
changed: [node1]
Sunday 08 January 2023  08:44:54 -0500 (0:00:05.934)       0:26:41.219 ********
Sunday 08 January 2023  08:44:54 -0500 (0:00:00.017)       0:26:41.236 ********
Sunday 08 January 2023  08:44:54 -0500 (0:00:00.016)       0:26:41.253 ********
Sunday 08 January 2023  08:44:54 -0500 (0:00:00.019)       0:26:41.272 ********
Sunday 08 January 2023  08:44:54 -0500 (0:00:00.019)       0:26:41.292 ********
Sunday 08 January 2023  08:44:54 -0500 (0:00:00.018)       0:26:41.314 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.4/kubespray/roles/etcd/tasks/install_host.yml for node1
Sunday 08 January 2023  08:44:54 -0500 (0:00:00.033)       0:26:41.350 ********

TASK [etcd : Get currently-deployed etcd version] **********************************************************************
fatal: [node1]: FAILED! => {"changed": false, "cmd": "/usr/local/bin/etcd --version", "msg": "[Errno 2] No such file or directory: b'/usr/local/bin/etcd'", "rc": 2, "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
...ignoring
Sunday 08 January 2023  08:44:56 -0500 (0:00:01.590)       0:26:42.940 ********

TASK [etcd : Restart etcd if necessary] ********************************************************************************
changed: [node1]
Sunday 08 January 2023  08:44:58 -0500 (0:00:02.388)       0:26:45.329 ********
Sunday 08 January 2023  08:44:58 -0500 (0:00:00.016)       0:26:45.346 ********

TASK [etcd : install | Copy etcd and etcdctl binary from download dir] *************************************************
changed: [node1] => (item=etcd)
changed: [node1] => (item=etcdctl)
Sunday 08 January 2023  08:45:04 -0500 (0:00:05.601)       0:26:50.948 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.4/kubespray/roles/etcd/tasks/configure.yml for node1
Sunday 08 January 2023  08:45:04 -0500 (0:00:00.042)       0:26:50.994 ********

TASK [etcd : Configure | Check if etcd cluster is healthy] *************************************************************
ok: [node1]
Sunday 08 January 2023  08:45:11 -0500 (0:00:06.818)       0:26:57.813 ********
Sunday 08 January 2023  08:45:11 -0500 (0:00:00.022)       0:26:57.835 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.4/kubespray/roles/etcd/tasks/refresh_config.yml for node1
Sunday 08 January 2023  08:45:11 -0500 (0:00:00.028)       0:26:57.867 ********

TASK [etcd : Refresh config | Create etcd config file] *****************************************************************
changed: [node1]
Sunday 08 January 2023  08:45:14 -0500 (0:00:03.230)       0:27:01.097 ********
Sunday 08 January 2023  08:45:14 -0500 (0:00:00.017)       0:27:01.115 ********

TASK [etcd : Configure | Copy etcd.service systemd file] ***************************************************************
changed: [node1]
Sunday 08 January 2023  08:45:18 -0500 (0:00:03.736)       0:27:04.852 ********
Sunday 08 January 2023  08:45:18 -0500 (0:00:00.017)       0:27:04.869 ********

TASK [etcd : Configure | reload systemd] *******************************************************************************
ok: [node1]
Sunday 08 January 2023  08:45:22 -0500 (0:00:04.569)       0:27:09.439 ********

TASK [etcd : Configure | Ensure etcd is running] ***********************************************************************
changed: [node1]
Sunday 08 January 2023  08:45:29 -0500 (0:00:06.489)       0:27:15.929 ********
Sunday 08 January 2023  08:45:29 -0500 (0:00:00.019)       0:27:15.948 ********

TASK [etcd : Configure | Wait for etcd cluster to be healthy] **********************************************************
ok: [node1]
Sunday 08 January 2023  08:45:31 -0500 (0:00:02.553)       0:27:18.502 ********
Sunday 08 January 2023  08:45:31 -0500 (0:00:00.016)       0:27:18.519 ********

TASK [etcd : Configure | Check if member is in etcd cluster] ***********************************************************
ok: [node1]
Sunday 08 January 2023  08:45:34 -0500 (0:00:03.035)       0:27:21.555 ********
Sunday 08 January 2023  08:45:34 -0500 (0:00:00.015)       0:27:21.570 ********
Sunday 08 January 2023  08:45:34 -0500 (0:00:00.021)       0:27:21.592 ********
Sunday 08 January 2023  08:45:34 -0500 (0:00:00.019)       0:27:21.611 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.4/kubespray/roles/etcd/tasks/refresh_config.yml for node1
Sunday 08 January 2023  08:45:34 -0500 (0:00:00.040)       0:27:21.652 ********

TASK [etcd : Refresh config | Create etcd config file] *****************************************************************
changed: [node1]
Sunday 08 January 2023  08:45:39 -0500 (0:00:04.238)       0:27:25.891 ********
Sunday 08 January 2023  08:45:39 -0500 (0:00:00.019)       0:27:25.910 ********
Sunday 08 January 2023  08:45:39 -0500 (0:00:00.019)       0:27:25.930 ********
Sunday 08 January 2023  08:45:39 -0500 (0:00:00.019)       0:27:25.949 ********

TASK [etcd : include_tasks] ********************************************************************************************
included: /root/13.4/kubespray/roles/etcd/tasks/refresh_config.yml for node1
Sunday 08 January 2023  08:45:39 -0500 (0:00:00.038)       0:27:25.988 ********

TASK [etcd : Refresh config | Create etcd config file] *****************************************************************
ok: [node1]
Sunday 08 January 2023  08:45:43 -0500 (0:00:03.712)       0:27:29.701 ********
Sunday 08 January 2023  08:45:43 -0500 (0:00:00.025)       0:27:29.727 ********

RUNNING HANDLER [etcd : restart etcd] **********************************************************************************
changed: [node1]
Sunday 08 January 2023  08:45:45 -0500 (0:00:02.044)       0:27:31.771 ********

RUNNING HANDLER [etcd : Backup etcd data] ******************************************************************************
changed: [node1]
Sunday 08 January 2023  08:45:47 -0500 (0:00:02.534)       0:27:34.306 ********

RUNNING HANDLER [etcd : Refresh Time Fact] *****************************************************************************
ok: [node1]
Sunday 08 January 2023  08:45:51 -0500 (0:00:04.179)       0:27:38.486 ********

RUNNING HANDLER [etcd : Set Backup Directory] **************************************************************************
ok: [node1]
Sunday 08 January 2023  08:45:51 -0500 (0:00:00.023)       0:27:38.509 ********

RUNNING HANDLER [etcd : Create Backup Directory] ***********************************************************************
changed: [node1]
Sunday 08 January 2023  08:45:53 -0500 (0:00:02.149)       0:27:40.659 ********

RUNNING HANDLER [etcd : Stat etcd v2 data directory] *******************************************************************
ok: [node1]
Sunday 08 January 2023  08:45:56 -0500 (0:00:02.270)       0:27:42.929 ********

RUNNING HANDLER [etcd : Backup etcd v2 data] ***************************************************************************
changed: [node1]
Sunday 08 January 2023  08:45:58 -0500 (0:00:02.007)       0:27:44.937 ********

RUNNING HANDLER [etcd : Backup etcd v3 data] ***************************************************************************
changed: [node1]
Sunday 08 January 2023  08:46:01 -0500 (0:00:03.564)       0:27:48.501 ********

RUNNING HANDLER [etcd : etcd | reload systemd] *************************************************************************
ok: [node1]
Sunday 08 January 2023  08:46:06 -0500 (0:00:04.843)       0:27:53.344 ********

RUNNING HANDLER [etcd : reload etcd] ***********************************************************************************
changed: [node1]
Sunday 08 January 2023  08:46:17 -0500 (0:00:10.707)       0:28:04.052 ********

RUNNING HANDLER [etcd : wait for etcd up] ******************************************************************************
ok: [node1]
Sunday 08 January 2023  08:46:20 -0500 (0:00:03.195)       0:28:07.248 ********

RUNNING HANDLER [etcd : Cleanup etcd backups] **************************************************************************
changed: [node1]
Sunday 08 January 2023  08:46:22 -0500 (0:00:02.384)       0:28:09.632 ********
Sunday 08 January 2023  08:46:22 -0500 (0:00:00.019)       0:28:09.652 ********

RUNNING HANDLER [etcd : set etcd_secret_changed] ***********************************************************************
ok: [node1]

PLAY [k8s_cluster] *****************************************************************************************************
Sunday 08 January 2023  08:46:23 -0500 (0:00:00.062)       0:28:09.715 ********
Sunday 08 January 2023  08:46:23 -0500 (0:00:00.049)       0:28:09.765 ********
Sunday 08 January 2023  08:46:23 -0500 (0:00:00.019)       0:28:09.785 ********
Sunday 08 January 2023  08:46:23 -0500 (0:00:00.017)       0:28:09.802 ********
Sunday 08 January 2023  08:46:23 -0500 (0:00:00.040)       0:28:09.847 ********
Sunday 08 January 2023  08:46:23 -0500 (0:00:00.046)       0:28:09.894 ********
Sunday 08 January 2023  08:46:23 -0500 (0:00:00.043)       0:28:09.938 ********
Sunday 08 January 2023  08:46:23 -0500 (0:00:00.050)       0:28:09.988 ********
Sunday 08 January 2023  08:46:23 -0500 (0:00:00.020)       0:28:10.009 ********
Sunday 08 January 2023  08:46:23 -0500 (0:00:00.044)       0:28:10.054 ********
Sunday 08 January 2023  08:46:23 -0500 (0:00:00.655)       0:28:10.709 ********

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
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.084)       0:28:10.794 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.032)       0:28:10.826 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.018)       0:28:10.845 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.047)       0:28:10.893 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.020)       0:28:10.913 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.047)       0:28:10.961 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.072)       0:28:11.034 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.050)       0:28:11.084 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.085)       0:28:11.169 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.054)       0:28:11.224 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.152)       0:28:11.377 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.055)       0:28:11.433 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.052)       0:28:11.485 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.053)       0:28:11.538 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.058)       0:28:11.597 ********
Sunday 08 January 2023  08:46:24 -0500 (0:00:00.051)       0:28:11.649 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.050)       0:28:11.699 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.048)       0:28:11.748 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.056)       0:28:11.804 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.049)       0:28:11.854 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.049)       0:28:11.904 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.053)       0:28:11.957 ********

PLAY [k8s_cluster] *****************************************************************************************************
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.126)       0:28:12.084 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.045)       0:28:12.129 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.020)       0:28:12.150 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.018)       0:28:12.168 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.047)       0:28:12.216 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.045)       0:28:12.262 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.045)       0:28:12.307 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.048)       0:28:12.355 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.015)       0:28:12.371 ********
Sunday 08 January 2023  08:46:25 -0500 (0:00:00.055)       0:28:12.426 ********
Sunday 08 January 2023  08:46:26 -0500 (0:00:00.652)       0:28:13.079 ********

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
Sunday 08 January 2023  08:46:26 -0500 (0:00:00.196)       0:28:13.276 ********
Sunday 08 January 2023  08:46:26 -0500 (0:00:00.035)       0:28:13.312 ********
Sunday 08 January 2023  08:46:26 -0500 (0:00:00.021)       0:28:13.333 ********
Sunday 08 January 2023  08:46:26 -0500 (0:00:00.048)       0:28:13.382 ********
Sunday 08 January 2023  08:46:26 -0500 (0:00:00.015)       0:28:13.398 ********
Sunday 08 January 2023  08:46:26 -0500 (0:00:00.045)       0:28:13.444 ********
Sunday 08 January 2023  08:46:26 -0500 (0:00:00.069)       0:28:13.513 ********
Sunday 08 January 2023  08:46:26 -0500 (0:00:00.048)       0:28:13.562 ********
Sunday 08 January 2023  08:46:26 -0500 (0:00:00.042)       0:28:13.604 ********
Sunday 08 January 2023  08:46:26 -0500 (0:00:00.044)       0:28:13.648 ********
Sunday 08 January 2023  08:46:26 -0500 (0:00:00.043)       0:28:13.691 ********

TASK [kubernetes/node : set kubelet_cgroup_driver_detected fact for containerd] ****************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:46:27 -0500 (0:00:00.053)       0:28:13.744 ********

TASK [kubernetes/node : set kubelet_cgroup_driver] *********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:46:27 -0500 (0:00:00.054)       0:28:13.800 ********
Sunday 08 January 2023  08:46:27 -0500 (0:00:00.040)       0:28:13.841 ********
Sunday 08 January 2023  08:46:27 -0500 (0:00:00.044)       0:28:13.885 ********
Sunday 08 January 2023  08:46:27 -0500 (0:00:00.052)       0:28:13.938 ********

TASK [kubernetes/node : Pre-upgrade | check if kubelet container exists] ***********************************************
ok: [node3]
ok: [node1]
ok: [node4]
ok: [node2]
Sunday 08 January 2023  08:46:35 -0500 (0:00:08.739)       0:28:22.677 ********
Sunday 08 January 2023  08:46:36 -0500 (0:00:00.041)       0:28:22.719 ********
Sunday 08 January 2023  08:46:36 -0500 (0:00:00.041)       0:28:22.760 ********
Sunday 08 January 2023  08:46:36 -0500 (0:00:00.045)       0:28:22.805 ********

TASK [kubernetes/node : Ensure /var/lib/cni exists] ********************************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:46:39 -0500 (0:00:02.937)       0:28:25.744 ********

TASK [kubernetes/node : install | Copy kubeadm binary from download dir] ***********************************************
changed: [node3]
changed: [node2]
changed: [node4]
Sunday 08 January 2023  08:46:43 -0500 (0:00:04.387)       0:28:30.132 ********

TASK [kubernetes/node : install | Copy kubelet binary from download dir] ***********************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Sunday 08 January 2023  08:46:53 -0500 (0:00:10.105)       0:28:40.238 ********
Sunday 08 January 2023  08:46:53 -0500 (0:00:00.048)       0:28:40.286 ********
Sunday 08 January 2023  08:46:53 -0500 (0:00:00.043)       0:28:40.330 ********

TASK [kubernetes/node : haproxy | Cleanup potentially deployed haproxy] ************************************************
ok: [node3]
ok: [node4]
ok: [node2]
Sunday 08 January 2023  08:46:57 -0500 (0:00:03.816)       0:28:44.146 ********

TASK [kubernetes/node : nginx-proxy | Make nginx directory] ************************************************************
changed: [node3]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:46:59 -0500 (0:00:02.297)       0:28:46.443 ********

TASK [kubernetes/node : nginx-proxy | Write nginx-proxy configuration] *************************************************
changed: [node3]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:47:05 -0500 (0:00:05.934)       0:28:52.378 ********

TASK [kubernetes/node : nginx-proxy | Get checksum from config] ********************************************************
ok: [node3]
ok: [node4]
ok: [node2]
Sunday 08 January 2023  08:47:07 -0500 (0:00:02.262)       0:28:54.641 ********

TASK [kubernetes/node : nginx-proxy | Write static pod] ****************************************************************
changed: [node3]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:47:13 -0500 (0:00:05.276)       0:28:59.917 ********
Sunday 08 January 2023  08:47:13 -0500 (0:00:00.055)       0:28:59.972 ********
Sunday 08 January 2023  08:47:13 -0500 (0:00:00.048)       0:29:00.021 ********
Sunday 08 January 2023  08:47:13 -0500 (0:00:00.047)       0:29:00.068 ********
Sunday 08 January 2023  08:47:13 -0500 (0:00:00.052)       0:29:00.121 ********
Sunday 08 January 2023  08:47:13 -0500 (0:00:00.044)       0:29:00.166 ********

TASK [kubernetes/node : Ensure nodePort range is reserved] *************************************************************
changed: [node3]
changed: [node1]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:47:16 -0500 (0:00:03.091)       0:29:03.257 ********

TASK [kubernetes/node : Verify if br_netfilter module exists] **********************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:47:20 -0500 (0:00:04.249)       0:29:07.507 ********

TASK [kubernetes/node : Verify br_netfilter module path exists] ********************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:47:24 -0500 (0:00:03.272)       0:29:10.781 ********

TASK [kubernetes/node : Enable br_netfilter module] ********************************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:47:27 -0500 (0:00:03.241)       0:29:14.024 ********

TASK [kubernetes/node : Persist br_netfilter module] *******************************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Sunday 08 January 2023  08:47:33 -0500 (0:00:06.264)       0:29:20.288 ********

TASK [kubernetes/node : Check if bridge-nf-call-iptables key exists] ***************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:47:36 -0500 (0:00:02.650)       0:29:22.938 ********

TASK [kubernetes/node : Enable bridge-nf-call tables] ******************************************************************
changed: [node3] => (item=net.bridge.bridge-nf-call-iptables)
changed: [node3] => (item=net.bridge.bridge-nf-call-arptables)
changed: [node4] => (item=net.bridge.bridge-nf-call-iptables)
changed: [node1] => (item=net.bridge.bridge-nf-call-iptables)
changed: [node2] => (item=net.bridge.bridge-nf-call-iptables)
changed: [node3] => (item=net.bridge.bridge-nf-call-ip6tables)
changed: [node4] => (item=net.bridge.bridge-nf-call-arptables)
changed: [node1] => (item=net.bridge.bridge-nf-call-arptables)
changed: [node4] => (item=net.bridge.bridge-nf-call-ip6tables)
changed: [node2] => (item=net.bridge.bridge-nf-call-arptables)
changed: [node1] => (item=net.bridge.bridge-nf-call-ip6tables)
changed: [node2] => (item=net.bridge.bridge-nf-call-ip6tables)
Sunday 08 January 2023  08:47:44 -0500 (0:00:08.358)       0:29:31.297 ********

TASK [kubernetes/node : Modprobe Kernel Module for IPVS] ***************************************************************
changed: [node3] => (item=ip_vs)
changed: [node3] => (item=ip_vs_rr)
changed: [node4] => (item=ip_vs)
changed: [node3] => (item=ip_vs_wrr)
changed: [node2] => (item=ip_vs)
changed: [node3] => (item=ip_vs_sh)
changed: [node1] => (item=ip_vs)
changed: [node4] => (item=ip_vs_rr)
changed: [node4] => (item=ip_vs_wrr)
changed: [node1] => (item=ip_vs_rr)
changed: [node2] => (item=ip_vs_rr)
changed: [node4] => (item=ip_vs_sh)
changed: [node1] => (item=ip_vs_wrr)
changed: [node2] => (item=ip_vs_wrr)
changed: [node2] => (item=ip_vs_sh)
changed: [node1] => (item=ip_vs_sh)
Sunday 08 January 2023  08:47:57 -0500 (0:00:12.533)       0:29:43.831 ********

TASK [kubernetes/node : Modprobe nf_conntrack_ipv4] ********************************************************************
fatal: [node3]: FAILED! => {"changed": false, "msg": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "name": "nf_conntrack_ipv4", "params": "", "rc": 1, "state": "present", "stderr": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "stderr_lines": ["modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64"], "stdout": "", "stdout_lines": []}
...ignoring
fatal: [node2]: FAILED! => {"changed": false, "msg": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "name": "nf_conntrack_ipv4", "params": "", "rc": 1, "state": "present", "stderr": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "stderr_lines": ["modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64"], "stdout": "", "stdout_lines": []}
...ignoring
fatal: [node4]: FAILED! => {"changed": false, "msg": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "name": "nf_conntrack_ipv4", "params": "", "rc": 1, "state": "present", "stderr": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "stderr_lines": ["modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64"], "stdout": "", "stdout_lines": []}
...ignoring
fatal: [node1]: FAILED! => {"changed": false, "msg": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "name": "nf_conntrack_ipv4", "params": "", "rc": 1, "state": "present", "stderr": "modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64\n", "stderr_lines": ["modprobe: FATAL: Module nf_conntrack_ipv4 not found in directory /lib/modules/5.10.0-19-amd64"], "stdout": "", "stdout_lines": []}
...ignoring
Sunday 08 January 2023  08:48:00 -0500 (0:00:03.470)       0:29:47.302 ********

TASK [kubernetes/node : Persist ip_vs modules] *************************************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Sunday 08 January 2023  08:48:08 -0500 (0:00:08.068)       0:29:55.370 ********
Sunday 08 January 2023  08:48:08 -0500 (0:00:00.047)       0:29:55.418 ********
Sunday 08 January 2023  08:48:08 -0500 (0:00:00.041)       0:29:55.459 ********
Sunday 08 January 2023  08:48:08 -0500 (0:00:00.114)       0:29:55.574 ********
Sunday 08 January 2023  08:48:08 -0500 (0:00:00.041)       0:29:55.616 ********

TASK [kubernetes/node : Set kubelet api version to v1beta1] ************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:48:08 -0500 (0:00:00.054)       0:29:55.670 ********

TASK [kubernetes/node : Write kubelet environment config file (kubeadm)] ***********************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Sunday 08 January 2023  08:48:16 -0500 (0:00:07.735)       0:30:03.406 ********

TASK [kubernetes/node : Write kubelet config file] *********************************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Sunday 08 January 2023  08:48:26 -0500 (0:00:10.168)       0:30:13.575 ********

TASK [kubernetes/node : Write kubelet systemd init file] ***************************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Sunday 08 January 2023  08:48:34 -0500 (0:00:07.783)       0:30:21.358 ********
Sunday 08 January 2023  08:48:34 -0500 (0:00:00.000)       0:30:21.359 ********

RUNNING HANDLER [kubernetes/node : Node | restart kubelet] *************************************************************
changed: [node3]
changed: [node2]
changed: [node4]
changed: [node1]
Sunday 08 January 2023  08:48:38 -0500 (0:00:03.927)       0:30:25.286 ********

RUNNING HANDLER [kubernetes/node : Kubelet | reload systemd] ***********************************************************
ok: [node3]
ok: [node2]
ok: [node4]
ok: [node1]
Sunday 08 January 2023  08:48:46 -0500 (0:00:08.236)       0:30:33.523 ********

RUNNING HANDLER [kubernetes/node : Kubelet | restart kubelet] **********************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:48:51 -0500 (0:00:04.530)       0:30:38.054 ********

TASK [kubernetes/node : Enable kubelet] ********************************************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:48:58 -0500 (0:00:07.477)       0:30:45.532 ********

RUNNING HANDLER [kubernetes/node : Kubelet | restart kubelet] **********************************************************
changed: [node3]
changed: [node2]
changed: [node1]
changed: [node4]

PLAY [kube_control_plane] **********************************************************************************************
Sunday 08 January 2023  08:49:03 -0500 (0:00:04.443)       0:30:49.975 ********
Sunday 08 January 2023  08:49:03 -0500 (0:00:00.019)       0:30:49.995 ********
Sunday 08 January 2023  08:49:03 -0500 (0:00:00.024)       0:30:50.019 ********
Sunday 08 January 2023  08:49:03 -0500 (0:00:00.019)       0:30:50.038 ********
Sunday 08 January 2023  08:49:03 -0500 (0:00:00.017)       0:30:50.056 ********
Sunday 08 January 2023  08:49:03 -0500 (0:00:00.016)       0:30:50.072 ********
Sunday 08 January 2023  08:49:03 -0500 (0:00:00.019)       0:30:50.092 ********
Sunday 08 January 2023  08:49:03 -0500 (0:00:00.020)       0:30:50.112 ********
Sunday 08 January 2023  08:49:03 -0500 (0:00:00.021)       0:30:50.133 ********
Sunday 08 January 2023  08:49:03 -0500 (0:00:00.016)       0:30:50.149 ********
Sunday 08 January 2023  08:49:03 -0500 (0:00:00.492)       0:30:50.642 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.052)       0:30:50.695 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.034)       0:30:50.729 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.017)       0:30:50.746 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.019)       0:30:50.766 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.019)       0:30:50.786 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.016)       0:30:50.802 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.099)       0:30:50.902 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.016)       0:30:50.918 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.015)       0:30:50.934 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.016)       0:30:50.950 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.016)       0:30:50.966 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.016)       0:30:50.983 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.028)       0:30:51.012 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.026)       0:30:51.039 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.032)       0:30:51.071 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.034)       0:30:51.106 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.025)       0:30:51.131 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.017)       0:30:51.148 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.024)       0:30:51.172 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.016)       0:30:51.189 ********
Sunday 08 January 2023  08:49:04 -0500 (0:00:00.022)       0:30:51.211 ********

TASK [kubernetes/control-plane : Pre-upgrade | Delete master manifests if etcd secrets changed] ************************
ok: [node1] => (item=kube-apiserver)
ok: [node1] => (item=kube-controller-manager)
ok: [node1] => (item=kube-scheduler)
Sunday 08 January 2023  08:49:09 -0500 (0:00:05.391)       0:30:56.603 ********
Sunday 08 January 2023  08:49:09 -0500 (0:00:00.020)       0:30:56.624 ********
Sunday 08 January 2023  08:49:09 -0500 (0:00:00.015)       0:30:56.640 ********
Sunday 08 January 2023  08:49:09 -0500 (0:00:00.018)       0:30:56.658 ********

TASK [kubernetes/control-plane : Create kube-scheduler config] *********************************************************
changed: [node1]
Sunday 08 January 2023  08:49:13 -0500 (0:00:03.685)       0:31:00.344 ********
Sunday 08 January 2023  08:49:13 -0500 (0:00:00.015)       0:31:00.360 ********
Sunday 08 January 2023  08:49:13 -0500 (0:00:00.014)       0:31:00.374 ********
Sunday 08 January 2023  08:49:13 -0500 (0:00:00.017)       0:31:00.392 ********
Sunday 08 January 2023  08:49:13 -0500 (0:00:00.024)       0:31:00.417 ********
Sunday 08 January 2023  08:49:13 -0500 (0:00:00.018)       0:31:00.435 ********
Sunday 08 January 2023  08:49:13 -0500 (0:00:00.018)       0:31:00.453 ********

TASK [kubernetes/control-plane : Install | Copy kubectl binary from download dir] **************************************
changed: [node1]
Sunday 08 January 2023  08:49:17 -0500 (0:00:03.414)       0:31:03.868 ********

TASK [kubernetes/control-plane : Install kubectl bash completion] ******************************************************
changed: [node1]
Sunday 08 January 2023  08:49:19 -0500 (0:00:02.604)       0:31:06.473 ********

TASK [kubernetes/control-plane : Set kubectl bash completion file permissions] *****************************************
changed: [node1]
Sunday 08 January 2023  08:49:21 -0500 (0:00:01.584)       0:31:08.057 ********
Sunday 08 January 2023  08:49:21 -0500 (0:00:00.015)       0:31:08.073 ********

TASK [kubernetes/control-plane : Check which kube-control nodes are already members of the cluster] ********************
fatal: [node1]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/kubectl", "get", "nodes", "--selector=node-role.kubernetes.io/control-plane", "-o", "json"], "delta": "0:00:00.626973", "end": "2023-01-08 13:49:23.587739", "msg": "non-zero return code", "rc": 1, "start": "2023-01-08 13:49:22.960766", "stderr": "The connection to the server localhost:8080 was refused - did you specify the right host or port?", "stderr_lines": ["The connection to the server localhost:8080 was refused - did you specify the right host or port?"], "stdout": "", "stdout_lines": []}
...ignoring
Sunday 08 January 2023  08:49:23 -0500 (0:00:02.359)       0:31:10.432 ********
Sunday 08 January 2023  08:49:23 -0500 (0:00:00.018)       0:31:10.451 ********

TASK [kubernetes/control-plane : Set fact first_kube_control_plane] ****************************************************
ok: [node1]
Sunday 08 January 2023  08:49:23 -0500 (0:00:00.024)       0:31:10.475 ********
Sunday 08 January 2023  08:49:23 -0500 (0:00:00.016)       0:31:10.492 ********

TASK [kubernetes/control-plane : kubeadm | Check if kubeadm has already run] *******************************************
ok: [node1]
Sunday 08 January 2023  08:49:26 -0500 (0:00:02.521)       0:31:13.014 ********
Sunday 08 January 2023  08:49:26 -0500 (0:00:00.032)       0:31:13.046 ********
Sunday 08 January 2023  08:49:26 -0500 (0:00:00.027)       0:31:13.074 ********

TASK [kubernetes/control-plane : kubeadm | aggregate all SANs] *********************************************************
ok: [node1]
Sunday 08 January 2023  08:49:26 -0500 (0:00:00.101)       0:31:13.176 ********
Sunday 08 January 2023  08:49:26 -0500 (0:00:00.016)       0:31:13.192 ********
Sunday 08 January 2023  08:49:26 -0500 (0:00:00.017)       0:31:13.210 ********
Sunday 08 January 2023  08:49:26 -0500 (0:00:00.020)       0:31:13.230 ********
Sunday 08 January 2023  08:49:26 -0500 (0:00:00.016)       0:31:13.246 ********

TASK [kubernetes/control-plane : Set kubeadm api version to v1beta3] ***************************************************
ok: [node1]
Sunday 08 January 2023  08:49:26 -0500 (0:00:00.020)       0:31:13.267 ********

TASK [kubernetes/control-plane : kubeadm | Create kubeadm config] ******************************************************
changed: [node1]
Sunday 08 January 2023  08:49:31 -0500 (0:00:04.628)       0:31:17.896 ********
Sunday 08 January 2023  08:49:31 -0500 (0:00:00.019)       0:31:17.916 ********
Sunday 08 January 2023  08:49:31 -0500 (0:00:00.018)       0:31:17.935 ********
Sunday 08 January 2023  08:49:31 -0500 (0:00:00.015)       0:31:17.950 ********
Sunday 08 January 2023  08:49:31 -0500 (0:00:00.015)       0:31:17.965 ********
Sunday 08 January 2023  08:49:31 -0500 (0:00:00.020)       0:31:17.986 ********
Sunday 08 January 2023  08:49:31 -0500 (0:00:00.016)       0:31:18.002 ********
Sunday 08 January 2023  08:49:31 -0500 (0:00:00.018)       0:31:18.020 ********
Sunday 08 January 2023  08:49:31 -0500 (0:00:00.016)       0:31:18.037 ********

TASK [kubernetes/control-plane : kubeadm | Initialize first master] ****************************************************
changed: [node1]
Sunday 08 January 2023  08:51:19 -0500 (0:01:48.104)       0:33:06.142 ********
Sunday 08 January 2023  08:51:19 -0500 (0:00:00.359)       0:33:06.502 ********
Sunday 08 January 2023  08:51:19 -0500 (0:00:00.030)       0:33:06.532 ********

TASK [kubernetes/control-plane : Create kubeadm token for joining nodes with 24h expiration (default)] *****************
ok: [node1]
Sunday 08 January 2023  08:51:23 -0500 (0:00:03.293)       0:33:09.826 ********

TASK [kubernetes/control-plane : Set kubeadm_token] ********************************************************************
ok: [node1]
Sunday 08 January 2023  08:51:23 -0500 (0:00:00.024)       0:33:09.851 ********
Sunday 08 January 2023  08:51:23 -0500 (0:00:00.014)       0:33:09.866 ********

TASK [kubernetes/control-plane : kubeadm | Join other masters] *********************************************************
included: /root/13.4/kubespray/roles/kubernetes/control-plane/tasks/kubeadm-secondary.yml for node1
Sunday 08 January 2023  08:51:23 -0500 (0:00:00.034)       0:33:09.900 ********

TASK [kubernetes/control-plane : Set kubeadm_discovery_address] ********************************************************
ok: [node1]
Sunday 08 January 2023  08:51:23 -0500 (0:00:00.060)       0:33:09.961 ********

TASK [kubernetes/control-plane : Upload certificates so they are fresh and not expired] ********************************
changed: [node1]
Sunday 08 January 2023  08:51:26 -0500 (0:00:02.951)       0:33:12.912 ********

TASK [kubernetes/control-plane : Parse certificate key if not set] *****************************************************
ok: [node1]
Sunday 08 January 2023  08:51:26 -0500 (0:00:00.047)       0:33:12.963 ********
Sunday 08 January 2023  08:51:26 -0500 (0:00:00.017)       0:33:12.980 ********

TASK [kubernetes/control-plane : Wait for k8s apiserver] ***************************************************************
ok: [node1]
Sunday 08 January 2023  08:51:27 -0500 (0:00:01.638)       0:33:14.622 ********

TASK [kubernetes/control-plane : check already run] ********************************************************************
ok: [node1] => {
    "msg": false
}
Sunday 08 January 2023  08:51:27 -0500 (0:00:00.023)       0:33:14.645 ********
Sunday 08 January 2023  08:51:27 -0500 (0:00:00.017)       0:33:14.662 ********
Sunday 08 January 2023  08:51:27 -0500 (0:00:00.016)       0:33:14.679 ********
Sunday 08 January 2023  08:51:28 -0500 (0:00:00.024)       0:33:14.704 ********
Sunday 08 January 2023  08:51:28 -0500 (0:00:00.018)       0:33:14.725 ********
Sunday 08 January 2023  08:51:28 -0500 (0:00:00.017)       0:33:14.743 ********

TASK [kubernetes/control-plane : Include kubeadm secondary server apiserver fixes] *************************************
included: /root/13.4/kubespray/roles/kubernetes/control-plane/tasks/kubeadm-fix-apiserver.yml for node1
Sunday 08 January 2023  08:51:28 -0500 (0:00:00.035)       0:33:14.778 ********

TASK [kubernetes/control-plane : Update server field in component kubeconfigs] *****************************************
changed: [node1] => (item=admin.conf)
changed: [node1] => (item=controller-manager.conf)
changed: [node1] => (item=kubelet.conf)
changed: [node1] => (item=scheduler.conf)
Sunday 08 January 2023  08:51:38 -0500 (0:00:10.112)       0:33:24.891 ********

TASK [kubernetes/control-plane : Update etcd-servers for apiserver] ****************************************************
ok: [node1]
Sunday 08 January 2023  08:51:40 -0500 (0:00:02.042)       0:33:26.933 ********

TASK [kubernetes/control-plane : Include kubelet client cert rotation fixes] *******************************************
included: /root/13.4/kubespray/roles/kubernetes/control-plane/tasks/kubelet-fix-client-cert-rotation.yml for node1
Sunday 08 January 2023  08:51:40 -0500 (0:00:00.035)       0:33:26.969 ********

TASK [kubernetes/control-plane : Fixup kubelet client cert rotation 1/2] ***********************************************
ok: [node1]
Sunday 08 January 2023  08:51:42 -0500 (0:00:02.715)       0:33:29.684 ********

TASK [kubernetes/control-plane : Fixup kubelet client cert rotation 2/2] ***********************************************
ok: [node1]
Sunday 08 January 2023  08:51:47 -0500 (0:00:04.259)       0:33:33.944 ********

TASK [kubernetes/control-plane : Install script to renew K8S control plane certificates] *******************************
changed: [node1]
Sunday 08 January 2023  08:51:51 -0500 (0:00:04.257)       0:33:38.202 ********
Sunday 08 January 2023  08:51:51 -0500 (0:00:00.016)       0:33:38.219 ********
Sunday 08 January 2023  08:51:51 -0500 (0:00:00.024)       0:33:38.243 ********

TASK [kubernetes/client : Set external kube-apiserver endpoint] ********************************************************
ok: [node1]
Sunday 08 January 2023  08:51:51 -0500 (0:00:00.028)       0:33:38.272 ********

TASK [kubernetes/client : Create kube config dir for current/ansible become user] **************************************
changed: [node1]
Sunday 08 January 2023  08:51:53 -0500 (0:00:02.028)       0:33:40.300 ********

TASK [kubernetes/client : Copy admin kubeconfig to current/ansible become user home] ***********************************
changed: [node1]
Sunday 08 January 2023  08:51:55 -0500 (0:00:01.650)       0:33:41.951 ********
Sunday 08 January 2023  08:51:55 -0500 (0:00:00.015)       0:33:41.967 ********

TASK [kubernetes/client : Wait for k8s apiserver] **********************************************************************
ok: [node1]
Sunday 08 January 2023  08:51:57 -0500 (0:00:02.327)       0:33:44.294 ********
Sunday 08 January 2023  08:51:57 -0500 (0:00:00.014)       0:33:44.309 ********
Sunday 08 January 2023  08:51:57 -0500 (0:00:00.017)       0:33:44.326 ********
Sunday 08 January 2023  08:51:57 -0500 (0:00:00.016)       0:33:44.343 ********
Sunday 08 January 2023  08:51:57 -0500 (0:00:00.016)       0:33:44.359 ********
Sunday 08 January 2023  08:51:57 -0500 (0:00:00.018)       0:33:44.378 ********
Sunday 08 January 2023  08:51:57 -0500 (0:00:00.024)       0:33:44.403 ********

TASK [kubernetes-apps/cluster_roles : Kubernetes Apps | Wait for kube-apiserver] ***************************************
ok: [node1]
Sunday 08 January 2023  08:52:05 -0500 (0:00:07.357)       0:33:51.760 ********

TASK [kubernetes-apps/cluster_roles : Kubernetes Apps | Add ClusterRoleBinding to admit nodes] *************************
changed: [node1]
Sunday 08 January 2023  08:52:09 -0500 (0:00:04.512)       0:33:56.273 ********

TASK [kubernetes-apps/cluster_roles : Apply workaround to allow all nodes with cert O=system:nodes to register] ********
ok: [node1]
Sunday 08 January 2023  08:52:20 -0500 (0:00:10.843)       0:34:07.116 ********
Sunday 08 January 2023  08:52:20 -0500 (0:00:00.017)       0:34:07.134 ********
Sunday 08 January 2023  08:52:20 -0500 (0:00:00.018)       0:34:07.152 ********
Sunday 08 January 2023  08:52:20 -0500 (0:00:00.018)       0:34:07.171 ********
Sunday 08 January 2023  08:52:20 -0500 (0:00:00.017)       0:34:07.189 ********
Sunday 08 January 2023  08:52:20 -0500 (0:00:00.017)       0:34:07.207 ********

TASK [kubernetes-apps/cluster_roles : PriorityClass | Copy k8s-cluster-critical-pc.yml file] ***************************
changed: [node1]
Sunday 08 January 2023  08:52:25 -0500 (0:00:04.579)       0:34:11.786 ********

TASK [kubernetes-apps/cluster_roles : PriorityClass | Create k8s-cluster-critical] *************************************
ok: [node1]
Sunday 08 January 2023  08:52:30 -0500 (0:00:05.162)       0:34:16.948 ********

RUNNING HANDLER [kubernetes/control-plane : Master | restart kubelet] **************************************************
changed: [node1]
Sunday 08 January 2023  08:52:32 -0500 (0:00:02.680)       0:34:19.628 ********

RUNNING HANDLER [kubernetes/control-plane : Master | wait for master static pods] **************************************
changed: [node1]
Sunday 08 January 2023  08:52:35 -0500 (0:00:02.759)       0:34:22.388 ********

RUNNING HANDLER [kubernetes/control-plane : Master | Restart kube-scheduler] *******************************************
changed: [node1]
Sunday 08 January 2023  08:52:37 -0500 (0:00:01.988)       0:34:24.376 ********

RUNNING HANDLER [kubernetes/control-plane : Master | Restart kube-controller-manager] **********************************
changed: [node1]
Sunday 08 January 2023  08:52:40 -0500 (0:00:02.638)       0:34:27.014 ********

RUNNING HANDLER [kubernetes/control-plane : Master | reload systemd] ***************************************************
ok: [node1]
Sunday 08 January 2023  08:52:48 -0500 (0:00:07.850)       0:34:34.865 ********

RUNNING HANDLER [kubernetes/control-plane : Master | reload kubelet] ***************************************************
changed: [node1]
Sunday 08 January 2023  08:52:50 -0500 (0:00:02.625)       0:34:37.490 ********
Sunday 08 January 2023  08:52:50 -0500 (0:00:00.016)       0:34:37.507 ********

RUNNING HANDLER [kubernetes/control-plane : Master | Remove scheduler container containerd/crio] ***********************
changed: [node1]
Sunday 08 January 2023  08:52:56 -0500 (0:00:05.375)       0:34:42.883 ********
Sunday 08 January 2023  08:52:56 -0500 (0:00:00.016)       0:34:42.900 ********

RUNNING HANDLER [kubernetes/control-plane : Master | Remove controller manager container containerd/crio] **************
changed: [node1]
Sunday 08 January 2023  08:52:59 -0500 (0:00:03.018)       0:34:45.918 ********
FAILED - RETRYING: [node1]: Master | wait for kube-scheduler (60 retries left).
FAILED - RETRYING: [node1]: Master | wait for kube-scheduler (59 retries left).
FAILED - RETRYING: [node1]: Master | wait for kube-scheduler (58 retries left).
FAILED - RETRYING: [node1]: Master | wait for kube-scheduler (57 retries left).
FAILED - RETRYING: [node1]: Master | wait for kube-scheduler (56 retries left).
FAILED - RETRYING: [node1]: Master | wait for kube-scheduler (55 retries left).

RUNNING HANDLER [kubernetes/control-plane : Master | wait for kube-scheduler] ******************************************
ok: [node1]
Sunday 08 January 2023  08:53:35 -0500 (0:00:36.446)       0:35:22.365 ********

RUNNING HANDLER [kubernetes/control-plane : Master | wait for kube-controller-manager] *********************************
ok: [node1]
Sunday 08 January 2023  08:53:38 -0500 (0:00:02.685)       0:35:25.050 ********

RUNNING HANDLER [kubernetes/control-plane : Master | wait for the apiserver to be running] *****************************
ok: [node1]

PLAY [k8s_cluster] *****************************************************************************************************
Sunday 08 January 2023  08:53:42 -0500 (0:00:03.761)       0:35:28.812 ********
Sunday 08 January 2023  08:53:42 -0500 (0:00:00.139)       0:35:28.951 ********
Sunday 08 January 2023  08:53:42 -0500 (0:00:00.020)       0:35:28.972 ********
Sunday 08 January 2023  08:53:42 -0500 (0:00:00.018)       0:35:28.991 ********
Sunday 08 January 2023  08:53:42 -0500 (0:00:00.043)       0:35:29.038 ********
Sunday 08 January 2023  08:53:42 -0500 (0:00:00.045)       0:35:29.087 ********
Sunday 08 January 2023  08:53:42 -0500 (0:00:00.045)       0:35:29.133 ********
Sunday 08 January 2023  08:53:42 -0500 (0:00:00.055)       0:35:29.188 ********
Sunday 08 January 2023  08:53:42 -0500 (0:00:00.017)       0:35:29.206 ********
Sunday 08 January 2023  08:53:42 -0500 (0:00:00.048)       0:35:29.255 ********
Sunday 08 January 2023  08:53:43 -0500 (0:00:00.669)       0:35:29.924 ********

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
Sunday 08 January 2023  08:53:43 -0500 (0:00:00.088)       0:35:30.013 ********
Sunday 08 January 2023  08:53:43 -0500 (0:00:00.035)       0:35:30.048 ********
Sunday 08 January 2023  08:53:43 -0500 (0:00:00.017)       0:35:30.065 ********
Sunday 08 January 2023  08:53:43 -0500 (0:00:00.054)       0:35:30.120 ********
Sunday 08 January 2023  08:53:43 -0500 (0:00:00.019)       0:35:30.139 ********
Sunday 08 January 2023  08:53:43 -0500 (0:00:00.047)       0:35:30.187 ********
Sunday 08 January 2023  08:53:43 -0500 (0:00:00.075)       0:35:30.262 ********

TASK [kubernetes/kubeadm : Set kubeadm_discovery_address] **************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:53:43 -0500 (0:00:00.096)       0:35:30.359 ********

TASK [kubernetes/kubeadm : Check if kubelet.conf exists] ***************************************************************
ok: [node3]
ok: [node1]
ok: [node2]
ok: [node4]
Sunday 08 January 2023  08:53:47 -0500 (0:00:04.077)       0:35:34.437 ********

TASK [kubernetes/kubeadm : Check if kubeadm CA cert is accessible] *****************************************************
ok: [node1]
Sunday 08 January 2023  08:53:49 -0500 (0:00:01.363)       0:35:35.801 ********

TASK [kubernetes/kubeadm : Calculate kubeadm CA cert hash] *************************************************************
ok: [node1]
Sunday 08 January 2023  08:53:50 -0500 (0:00:01.809)       0:35:37.610 ********

TASK [kubernetes/kubeadm : Create kubeadm token for joining nodes with 24h expiration (default)] ***********************
ok: [node3 -> node1(51.250.73.59)]
ok: [node4 -> node1(51.250.73.59)]
ok: [node2 -> node1(51.250.73.59)]
Sunday 08 January 2023  08:53:55 -0500 (0:00:04.159)       0:35:41.770 ********

TASK [kubernetes/kubeadm : Set kubeadm_token to generated token] *******************************************************
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:53:55 -0500 (0:00:00.058)       0:35:41.828 ********

TASK [kubernetes/kubeadm : Set kubeadm api version to v1beta3] *********************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:53:55 -0500 (0:00:00.050)       0:35:41.883 ********

TASK [kubernetes/kubeadm : Create kubeadm client config] ***************************************************************
changed: [node3]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:53:59 -0500 (0:00:04.575)       0:35:46.458 ********
Sunday 08 January 2023  08:53:59 -0500 (0:00:00.046)       0:35:46.504 ********
Sunday 08 January 2023  08:53:59 -0500 (0:00:00.054)       0:35:46.559 ********

TASK [kubernetes/kubeadm : Join to cluster] ****************************************************************************
changed: [node3]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:54:24 -0500 (0:00:24.864)       0:36:11.423 ********
Sunday 08 January 2023  08:54:24 -0500 (0:00:00.050)       0:36:11.473 ********

TASK [kubernetes/kubeadm : Update server field in kubelet kubeconfig] **************************************************
changed: [node3]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:54:28 -0500 (0:00:03.788)       0:36:15.262 ********

TASK [kubernetes/kubeadm : Update server field in kube-proxy kubeconfig] ***********************************************
changed: [node1]
Sunday 08 January 2023  08:54:34 -0500 (0:00:05.481)       0:36:20.744 ********

TASK [kubernetes/kubeadm : Set ca.crt file permission] *****************************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:54:38 -0500 (0:00:04.801)       0:36:25.545 ********

TASK [kubernetes/kubeadm : Restart all kube-proxy pods to ensure that they load the new configmap] *********************
changed: [node1]
Sunday 08 January 2023  08:54:46 -0500 (0:00:07.967)       0:36:33.513 ********
Sunday 08 January 2023  08:54:46 -0500 (0:00:00.072)       0:36:33.586 ********

TASK [kubernetes/node-label : Kubernetes Apps | Wait for kube-apiserver] ***********************************************
ok: [node1]
Sunday 08 January 2023  08:54:53 -0500 (0:00:06.630)       0:36:40.216 ********

TASK [kubernetes/node-label : Set role node label to empty list] *******************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:54:53 -0500 (0:00:00.055)       0:36:40.271 ********
Sunday 08 January 2023  08:54:53 -0500 (0:00:00.044)       0:36:40.316 ********

TASK [kubernetes/node-label : Set inventory node label to empty list] **************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  08:54:53 -0500 (0:00:00.058)       0:36:40.375 ********
Sunday 08 January 2023  08:54:53 -0500 (0:00:00.044)       0:36:40.420 ********

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
Sunday 08 January 2023  08:54:53 -0500 (0:00:00.058)       0:36:40.478 ********

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
Sunday 08 January 2023  08:54:53 -0500 (0:00:00.060)       0:36:40.539 ********
Sunday 08 January 2023  08:54:53 -0500 (0:00:00.074)       0:36:40.614 ********

TASK [network_plugin/cni : CNI | make sure /opt/cni/bin exists] ********************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  08:54:57 -0500 (0:00:03.272)       0:36:43.886 ********

TASK [network_plugin/cni : CNI | Copy cni plugins] *********************************************************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  08:55:28 -0500 (0:00:31.581)       0:37:15.468 ********
Sunday 08 January 2023  08:55:28 -0500 (0:00:00.049)       0:37:15.517 ********
Sunday 08 January 2023  08:55:28 -0500 (0:00:00.045)       0:37:15.562 ********
Sunday 08 January 2023  08:55:28 -0500 (0:00:00.052)       0:37:15.614 ********
Sunday 08 January 2023  08:55:28 -0500 (0:00:00.047)       0:37:15.662 ********
Sunday 08 January 2023  08:55:29 -0500 (0:00:00.128)       0:37:15.791 ********
Sunday 08 January 2023  08:55:29 -0500 (0:00:00.047)       0:37:15.838 ********
Sunday 08 January 2023  08:55:29 -0500 (0:00:00.050)       0:37:15.888 ********
Sunday 08 January 2023  08:55:29 -0500 (0:00:00.053)       0:37:15.941 ********
Sunday 08 January 2023  08:55:29 -0500 (0:00:00.048)       0:37:15.990 ********
Sunday 08 January 2023  08:55:29 -0500 (0:00:00.078)       0:37:16.079 ********

TASK [network_plugin/calico : Slurp CNI config] ************************************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  08:55:32 -0500 (0:00:02.933)       0:37:19.013 ********
Sunday 08 January 2023  08:55:32 -0500 (0:00:00.049)       0:37:19.062 ********
Sunday 08 January 2023  08:55:32 -0500 (0:00:00.057)       0:37:19.120 ********
Sunday 08 January 2023  08:55:32 -0500 (0:00:00.082)       0:37:19.202 ********

TASK [network_plugin/calico : Calico | Gather os specific variables] ***************************************************
ok: [node1] => (item=/root/13.4/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
ok: [node2] => (item=/root/13.4/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
ok: [node3] => (item=/root/13.4/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
ok: [node4] => (item=/root/13.4/kubespray/roles/network_plugin/calico/vars/../vars/debian.yml)
Sunday 08 January 2023  08:55:32 -0500 (0:00:00.068)       0:37:19.271 ********
Sunday 08 January 2023  08:55:32 -0500 (0:00:00.048)       0:37:19.320 ********

TASK [network_plugin/calico : include_tasks] ***************************************************************************
included: /root/13.4/kubespray/roles/network_plugin/calico/tasks/install.yml for node1, node2, node3, node4
Sunday 08 January 2023  08:55:32 -0500 (0:00:00.118)       0:37:19.439 ********
Sunday 08 January 2023  08:55:32 -0500 (0:00:00.051)       0:37:19.490 ********

TASK [network_plugin/calico : Calico | Copy calicoctl binary from download dir] ****************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:55:39 -0500 (0:00:07.199)       0:37:26.690 ********

TASK [network_plugin/calico : Calico | Write Calico cni config] ********************************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  08:55:46 -0500 (0:00:06.410)       0:37:33.100 ********
Sunday 08 January 2023  08:55:46 -0500 (0:00:00.047)       0:37:33.148 ********
Sunday 08 January 2023  08:55:46 -0500 (0:00:00.064)       0:37:33.213 ********
Sunday 08 January 2023  08:55:46 -0500 (0:00:00.046)       0:37:33.259 ********
Sunday 08 January 2023  08:55:46 -0500 (0:00:00.050)       0:37:33.309 ********

TASK [network_plugin/calico : Calico | Install calicoctl wrapper script] ***********************************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  08:55:52 -0500 (0:00:05.583)       0:37:38.893 ********
Sunday 08 January 2023  08:55:52 -0500 (0:00:00.019)       0:37:38.912 ********

TASK [network_plugin/calico : Calico | Check if calico network pool has already been configured] ***********************
ok: [node1]
Sunday 08 January 2023  08:55:56 -0500 (0:00:04.318)       0:37:43.231 ********
Sunday 08 January 2023  08:55:56 -0500 (0:00:00.047)       0:37:43.278 ********
Sunday 08 January 2023  08:55:56 -0500 (0:00:00.049)       0:37:43.328 ********
Sunday 08 January 2023  08:55:56 -0500 (0:00:00.049)       0:37:43.377 ********

TASK [network_plugin/calico : Calico | Check if extra directory is needed] *********************************************
ok: [node1]
Sunday 08 January 2023  08:55:59 -0500 (0:00:02.561)       0:37:45.938 ********
Sunday 08 January 2023  08:55:59 -0500 (0:00:00.049)       0:37:45.988 ********

TASK [network_plugin/calico : Calico | Set kdd path when calico > v3.22.2] *********************************************
ok: [node1]
Sunday 08 January 2023  08:55:59 -0500 (0:00:00.054)       0:37:46.042 ********

TASK [network_plugin/calico : Calico | Create calico manifests for kdd] ************************************************
changed: [node1]
Sunday 08 January 2023  08:56:02 -0500 (0:00:03.591)       0:37:49.633 ********

TASK [network_plugin/calico : Calico | Create Calico Kubernetes datastore resources] ***********************************
ok: [node1]
Sunday 08 January 2023  08:56:14 -0500 (0:00:11.317)       0:38:00.951 ********

TASK [network_plugin/calico : Calico | Get existing FelixConfiguration] ************************************************
fatal: [node1]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/calicoctl.sh", "get", "felixconfig", "default", "-o", "json"], "delta": "0:00:03.545855", "end": "2023-01-08 13:56:19.522516", "msg": "non-zero return code", "rc": 1, "start": "2023-01-08 13:56:15.976661", "stderr": "resource does not exist: FelixConfiguration(default) with error: felixconfigurations.crd.projectcalico.org \"default\" not found", "stderr_lines": ["resource does not exist: FelixConfiguration(default) with error: felixconfigurations.crd.projectcalico.org \"default\" not found"], "stdout": "null", "stdout_lines": ["null"]}
...ignoring
Sunday 08 January 2023  08:56:19 -0500 (0:00:05.469)       0:38:06.421 ********

TASK [network_plugin/calico : Calico | Set kubespray FelixConfiguration] ***********************************************
ok: [node1]
Sunday 08 January 2023  08:56:19 -0500 (0:00:00.047)       0:38:06.468 ********
Sunday 08 January 2023  08:56:19 -0500 (0:00:00.046)       0:38:06.514 ********

TASK [network_plugin/calico : Calico | Configure calico FelixConfiguration] ********************************************
ok: [node1]
Sunday 08 January 2023  08:56:21 -0500 (0:00:01.864)       0:38:08.383 ********

TASK [network_plugin/calico : Calico | Get existing calico network pool] ***********************************************
fatal: [node1]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/calicoctl.sh", "get", "ippool", "default-pool", "-o", "json"], "delta": "0:00:00.279180", "end": "2023-01-08 13:56:23.185256", "msg": "non-zero return code", "rc": 1, "start": "2023-01-08 13:56:22.906076", "stderr": "resource does not exist: IPPool(default-pool) with error: ippools.crd.projectcalico.org \"default-pool\" not found", "stderr_lines": ["resource does not exist: IPPool(default-pool) with error: ippools.crd.projectcalico.org \"default-pool\" not found"], "stdout": "null", "stdout_lines": ["null"]}
...ignoring
Sunday 08 January 2023  08:56:23 -0500 (0:00:01.674)       0:38:10.058 ********

TASK [network_plugin/calico : Calico | Set kubespray calico network pool] **********************************************
ok: [node1]
Sunday 08 January 2023  08:56:23 -0500 (0:00:00.048)       0:38:10.106 ********
Sunday 08 January 2023  08:56:23 -0500 (0:00:00.047)       0:38:10.153 ********

TASK [network_plugin/calico : Calico | Configure calico network pool] **************************************************
ok: [node1]
Sunday 08 January 2023  08:56:24 -0500 (0:00:01.103)       0:38:11.256 ********
Sunday 08 January 2023  08:56:24 -0500 (0:00:00.049)       0:38:11.306 ********
Sunday 08 January 2023  08:56:24 -0500 (0:00:00.047)       0:38:11.353 ********
Sunday 08 January 2023  08:56:24 -0500 (0:00:00.053)       0:38:11.406 ********
Sunday 08 January 2023  08:56:24 -0500 (0:00:00.048)       0:38:11.455 ********
Sunday 08 January 2023  08:56:24 -0500 (0:00:00.016)       0:38:11.472 ********
Sunday 08 January 2023  08:56:24 -0500 (0:00:00.019)       0:38:11.491 ********
Sunday 08 January 2023  08:56:24 -0500 (0:00:00.020)       0:38:11.512 ********

TASK [network_plugin/calico : Calico | Get existing BGP Configuration] *************************************************
fatal: [node1]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/calicoctl.sh", "get", "bgpconfig", "default", "-o", "json"], "delta": "0:00:00.308738", "end": "2023-01-08 13:56:26.202333", "msg": "non-zero return code", "rc": 1, "start": "2023-01-08 13:56:25.893595", "stderr": "resource does not exist: BGPConfiguration(default) with error: bgpconfigurations.crd.projectcalico.org \"default\" not found", "stderr_lines": ["resource does not exist: BGPConfiguration(default) with error: bgpconfigurations.crd.projectcalico.org \"default\" not found"], "stdout": "null", "stdout_lines": ["null"]}
...ignoring
Sunday 08 January 2023  08:56:26 -0500 (0:00:01.518)       0:38:13.031 ********

TASK [network_plugin/calico : Calico | Set kubespray BGP Configuration] ************************************************
ok: [node1]
Sunday 08 January 2023  08:56:26 -0500 (0:00:00.050)       0:38:13.081 ********
Sunday 08 January 2023  08:56:26 -0500 (0:00:00.048)       0:38:13.129 ********

TASK [network_plugin/calico : Calico | Set up BGP Configuration] *******************************************************
ok: [node1]
Sunday 08 January 2023  08:56:27 -0500 (0:00:01.154)       0:38:14.283 ********

TASK [network_plugin/calico : Calico | Create calico manifests] ********************************************************
changed: [node1] => (item={'name': 'calico-config', 'file': 'calico-config.yml', 'type': 'cm'})
changed: [node1] => (item={'name': 'calico-node', 'file': 'calico-node.yml', 'type': 'ds'})
changed: [node1] => (item={'name': 'calico', 'file': 'calico-node-sa.yml', 'type': 'sa'})
changed: [node1] => (item={'name': 'calico', 'file': 'calico-cr.yml', 'type': 'clusterrole'})
changed: [node1] => (item={'name': 'calico', 'file': 'calico-crb.yml', 'type': 'clusterrolebinding'})
changed: [node1] => (item={'name': 'kubernetes-services-endpoint', 'file': 'kubernetes-services-endpoint.yml', 'type': 'cm'})
Sunday 08 January 2023  08:56:42 -0500 (0:00:14.723)       0:38:29.007 ********
Sunday 08 January 2023  08:56:42 -0500 (0:00:00.048)       0:38:29.055 ********
Sunday 08 January 2023  08:56:42 -0500 (0:00:00.051)       0:38:29.106 ********
Sunday 08 January 2023  08:56:42 -0500 (0:00:00.044)       0:38:29.151 ********
Sunday 08 January 2023  08:56:42 -0500 (0:00:00.052)       0:38:29.203 ********

TASK [network_plugin/calico : Start Calico resources] ******************************************************************
ok: [node1] => (item=calico-config.yml)
ok: [node1] => (item=calico-node.yml)
ok: [node1] => (item=calico-node-sa.yml)
ok: [node1] => (item=calico-cr.yml)
ok: [node1] => (item=calico-crb.yml)
ok: [node1] => (item=kubernetes-services-endpoint.yml)
Sunday 08 January 2023  08:57:12 -0500 (0:00:29.684)       0:38:58.888 ********
Sunday 08 January 2023  08:57:12 -0500 (0:00:00.055)       0:38:58.943 ********

TASK [network_plugin/calico : Wait for calico kubeconfig to be created] ************************************************
ok: [node3]
ok: [node4]
ok: [node2]
Sunday 08 January 2023  08:57:52 -0500 (0:00:40.663)       0:39:39.606 ********

TASK [network_plugin/calico : Calico | Create Calico ipam manifests] ***************************************************
changed: [node1] => (item={'name': 'calico', 'file': 'calico-ipamconfig.yml', 'type': 'ipam'})
Sunday 08 January 2023  08:57:59 -0500 (0:00:06.512)       0:39:46.119 ********

TASK [network_plugin/calico : Calico | Create ipamconfig resources] ****************************************************
ok: [node1]
Sunday 08 January 2023  08:58:08 -0500 (0:00:08.882)       0:39:55.001 ********
Sunday 08 January 2023  08:58:08 -0500 (0:00:00.051)       0:39:55.053 ********
Sunday 08 January 2023  08:58:08 -0500 (0:00:00.076)       0:39:55.129 ********
Sunday 08 January 2023  08:58:08 -0500 (0:00:00.047)       0:39:55.177 ********
Sunday 08 January 2023  08:58:08 -0500 (0:00:00.082)       0:39:55.259 ********
Sunday 08 January 2023  08:58:08 -0500 (0:00:00.046)       0:39:55.305 ********
Sunday 08 January 2023  08:58:08 -0500 (0:00:00.076)       0:39:55.382 ********
Sunday 08 January 2023  08:58:08 -0500 (0:00:00.045)       0:39:55.430 ********
Sunday 08 January 2023  08:58:08 -0500 (0:00:00.200)       0:39:55.638 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.061)       0:39:55.699 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.048)       0:39:55.748 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.044)       0:39:55.792 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.056)       0:39:55.849 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.017)       0:39:55.866 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.092)       0:39:55.959 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.121)       0:39:56.080 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.086)       0:39:56.166 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.077)       0:39:56.244 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.046)       0:39:56.291 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.046)       0:39:56.337 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.053)       0:39:56.391 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.046)       0:39:56.438 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.065)       0:39:56.504 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.049)       0:39:56.553 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.055)       0:39:56.608 ********
Sunday 08 January 2023  08:58:09 -0500 (0:00:00.047)       0:39:56.656 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.055)       0:39:56.711 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.062)       0:39:56.773 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.044)       0:39:56.817 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.050)       0:39:56.868 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.075)       0:39:56.944 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.053)       0:39:56.997 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.088)       0:39:57.085 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.051)       0:39:57.137 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.052)       0:39:57.189 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.051)       0:39:57.241 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.047)       0:39:57.288 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.053)       0:39:57.341 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.047)       0:39:57.389 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.052)       0:39:57.441 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.047)       0:39:57.489 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.052)       0:39:57.542 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.059)       0:39:57.601 ********
Sunday 08 January 2023  08:58:10 -0500 (0:00:00.050)       0:39:57.651 ********
Sunday 08 January 2023  08:58:11 -0500 (0:00:00.148)       0:39:57.800 ********
Sunday 08 January 2023  08:58:11 -0500 (0:00:00.107)       0:39:57.907 ********

RUNNING HANDLER [kubernetes/kubeadm : Kubeadm | restart kubelet] *******************************************************
changed: [node3]
changed: [node2]
changed: [node4]
Sunday 08 January 2023  08:58:15 -0500 (0:00:03.892)       0:40:01.799 ********

RUNNING HANDLER [kubernetes/kubeadm : Kubeadm | reload systemd] ********************************************************
ok: [node3]
ok: [node4]
ok: [node2]
Sunday 08 January 2023  08:58:21 -0500 (0:00:06.703)       0:40:08.503 ********

RUNNING HANDLER [kubernetes/kubeadm : Kubeadm | reload kubelet] ********************************************************
changed: [node3]
changed: [node4]
changed: [node2]
Sunday 08 January 2023  08:58:27 -0500 (0:00:05.575)       0:40:14.078 ********

PLAY [calico_rr] *******************************************************************************************************
skipping: no hosts matched

PLAY [kube_control_plane[0]] *******************************************************************************************
Sunday 08 January 2023  08:58:27 -0500 (0:00:00.081)       0:40:14.160 ********
Sunday 08 January 2023  08:58:27 -0500 (0:00:00.021)       0:40:14.181 ********
Sunday 08 January 2023  08:58:27 -0500 (0:00:00.022)       0:40:14.204 ********
Sunday 08 January 2023  08:58:27 -0500 (0:00:00.017)       0:40:14.222 ********
Sunday 08 January 2023  08:58:27 -0500 (0:00:00.015)       0:40:14.238 ********
Sunday 08 January 2023  08:58:27 -0500 (0:00:00.017)       0:40:14.255 ********
Sunday 08 January 2023  08:58:27 -0500 (0:00:00.019)       0:40:14.274 ********
Sunday 08 January 2023  08:58:27 -0500 (0:00:00.018)       0:40:14.293 ********
Sunday 08 January 2023  08:58:27 -0500 (0:00:00.021)       0:40:14.314 ********
Sunday 08 January 2023  08:58:27 -0500 (0:00:00.016)       0:40:14.331 ********
Sunday 08 January 2023  08:58:28 -0500 (0:00:00.500)       0:40:14.831 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Sunday 08 January 2023  08:58:28 -0500 (0:00:00.056)       0:40:14.888 ********
Sunday 08 January 2023  08:58:28 -0500 (0:00:00.032)       0:40:14.920 ********
Sunday 08 January 2023  08:58:28 -0500 (0:00:00.016)       0:40:14.937 ********
Sunday 08 January 2023  08:58:28 -0500 (0:00:00.021)       0:40:14.958 ********
Sunday 08 January 2023  08:58:28 -0500 (0:00:00.017)       0:40:14.976 ********
Sunday 08 January 2023  08:58:28 -0500 (0:00:00.017)       0:40:14.994 ********
Sunday 08 January 2023  08:58:28 -0500 (0:00:00.023)       0:40:15.018 ********

TASK [win_nodes/kubernetes_patch : Ensure that user manifests directory exists] ****************************************
changed: [node1]
Sunday 08 January 2023  08:58:32 -0500 (0:00:04.304)       0:40:19.322 ********

TASK [win_nodes/kubernetes_patch : Check current nodeselector for kube-proxy daemonset] ********************************
ok: [node1]
Sunday 08 January 2023  08:58:40 -0500 (0:00:08.071)       0:40:27.394 ********

TASK [win_nodes/kubernetes_patch : Apply nodeselector patch for kube-proxy daemonset] **********************************
changed: [node1]
Sunday 08 January 2023  08:58:45 -0500 (0:00:04.815)       0:40:32.210 ********

TASK [win_nodes/kubernetes_patch : debug] ******************************************************************************
ok: [node1] => {
    "msg": [
        "daemonset.apps/kube-proxy patched (no change)"
    ]
}
Sunday 08 January 2023  08:58:45 -0500 (0:00:00.030)       0:40:32.240 ********

TASK [win_nodes/kubernetes_patch : debug] ******************************************************************************
ok: [node1] => {
    "msg": []
}

PLAY [kube_control_plane] **********************************************************************************************
Sunday 08 January 2023  08:58:45 -0500 (0:00:00.131)       0:40:32.372 ********
Sunday 08 January 2023  08:58:45 -0500 (0:00:00.022)       0:40:32.395 ********
Sunday 08 January 2023  08:58:45 -0500 (0:00:00.025)       0:40:32.420 ********
Sunday 08 January 2023  08:58:45 -0500 (0:00:00.018)       0:40:32.439 ********
Sunday 08 January 2023  08:58:45 -0500 (0:00:00.024)       0:40:32.464 ********
Sunday 08 January 2023  08:58:45 -0500 (0:00:00.018)       0:40:32.482 ********
Sunday 08 January 2023  08:58:45 -0500 (0:00:00.020)       0:40:32.502 ********
Sunday 08 January 2023  08:58:45 -0500 (0:00:00.021)       0:40:32.524 ********
Sunday 08 January 2023  08:58:45 -0500 (0:00:00.019)       0:40:32.544 ********
Sunday 08 January 2023  08:58:45 -0500 (0:00:00.018)       0:40:32.563 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.499)       0:40:33.062 ********

TASK [kubespray-defaults : Configure defaults] *************************************************************************
ok: [node1] => {
    "msg": "Check roles/kubespray-defaults/defaults/main.yml"
}
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.016)       0:40:33.121 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.034)       0:40:33.155 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.019)       0:40:33.175 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.022)       0:40:33.197 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.018)       0:40:33.216 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.018)       0:40:33.234 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.028)       0:40:33.262 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.103)       0:40:33.366 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.017)       0:40:33.383 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.015)       0:40:33.399 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.027)       0:40:33.426 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.040)       0:40:33.467 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.020)       0:40:33.488 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.018)       0:40:33.506 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.026)       0:40:33.533 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.018)       0:40:33.551 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.018)       0:40:33.570 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.037)       0:40:33.608 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.019)       0:40:33.627 ********
Sunday 08 January 2023  08:58:46 -0500 (0:00:00.046)       0:40:33.673 ********
Sunday 08 January 2023  08:58:47 -0500 (0:00:00.059)       0:40:33.733 ********
Sunday 08 January 2023  08:58:47 -0500 (0:00:00.024)       0:40:33.757 ********
Sunday 08 January 2023  08:58:47 -0500 (0:00:00.025)       0:40:33.782 ********
Sunday 08 January 2023  08:58:47 -0500 (0:00:00.038)       0:40:33.821 ********
Sunday 08 January 2023  08:58:47 -0500 (0:00:00.017)       0:40:33.839 ********
Sunday 08 January 2023  08:58:47 -0500 (0:00:00.033)       0:40:33.873 ********
Sunday 08 January 2023  08:58:47 -0500 (0:00:00.035)       0:40:33.909 ********
Sunday 08 January 2023  08:58:47 -0500 (0:00:00.028)       0:40:33.937 ********
Sunday 08 January 2023  08:58:47 -0500 (0:00:00.049)       0:40:33.987 ********
Sunday 08 January 2023  08:58:47 -0500 (0:00:00.021)       0:40:34.009 ********

TASK [policy_controller/calico : Create calico-kube-controllers manifests] *********************************************
changed: [node1] => (item={'name': 'calico-kube-controllers', 'file': 'calico-kube-controllers.yml', 'type': 'deployment'})
changed: [node1] => (item={'name': 'calico-kube-controllers', 'file': 'calico-kube-sa.yml', 'type': 'sa'})
changed: [node1] => (item={'name': 'calico-kube-controllers', 'file': 'calico-kube-cr.yml', 'type': 'clusterrole'})
changed: [node1] => (item={'name': 'calico-kube-controllers', 'file': 'calico-kube-crb.yml', 'type': 'clusterrolebinding'})
Sunday 08 January 2023  08:59:15 -0500 (0:00:28.539)       0:41:02.548 ********

TASK [policy_controller/calico : Start of Calico kube controllers] *****************************************************
ok: [node1] => (item=calico-kube-controllers.yml)
ok: [node1] => (item=calico-kube-sa.yml)
ok: [node1] => (item=calico-kube-cr.yml)
ok: [node1] => (item=calico-kube-crb.yml)
Sunday 08 January 2023  08:59:44 -0500 (0:00:28.456)       0:41:31.005 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.016)       0:41:31.021 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.016)       0:41:31.038 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.015)       0:41:31.053 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.017)       0:41:31.073 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.025)       0:41:31.098 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.016)       0:41:31.114 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.018)       0:41:31.132 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.010)       0:41:31.152 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.019)       0:41:31.172 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.017)       0:41:31.189 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.026)       0:41:31.216 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.018)       0:41:31.234 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.016)       0:41:31.259 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.049)       0:41:31.309 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.028)       0:41:31.337 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.017)       0:41:31.355 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.018)       0:41:31.373 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.019)       0:41:31.393 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.026)       0:41:31.420 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.017)       0:41:31.437 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.016)       0:41:31.453 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.017)       0:41:31.471 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.019)       0:41:31.491 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.015)       0:41:31.507 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.017)       0:41:31.524 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.016)       0:41:31.541 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.028)       0:41:31.569 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.026)       0:41:31.596 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.018)       0:41:31.614 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.015)       0:41:31.630 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.018)       0:41:31.649 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.016)       0:41:31.665 ********
Sunday 08 January 2023  08:59:44 -0500 (0:00:00.017)       0:41:31.683 ********
Sunday 08 January 2023  08:59:45 -0500 (0:00:00.020)       0:41:31.704 ********
Sunday 08 January 2023  08:59:45 -0500 (0:00:00.027)       0:41:31.731 ********
Sunday 08 January 2023  08:59:45 -0500 (0:00:00.018)       0:41:31.750 ********
Sunday 08 January 2023  08:59:45 -0500 (0:00:00.018)       0:41:31.768 ********
Sunday 08 January 2023  08:59:45 -0500 (0:00:00.017)       0:41:31.785 ********
Sunday 08 January 2023  08:59:45 -0500 (0:00:00.019)       0:41:31.805 ********
Sunday 08 January 2023  08:59:45 -0500 (0:00:00.017)       0:41:31.822 ********
Sunday 08 January 2023  08:59:45 -0500 (0:00:00.036)       0:41:31.858 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Wait for kube-apiserver] *********************************************
ok: [node1]
Sunday 08 January 2023  08:59:51 -0500 (0:00:05.856)       0:41:37.715 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Register coredns deployment annotation `createdby`] ******************
fatal: [node1]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/kubectl", "--kubeconfig", "/etc/kubernetes/admin.conf", "get", "deploy", "-n", "kube-system", "coredns", "-o", "jsonpath={ .spec.template.metadata.annotations.createdby }"], "delta": "0:00:01.028566", "end": "2023-01-08 13:59:54.724544", "msg": "non-zero return code", "rc": 1, "start": "2023-01-08 13:59:53.695978", "stderr": "Error from server (NotFound): deployments.apps \"coredns\" not found", "stderr_lines": ["Error from server (NotFound): deployments.apps \"coredns\" not found"], "stdout": "", "stdout_lines": []}
...ignoring
Sunday 08 January 2023  08:59:55 -0500 (0:00:04.095)       0:41:41.814 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Register coredns service annotation `createdby`] *********************
fatal: [node1]: FAILED! => {"changed": false, "cmd": ["/usr/local/bin/kubectl", "--kubeconfig", "/etc/kubernetes/admin.conf", "get", "svc", "-n", "kube-system", "coredns", "-o", "jsonpath={ .metadata.annotations.createdby }"], "delta": "0:00:01.021546", "end": "2023-01-08 13:59:58.180791", "msg": "non-zero return code", "rc": 1, "start": "2023-01-08 13:59:57.159245", "stderr": "Error from server (NotFound): services \"coredns\" not found", "stderr_lines": ["Error from server (NotFound): services \"coredns\" not found"], "stdout": "", "stdout_lines": []}
...ignoring
Sunday 08 January 2023  08:59:58 -0500 (0:00:03.208)       0:41:45.022 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Delete kubeadm CoreDNS] **********************************************
ok: [node1]
Sunday 08 January 2023  09:00:01 -0500 (0:00:03.554)       0:41:48.577 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Delete kubeadm Kube-DNS service] *************************************
ok: [node1]
Sunday 08 January 2023  09:00:07 -0500 (0:00:06.011)       0:41:54.589 ********

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
Sunday 08 January 2023  09:00:54 -0500 (0:00:46.693)       0:42:41.282 ********
Sunday 08 January 2023  09:00:54 -0500 (0:00:00.040)       0:42:41.323 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | set up necessary nodelocaldns parameters] ****************************
ok: [node1]
Sunday 08 January 2023  09:00:54 -0500 (0:00:00.059)       0:42:41.383 ********

TASK [kubernetes-apps/ansible : Kubernetes Apps | Lay Down nodelocaldns Template] **************************************
changed: [node1] => (item={'name': 'nodelocaldns', 'file': 'nodelocaldns-config.yml', 'type': 'configmap'})
changed: [node1] => (item={'name': 'nodelocaldns', 'file': 'nodelocaldns-sa.yml', 'type': 'sa'})
changed: [node1] => (item={'name': 'nodelocaldns', 'file': 'nodelocaldns-daemonset.yml', 'type': 'daemonset'})
Sunday 08 January 2023  09:01:15 -0500 (0:00:20.716)       0:43:02.100 ********
Sunday 08 January 2023  09:01:15 -0500 (0:00:00.027)       0:43:02.128 ********

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
Sunday 08 January 2023  09:02:24 -0500 (0:01:08.995)       0:44:11.124 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.027)       0:44:11.151 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.029)       0:44:11.180 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.021)       0:44:11.202 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.021)       0:44:11.223 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.019)       0:44:11.243 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.018)       0:44:11.261 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.019)       0:44:11.281 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.022)       0:44:11.303 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.022)       0:44:11.325 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.032)       0:44:11.357 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.019)       0:44:11.377 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.021)       0:44:11.399 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.023)       0:44:11.422 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.026)       0:44:11.449 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.017)       0:44:11.467 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.019)       0:44:11.486 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.016)       0:44:11.503 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.018)       0:44:11.521 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.018)       0:44:11.540 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.020)       0:44:11.560 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.018)       0:44:11.578 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.026)       0:44:11.604 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.019)       0:44:11.624 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.023)       0:44:11.648 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.021)       0:44:11.669 ********
Sunday 08 January 2023  09:02:24 -0500 (0:00:00.009)       0:44:11.696 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.018)       0:44:11.715 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.016)       0:44:11.731 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.018)       0:44:11.750 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.019)       0:44:11.769 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.018)       0:44:11.787 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.015)       0:44:11.803 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.019)       0:44:11.822 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.019)       0:44:11.842 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.019)       0:44:11.861 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.016)       0:44:11.878 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.016)       0:44:11.895 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.032)       0:44:11.928 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.015)       0:44:11.944 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.016)       0:44:11.961 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.017)       0:44:11.979 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.015)       0:44:11.995 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.017)       0:44:12.012 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.024)       0:44:12.037 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.028)       0:44:12.066 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.034)       0:44:12.100 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.018)       0:44:12.119 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.025)       0:44:12.144 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.017)       0:44:12.161 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.019)       0:44:12.181 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.035)       0:44:12.216 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.043)       0:44:12.259 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.024)       0:44:12.284 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.040)       0:44:12.324 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.017)       0:44:12.342 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.018)       0:44:12.360 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.015)       0:44:12.376 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.033)       0:44:12.410 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.039)       0:44:12.449 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.017)       0:44:12.467 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.018)       0:44:12.485 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.016)       0:44:12.502 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.025)       0:44:12.527 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.039)       0:44:12.566 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.019)       0:44:12.586 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.015)       0:44:12.602 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.027)       0:44:12.630 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.038)       0:44:12.669 ********
Sunday 08 January 2023  09:02:25 -0500 (0:00:00.017)       0:44:12.687 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.017)       0:44:12.705 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.030)       0:44:12.736 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.017)       0:44:12.754 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.025)       0:44:12.779 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.043)       0:44:12.823 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.018)       0:44:12.841 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.028)       0:44:12.870 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.016)       0:44:12.887 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.028)       0:44:12.915 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.018)       0:44:12.934 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.028)       0:44:12.963 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.018)       0:44:12.981 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.013)       0:44:13.008 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.019)       0:44:13.027 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.030)       0:44:13.058 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.017)       0:44:13.075 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.037)       0:44:13.112 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.019)       0:44:13.132 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.030)       0:44:13.163 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.038)       0:44:13.201 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.017)       0:44:13.219 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.039)       0:44:13.259 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.018)       0:44:13.278 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.018)       0:44:13.296 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.019)       0:44:13.316 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.030)       0:44:13.347 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.019)       0:44:13.367 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.018)       0:44:13.385 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.019)       0:44:13.405 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.028)       0:44:13.433 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.018)       0:44:13.451 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.029)       0:44:13.481 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.018)       0:44:13.499 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.038)       0:44:13.537 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.024)       0:44:13.562 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.102)       0:44:13.664 ********
Sunday 08 January 2023  09:02:26 -0500 (0:00:00.017)       0:44:13.681 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.017)       0:44:13.699 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.022)       0:44:13.722 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.042)       0:44:13.765 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.019)       0:44:13.784 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.018)       0:44:13.803 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.017)       0:44:13.821 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.017)       0:44:13.839 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.019)       0:44:13.858 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.018)       0:44:13.877 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.018)       0:44:13.896 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.016)       0:44:13.912 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.019)       0:44:13.932 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.018)       0:44:13.950 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.018)       0:44:13.968 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.018)       0:44:13.987 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.017)       0:44:14.004 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.016)       0:44:14.020 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.027)       0:44:14.048 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.018)       0:44:14.066 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.019)       0:44:14.086 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.017)       0:44:14.103 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.018)       0:44:14.122 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.018)       0:44:14.140 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.016)       0:44:14.157 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.018)       0:44:14.176 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.036)       0:44:14.212 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.018)       0:44:14.231 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.017)       0:44:14.248 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.019)       0:44:14.268 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.018)       0:44:14.287 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.024)       0:44:14.312 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.017)       0:44:14.329 ********

PLAY [Apply resolv.conf changes now that cluster DNS is up] ************************************************************
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.123)       0:44:14.452 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.046)       0:44:14.499 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.024)       0:44:14.524 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.019)       0:44:14.543 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.043)       0:44:14.587 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.052)       0:44:14.639 ********
Sunday 08 January 2023  09:02:27 -0500 (0:00:00.048)       0:44:14.688 ********
Sunday 08 January 2023  09:02:28 -0500 (0:00:00.043)       0:44:14.739 ********
Sunday 08 January 2023  09:02:28 -0500 (0:00:00.020)       0:44:14.763 ********
Sunday 08 January 2023  09:02:28 -0500 (0:00:00.046)       0:44:14.810 ********
Sunday 08 January 2023  09:02:28 -0500 (0:00:00.681)       0:44:15.492 ********

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
Sunday 08 January 2023  09:02:28 -0500 (0:00:00.050)       0:44:15.578 ********
Sunday 08 January 2023  09:02:28 -0500 (0:00:00.034)       0:44:15.613 ********
Sunday 08 January 2023  09:02:28 -0500 (0:00:00.019)       0:44:15.633 ********
Sunday 08 January 2023  09:02:28 -0500 (0:00:00.051)       0:44:15.684 ********
Sunday 08 January 2023  09:02:29 -0500 (0:00:00.018)       0:44:15.703 ********
Sunday 08 January 2023  09:02:29 -0500 (0:00:00.049)       0:44:15.753 ********
Sunday 08 January 2023  09:02:29 -0500 (0:00:00.069)       0:44:15.823 ********

TASK [adduser : User | Create User Group] ******************************************************************************
ok: [node3]
ok: [node1]
ok: [node4]
ok: [node2]
Sunday 08 January 2023  09:02:38 -0500 (0:00:09.385)       0:44:25.208 ********

TASK [adduser : User | Create User] ************************************************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  09:02:44 -0500 (0:00:05.559)       0:44:30.768 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.054)       0:44:30.823 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.044)       0:44:30.868 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.051)       0:44:30.920 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.046)       0:44:30.966 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.022)       0:44:30.989 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.017)       0:44:31.007 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.047)       0:44:31.054 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.047)       0:44:31.102 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.046)       0:44:31.148 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.047)       0:44:31.196 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.033)       0:44:31.230 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.045)       0:44:31.275 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.049)       0:44:31.324 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.045)       0:44:31.369 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.044)       0:44:31.414 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.045)       0:44:31.459 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.044)       0:44:31.504 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.047)       0:44:31.552 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.046)       0:44:31.598 ********
Sunday 08 January 2023  09:02:44 -0500 (0:00:00.045)       0:44:31.644 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.048)       0:44:31.693 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.045)       0:44:31.738 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.050)       0:44:31.789 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.016)       0:44:31.805 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.009)       0:44:31.822 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.017)       0:44:31.840 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.016)       0:44:31.857 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.020)       0:44:31.877 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.017)       0:44:31.894 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.017)       0:44:31.912 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.018)       0:44:31.930 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.044)       0:44:31.975 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.020)       0:44:31.995 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.047)       0:44:32.043 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.017)       0:44:32.060 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.017)       0:44:32.077 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.047)       0:44:32.125 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.044)       0:44:32.170 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.047)       0:44:32.217 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.045)       0:44:32.263 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.018)       0:44:32.281 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.112)       0:44:32.394 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.050)       0:44:32.444 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.044)       0:44:32.489 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.048)       0:44:32.537 ********
Sunday 08 January 2023  09:02:45 -0500 (0:00:00.041)       0:44:32.579 ********

TASK [kubernetes/preinstall : check if booted with ostree] *************************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  09:02:49 -0500 (0:00:03.621)       0:44:36.201 ********

TASK [kubernetes/preinstall : set is_fedora_coreos] ********************************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  09:02:53 -0500 (0:00:03.677)       0:44:39.879 ********

TASK [kubernetes/preinstall : set is_fedora_coreos] ********************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  09:02:53 -0500 (0:00:00.051)       0:44:39.933 ********

TASK [kubernetes/preinstall : check resolvconf] ************************************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  09:02:56 -0500 (0:00:03.381)       0:44:43.315 ********

TASK [kubernetes/preinstall : check existence of /etc/resolvconf/resolv.conf.d] ****************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  09:03:00 -0500 (0:00:03.690)       0:44:47.006 ********

TASK [kubernetes/preinstall : check status of /etc/resolv.conf] ********************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  09:03:04 -0500 (0:00:04.012)       0:44:51.023 ********

TASK [kubernetes/preinstall : get content of /etc/resolv.conf] *********************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  09:03:07 -0500 (0:00:03.268)       0:44:54.291 ********

TASK [kubernetes/preinstall : get currently configured nameservers] ****************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  09:03:07 -0500 (0:00:00.085)       0:44:54.377 ********

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
Sunday 08 January 2023  09:03:07 -0500 (0:00:00.057)       0:44:54.437 ********

TASK [kubernetes/preinstall : NetworkManager | Check if host has NetworkManager] ***************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  09:03:11 -0500 (0:00:03.596)       0:44:58.033 ********

TASK [kubernetes/preinstall : check systemd-resolved] ******************************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  09:03:14 -0500 (0:00:03.645)       0:45:01.679 ********

TASK [kubernetes/preinstall : set default dns if remove_default_searchdomains is false] ********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  09:03:15 -0500 (0:00:00.057)       0:45:01.736 ********

TASK [kubernetes/preinstall : set dns facts] ***************************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  09:03:15 -0500 (0:00:00.058)       0:45:01.795 ********

TASK [kubernetes/preinstall : check if kubelet is configured] **********************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  09:03:18 -0500 (0:00:03.395)       0:45:05.193 ********

TASK [kubernetes/preinstall : check if early DNS configuration stage] **************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  09:03:18 -0500 (0:00:00.058)       0:45:05.251 ********

TASK [kubernetes/preinstall : target resolv.conf files] ****************************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  09:03:18 -0500 (0:00:00.061)       0:45:05.312 ********
Sunday 08 January 2023  09:03:18 -0500 (0:00:00.044)       0:45:05.357 ********

TASK [kubernetes/preinstall : check if /etc/dhclient.conf exists] ******************************************************
ok: [node3]
ok: [node4]
ok: [node1]
ok: [node2]
Sunday 08 January 2023  09:03:23 -0500 (0:00:04.353)       0:45:09.711 ********
Sunday 08 January 2023  09:03:23 -0500 (0:00:00.047)       0:45:09.759 ********

TASK [kubernetes/preinstall : check if /etc/dhcp/dhclient.conf exists] *************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  09:03:26 -0500 (0:00:02.983)       0:45:12.742 ********

TASK [kubernetes/preinstall : target dhclient conf file for /etc/dhcp/dhclient.conf] ***********************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  09:03:26 -0500 (0:00:00.052)       0:45:12.794 ********
Sunday 08 January 2023  09:03:26 -0500 (0:00:00.116)       0:45:12.914 ********

TASK [kubernetes/preinstall : target dhclient hook file for Debian family] *********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  09:03:26 -0500 (0:00:00.053)       0:45:12.968 ********

TASK [kubernetes/preinstall : generate search domains to resolvconf] ***************************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  09:03:26 -0500 (0:00:00.053)       0:45:13.022 ********

TASK [kubernetes/preinstall : pick coredns cluster IP or default resolver] *********************************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  09:03:26 -0500 (0:00:00.094)       0:45:13.117 ********

TASK [kubernetes/preinstall : generate nameservers for resolvconf, including cluster DNS] ******************************
ok: [node1]
ok: [node2]
ok: [node3]
ok: [node4]
Sunday 08 January 2023  09:03:26 -0500 (0:00:00.061)       0:45:13.178 ********
Sunday 08 January 2023  09:03:26 -0500 (0:00:00.048)       0:45:13.227 ********

TASK [kubernetes/preinstall : gather os specific variables] ************************************************************
ok: [node1] => (item=/root/13.4/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
ok: [node2] => (item=/root/13.4/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
ok: [node3] => (item=/root/13.4/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
ok: [node4] => (item=/root/13.4/kubespray/roles/kubernetes/preinstall/vars/../vars/debian-11.yml)
Sunday 08 January 2023  09:03:26 -0500 (0:00:00.066)       0:45:13.293 ********
Sunday 08 January 2023  09:03:26 -0500 (0:00:00.317)       0:45:13.621 ********

TASK [kubernetes/preinstall : check /usr readonly] *********************************************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  09:03:30 -0500 (0:00:03.617)       0:45:17.238 ********
Sunday 08 January 2023  09:03:30 -0500 (0:00:00.051)       0:45:17.289 ********
Sunday 08 January 2023  09:03:30 -0500 (0:00:00.047)       0:45:17.337 ********
Sunday 08 January 2023  09:03:30 -0500 (0:00:00.047)       0:45:17.385 ********
Sunday 08 January 2023  09:03:30 -0500 (0:00:00.069)       0:45:17.455 ********
Sunday 08 January 2023  09:03:30 -0500 (0:00:00.047)       0:45:17.506 ********
Sunday 08 January 2023  09:03:30 -0500 (0:00:00.047)       0:45:17.554 ********
Sunday 08 January 2023  09:03:30 -0500 (0:00:00.046)       0:45:17.600 ********
Sunday 08 January 2023  09:03:30 -0500 (0:00:00.060)       0:45:17.661 ********
Sunday 08 January 2023  09:03:31 -0500 (0:00:00.059)       0:45:17.720 ********
Sunday 08 January 2023  09:03:31 -0500 (0:00:00.057)       0:45:17.778 ********

TASK [kubernetes/preinstall : Add domain/search/nameservers/options to resolv.conf] ************************************
changed: [node3]
changed: [node4]
changed: [node1]
changed: [node2]
Sunday 08 January 2023  09:03:34 -0500 (0:00:03.249)       0:45:21.027 ********

TASK [kubernetes/preinstall : Remove search/domain/nameserver options before block] ************************************
ok: [node3] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'options\\s'])
Sunday 08 January 2023  09:03:45 -0500 (0:00:11.186)       0:45:32.214 ********

TASK [kubernetes/preinstall : Remove search/domain/nameserver options after block] *************************************
ok: [node3] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node3] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'search\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'nameserver\\s'])
ok: [node4] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'domain\\s'])
ok: [node2] => (item=['/etc/resolv.conf', 'options\\s'])
ok: [node1] => (item=['/etc/resolv.conf', 'options\\s'])
Sunday 08 January 2023  09:03:57 -0500 (0:00:11.842)       0:45:44.056 ********
Sunday 08 January 2023  09:03:57 -0500 (0:00:00.054)       0:45:44.111 ********
Sunday 08 January 2023  09:03:57 -0500 (0:00:00.051)       0:45:44.162 ********
Sunday 08 January 2023  09:03:57 -0500 (0:00:00.048)       0:45:44.211 ********
Sunday 08 January 2023  09:03:57 -0500 (0:00:00.044)       0:45:44.256 ********
Sunday 08 January 2023  09:03:57 -0500 (0:00:00.048)       0:45:44.304 ********
Sunday 08 January 2023  09:03:57 -0500 (0:00:00.046)       0:45:44.350 ********
Sunday 08 January 2023  09:03:57 -0500 (0:00:00.056)       0:45:44.407 ********
Sunday 08 January 2023  09:03:57 -0500 (0:00:00.048)       0:45:44.455 ********
Sunday 08 January 2023  09:03:57 -0500 (0:00:00.050)       0:45:44.506 ********
Sunday 08 January 2023  09:03:57 -0500 (0:00:00.126)       0:45:44.632 ********
Sunday 08 January 2023  09:03:57 -0500 (0:00:00.044)       0:45:44.677 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.051)       0:45:44.728 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.047)       0:45:44.776 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.046)       0:45:44.823 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.049)       0:45:44.873 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.048)       0:45:44.921 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.047)       0:45:44.969 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.044)       0:45:45.013 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.048)       0:45:45.061 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.051)       0:45:45.113 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.044)       0:45:45.158 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.048)       0:45:45.206 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.043)       0:45:45.250 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.056)       0:45:45.306 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.045)       0:45:45.352 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.045)       0:45:45.397 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.042)       0:45:45.439 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.049)       0:45:45.489 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.046)       0:45:45.536 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.047)       0:45:45.583 ********
Sunday 08 January 2023  09:03:58 -0500 (0:00:00.046)       0:45:45.630 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.072)       0:45:45.702 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.045)       0:45:45.747 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.043)       0:45:45.790 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.043)       0:45:45.833 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.049)       0:45:45.883 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.046)       0:45:45.930 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.048)       0:45:45.979 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.046)       0:45:46.025 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.043)       0:45:46.069 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.047)       0:45:46.116 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.042)       0:45:46.159 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.051)       0:45:46.210 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.019)       0:45:46.230 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.044)       0:45:46.275 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.047)       0:45:46.322 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.047)       0:45:46.369 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.048)       0:45:46.418 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.130)       0:45:46.549 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.055)       0:45:46.605 ********
Sunday 08 January 2023  09:03:59 -0500 (0:00:00.050)       0:45:46.658 ********

TASK [kubernetes/preinstall : Configure dhclient to supersede search/domain/nameservers] *******************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  09:04:04 -0500 (0:00:04.513)       0:45:51.171 ********

TASK [kubernetes/preinstall : Configure dhclient hooks for resolv.conf (non-RH)] ***************************************
ok: [node3]
ok: [node4]
ok: [node2]
ok: [node1]
Sunday 08 January 2023  09:04:12 -0500 (0:00:07.749)       0:45:58.920 ********
Sunday 08 January 2023  09:04:12 -0500 (0:00:00.050)       0:45:58.970 ********
Sunday 08 January 2023  09:04:12 -0500 (0:00:00.047)       0:45:59.018 ********
Sunday 08 January 2023  09:04:12 -0500 (0:00:00.044)       0:45:59.063 ********
Sunday 08 January 2023  09:04:12 -0500 (0:00:00.000)       0:45:59.063 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | propagate resolvconf to k8s components] **************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  09:04:14 -0500 (0:00:02.600)       0:46:01.664 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | reload kubelet] **************************************************
changed: [node3]
changed: [node4]
changed: [node2]
changed: [node1]
Sunday 08 January 2023  09:04:21 -0500 (0:00:06.274)       0:46:07.939 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | kube-apiserver configured] ***************************************
ok: [node1]
Sunday 08 January 2023  09:04:24 -0500 (0:00:03.116)       0:46:11.055 ********

RUNNING HANDLER [kubernetes/preinstall : Preinstall | kube-controller configured] **************************************
ok: [node1]
Sunday 08 January 2023  09:04:27 -0500 (0:00:02.792)       0:46:13.848 ********
Sunday 08 January 2023  09:04:27 -0500 (0:00:00.048)       0:46:13.897 ********
Sunday 08 January 2023  09:04:27 -0500 (0:00:00.053)       0:46:13.950 ********
Sunday 08 January 2023  09:04:27 -0500 (0:00:00.048)       0:46:13.998 ********
FAILED - RETRYING: [node1]: Preinstall | restart kube-apiserver crio/containerd (10 retries left).

RUNNING HANDLER [kubernetes/preinstall : Preinstall | restart kube-apiserver crio/containerd] **************************
changed: [node1]
Sunday 08 January 2023  09:04:48 -0500 (0:00:21.513)       0:46:35.511 ********
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (60 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (59 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (58 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (57 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (56 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (55 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (54 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (53 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (52 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (51 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (50 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (49 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (48 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (47 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (46 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (45 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (44 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (43 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (42 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (41 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (40 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (39 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (38 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (37 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (36 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (35 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (34 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (33 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (32 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (31 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (30 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (29 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (28 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (27 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (26 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (25 retries left).
FAILED - RETRYING: [node1]: Preinstall | wait for the apiserver to be running (24 retries left).

RUNNING HANDLER [kubernetes/preinstall : Preinstall | wait for the apiserver to be running] ****************************
ok: [node1]
Sunday 08 January 2023  09:13:23 -0500 (0:08:35.017)       0:55:10.529 ********
Sunday 08 January 2023  09:13:23 -0500 (0:00:00.047)       0:55:10.577 ********
Sunday 08 January 2023  09:13:23 -0500 (0:00:00.047)       0:55:10.625 ********
Sunday 08 January 2023  09:13:23 -0500 (0:00:00.049)       0:55:10.675 ********
Sunday 08 January 2023  09:13:24 -0500 (0:00:00.047)       0:55:10.722 ********
Sunday 08 January 2023  09:13:24 -0500 (0:00:00.051)       0:55:10.773 ********
Sunday 08 January 2023  09:13:24 -0500 (0:00:00.042)       0:55:10.816 ********
Sunday 08 January 2023  09:13:24 -0500 (0:00:00.049)       0:55:10.865 ********
Sunday 08 January 2023  09:13:24 -0500 (0:00:00.044)       0:55:10.910 ********

TASK [Run calico checks] ***********************************************************************************************
Sunday 08 January 2023  09:13:24 -0500 (0:00:00.386)       0:55:11.296 ********

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (ipip)] ******************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  09:13:24 -0500 (0:00:00.035)       0:55:11.332 ********

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (ipip_mode)] *************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  09:13:24 -0500 (0:00:00.037)       0:55:11.369 ********

TASK [network_plugin/calico : Stop if legacy encapsulation variables are detected (calcio_ipam_autoallocateblocks)] ****
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  09:13:24 -0500 (0:00:00.034)       0:55:11.404 ********
Sunday 08 January 2023  09:13:24 -0500 (0:00:00.024)       0:55:11.428 ********

TASK [network_plugin/calico : Stop if supported Calico versions] *******************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  09:13:24 -0500 (0:00:00.137)       0:55:11.566 ********
ASYNC OK on node1: jid=317066611728.30537

TASK [network_plugin/calico : Get current calico cluster version] ******************************************************
ok: [node1]
Sunday 08 January 2023  09:13:37 -0500 (0:00:12.537)       0:55:24.103 ********

TASK [network_plugin/calico : Check that current calico version is enough for upgrade] *********************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  09:13:37 -0500 (0:00:00.043)       0:55:24.146 ********
Sunday 08 January 2023  09:13:37 -0500 (0:00:00.030)       0:55:24.177 ********
Sunday 08 January 2023  09:13:37 -0500 (0:00:00.028)       0:55:24.205 ********

TASK [network_plugin/calico : Check vars defined correctly] ************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  09:13:37 -0500 (0:00:00.035)       0:55:24.241 ********

TASK [network_plugin/calico : Check calico network backend defined correctly] ******************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  09:13:37 -0500 (0:00:00.036)       0:55:24.277 ********

TASK [network_plugin/calico : Check ipip and vxlan mode defined correctly] *********************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  09:13:37 -0500 (0:00:00.037)       0:55:24.315 ********
Sunday 08 January 2023  09:13:37 -0500 (0:00:00.026)       0:55:24.341 ********

TASK [network_plugin/calico : Check ipip and vxlan mode if simultaneously enabled] *************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  09:13:37 -0500 (0:00:00.037)       0:55:24.379 ********

TASK [network_plugin/calico : Get Calico default-pool configuration] ***************************************************
ok: [node1]
Sunday 08 January 2023  09:13:40 -0500 (0:00:03.030)       0:55:27.409 ********

TASK [network_plugin/calico : Set calico_pool_conf] ********************************************************************
ok: [node1]
Sunday 08 January 2023  09:13:40 -0500 (0:00:00.042)       0:55:27.452 ********

TASK [network_plugin/calico : Check if inventory match current cluster configuration] **********************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Sunday 08 January 2023  09:13:40 -0500 (0:00:00.030)       0:55:27.494 ********
Sunday 08 January 2023  09:13:40 -0500 (0:00:00.028)       0:55:27.522 ********
Sunday 08 January 2023  09:13:40 -0500 (0:00:00.026)       0:55:27.549 ********

PLAY RECAP *************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node1                      : ok=727  changed=144  unreachable=0    failed=0    skipped=1258 rescued=0    ignored=8
node2                      : ok=505  changed=90   unreachable=0    failed=0    skipped=776  rescued=0    ignored=1
node3                      : ok=505  changed=90   unreachable=0    failed=0    skipped=775  rescued=0    ignored=1
node4                      : ok=505  changed=90   unreachable=0    failed=0    skipped=775  rescued=0    ignored=1

Sunday 08 January 2023  09:13:40 -0500 (0:00:00.078)       0:55:27.628 ********
===============================================================================
kubernetes/preinstall : Preinstall | wait for the apiserver to be running ------------------------------------- 515.02s
kubernetes/preinstall : Install packages requirements --------------------------------------------------------- 189.59s
kubernetes/control-plane : kubeadm | Initialize first master -------------------------------------------------- 108.10s
download : download_container | Download image if required ----------------------------------------------------- 93.45s
kubernetes-apps/ansible : Kubernetes Apps | Start Resources ---------------------------------------------------- 69.00s
bootstrap-os : Update Apt cache -------------------------------------------------------------------------------- 53.33s
download : download_container | Download image if required ----------------------------------------------------- 48.70s
download : download_container | Download image if required ----------------------------------------------------- 47.40s
download : download_container | Download image if required ----------------------------------------------------- 47.36s
kubernetes-apps/ansible : Kubernetes Apps | Lay Down CoreDNS templates ----------------------------------------- 46.69s
network_plugin/calico : Wait for calico kubeconfig to be created ----------------------------------------------- 40.66s
download : download_container | Download image if required ----------------------------------------------------- 37.96s
download : download_container | Download image if required ----------------------------------------------------- 37.46s
kubernetes/control-plane : Master | wait for kube-scheduler ---------------------------------------------------- 36.45s
network_plugin/cni : CNI | Copy cni plugins -------------------------------------------------------------------- 31.58s
network_plugin/calico : Start Calico resources ----------------------------------------------------------------- 29.68s
policy_controller/calico : Create calico-kube-controllers manifests -------------------------------------------- 28.54s
policy_controller/calico : Start of Calico kube controllers ---------------------------------------------------- 28.46s
download : download_file | Download item ----------------------------------------------------------------------- 25.21s
kubernetes/kubeadm : Join to cluster --------------------------------------------------------------------------- 24.86s

PLAY [Get control plane config] ****************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [node1]

TASK [Copy default admin config] ***************************************************************************************
changed: [node1]

PLAY RECAP *************************************************************************************************************
node1                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

+----------------------+---------------+---------------+---------+----------------+-------------+
|          ID          |     NAME      |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+---------------+---------------+---------+----------------+-------------+
| fhm7mat0c9s1fji8qg8u | kube-master-1 | ru-central1-a | RUNNING | 51.250.73.59   | 10.2.0.21   |
| fhm8sj6lq0tbd2gkmfu8 | kube-worker-1 | ru-central1-a | RUNNING | 158.160.40.142 | 10.2.0.14   |
| fhmaq8ancnu84n5gki0c | kube-worker-3 | ru-central1-a | RUNNING | 158.160.47.243 | 10.2.0.4    |
| fhmc4gfm26rq51qb2o22 | kube-worker-2 | ru-central1-a | RUNNING | 158.160.35.238 | 10.2.0.7    |
+----------------------+---------------+---------------+---------+----------------+-------------+

root@debian11:~/13.4# mv ~/.kube/_config_from_node1 ~/.kube/config
root@debian11:~/13.4# nano ~/.kube/config
root@debian11:~/13.4# kubectl get nodes
NAME    STATUS   ROLES           AGE    VERSION
node1   Ready    control-plane   19m    v1.25.5
node2   Ready    <none>          16m    v1.25.5
node3   Ready    <none>          16m    v1.25.5
node4   Ready    <none>          16m    v1.25.5
root@debian11:~/13.4#
root@debian11:~/13.4# ./go.sh nfs
--- Add helm repo ---
"stable" has been added to your repositories
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈
--- Install NFS-common package ---

PLAY [Install NFS-common library] **************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [node3]
ok: [node4]
ok: [node2]

TASK [try universal package manager plugin] ****************************************************************************
changed: [node3]
changed: [node2]
changed: [node4]

PLAY RECAP *************************************************************************************************************
node2                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node3                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node4                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

--- Install NFS server provisioner ---
WARNING: This chart is deprecated
Release "nfs-server" has been upgraded. Happy Helming!
NAME: nfs-server
LAST DEPLOYED: Sun Jan  8 11:13:58 2023
NAMESPACE: default
STATUS: deployed
REVISION: 2
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
root@debian11:~/13.4#
```