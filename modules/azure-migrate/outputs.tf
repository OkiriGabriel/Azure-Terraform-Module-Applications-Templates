output "migrate_project_id" {
  description = "Azure Migrate project ID"
  value       = azurerm_resource_group_template_deployment.migrate_project.id
}

output "assessment_project_id" {
  description = "Azure Migrate assessment project ID"
  value       = azurerm_resource_group_template_deployment.assessment_project.id
}

output "storage_account_id" {
  description = "Migration storage account ID"
  value       = azurerm_storage_account.migrate.id
}

output "storage_account_name" {
  description = "Migration storage account name"
  value       = azurerm_storage_account.migrate.name
}

output "storage_account_primary_blob_endpoint" {
  description = "Storage account primary blob endpoint"
  value       = azurerm_storage_account.migrate.primary_blob_endpoint
}

output "key_vault_id" {
  description = "Migration Key Vault ID"
  value       = azurerm_key_vault.migrate.id
}

output "key_vault_uri" {
  description = "Migration Key Vault URI"
  value       = azurerm_key_vault.migrate.vault_uri
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  value       = var.create_log_analytics ? azurerm_log_analytics_workspace.migrate[0].id : null
}

output "log_analytics_workspace_workspace_id" {
  description = "Log Analytics workspace workspace ID (GUID)"
  value       = var.create_log_analytics ? azurerm_log_analytics_workspace.migrate[0].workspace_id : null
}

output "recovery_services_vault_id" {
  description = "Recovery Services Vault ID"
  value       = azurerm_recovery_services_vault.migrate.id
}

output "recovery_services_vault_name" {
  description = "Recovery Services Vault name"
  value       = azurerm_recovery_services_vault.migrate.name
}

output "backup_policy_id" {
  description = "Backup policy ID"
  value       = azurerm_backup_policy_vm.migrate.id
}

output "automation_account_id" {
  description = "Automation Account ID"
  value       = var.create_automation_account ? azurerm_automation_account.migrate[0].id : null
}

output "automation_account_dsc_server_endpoint" {
  description = "Automation Account DSC server endpoint"
  value       = var.create_automation_account ? azurerm_automation_account.migrate[0].dsc_server_endpoint : null
}

output "private_endpoint_storage_id" {
  description = "Storage private endpoint ID"
  value       = var.enable_private_endpoints ? azurerm_private_endpoint.storage[0].id : null
}

output "private_endpoint_keyvault_id" {
  description = "Key Vault private endpoint ID"
  value       = var.enable_private_endpoints ? azurerm_private_endpoint.keyvault[0].id : null
}

output "appliance_config_path" {
  description = "Path to appliance configuration file"
  value       = var.create_appliance_config ? local_file.appliance_config[0].filename : null
}
