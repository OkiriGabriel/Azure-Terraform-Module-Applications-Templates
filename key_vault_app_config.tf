# data "azurerm_client_config" "current" {}

# Create a new Key Vault for secrets
resource "azurerm_key_vault" "secrets_vault" {
  name                = local.current_env.key_vault_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tenant_id           = local.current_env.tenant_id

  sku_name                        = "standard"
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = false
  soft_delete_retention_days      = 7

  # Include access policy for the container's managed identity
  # access_policy {
  #   tenant_id = local.current_env.tenant_id
  #   object_id = module.container_apps.backend_identity_principal_id



  #   secret_permissions = [
  #     "Get", "List"
  #   ]
  # }


  # Access policy for Container Apps will be created separately to avoid circular dependency
  #  Include access policy for Masha
  access_policy {
    tenant_id = local.current_env.tenant_id
    object_id = "dd88c017-6251-42ff-b327-f486176fe6c1"

    secret_permissions = [
      "Get", "List", "Set"
    ]
  }

  # Include access policy inline
  access_policy {
    tenant_id = local.current_env.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
    ]

    key_permissions = [
      "Backup", "Create", "Delete", "Get", "Import", "List", "Purge", "Recover",
      "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"
    ]

    certificate_permissions = [
      "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers",
      "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers",
      "Purge", "Recover", "Restore", "SetIssuers", "Update"
    ]

    storage_permissions = [
      "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS",
      "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"
    ]
  }

  access_policy {
    tenant_id = local.current_env.tenant_id
    object_id = local.current_env.key_vault_config.user_object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]

    key_permissions = [
      "Get", "List", "Create", "Delete"
    ]

    certificate_permissions = [
      "Get", "List", "Create", "Delete"
    ]
  }


  # access_policy {
  #   tenant_id = local.current_env.tenant_id
  #   object_id = module.container_apps.backend_identity_principal_id


  #   secret_permissions = [
  #     "Get", "List"
  #   ]
  # }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
    # ip_rules                   = local.current_env.key_vault_config.allowed_ip_ranges
  }

  tags = local.current_env.tags
}

# Add diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "secrets_vault" {
  name                       = "example-${local.current_env.environment}-web-secrets-kv-diag"
  target_resource_id         = azurerm_key_vault.secrets_vault.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "AuditEvent"
  }
}

# # Create all the secrets
resource "azurerm_key_vault_secret" "secrets" {
  for_each = {
    # Application Configuration
    JWT-EXPIRY         = "7d"
    PORT               = "4600"
    JWT-SECRET         = "CHANGE_ME_jwt_secret"
    BASE-URL           = "http://localhost:4600/"
    example-COMMISSION = "0.2"

    # Redis Configuration
    REDIS-URL = "rediss://:${module.redis.redis_primary_access_key["main"]}@${module.redis.redis_hostname["main"]}:${module.redis.redis_ssl_port["main"]}?ssl=true&abortConnect=false"

    # MongoDB Configuration
    MONGO-URI = "mongodb+srv://username:password@cluster.example.mongodb.net/exampleApp?retryWrites=true&w=majority"

    # Termii SMS Configuration
    TERMII-API-KEY = "CHANGE_ME_termii_api_key"
    SENDER-ID      = "N-Alert"

    # Mailgun Email Configuration
    MAILGUN-FROM-EMAIL = "admin@example.com"
    MAILGUN-DOMAIN     = "mg.example.com"
    MAILGUN-SECRET-KEY = "CHANGE_ME_mailgun_api_key"

    # Azure Storage Configuration
    AZURE-STORAGE-CONNECTION-STRING = "DefaultEndpointsProtocol=https;AccountName=yourstorageaccount;AccountKey=CHANGE_ME_storage_account_key;EndpointSuffix=core.windows.net"

    # Application Secrets
    ACCESS-SECRET                      = "your_access_secret"
    PASSWORD-CHANGE-SECRET             = "your_password_change_secret"
    PASSWORD-RESET-SECRET              = "your_password_reset_secret"
    VERIFY-EMAIL-SECRET                = "your_verify_email_secret"
    ACCESS-TOKEN-EXPIRES-AT-IN-SECONDS = "3600"
    ENCRYPTION-KEY                     = "CHANGE_ME_64_character_hex_encryption_key"

    # Google OAuth Configuration (Base64 encoded)
    GOOGLE-CREDENTIALS-B64 = "CHANGE_ME_base64_encoded_google_credentials"
    GOOGLE-SCOPES-API      = "email,profile"
    AUDIENCE               = "[\"your-google-client-id.apps.googleusercontent.com\"]"

    # Stripe Configuration
    STRIPE-KEY = "CHANGE_ME_stripe_test_key"

    # Currency Configuration
    CURRENCY-TYPE = "usd"
  }

  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.secrets_vault.id

  # lifecycle block removed to allow secret value updates
}

# Access policy for Container Apps (created after Container Apps to avoid circular dependency)
resource "azurerm_key_vault_access_policy" "container_apps_policy" {
  key_vault_id = azurerm_key_vault.secrets_vault.id
  tenant_id    = local.current_env.tenant_id
  object_id    = module.container_apps_v2.backend_identity_principal_id

  secret_permissions = [
    "Get", "List"
  ]

  certificate_permissions = [
    "Get", "List"
  ]

  key_permissions = [
    "Get", "List"
  ]

  depends_on = [
    module.container_apps_v2
  ]
}

# Output the new Key Vault details
output "secrets_vault_name" {
  description = "The name of the Secrets Key Vault"
  value       = azurerm_key_vault.secrets_vault.name
}

output "secrets_vault_uri" {
  description = "The URI of the Secrets Key Vault"
  value       = azurerm_key_vault.secrets_vault.vault_uri
}
