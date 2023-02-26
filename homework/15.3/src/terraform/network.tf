resource "yandex_vpc_network" "my-net" {
  name = "master-network"
}

resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.YC_ZONE
  network_id     = yandex_vpc_network.my-net.id
}
