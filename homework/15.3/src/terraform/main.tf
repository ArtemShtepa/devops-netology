variable "YC_TOKEN" { default = "" }
variable "YC_CLOUD_ID" { default = "" }
variable "YC_FOLDER_ID" { default = "" }
variable "YC_ZONE" { default = "" }

variable "NAT_GATEWAY" { default = "192.168.10.254" }

variable "BUCKET"   { default = "artem-shtepa-2023-02" }
variable "CRYPT"    { default = "" }                     # 'true' to enable encryption
variable "DOMAIN"   { default = "storage.hwolf.ru" }     # set '' to use YC domain
variable "USE_CERT" { default = "true" }                 # 'true' to use certificate

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.70"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = var.YC_ZONE
}

module cert {
  source = "./cert"
  count = var.USE_CERT == "true" ? 1 : 0

  DOMAINS = var.DOMAIN == "" ? [format("%s.website.yandexcloud.net", var.BUCKET)] : [var.DOMAIN]
}
