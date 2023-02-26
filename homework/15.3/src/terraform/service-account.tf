# Создание сервисного аккаунта
resource "yandex_iam_service_account" "sa" {
  name       = "sa-test"
  folder_id  = var.YC_FOLDER_ID
}

# Назначение роли сервисному аккаунту - редактирование хранилища
resource "yandex_resourcemanager_folder_iam_member" "sa-storage-editor" {
  folder_id  = var.YC_FOLDER_ID
  role       = "storage.editor"
  member     = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Назначение роли сервисному аккаунту - редактирование хранилища
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id  = var.YC_FOLDER_ID
  role       = "editor"
  member     = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Назначение роли сервисному аккаунту - редактирование хранилища
resource "yandex_resourcemanager_folder_iam_member" "sa-kms-encrypt-decrypt" {
  folder_id  = var.YC_FOLDER_ID
  role       = "kms.keys.encrypterDecrypter"
  member     = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Назначение роли сервисному аккаунту - редактирование хранилища
resource "yandex_resourcemanager_folder_iam_member" "sa-kms-viewer" {
  folder_id  = var.YC_FOLDER_ID
  role       = "kms.viewer"
  member     = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
}
