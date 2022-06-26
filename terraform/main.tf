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

module "vm-master" {
  source = "./vm-instance"

  for_each = local.master_nodes

  name        = "master-${each.key}"
  description = "Master Node - ${each.key}"
  cpu         = local.instance_cpu_cores[terraform.workspace]
  ram         = local.instance_ram[terraform.workspace]
  cpu_load    = local.instance_core_frac[terraform.workspace]
  main_disk_image = yandex_compute_image.d11-image.id
  main_disk_size  = local.primary_disk[terraform.workspace]
  subnet      = yandex_vpc_subnet.my-subnet.id
}

module "vm-dn" {
  source = "./vm-instance"

  count       = local.instance_count[terraform.workspace]
  name        = "node-${format("%01d", count.index + 1)}"
  description = "Data Node ${count.index + 1}"
  cpu         = local.instance_cpu_cores[terraform.workspace]
  ram         = local.instance_ram[terraform.workspace]
  cpu_load    = local.instance_core_frac[terraform.workspace]
  main_disk_image = yandex_compute_image.d11-image.id
  main_disk_size  = local.primary_disk[terraform.workspace]
  ext_disk_id     = toset(["${yandex_compute_disk.blank-disk[count.index].id}"])
  subnet      = yandex_vpc_subnet.my-subnet.id

  depends_on = [
    yandex_compute_disk.blank-disk
  ]
}
