# Key Vault secrets are passed as variables instead of using data source

# Log Analytics workspace for Container Apps
resource "azurerm_storage_account" "frontend" {
  name                     = var.frontend
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = var.tags
}
resource "azurerm_storage_account" "backend" {
  name                     = var.backend
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = var.tags
}

resource "azurerm_storage_account" "marketplace" {
  name                     = var.marketplace
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = var.tags
}

# Admin Frontend Storage Account
resource "azurerm_storage_account" "admin_frontend" {
  name                     = var.admin_frontend
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = var.tags
}


# Create a file share for frontend data in the new storage account
resource "azurerm_storage_share" "frontend_data_new" {
  name               = "data"
  storage_account_id = azurerm_storage_account.frontend.id
  quota              = 100
}

resource "azurerm_storage_share" "backend_data_new" {
  name               = "data"
  storage_account_id = azurerm_storage_account.backend.id
  quota              = 100
}

resource "azurerm_storage_share" "marketplace_data_new" {
  name               = "data"
  storage_account_id = azurerm_storage_account.marketplace.id
  quota              = 100
}

# Admin Frontend Storage Share
resource "azurerm_storage_share" "admin_frontend_data_new" {
  name               = "data"
  storage_account_id = azurerm_storage_account.admin_frontend.id
  quota              = 100
}

# Create a file share for frontend config in the new storage account
resource "azurerm_storage_share" "frontend_config_new" {
  name               = "frontendconfig"
  storage_account_id = azurerm_storage_account.frontend.id
  quota              = 1
}

resource "azurerm_storage_share" "backend_config_new" {
  name               = "backendconfig"
  storage_account_id = azurerm_storage_account.backend.id
  quota              = 1
}

# Get current Azure client configuration
data "azurerm_client_config" "current" {}
resource "azurerm_log_analytics_workspace" "container_apps" {
  name                = "${var.log_analytics_workspace}-container-apps-logs"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# Container Apps Environment
resource "azurerm_container_app_environment" "main" {
  name                       = "example-container-apps-env-${var.environment}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.container_apps.id
  # infrastructure_subnet_id   = var.subnet_id

  tags = var.tags
}
# Register storage with Container App Environment
resource "azurerm_container_app_environment_storage" "frontend_storage" {
  name                         = "frontend-storage-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  account_name                 = azurerm_storage_account.frontend.name
  access_key                   = azurerm_storage_account.frontend.primary_access_key
  share_name                   = azurerm_storage_share.frontend_data_new.name
  access_mode                  = "ReadWrite"
}

resource "azurerm_container_app_environment_storage" "backend_storage" {
  name                         = "backend-storage-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  account_name                 = azurerm_storage_account.backend.name
  access_key                   = azurerm_storage_account.backend.primary_access_key
  share_name                   = azurerm_storage_share.backend_data_new.name
  access_mode                  = "ReadWrite"
}

resource "azurerm_container_app_environment_storage" "marketplace_storage" {
  name                         = "marketplace-storage-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  account_name                 = azurerm_storage_account.marketplace.name
  access_key                   = azurerm_storage_account.marketplace.primary_access_key
  share_name                   = azurerm_storage_share.marketplace_data_new.name
  access_mode                  = "ReadWrite"
}

# Admin Frontend Environment Storage
resource "azurerm_container_app_environment_storage" "admin_frontend_storage" {
  name                         = "admin-frontend-storage-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  account_name                 = azurerm_storage_account.admin_frontend.name
  access_key                   = azurerm_storage_account.admin_frontend.primary_access_key
  share_name                   = azurerm_storage_share.admin_frontend_data_new.name
  access_mode                  = "ReadWrite"
}

# Frontend Container App
resource "azurerm_container_app" "frontend" {
  name                         = var.frontend_app_name
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled = true
    target_port      = var.frontend_port
    transport        = "http"
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "frontend"
      image  = var.frontend_image
      cpu    = var.frontend_cpu
      memory = "${var.frontend_memory}Gi"

      env {
        name  = "PORT"
        value = "3000"
      }
      env {
        name  = "SERVER_NAME"
        value = "_"
      }
      env {
        name  = "HTTPS_PORT"
        value = "443"
      }
      env {
        name  = "APP_PORT"
        value = "3000"
      }
      env {
        name  = "STORAGE_ACCOUNT_NAME"
        value = azurerm_storage_account.frontend.name
      }
      env {
        name  = "STORAGE_ACCOUNT_KEY"
        value = azurerm_storage_account.frontend.primary_access_key
      }
      env {
        name  = "STORAGE_SHARE_NAME"
        value = azurerm_storage_share.frontend_data_new.name
      }

      volume_mounts {
        name = "frontend-data-volume"
        path = "/frontend/storage"
      }
    }

    volume {
      name         = "frontend-data-volume"
      storage_type = "AzureFile"
      storage_name = "frontend-storage-${var.environment}"
    }

    min_replicas = var.frontend_min_replicas
    max_replicas = var.frontend_max_replicas

    http_scale_rule {
      name                = "http-scale-rule"
      concurrent_requests = 100
    }

    # CPU-based scaling rule
    custom_scale_rule {
      name             = "cpu-scale-rule"
      custom_rule_type = "cpu"
      metadata = {
        type  = "Utilization"
        value = "70" # Scale when CPU > 70%
      }
    }

    # Memory-based scaling rule
    custom_scale_rule {
      name             = "memory-scale-rule"
      custom_rule_type = "memory"
      metadata = {
        type  = "Utilization"
        value = "80" # Scale when memory > 80%
      }
    }
  }

  registry {
    server               = var.frontend_acr_server
    username             = var.frontend_acr_username
    identity             = var.frontend_acr_identity
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = var.frontend_acr_password
  }

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "frontend_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_container_app.frontend.identity[0].principal_id

  secret_permissions = [
    "Get", "List"
  ]

  certificate_permissions = [
    "Get", "List"
  ]

  key_permissions = [
    "Get", "List"
  ]

  lifecycle {
    ignore_changes = [
      secret_permissions,
      certificate_permissions,
      key_permissions
    ]
  }
}

# Admin Frontend Key Vault Access Policy
resource "azurerm_key_vault_access_policy" "admin_frontend_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_container_app.admin_frontend.identity[0].principal_id

  secret_permissions = [
    "Get", "List"
  ]

  certificate_permissions = [
    "Get", "List"
  ]

  key_permissions = [
    "Get", "List"
  ]

  lifecycle {
    ignore_changes = [
      secret_permissions,
      certificate_permissions,
      key_permissions
    ]
  }
}
resource "azurerm_network_security_group" "container_apps" {
  name                = "container-apps-nsg-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate NSG with Container App Subnet
# resource "azurerm_subnet_network_security_group_association" "container_apps" {
#   subnet_id                 = var.subnet_id
#   network_security_group_id = azurerm_network_security_group.container_apps.id
# }

# Backend Container App
resource "azurerm_container_app" "backend" {
  name                         = var.backend_app_name
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled = true
    target_port      = var.backend_port
    transport        = "http"
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "backend"
      image  = var.backend_image
      cpu    = var.backend_cpu
      memory = "${var.backend_memory}Gi"

      env {
        name        = "KEY_VAULT_NAME"
        secret_name = "keyvaultname"
      }
      env {
        name        = "AZURE_TENANT_ID"
        secret_name = "azure-tenant-id"
      }
      env {
        name  = "NODE_ENV"
        value = var.environment
      }
      env {
        name  = "PORT"
        value = "4600"
      }
      env {
        name  = "HTTP_PORT"
        value = "4600"
      }
      env {
        name  = "NODE_PORT"
        value = "4600"
      }
      env {
        name  = "HTTPS_PORT"
        value = "443"
      }
      # NGINX configuration - currently disabled
      # env {
      #   name  = "NGINX_BACKEND_PORT"
      #   value = "8001"
      # }
      # env {
      #   name  = "NGINX_BACKEND_HOST"
      #   value = "localhost"
      # }
      # env {
      #   name  = "NGINX_CLIENT_MAX_BODY_SIZE"
      #   value = "10G"
      # }
      # env {
      #   name  = "NGINX_TIMEOUT"
      #   value = "3600s"
      # }


      # Backend Application Environment Variables (from Key Vault)
      env {
        name        = "JWT_EXPIRY"
        secret_name = "jwt-expiry"
      }
      env {
        name        = "JWT_SECRET"
        secret_name = "jwt-secret"
      }
      env {
        name        = "BASE_URL"
        secret_name = "base-url"
      }
      env {
        name        = "REDIS_URL"
        secret_name = "redis-url"
      }
      env {
        name        = "MONGO_URI"
        secret_name = "mongo-uri"
      }
      env {
        name        = "TERMII_API_KEY"
        secret_name = "termii-api-key"
      }
      env {
        name        = "SENDER_ID"
        secret_name = "sender-id"
      }
      env {
        name        = "MAILGUN_FROM_EMAIL"
        secret_name = "mailgun-from-email"
      }
      env {
        name        = "MAILGUN_DOMAIN"
        secret_name = "mailgun-domain"
      }
      env {
        name        = "MAILGUN_SECRET_KEY"
        secret_name = "mailgun-secret-key"
      }
      env {
        name        = "AZURE_STORAGE_CONNECTION_STRING"
        secret_name = "azure-storage-connection-string"
      }
      env {
        name        = "ACCESS_SECRET"
        secret_name = "access-secret"
      }
      env {
        name        = "PASSWORD_CHANGE_SECRET"
        secret_name = "password-change-secret"
      }
      env {
        name        = "PASSWORD_RESET_SECRET"
        secret_name = "password-reset-secret"
      }
      env {
        name        = "VERIFY_EMAIL_SECRET"
        secret_name = "verify-email-secret"
      }
      env {
        name        = "ACCESS_TOKEN_EXPIRES_AT_IN_SECONDS"
        secret_name = "access-token-expires-at-in-seconds"
      }
      env {
        name        = "ENCRYPTION_KEY"
        secret_name = "encryption-key"
      }
      env {
        name        = "GOOGLE_CREDENTIALS_B64"
        secret_name = "google-credentials-b64"
      }
      env {
        name  = "GOOGLE_CREDENTIALS_PATH"
        value = "/app/credential.json"
      }
      env {
        name        = "GOOGLE_SCOPES_API"
        secret_name = "google-scopes-api"
      }
      env {
        name        = "AUDIENCE"
        secret_name = "audience"
      }
      env {
        name        = "CURRENCY_TYPE"
        secret_name = "currency-type"
      }
      env {
        name        = "STRIPE_KEY"
        secret_name = "stripe-key"
      }
      env {
        name        = "example_COMMISSION"
        secret_name = "example-commission"
      }


      # Example environment variables (now configured as secrets above):
      # GOOGLE_CREDENTIALS=<JSON_CONTENT>
      # GOOGLE_SCOPES_API=email,profile
      # CURRENCY_TYPE=usd
      # STRIPE_KEY=<set via Key Vault secret>





      volume_mounts {
        name = "backend-data-volume"
        path = "/backend/storage"
      }
    }

    volume {
      name         = "backend-data-volume"
      storage_type = "AzureFile"
      storage_name = "backend-storage-${var.environment}"
    }

    min_replicas = var.backend_min_replicas
    max_replicas = var.backend_max_replicas

    http_scale_rule {
      name                = "http-scale-rule"
      concurrent_requests = 100
    }

    # CPU-based scaling rule
    custom_scale_rule {
      name             = "cpu-scale-rule"
      custom_rule_type = "cpu"
      metadata = {
        type  = "Utilization"
        value = "70" # Scale when CPU > 70%
      }
    }

    # Memory-based scaling rule
    custom_scale_rule {
      name             = "memory-scale-rule"
      custom_rule_type = "memory"
      metadata = {
        type  = "Utilization"
        value = "80" # Scale when memory > 80%
      }
    }
  }

  registry {
    server               = var.backend_acr_server
    username             = var.backend_acr_username
    identity             = var.backend_acr_identity
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = var.backend_acr_password
  }

  # Key Vault connection secrets
  secret {
    name  = "keyvaultname"
    value = var.key_vault_url
  }
  secret {
    name  = "azure-tenant-id"
    value = var.tenant_id
  }

  # Backend Application Secrets (from variables)
  secret {
    name  = "jwt-expiry"
    value = var.jwt_expiry
  }
  secret {
    name  = "jwt-secret"
    value = var.jwt_secret
  }
  secret {
    name  = "base-url"
    value = var.base_url
  }
  secret {
    name  = "redis-url"
    value = var.redis_url
  }
  secret {
    name  = "mongo-uri"
    value = var.mongo_uri
  }
  secret {
    name  = "termii-api-key"
    value = var.termii_api_key
  }
  secret {
    name  = "sender-id"
    value = var.sender_id
  }
  secret {
    name  = "mailgun-from-email"
    value = var.mailgun_from_email
  }
  secret {
    name  = "mailgun-domain"
    value = var.mailgun_domain
  }
  secret {
    name  = "mailgun-secret-key"
    value = var.mailgun_secret_key
  }
  secret {
    name  = "azure-storage-connection-string"
    value = var.azure_storage_connection_string
  }
  secret {
    name  = "access-secret"
    value = var.access_secret
  }
  secret {
    name  = "password-change-secret"
    value = var.password_change_secret
  }
  secret {
    name  = "password-reset-secret"
    value = var.password_reset_secret
  }
  secret {
    name  = "verify-email-secret"
    value = var.verify_email_secret
  }
  secret {
    name  = "access-token-expires-at-in-seconds"
    value = var.access_token_expires_at_in_seconds
  }
  secret {
    name  = "encryption-key"
    value = var.encryption_key
  }
  secret {
    name  = "google-credentials-b64"
    value = var.google_credentials_b64
  }
  secret {
    name  = "google-scopes-api"
    value = var.google_scopes_api
  }
  secret {
    name  = "currency-type"
    value = var.currency_type
  }
  secret {
    name  = "stripe-key"
    value = var.stripe_key
  }
  secret {
    name  = "example-commission"
    value = var.example_commission
  }

  tags = var.tags
}

# Marketplace Container App
resource "azurerm_container_app" "marketplace" {
  name                         = var.marketplace_app_name
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled = true
    target_port      = var.marketplace_port
    transport        = "http"
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "marketplace"
      image  = var.marketplace_image
      cpu    = var.marketplace_cpu
      memory = "${var.marketplace_memory}Gi"

      env {
        name  = "NODE_ENV"
        value = var.environment
      }
      env {
        name  = "PORT"
        value = tostring(var.marketplace_port)
      }
      env {
        name  = "HTTP_PORT"
        value = tostring(var.marketplace_port)
      }
      env {
        name  = "NODE_PORT"
        value = tostring(var.marketplace_port)
      }
      env {
        name  = "HTTPS_PORT"
        value = "443"
      }
      env {
        name  = "HOME"
        value = "/root"
      }

      # Marketplace Frontend Application Environment Variables
      env {
        name  = "STORAGE_ACCOUNT_NAME"
        value = azurerm_storage_account.marketplace.name
      }
      env {
        name  = "STORAGE_ACCOUNT_KEY"
        value = azurerm_storage_account.marketplace.primary_access_key
      }
      env {
        name  = "STORAGE_SHARE_NAME"
        value = azurerm_storage_share.marketplace_data_new.name
      }

      volume_mounts {
        name = "marketplace-data-volume"
        path = "/marketplace/storage"
      }
    }

    volume {
      name         = "marketplace-data-volume"
      storage_type = "AzureFile"
      storage_name = "marketplace-storage-${var.environment}"
    }

    min_replicas = var.marketplace_min_replicas
    max_replicas = var.marketplace_max_replicas

    http_scale_rule {
      name                = "http-scale-rule"
      concurrent_requests = 30 # Reduced for more aggressive scaling down
    }

    # CPU-based scaling rule
    custom_scale_rule {
      name             = "cpu-scale-rule"
      custom_rule_type = "cpu"
      metadata = {
        type  = "Utilization"
        value = "40" # Reduced from 70% for more aggressive scaling down
      }
    }

    # Memory-based scaling rule
    custom_scale_rule {
      name             = "memory-scale-rule"
      custom_rule_type = "memory"
      metadata = {
        type  = "Utilization"
        value = "50" # Reduced from 80% for more aggressive scaling down
      }
    }
  }

  registry {
    server               = var.marketplace_acr_server
    username             = var.marketplace_acr_username
    identity             = var.marketplace_acr_identity
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = var.marketplace_acr_password
  }



  tags = var.tags
}

# Admin Frontend Container App
resource "azurerm_container_app" "admin_frontend" {
  name                         = var.admin_frontend_app_name
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled = true
    target_port      = var.admin_frontend_port
    transport        = "http"
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "admin-frontend"
      image  = var.admin_frontend_image
      cpu    = var.admin_frontend_cpu
      memory = "${var.admin_frontend_memory}Gi"

      env {
        name  = "NODE_ENV"
        value = var.environment
      }
      env {
        name  = "PORT"
        value = tostring(var.admin_frontend_port)
      }
      env {
        name  = "HTTP_PORT"
        value = tostring(var.admin_frontend_port)
      }
      env {
        name  = "NODE_PORT"
        value = tostring(var.admin_frontend_port)
      }
      env {
        name  = "HTTPS_PORT"
        value = "443"
      }
      env {
        name  = "HOME"
        value = "/root"
      }

      # Admin Frontend Application Environment Variables
      env {
        name  = "STORAGE_ACCOUNT_NAME"
        value = azurerm_storage_account.admin_frontend.name
      }
      env {
        name  = "STORAGE_ACCOUNT_KEY"
        value = azurerm_storage_account.admin_frontend.primary_access_key
      }
      env {
        name  = "STORAGE_SHARE_NAME"
        value = azurerm_storage_share.admin_frontend_data_new.name
      }

      volume_mounts {
        name = "admin-frontend-data-volume"
        path = "/admin-frontend/storage"
      }
    }

    volume {
      name         = "admin-frontend-data-volume"
      storage_type = "AzureFile"
      storage_name = "admin-frontend-storage-${var.environment}"
    }

    min_replicas = var.admin_frontend_min_replicas
    max_replicas = var.admin_frontend_max_replicas

    http_scale_rule {
      name                = "http-scale-rule"
      concurrent_requests = 30 # Reduced for more aggressive scaling down
    }

    # CPU-based scaling rule
    custom_scale_rule {
      name             = "cpu-scale-rule"
      custom_rule_type = "cpu"
      metadata = {
        type  = "Utilization"
        value = "40" # Reduced from 70% for more aggressive scaling down
      }
    }

    # Memory-based scaling rule
    custom_scale_rule {
      name             = "memory-scale-rule"
      custom_rule_type = "memory"
      metadata = {
        type  = "Utilization"
        value = "50" # Reduced from 80% for more aggressive scaling down
      }
    }
  }

  registry {
    server               = var.admin_frontend_acr_server
    username             = var.admin_frontend_acr_username
    identity             = var.admin_frontend_acr_identity
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = var.admin_frontend_acr_password
  }

  tags = var.tags
}

# Backend access policy is managed in the root configuration to avoid conflicts
# resource "azurerm_key_vault_access_policy" "backend_policy" {
#   key_vault_id = var.key_vault_id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = azurerm_container_app.backend.identity[0].principal_id

#   secret_permissions = [
#     "Get", "List"
#   ]

#   certificate_permissions = [
#     "Get", "List"
#   ]

#   key_permissions = [
#     "Get", "List"
#   ]

#   depends_on = [
#     azurerm_container_app.backend
#   ]
# }

resource "azurerm_network_security_group" "backend_nsg" {
  name                = "${var.backend_app_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow access from Azure services
  security_rule {
    name                       = "AllowAzureServices"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = [var.backend_port, var.backend_port_https, var.backend_application_port]
    source_address_prefix      = "AzureCloud"
    destination_address_prefix = "*"
  }

  # Deny all other traffic
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Add DNS Zone
# resource "azurerm_dns_zone" "exampleplatform" {
#   name                = var.dns_zone
#   resource_group_name = var.resource_group_name
# }

# # Add DNS record for the API
# resource "azurerm_dns_cname_record" "api" {
#   name                = var.dns_cname_record
#   zone_name           = azurerm_dns_zone.exampleplatform.name
#   resource_group_name = var.resource_group_name
#   ttl                 = 300
#   record              = azurerm_container_app.backend.ingress[0].fqdn
# }