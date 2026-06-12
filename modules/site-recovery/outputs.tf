output "vault_id" {
  description = "Recovery Services Vault ID"
  value       = azurerm_recovery_services_vault.main.id
}

output "vault_name" {
  description = "Recovery Services Vault name"
  value       = azurerm_recovery_services_vault.main.name
}

output "source_fabric_ids" {
  description = "Source fabric IDs"
  value = {
    for k, v in azurerm_site_recovery_fabric.source : k => v.id
  }
}

output "target_fabric_ids" {
  description = "Target fabric IDs"
  value = {
    for k, v in azurerm_site_recovery_fabric.target : k => v.id
  }
}

output "source_protection_container_ids" {
  description = "Source protection container IDs"
  value = {
    for k, v in azurerm_site_recovery_protection_container.source : k => v.id
  }
}

output "target_protection_container_ids" {
  description = "Target protection container IDs"
  value = {
    for k, v in azurerm_site_recovery_protection_container.target : k => v.id
  }
}

output "replication_policy_ids" {
  description = "Replication policy IDs"
  value = {
    for k, v in azurerm_site_recovery_replication_policy.main : k => v.id
  }
}

output "protection_container_mapping_ids" {
  description = "Protection container mapping IDs"
  value = {
    for k, v in azurerm_site_recovery_protection_container_mapping.main : k => v.id
  }
}

output "network_mapping_ids" {
  description = "Network mapping IDs"
  value = {
    for k, v in azurerm_site_recovery_network_mapping.main : k => v.id
  }
}

output "cache_storage_account_id" {
  description = "Cache storage account ID"
  value       = azurerm_storage_account.cache.id
}

output "cache_storage_account_name" {
  description = "Cache storage account name"
  value       = azurerm_storage_account.cache.name
}

output "target_storage_account_id" {
  description = "Target storage account ID"
  value       = var.create_target_storage ? azurerm_storage_account.target[0].id : null
}

output "automation_account_id" {
  description = "Automation Account ID"
  value       = var.create_automation_account ? azurerm_automation_account.asr[0].id : null
}

output "automation_account_identity" {
  description = "Automation Account managed identity"
  value       = var.create_automation_account ? azurerm_automation_account.asr[0].identity : null
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  value       = var.create_log_analytics ? azurerm_log_analytics_workspace.asr[0].id : null
}

output "log_analytics_workspace_workspace_id" {
  description = "Log Analytics workspace workspace ID (GUID)"
  value       = var.create_log_analytics ? azurerm_log_analytics_workspace.asr[0].workspace_id : null
}

output "asr_config_path" {
  description = "Path to ASR configuration file"
  value       = var.create_asr_config ? local_file.asr_config[0].filename : null
}
