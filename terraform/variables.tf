variable "YC_TOKEN" { default = "" }
variable "YC_CLOUD_ID" { default = "" }
variable "YC_FOLDER_ID" { default = "" }
variable "YC_ZONE" { default = "" }

locals {
  instance_count = {
    stage = 1
    prod  = 2
  }
  instance_cpu_cores = {
    stage = 2
    prod  = 4
  }
  instance_core_frac = {
    stage = 20
    prod  = 100
  }
  instance_ram = {
    stage = 4
    prod  = 8
  }
  primary_disk = {
    stage = 10
    prod  = 20
  }
  node_disk = {
    stage = 20
    prod  = 80
  }
  master_nodes = toset(["main", "reserved"])
}
