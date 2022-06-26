output "master_main_external_ip_address" {
  value = module.vm-master["main"].external_ip
}

output "master_reserved_external_ip_address" {
  value = module.vm-master["reserved"].external_ip
}

output "DN_external_ip_address" {
  value = module.vm-dn[*].external_ip
}
