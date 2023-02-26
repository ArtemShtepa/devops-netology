variable DOMAINS { default = [] }

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.70"
    }
  }
  required_version = ">= 0.13"
}

resource "yandex_cm_certificate" "cert" {
  name    = "certificate"
  domains = var.DOMAINS

  managed {
    challenge_type = "HTTP"
  }
}

output "cert_id" {
  value = "${yandex_cm_certificate.cert.id}"
}

output "challenge_url" {
  value = "${yandex_cm_certificate.cert.challenges[0].http_url}"
}

output "challenge_value" {
  value = "${yandex_cm_certificate.cert.challenges[0].http_content}"
}

