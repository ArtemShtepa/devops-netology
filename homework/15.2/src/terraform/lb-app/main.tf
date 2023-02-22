variable target_group_id { default = "" }
variable zone { default = "" }
variable net_id { default = "" }
variable subnet_id { default = "" }

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.70"
    }
  }
  required_version = ">= 0.13"
}

# Создание самого балансировщика
resource "yandex_alb_load_balancer" "lamp-al-balancer" {
  name        = "lamp-alb"
  network_id  = var.net_id

  # Политика размещения
  allocation_policy {
    location {
      zone_id   = var.zone
      subnet_id = var.subnet_id
    }
  }

  # Настройка "слушателя"
  listener {
    name = "lamp-alb-listener"
    endpoint {
      address {
        external_ipv4_address { }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.alb-router.id
      }
    }
  }
}

# Создания ресурса http роутера
resource "yandex_alb_http_router" "alb-router" {
  name = "alb-http-router"
}

# Создание backend для группы ВМ
resource "yandex_alb_backend_group" "alb-backend-group" {
  name = "alb-group"

  http_backend {
    name   = "alb-backend"
    weight = 1
    port   = 80
    target_group_ids = [var.target_group_id]
    load_balancing_config {
      panic_threshold = 50
    }    
    healthcheck {
      timeout = "1s"
      interval = "10s"
      http_healthcheck {
        path  = "/"
      }
    }
    http2 = "false"
  }
}

# Создание виртуального хоста
resource "yandex_alb_virtual_host" "alb-virtual-host" {
  name = "alb-virtual-host"
  http_router_id = yandex_alb_http_router.alb-router.id

  route {
    name = "alb-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.alb-backend-group.id
        timeout = "3s"
      }
    }
  }
}

output "balancer-ip" {
  value = [for l in yandex_alb_load_balancer.lamp-al-balancer.listener: l.endpoint[0].address].0[0].external_ipv4_address[0].address
}
