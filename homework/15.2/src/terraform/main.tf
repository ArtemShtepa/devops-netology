variable "YC_TOKEN" { default = "" }
variable "YC_CLOUD_ID" { default = "" }
variable "YC_FOLDER_ID" { default = "" }
variable "YC_ZONE" { default = "" }
variable "NAT_GATEWAY" { default = "192.168.10.254" }
variable "LB_TYPE" { default = "app" } # Can be 'net' or 'app'

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

module nlb {
  count = var.LB_TYPE == "net" ? 1 : 0
  source = "./lb-net"

  target_group_id = yandex_compute_instance_group.vm-group.load_balancer[0].target_group_id
}

module alb {
  count = var.LB_TYPE == "app" ? 1 : 0
  source = "./lb-app"

  target_group_id = yandex_compute_instance_group.vm-group.application_load_balancer[0].target_group_id
  zone = var.YC_ZONE
  net_id = yandex_vpc_network.my-net.id
  subnet_id = yandex_vpc_subnet.public-subnet.id
}

output "balancer-ip" {
  value = var.LB_TYPE == "net" ? module.nlb[*].balancer-ip : module.alb[*].balancer-ip
}
