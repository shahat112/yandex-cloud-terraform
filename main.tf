terraform {
  required_version = ">= 1.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"     
      version = ">= 0.100.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"   
  cloud_id                 = var.cloud_id 
  folder_id                = var.folder_id
  zone                     = var.zone     
}

# Данные о существующей сети
data "yandex_vpc_network" "network" {     
  name = var.network_name
}

# Данные о существующей подсети
data "yandex_vpc_subnet" "subnet" {
  name = var.subnet_name
}

# Существующий кластер Kubernetes
resource "yandex_kubernetes_cluster" "cluster" {
  name               = var.cluster_name
  network_id         = data.yandex_vpc_network.network.id

  # ПРАВИЛЬНЫЕ имена параметров для CIDR
  cluster_ipv4_range = var.k8s_pod_cidr
  service_ipv4_range = var.k8s_service_cidr

  master {
    zonal {
      zone      = var.zone
      subnet_id = data.yandex_vpc_subnet.subnet.id
    }

    public_ip = true
    version   = "1.30"
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id
}

# Существующая группа нод
resource "yandex_kubernetes_node_group" "nodes" {
  cluster_id = yandex_kubernetes_cluster.cluster.id
  name       = var.node_group_name

  instance_template {
    platform_id = "standard-v2"

    resources {
      memory = 4
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 30
    }

    network_interface {
      subnet_ids = [data.yandex_vpc_subnet.subnet.id]
      nat        = true
    }

    scheduling_policy {
      preemptible = true
    }
  }

  scale_policy {
    fixed_scale {
      size = var.node_count
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }
}

# Существующий Container Registry
resource "yandex_container_registry" "registry" {
  name = var.registry_name
}

# Существующий PostgreSQL Cluster
resource "yandex_mdb_postgresql_cluster" "postgres" {
  name        = var.postgres_name
  environment = "PRODUCTION"
  network_id  = data.yandex_vpc_network.network.id

  config {
    version = 15
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 20
    }

    access {
      web_sql = true
    }
  }

  host {
    zone      = var.zone
    subnet_id = data.yandex_vpc_subnet.subnet.id
  }
}

# Существующий ClickHouse Cluster БЕЗ БЛОКА DATABASE
resource "yandex_mdb_clickhouse_cluster" "clickhouse" {
  name        = var.clickhouse_name
  environment = "PRODUCTION"
  network_id  = data.yandex_vpc_network.network.id

  clickhouse {
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 20
    }
  }

  host {
    type      = "CLICKHOUSE"
    zone      = var.zone
    subnet_id = data.yandex_vpc_subnet.subnet.id
  }
}

# ОТДЕЛЬНЫЙ ресурс для базы данных ClickHouse
resource "yandex_mdb_clickhouse_database" "analytics" {
  cluster_id = yandex_mdb_clickhouse_cluster.clickhouse.id
  name       = var.clickhouse_database  # "analytics"
}

# Отдельный ресурс для пользователя ClickHouse
resource "yandex_mdb_clickhouse_user" "clickhouse_user" {
  cluster_id = yandex_mdb_clickhouse_cluster.clickhouse.id
  name       = var.clickhouse_user
  password   = var.clickhouse_password

  permission {
    database_name = var.clickhouse_database
  }

  # Теперь пользователь зависит от создания базы данных
  depends_on = [yandex_mdb_clickhouse_database.analytics]
}

# Существующий Redis/Valkey Cluster
resource "yandex_mdb_redis_cluster" "redis" {
  name        = var.redis_name
  environment = "PRODUCTION"
  network_id  = data.yandex_vpc_network.network.id

  # Простая конфигурация с паролем
  config {
    password = var.redis_password != "" ? var.redis_password : "DefaultRedisPassword123!"
    version  = var.redis_version
  }

  resources {
    resource_preset_id = "hm2.nano"
    disk_size          = 16
  }

  host {
    zone      = var.zone
    subnet_id = data.yandex_vpc_subnet.subnet.id
  }
}

# Outputs
output "cluster_id" {
  value = yandex_kubernetes_cluster.cluster.id
}

output "cluster_endpoint" {
  value = yandex_kubernetes_cluster.cluster.master[0].external_v4_endpoint
}

output "cluster_name" {
  value = yandex_kubernetes_cluster.cluster.name
}

output "network_id" {
  value = data.yandex_vpc_network.network.id
}

output "subnet_id" {
  value = data.yandex_vpc_subnet.subnet.id
}

output "subnet_cidr" {
  value = data.yandex_vpc_subnet.subnet.v4_cidr_blocks[0]
}

output "pod_cidr" {
  value = var.k8s_pod_cidr
}

output "service_cidr" {
  value = var.k8s_service_cidr
}

output "node_group_id" {
  value = yandex_kubernetes_node_group.nodes.id
}

output "postgres_fqdn" {
  value = yandex_mdb_postgresql_cluster.postgres.host[0].fqdn
}

output "clickhouse_fqdn" {
  value = yandex_mdb_clickhouse_cluster.clickhouse.host[0].fqdn
}

output "redis_fqdn" {
  value = yandex_mdb_redis_cluster.redis.host[0].fqdn
}

output "registry_id" {
  value = yandex_container_registry.registry.id
}

output "full_image_name" {
  value = "cr.yandex/${yandex_container_registry.registry.id}/demo-app:latest"
}
