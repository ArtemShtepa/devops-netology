variable kube_version { default = "1.23" }
variable cluster_id { default = "" }
variable zone_name { default = "" }
variable zone_subnet_id { default = "" }
variable group_name { default = "" }
variable group_desc { default = "" }
variable group_min { default = 1 }
variable group_max { default = 2 }
variable instance_platform { default = "standard-v1" }
variable instance_cpu { default = 2 }
variable instance_mem { default = 2 }
variable instance_disk { default = 50 }

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.70"
    }
  }
  required_version = ">= 0.13"
}

# Создание рабочей группы кластера Kubernetes
resource "yandex_kubernetes_node_group" "kube-node-group" {
  cluster_id  = var.cluster_id
  name        = var.group_name
  description = var.group_desc
  version     = var.kube_version

  instance_template {
    platform_id = var.instance_platform

    network_interface {
      nat         = true
      subnet_ids  = [var.zone_subnet_id]
    }

    resources {
      memory = var.instance_mem
      cores  = var.instance_cpu
    }

    boot_disk {
      type = "network-hdd"
      size = var.instance_disk
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      min = var.group_min
      initial = var.group_min
      max = var.group_max
    }
  }

  allocation_policy {
    location {
      zone = var.zone_name
    }
  }

  maintenance_policy {
    auto_upgrade = "false"
    auto_repair = "true"

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }
  }
}
