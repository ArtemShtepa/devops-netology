resource "yandex_vpc_network" "my-net" {
  name = "cluster-network"
}

resource "yandex_vpc_subnet" "my-subnet" {
  name           = "cluster-subnet"
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = var.YC_ZONE
  network_id     = yandex_vpc_network.my-net.id
}

resource "yandex_compute_image" "d11-image" {
  name          = "debian11-image"
  source_family = "debian-11"
}

resource "yandex_compute_disk" "blank-disk" {
  count = local.instance_count[terraform.workspace]

  name  = "node-disk-${count.index + 1}"
  type  = "network-hdd"
  zone  = var.YC_ZONE
  size  = local.node_disk[terraform.workspace]
}

resource "yandex_compute_instance" "vm-master" {
  for_each = local.master_nodes

  name        = "master-${each.key}"
  description = "Master Node - ${each.key}"
  platform_id = "standard-v1"

  resources {
    cores         = local.instance_cpu_cores[terraform.workspace]
    memory        = local.instance_ram[terraform.workspace]
    core_fraction = local.instance_core_frac[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.d11-image.id
      type     = "network-hdd"
      size     = local.primary_disk[terraform.workspace]
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.my-subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "d11-user:${file("~/.ssh/id_rsa.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "yandex_compute_instance" "vm-dn" {
  name        = "node-${format("%01d", count.index + 1)}"
  description = "Data Node ${count.index + 1}"
  platform_id = "standard-v1"
  count       = local.instance_count[terraform.workspace]

  resources {
    cores         = local.instance_cpu_cores[terraform.workspace]
    memory        = local.instance_ram[terraform.workspace]
    core_fraction = local.instance_core_frac[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.d11-image.id
      type     = "network-hdd"
      size     = local.primary_disk[terraform.workspace]
    }
  }

  secondary_disk {
    disk_id = "${yandex_compute_disk.blank-disk[count.index].id}"
    device_name = "data"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.my-subnet.id
    nat       = true
  }

  depends_on = [
    yandex_compute_disk.blank-disk
  ]
}