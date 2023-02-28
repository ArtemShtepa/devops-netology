# Создание симметричного ключа шифрования
resource "yandex_kms_symmetric_key" "kube-key" {
  name              = "kube-kms-key"
  default_algorithm = "AES_256"
  rotation_period   = "720h"
}

# Создание кластера Kubernetes
resource "yandex_kubernetes_cluster" "kube-cluster" {
  name        = "kube-cluster"
  description = "Kubernetes Test Cluster"

  network_id = yandex_vpc_network.my-net.id

  # Размещение ControlPlane - региональное
  master {
    regional {
      region = "ru-central1"
      location {
        zone      = "ru-central1-a"
        subnet_id = yandex_vpc_subnet.kube-sn-a.id
      }
      location {
        zone      = "ru-central1-b"
        subnet_id = yandex_vpc_subnet.kube-sn-b.id
      }
      location {
        zone      = "ru-central1-c"
        subnet_id = yandex_vpc_subnet.kube-sn-c.id
      }
    }

    version   = var.KUBE_VERSION
    public_ip = true

    # Политика обновления
    maintenance_policy {
      auto_upgrade = "false"
    }
  }

  service_account_id      = yandex_iam_service_account.sa.id
  node_service_account_id = yandex_iam_service_account.sa.id
  kms_provider {
    key_id = yandex_kms_symmetric_key.kube-key.id
  }

  release_channel = "STABLE"
}

# Создание рабочей группы А нод кластера Kubernetes
module "kube-node-group-a" {
  source = "./node-group"

  kube_version   = var.KUBE_VERSION
  cluster_id     = yandex_kubernetes_cluster.kube-cluster.id
  zone_name      = "ru-central1-a"
  zone_subnet_id = yandex_vpc_subnet.kube-sn-a.id
  group_name     = "kube-node-group-a"
  group_desc     = "Kubernetes Node Group A"
}

# Создание рабочей группы Б нод кластера Kubernetes
module "kube-node-group-b" {
  source = "./node-group"

  kube_version   = var.KUBE_VERSION
  cluster_id     = yandex_kubernetes_cluster.kube-cluster.id
  zone_name      = "ru-central1-b"
  zone_subnet_id = yandex_vpc_subnet.kube-sn-b.id
  group_name     = "kube-node-group-b"
  group_desc     = "Kubernetes Node Group B"
}

# Создание рабочей группы В нод кластера Kubernetes
module "kube-node-group-c" {
  source = "./node-group"

  kube_version   = var.KUBE_VERSION
  cluster_id     = yandex_kubernetes_cluster.kube-cluster.id
  zone_name      = "ru-central1-c"
  zone_subnet_id = yandex_vpc_subnet.kube-sn-c.id
  group_name     = "kube-node-group-c"
  group_desc     = "Kubernetes Node Group C"
}
