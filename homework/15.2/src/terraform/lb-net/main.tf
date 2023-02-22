variable "target_group_id" { default = "" }

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.70"
    }
  }
  required_version = ">= 0.13"
}

# Создание целевой группы для балансировщика
# Используется только при отсутствии в ресурсе instance_group параметра load_balancer
#resource "yandex_lb_target_group" "lamp-nl-balancer-group" {
# name      = "lamp-nlb-group"
#  region_id = "ru-central1"
#
#  dynamic "target" {
#    for_each = yandex_compute_instance_group.vm-group.instances
#    content {
#      subnet_id = yandex_vpc_subnet.public-subnet.id
#      address   = target.value.network_interface[0].ip_address
#    }
#  }
#}

# Создание самого балансировщика
resource "yandex_lb_network_load_balancer" "lamp-nl-balancer" {
  name = "lamp-nlb"

  # Настройка "слушателя"
  listener {
    name = "lamp-nlb-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Добавление целевой группы и настройка для неё проверки состояния
  attached_target_group {
    # Используется при автоматическом создании целевой группы в instance_group
    #target_group_id = yandex_compute_instance_group.vm-group.load_balancer[0].target_group_id    
    # Используется при ручном создани целевой группы
    #target_group_id = yandex_lb_target_group.lamp-nl-balancer-group.id

    target_group_id = var.target_group_id
    healthcheck {
      name = "lamp-nlb-healthcheck"
      http_options {
        port = 80
        path = "/index.php"
      }
    }
  }
}

output "balancer-ip" {
  value = [for l in yandex_lb_network_load_balancer.lamp-nl-balancer.listener: l.external_address_spec.*.address].0[0]
}
