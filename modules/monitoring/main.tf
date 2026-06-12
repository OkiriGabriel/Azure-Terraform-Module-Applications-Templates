

# Monitoring Stack Container Apps
# Prometheus, Grafana, and Loki for monitoring and logging

# Prometheus Container App
resource "azurerm_container_app" "prometheus" {
  name                         = var.prometheus_app_name
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  depends_on = [
    azurerm_container_app_environment_storage.prometheus_storage
  ]

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled = true
    target_port      = var.prometheus_port
    transport        = "http"
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "prometheus"
      image  = var.prometheus_image
      cpu    = var.prometheus_cpu
      memory = "${var.prometheus_memory}Gi"

      env {
        name  = "NODE_ENV"
        value = var.environment
      }
      env {
        name  = "PORT"
        value = tostring(var.prometheus_port)
      }

      # Prometheus configuration for scraping container apps
      env {
        name = "PROMETHEUS_CONFIG"
        value = jsonencode({
          global = {
            scrape_interval     = "15s"
            evaluation_interval = "15s"
          }
          scrape_configs = [
            {
              job_name = "container-apps"
              static_configs = [
                {
                  targets = [
                    "${var.frontend_app_name}.${var.container_app_environment_domain}:${var.frontend_port}",
                    "${var.backend_app_name}.${var.container_app_environment_domain}:${var.backend_port}",
                    "${var.marketplace_app_name}.${var.container_app_environment_domain}:${var.marketplace_port}",
                    "${var.admin_frontend_app_name}.${var.container_app_environment_domain}:${var.admin_frontend_port}"
                  ]
                }
              ]
            }
          ]
        })
      }

      volume_mounts {
        name = "prometheus-data-volume"
        path = "/prometheus/data"
      }
    }

    volume {
      name         = "prometheus-data-volume"
      storage_type = "AzureFile"
      storage_name = "prometheus-storage-${var.environment}"
    }

    min_replicas = var.prometheus_min_replicas
    max_replicas = var.prometheus_max_replicas
  }

  tags = var.tags
}

# Grafana Container App
resource "azurerm_container_app" "grafana" {
  name                         = var.grafana_app_name
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  depends_on = [
    azurerm_container_app_environment_storage.grafana_storage
  ]

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled = true
    target_port      = var.grafana_port
    transport        = "http"
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "grafana"
      image  = var.grafana_image
      cpu    = var.grafana_cpu
      memory = "${var.grafana_memory}Gi"

      env {
        name  = "NODE_ENV"
        value = var.environment
      }
      env {
        name  = "PORT"
        value = tostring(var.grafana_port)
      }
      env {
        name        = "GF_SECURITY_ADMIN_PASSWORD"
        secret_name = "grafana-admin-password"
      }
      env {
        name  = "GF_SECURITY_ADMIN_USER"
        value = "admin"
      }
      env {
        name  = "GF_SERVER_ROOT_URL"
        value = "http://${var.grafana_app_name}.${var.container_app_environment_domain}"
      }

      # Grafana datasource configuration
      env {
        name  = "GF_INSTALL_PLUGINS"
        value = "grafana-loki-datasource"
      }

      volume_mounts {
        name = "grafana-data-volume"
        path = "/var/lib/grafana"
      }
    }

    volume {
      name         = "grafana-data-volume"
      storage_type = "AzureFile"
      storage_name = "grafana-storage-${var.environment}"
    }

    min_replicas = var.grafana_min_replicas
    max_replicas = var.grafana_max_replicas
  }

  secret {
    name  = "grafana-admin-password"
    value = var.grafana_admin_password
  }

  tags = var.tags
}

# Loki Container App
resource "azurerm_container_app" "loki" {
  name                         = var.loki_app_name
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  depends_on = [
    azurerm_container_app_environment_storage.loki_storage
  ]

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled = true
    target_port      = var.loki_port
    transport        = "http"
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "loki"
      image  = var.loki_image
      cpu    = var.loki_cpu
      memory = "${var.loki_memory}Gi"

      env {
        name  = "NODE_ENV"
        value = var.environment
      }
      env {
        name  = "PORT"
        value = tostring(var.loki_port)
      }

      # Loki configuration
      env {
        name = "LOKI_CONFIG"
        value = jsonencode({
          auth_enabled = false
          server = {
            http_listen_port = var.loki_port
          }
          ingester = {
            lifecycler = {
              address = "127.0.0.1"
              ring = {
                kvstore = {
                  store = "inmemory"
                }
                replication_factor = 1
              }
              final_sleep = "0s"
            }
            chunk_idle_period   = "5m"
            chunk_retain_period = "30s"
          }
          schema_config = {
            configs = [
              {
                from         = "2020-05-15"
                store        = "boltdb-shipper"
                object_store = "filesystem"
                schema       = "v11"
                index = {
                  prefix = "index_"
                  period = "24h"
                }
              }
            ]
          }
          storage_config = {
            boltdb_shipper = {
              active_index_directory = "/loki/boltdb-shipper-active"
              cache_location         = "/loki/boltdb-shipper-cache"
              cache_ttl              = "24h"
              shared_store           = "filesystem"
            }
            filesystem = {
              directory = "/loki/chunks"
            }
          }
          limits_config = {
            enforce_metric_name        = false
            reject_old_samples         = true
            reject_old_samples_max_age = "168h"
          }
        })
      }

      volume_mounts {
        name = "loki-data-volume"
        path = "/loki"
      }
    }

    volume {
      name         = "loki-data-volume"
      storage_type = "AzureFile"
      storage_name = "loki-storage-${var.environment}"
    }

    min_replicas = var.loki_min_replicas
    max_replicas = var.loki_max_replicas
  }

  tags = var.tags
}

# Storage accounts for monitoring data
resource "azurerm_storage_account" "prometheus_storage" {
  name                     = var.prometheus_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = var.tags
}

resource "azurerm_storage_account" "grafana_storage" {
  name                     = var.grafana_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = var.tags
}

resource "azurerm_storage_account" "loki_storage" {
  name                     = var.loki_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = var.tags
}

# File shares for monitoring data
resource "azurerm_storage_share" "prometheus_data" {
  name               = "prometheus-data"
  storage_account_id = azurerm_storage_account.prometheus_storage.id
  quota              = 10
}

resource "azurerm_storage_share" "grafana_data" {
  name               = "grafana-data"
  storage_account_id = azurerm_storage_account.grafana_storage.id
  quota              = 10
}

resource "azurerm_storage_share" "loki_data" {
  name               = "loki-data"
  storage_account_id = azurerm_storage_account.loki_storage.id
  quota              = 50
}

# Register storage with Container App Environment
resource "azurerm_container_app_environment_storage" "prometheus_storage" {
  name                         = "prometheus-storage-${var.environment}"
  container_app_environment_id = var.container_app_environment_id
  account_name                 = azurerm_storage_account.prometheus_storage.name
  access_key                   = azurerm_storage_account.prometheus_storage.primary_access_key
  share_name                   = azurerm_storage_share.prometheus_data.name
  access_mode                  = "ReadWrite"
}

resource "azurerm_container_app_environment_storage" "grafana_storage" {
  name                         = "grafana-storage-${var.environment}"
  container_app_environment_id = var.container_app_environment_id
  account_name                 = azurerm_storage_account.grafana_storage.name
  access_key                   = azurerm_storage_account.grafana_storage.primary_access_key
  share_name                   = azurerm_storage_share.grafana_data.name
  access_mode                  = "ReadWrite"
}

resource "azurerm_container_app_environment_storage" "loki_storage" {
  name                         = "loki-storage-${var.environment}"
  container_app_environment_id = var.container_app_environment_id
  account_name                 = azurerm_storage_account.loki_storage.name
  access_key                   = azurerm_storage_account.loki_storage.primary_access_key
  share_name                   = azurerm_storage_share.loki_data.name
  access_mode                  = "ReadWrite"
}