variable "YC_TOKEN" { default = "" }
variable "YC_CLOUD_ID" { default = "" }
variable "YC_FOLDER_ID" { default = "" }
variable "YC_ZONE" { default = "" }
variable "NAT_GATEWAY" { default = "192.168.10.254" }

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

output "SSH_Bastion" {
  value = "ssh -J ${module.vm-nat-gateway.user}@${module.vm-nat-gateway.external_ip} ${module.vm-private.user}@${module.vm-private.internal_ip}"
}
