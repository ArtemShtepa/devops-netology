// Создание бакета с использованием ключа сервисного аккаунта
resource "yandex_storage_bucket" "storage" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "artem-shtepa-2023-02"

  website {
    index_document = "my-photo"
    error_document = "error.html"
  }
  anonymous_access_flags {
    read = true
    list = false
  }
}

//Добавление обхекта в хранилище - картинки
resource "yandex_storage_object" "photo" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = yandex_storage_bucket.storage.bucket

  key    = "my-photo"
  acl    = "public-read"
  content_type = "image/jpg"
  source = "./../image/IMG_20210330_2219.jpg"
}

output "storage-url" {
  value = "https://${yandex_storage_bucket.storage.bucket}.storage.yandexcloud.net/${yandex_storage_object.photo.key}"
}
