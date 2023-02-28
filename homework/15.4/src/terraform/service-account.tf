# Создание сервисного аккаунта
resource "yandex_iam_service_account" "sa" {
  name       = "sa-test"
  folder_id  = var.YC_FOLDER_ID
}

# Назначение роли сервисному аккаунту - редактор (ВМ, групп)
resource "yandex_resourcemanager_folder_iam_binding" "sa-editor" {
  folder_id  = var.YC_FOLDER_ID
  role       = "editor"
  members    = ["serviceAccount:${yandex_iam_service_account.sa.id}"]
  depends_on = [yandex_iam_service_account.sa]
}
