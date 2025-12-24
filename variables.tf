variable "cloud_id" {
  type    = string
  default = "b1g2n8g0k698p8h8pfg2"
}

variable "folder_id" {
  type    = string
  default = "b1gqbh9n63qaria5u2tj"
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "network_name" {
  type    = string
  default = "shahat112-network"
}

variable "subnet_name" {
  type    = string
  default = "shahat112-k8s-subnet"
}

variable "cluster_name" {
  type    = string
  default = "shahat112-k8s-cluster"
}

variable "node_group_name" {
  type    = string
  default = "shahat112-nodes"
}

variable "node_count" {
  type    = number
  default = 2
}

variable "service_account_id" {
  type    = string
  default = "ajej6rnsr5kdvhhsuaqs"
}

# Kubernetes CIDR (ИЗМЕНЕНО - новые диапазоны чтобы избежать конфликтов)
variable "k8s_pod_cidr" {
  type    = string
  default = "172.24.0.0/16"
}

variable "k8s_service_cidr" {
  type    = string
  default = "172.25.0.0/16"
}

# Registry
variable "registry_name" {
  type    = string
  default = "shahat112-registry"
}

# PostgreSQL
variable "postgres_name" {
  type    = string
  default = "shahat112-postgres"
}

variable "postgres_user" {
  type    = string
  default = "appuser"
}

variable "postgres_password" {
  type      = string
  sensitive = true
  default   = "DemoAppPassword123!"
}

variable "postgres_database" {
  type    = string
  default = "demoapp"
}

# ClickHouse
variable "clickhouse_name" {
  type    = string
  default = "shahat112-clickhouse"
}

variable "clickhouse_user" {
  type    = string
  default = "admin"
}

variable "clickhouse_password" {
  type      = string
  sensitive = true
  default   = "DemoAppPassword123!"
}

variable "clickhouse_database" {
  type    = string
  default = "analytics"
}

# Redis/Valkey
variable "redis_name" {
  type    = string
  default = "shahat112-redis"
}

variable "redis_password" {
  type      = string
  sensitive = true
  default   = "DemoAppPassword123!"
}

variable "redis_version" {
  type    = string
  default = "7.2-valkey"
}
