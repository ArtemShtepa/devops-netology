# Создание сети
resource "yandex_vpc_network" "my-net" {
  name = "master-network"
}

# Создание подсети А для MySQL
resource "yandex_vpc_subnet" "mysql-sn-a" {
  name           = "mysql-subnet-a"
  v4_cidr_blocks = ["192.168.21.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.my-net.id
}

# Создание подсети Б для MySQL
resource "yandex_vpc_subnet" "mysql-sn-b" {
  name           = "mysql-subnet-b"
  v4_cidr_blocks = ["192.168.22.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.my-net.id
}

# Создание подсети А для Kubernetes
resource "yandex_vpc_subnet" "kube-sn-a" {
  name           = "kube-subnet-a"
  v4_cidr_blocks = ["192.168.11.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.my-net.id
}

# Создание подсети Б для Kubernetes
resource "yandex_vpc_subnet" "kube-sn-b" {
  name           = "kube-subnet-b"
  v4_cidr_blocks = ["192.168.12.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.my-net.id
}

# Создание подсети В для Kubernetes
resource "yandex_vpc_subnet" "kube-sn-c" {
  name           = "kube-subnet-c"
  v4_cidr_blocks = ["192.168.13.0/24"]
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.my-net.id
}
