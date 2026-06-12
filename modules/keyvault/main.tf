# data "azurerm_client_config" "current" {}

# resource "azurerm_key_vault" "vault" {
#   name                            = var.vault_name
#   location                        = var.location
#   resource_group_name             = var.resource_group_name
#   tenant_id                       = var.tenant_id
#   sku_name                        = var.sku_name
#   enabled_for_disk_encryption     = true
#   enabled_for_deployment          = true
#   enabled_for_template_deployment = true
#   purge_protection_enabled        = true
#   soft_delete_retention_days      = 90

#   # Include access policy inline
#   access_policy {
#     tenant_id = var.tenant_id
#     object_id = data.azurerm_client_config.current.object_id

#     secret_permissions = [
#       "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
#     ]

#     key_permissions = [
#       "Backup", "Create", "Delete", "Get", "Import", "List", "Purge", "Recover",
#       "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"
#     ]

#     certificate_permissions = [
#       "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", 
#       "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", 
#       "Purge", "Recover", "Restore", "SetIssuers", "Update"
#     ]
#   }

#   access_policy {
#     tenant_id = var.tenant_id
#     object_id = data.azurerm_client_config.current.object_id

#     secret_permissions = [
#       "Get", "List", "Set", "Delete"
#     ]

#     key_permissions = [
#       "Get", "List", "Create", "Delete"
#     ]

#     certificate_permissions = [
#       "Get", "List", "Create", "Delete"
#     ]
#   }

#   network_acls {
#     default_action = "Allow"
#     bypass         = "AzureServices"
#     ip_rules       = var.allowed_ip_ranges
#   }

#   tags = var.tags
# }

# # Diagnostic Settings
# resource "azurerm_monitor_diagnostic_setting" "key_vault" {
#   name                       = var.diagnostic_settings
#   target_resource_id        = azurerm_key_vault.vault.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id

#   enabled_log {
#     category = "AuditEvent"
#   }

#   metric {
#     category = "AllMetrics"
#     enabled  = true
#   }
# }

# output "key_vault_id" {
#   description = "The ID of the Key Vault"
#   value       = azurerm_key_vault.vault.id
# }

# output "key_vault_uri" {
#   description = "The URI of the Key Vault"
#   value       = azurerm_key_vault.vault.vault_uri
# }

# output "key_vault_name" {
#   description = "The name of the Key Vault"
#   value       = azurerm_key_vault.vault.name
# }


data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name                            = var.vault_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = var.tenant_id
  sku_name                        = var.sku_name
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = true
  soft_delete_retention_days      = 90

  # Include access policy inline
  access_policy {
    tenant_id = var.tenant_id
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
    tenant_id = var.tenant_id
    object_id = var.user_object_id # Your user object ID

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

  # Add access policy for the specified principal ID
  access_policy {
    tenant_id = var.tenant_id
    object_id = var.service_principal_object_id

    secret_permissions = [
      "Get", "List", "Set"
    ]

    key_permissions = [
      "Get", "List"
    ]

    certificate_permissions = [
      "Get", "List"
    ]
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
    # ip_rules                   = var.allowed_ip_ranges
    # virtual_network_subnet_ids = toset(var.allowed_subnet_ids)  
  }

  tags = var.tags
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = var.diagnostic_settings
  target_resource_id         = azurerm_key_vault.vault.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.vault.id
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.vault.vault_uri
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.vault.name
}
