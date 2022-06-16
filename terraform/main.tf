variable "YC_TOKEN" { default = "" }
variable "YC_CLOUD_ID" { default = "" }
variable "YC_FOLDER_ID" { default = "" }
variable "YC_ZONE" { default = "" }

provider "yandex" {
  token     = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = var.YC_ZONE
}

resource "yandex_compute_image" "d11-image" {
  name          = "debian11-image"
  source_family = "debian-11"
}

resource "yandex_vpc_network" "d11-net" {}

resource "yandex_vpc_subnet" "d11-subnet" {
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = var.YC_ZONE
  network_id     = "${yandex_vpc_network.d11-net.id}"
}

resource "yandex_compute_instance" "d11-vm" {
  name        = "debian-11"
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = "${yandex_compute_image.d11-image.id}"
      name     = "d11-boot-disk"
      type     = "network-hdd"
      size     = 20
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.d11-subnet.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "d11-user:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "external_ip_address" {
  value = "${yandex_compute_instance.d11-vm.network_interface.0.nat_ip_address}"
}