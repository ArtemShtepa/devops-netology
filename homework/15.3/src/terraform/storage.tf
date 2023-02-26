# Создание бакета с использованием ключа сервисного аккаунта
resource "yandex_storage_bucket" "storage" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = var.DOMAIN == "" ? var.BUCKET : var.DOMAIN

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  anonymous_access_flags {
    read = true
    list = false
  }

  # Активация шифрования на стороне сервера
  dynamic "server_side_encryption_configuration" {
    for_each = var.CRYPT == "true" ? toset([1]) : toset([]) 
    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = yandex_kms_symmetric_key.key-a.id
          sse_algorithm     = "aws:kms"
        }
      }
    }
  }

  # Подключение сертификата
  dynamic "https" {
    for_each = var.USE_CERT == "true" ? toset([1]) : toset([])
    content {
      certificate_id = module.cert[0].cert_id
    }
  }
}

# Добавление объекта в хранилище
resource "yandex_storage_object" "index" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = yandex_storage_bucket.storage.bucket

  key    = "index.html"
  acl    = "public-read"
  content_type = "text/html"
  source = "./../files/index.html"
}

# Добавление объекта в хранилище
resource "yandex_storage_object" "error" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = yandex_storage_bucket.storage.bucket

  key    = "error.html"
  acl    = "public-read"
  content_type = "text/html"
  source = "./../files/error.html"
}

# Добавление объекта в хранилище - валидация сертификата
resource "yandex_storage_object" "cert-challenge" {
  count = var.USE_CERT == "true" ? 1 : 0
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = yandex_storage_bucket.storage.bucket

  key    = trimprefix(trimprefix(trimprefix(trimprefix("${module.cert[0].challenge_url}", "http://"), var.BUCKET), var.DOMAIN), ".website.yandexcloud.net")
  acl    = "public-read"
  content_type = "text/plain"
  content = "${module.cert[0].challenge_value}"
}

output "storage-url" {
  value = var.DOMAIN == "" ? "${yandex_storage_bucket.storage.bucket}.storage.yandexcloud.net" : "${var.DOMAIN}"
}
