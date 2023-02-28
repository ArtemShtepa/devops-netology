# Создание кластера MySQL
resource "yandex_mdb_mysql_cluster" "mysql-cluster" {
  name        = "mysql-cluster"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.my-net.id
  version     = "8.0"
  deletion_protection = false

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  access {
    web_sql   = true
    data_lens = false
  }

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }
  backup_retain_period_days = 7

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.mysql-sn-a.id
  }
  host {
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.mysql-sn-b.id
  }
}

# Создание базы данных
resource "yandex_mdb_mysql_database" "mysql-db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql-cluster.id
  name       = "netology_db"
  depends_on = [yandex_mdb_mysql_cluster.mysql-cluster]
}

# Создание пользователя базы данных
resource "yandex_mdb_mysql_user" "mysql-user" {
  cluster_id = yandex_mdb_mysql_cluster.mysql-cluster.id
  name       = "sqluser"
  password   = "sqlpassword"

  permission {
    database_name = "netology_db"
    roles = ["ALL"]
  }

  authentication_plugin = "SHA256_PASSWORD"
  depends_on = [yandex_mdb_mysql_database.mysql-db]
}
