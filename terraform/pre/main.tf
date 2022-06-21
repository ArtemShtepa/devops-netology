variable "YC_TOKEN" { default = "" }
variable "YC_CLOUD_ID" { default = "" }
variable "YC_FOLDER_ID" { default = "" }
variable "YC_ZONE" { default = "" }

resource "yandex_iam_service_account" "sa" {
  name        = "sa-netology"
  description = "Service account"
  folder_id   = var.YC_FOLDER_ID
}

resource "yandex_resourcemanager_folder_iam_binding" "sa-role" {
  folder_id = var.YC_FOLDER_ID
  role = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa.id}",
  ]
  depends_on = [
    yandex_iam_service_account.sa
  ]
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
}

resource "yandex_storage_bucket" "s3-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "my-terraform-bucket"
}

output "sa_id" {
  value = yandex_iam_service_account.sa.id
  description = "Service Account ID"
}

resource "local_file" "access-key" {
  content  = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  filename = "../access_key"
}

resource "local_file" "secret-key" {
  content  = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  filename = "../secret_key"
}
