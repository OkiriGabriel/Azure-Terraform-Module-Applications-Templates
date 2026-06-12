variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location of the monitoring resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the monitoring resources"
  type        = map(string)
  default     = {}
}

variable "container_app_environment_id" {
  description = "ID of the Container App Environment"
  type        = string
}

variable "container_app_environment_domain" {
  description = "Domain of the Container App Environment"
  type        = string
}

# Prometheus Configuration
variable "prometheus_app_name" {
  description = "Name of the Prometheus container app"
  type        = string
  default     = "prometheus"
}

variable "prometheus_port" {
  description = "Port for Prometheus"
  type        = number
  default     = 9090
}

variable "prometheus_image" {
  description = "Docker image for Prometheus"
  type        = string
  default     = "prom/prometheus:latest"
}

variable "prometheus_cpu" {
  description = "CPU allocation for Prometheus"
  type        = number
  default     = 1.0
}

variable "prometheus_memory" {
  description = "Memory allocation for Prometheus in GB"
  type        = number
  default     = 2.0
}

variable "prometheus_min_replicas" {
  description = "Minimum replicas for Prometheus"
  type        = number
  default     = 1
}

variable "prometheus_max_replicas" {
  description = "Maximum replicas for Prometheus"
  type        = number
  default     = 3
}

variable "prometheus_storage_account_name" {
  description = "Name of the storage account for Prometheus data"
  type        = string
}

# Grafana Configuration
variable "grafana_app_name" {
  description = "Name of the Grafana container app"
  type        = string
  default     = "grafana"
}

variable "grafana_port" {
  description = "Port for Grafana"
  type        = number
  default     = 3000
}

variable "grafana_image" {
  description = "Docker image for Grafana"
  type        = string
  default     = "grafana/grafana:latest"
}

variable "grafana_cpu" {
  description = "CPU allocation for Grafana"
  type        = number
  default     = 1.0
}

variable "grafana_memory" {
  description = "Memory allocation for Grafana in GB"
  type        = number
  default     = 2.0
}

variable "grafana_min_replicas" {
  description = "Minimum replicas for Grafana"
  type        = number
  default     = 1
}

variable "grafana_max_replicas" {
  description = "Maximum replicas for Grafana"
  type        = number
  default     = 3
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  default     = "admin123"
}

variable "grafana_storage_account_name" {
  description = "Name of the storage account for Grafana data"
  type        = string
}

# Loki Configuration
variable "loki_app_name" {
  description = "Name of the Loki container app"
  type        = string
  default     = "loki"
}

variable "loki_port" {
  description = "Port for Loki"
  type        = number
  default     = 3100
}

variable "loki_image" {
  description = "Docker image for Loki"
  type        = string
  default     = "grafana/loki:latest"
}

variable "loki_cpu" {
  description = "CPU allocation for Loki"
  type        = number
  default     = 1.0
}

variable "loki_memory" {
  description = "Memory allocation for Loki in GB"
  type        = number
  default     = 2.0
}

variable "loki_min_replicas" {
  description = "Minimum replicas for Loki"
  type        = number
  default     = 1
}

variable "loki_max_replicas" {
  description = "Maximum replicas for Loki"
  type        = number
  default     = 3
}

variable "loki_storage_account_name" {
  description = "Name of the storage account for Loki data"
  type        = string
}

# Container App Names for Monitoring
variable "frontend_app_name" {
  description = "Name of the frontend container app"
  type        = string
}

variable "backend_app_name" {
  description = "Name of the backend container app"
  type        = string
}

variable "marketplace_app_name" {
  description = "Name of the marketplace container app"
  type        = string
}

variable "admin_frontend_app_name" {
  description = "Name of the admin frontend container app"
  type        = string
}

variable "frontend_port" {
  description = "Port of the frontend container app"
  type        = number
}

variable "backend_port" {
  description = "Port of the backend container app"
  type        = number
}

variable "marketplace_port" {
  description = "Port of the marketplace container app"
  type        = number
}

variable "admin_frontend_port" {
  description = "Port of the admin frontend container app"
  type        = number
}


