output "master_main_external_ip_address" {
  value = yandex_compute_instance.vm-master["main"].network_interface.0.nat_ip_address
}

output "master_reserved_external_ip_address" {
  value = yandex_compute_instance.vm-master["reserved"].network_interface.0.nat_ip_address
}

output "DN_external_ip_address" {
  value = yandex_compute_instance.vm-dn[*].network_interface.0.nat_ip_address
}
