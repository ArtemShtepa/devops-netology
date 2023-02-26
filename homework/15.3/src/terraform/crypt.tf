# Создание симметричного криптографического ключа
resource "yandex_kms_symmetric_key" "key-a" {
  name              = "storage-key"
  default_algorithm = "AES_256"
  rotation_period   = "720h"
  lifecycle {
    prevent_destroy = false
  }
}
