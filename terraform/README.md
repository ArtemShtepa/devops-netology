## Тестовый проект по **Terraform**

Для подготовки клиента **Яндекс.Облака** нужно выполнить команду `yc init`

После чего нужно задать переменные окружения авторизации провайдера **Яндекс.Облака** в **Terraform** следующими командами:

`export TF_VAR_YC_TOKEN=$(yc config get token)`

`export TF_VAR_YC_CLOUD_ID=$(yc config get cloud-id)`

`export TF_VAR_YC_FOLDER_ID=$(yc config get folder-id)`

`export TF_VAR_YC_ZONE=$(yc config get compute-default-zone)`

