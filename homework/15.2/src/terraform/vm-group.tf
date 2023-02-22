# Создание группы ВМ фиксированного размера
resource "yandex_compute_instance_group" "vm-group" {
  name               = "fixed-ig"
  folder_id          = var.YC_FOLDER_ID
  service_account_id = yandex_iam_service_account.sa.id
  depends_on         = [yandex_resourcemanager_folder_iam_binding.sa-editor]

  # Шаблон ВМ
  instance_template {
    platform_id = "standard-v1"
    name = "vm-instance-{instance.index}"

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8i0dacbfhkd73r1dhq"
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.my-net.id}"
      subnet_ids = ["${yandex_vpc_subnet.public-subnet.id}"]
    }

    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
      user-data = file("./../files/cloud-init.yaml")
    }
  }

  # Политика масштабирования
  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  # Политики распределения
  allocation_policy {
    zones = [var.YC_ZONE]
  }

  # Политика развёртывания
  deploy_policy {
    max_unavailable = 1
    max_expansion = 0
  }

  # Проверка состояния
  health_check {
    interval = 20
    timeout = 1
    healthy_threshold = 2
    unhealthy_threshold = 3
    http_options {
      path = "/index.html"
      port = 80
    }
  }

  # Создание целевой группы для L7 балансировщика
  dynamic "application_load_balancer" {
    for_each = var.LB_TYPE == "app" ? toset([1]) : toset([]) 
    content {
      target_group_name = "load-balancer-group"
    }
  }
  # Создание целевой группы для сетевого балансировщика
  dynamic "load_balancer" {
    for_each = var.LB_TYPE == "net" ? toset([1]) : toset([])
    content {
      target_group_name = "load-balancer-group"
    }
  }
}

# Вывод IP адресов ВИ группы
output "vm-group-ip" {
  value = "${yandex_compute_instance_group.vm-group.instances[*].network_interface[0].ip_address}"
}
