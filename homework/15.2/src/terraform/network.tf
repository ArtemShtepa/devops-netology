resource "yandex_vpc_network" "my-net" {
  name = "master-network"
}

resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.YC_ZONE
  network_id     = yandex_vpc_network.my-net.id
}

# resource "yandex_vpc_subnet" "private-subnet" {
#   name           = "private"
#   v4_cidr_blocks = ["192.168.20.0/24"]
#   zone           = var.YC_ZONE
#   network_id     = yandex_vpc_network.my-net.id
#   route_table_id = yandex_vpc_route_table.rt.id
# }

# resource "yandex_vpc_route_table" "rt" {
#   name       = "route-table"
#   network_id = yandex_vpc_network.my-net.id
#
#   static_route {
#     destination_prefix = "0.0.0.0/0"
#     next_hop_address   = module.vm-nat-gateway.internal_ip
#   }
# }

# module "vm-nat-gateway" {
#   source = "./vm-instance"
#
#   name        = "nat-gateway"
#   user        = "ubuntu"
#   description = "NAT Gateway"
#   cpu         = 2
#   ram         = 2
#   cpu_load    = 5
#   ip          = var.NAT_GATEWAY
#   nat         = "true"
#   subnet      = yandex_vpc_subnet.public-subnet.id
#   main_disk_image = "fd80mrhj8fl2oe87o4e1"
#   main_disk_size  = 10
# }
