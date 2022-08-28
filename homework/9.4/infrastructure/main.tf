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

resource "yandex_compute_image" "os-centos" {
  name          = "os-centos-stream"
  source_family = "centos-stream-8"
}

module "jen-master" {
  source = "./vm-instance"

  name        = "jenkins-master-01"
  user        = "centos"
  description = "Jenkins Master"
  cpu         = 2
  ram         = 2
  cpu_load    = 5
  main_disk_image = yandex_compute_image.os-centos.id
  main_disk_size  = 10
  subnet      = yandex_vpc_subnet.my-subnet.id
}

module "jen-slave" {
  source = "./vm-instance"

  count       = 1

  name        = "jenkins-agent-${format("%02d", count.index + 1)}"
  user        = "centos"
  description = "Jenkins Slave Node ${count.index + 1}"
  cpu         = 2
  ram         = 4
  cpu_load    = 20
  main_disk_image = yandex_compute_image.os-centos.id
  main_disk_size  = 10
  subnet      = yandex_vpc_subnet.my-subnet.id
}

output "master_ip" {
  value = module.jen-master.external_ip
}

output "slave_ip" {
  value = module.jen-slave[*].external_ip
}
