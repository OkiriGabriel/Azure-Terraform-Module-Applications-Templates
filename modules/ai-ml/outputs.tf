output "workspace_id" {
  description = "ID of the Azure Machine Learning workspace."
  value       = azurerm_machine_learning_workspace.this.id
}

output "workspace_name" {
  description = "Name of the Azure Machine Learning workspace."
  value       = azurerm_machine_learning_workspace.this.name
}

output "workspace_principal_id" {
  description = "Principal ID of the workspace system-assigned identity."
  value       = azurerm_machine_learning_workspace.this.identity[0].principal_id
}

output "compute_cluster_ids" {
  description = "Map of compute cluster names to IDs."
  value       = { for k, v in azurerm_machine_learning_compute_cluster.this : k => v.id }
}

output "openai_endpoint" {
  description = "Azure OpenAI endpoint (null when disabled)."
  value       = try(azurerm_cognitive_account.openai[0].endpoint, null)
}

output "openai_account_id" {
  description = "Azure OpenAI account ID (null when disabled)."
  value       = try(azurerm_cognitive_account.openai[0].id, null)
}

output "openai_deployment_names" {
  description = "Names of the Azure OpenAI model deployments."
  value       = keys(azurerm_cognitive_deployment.this)
}

output "search_endpoint" {
  description = "Azure AI Search endpoint (null when disabled)."
  value       = try("https://${azurerm_search_service.this[0].name}.search.windows.net", null)
}

output "application_insights_connection_string" {
  description = "Application Insights connection string for ML workloads."
  value       = azurerm_application_insights.this.connection_string
  sensitive   = true
}

output "key_vault_id" {
  description = "ID of the workspace Key Vault."
  value       = azurerm_key_vault.this.id
}

output "storage_account_id" {
  description = "ID of the workspace storage account."
  value       = azurerm_storage_account.this.id
}
