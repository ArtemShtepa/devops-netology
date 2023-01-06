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

resource "yandex_vpc_network" "my-net" {
  name = "cluster-network"
}

resource "yandex_vpc_subnet" "my-subnet" {
  name           = "cluster-subnet"
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = var.YC_ZONE
  network_id     = yandex_vpc_network.my-net.id
}

resource "yandex_compute_image" "os-disk" {
  name          = "os-disk"
  source_family = "debian-11"
}

module "kube-master" {
  source = "./vm-instance"

  count       = 1

  name        = "kube-master-${format("%d", count.index + 1)}"
  user        = "debian"
  description = "Master Node"
  cpu         = 2
  ram         = 2
  cpu_load    = 5
  main_disk_image = yandex_compute_image.os-disk.id
  main_disk_size  = 10
  subnet      = yandex_vpc_subnet.my-subnet.id
}

module "kube-worker" {
  source = "./vm-instance"

  count       = 3

  name        = "kube-worker-${format("%d", count.index + 1)}"
  user        = "debian"
  description = "Worker Node ${count.index + 1}"
  cpu         = 2
  ram         = 2
  cpu_load    = 5
  main_disk_image = yandex_compute_image.os-disk.id
  main_disk_size  = 20
  subnet      = yandex_vpc_subnet.my-subnet.id
}

output "master_ip" {
  value = module.kube-master[*].external_ip
}

output "master_internal_ip" {
  value = module.kube-master[*].internal_ip
}

output "worker_ip" {
  value = module.kube-worker[*].external_ip
}

output "worker_internal_ip" {
  value = module.kube-worker[*].internal_ip
}
