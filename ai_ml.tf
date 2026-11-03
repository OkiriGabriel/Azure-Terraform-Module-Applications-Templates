# AI / ML platform: Azure Machine Learning, Azure OpenAI and Azure AI Search.
# Toggle per environment with ai_ml_config.enabled in vars_enviro_dev.tf / var_enviro_prod.tf.

module "ai_ml" {
  source = "./modules/ai-ml"
  count  = local.current_env.ai_ml_config.enabled ? 1 : 0

  name_prefix                = "example-${local.current_env.environment}"
  resource_group_name        = module.resource_group.name
  location                   = module.resource_group.location
  tenant_id                  = local.current_env.tenant_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  tags                       = merge(local.current_env.tags, { Workload = "ai-ml" })

  storage_account_name     = "example${local.current_env.environment}mlsa"
  storage_replication_type = local.current_env.ai_ml_config.storage_replication_type
  key_vault_name           = "example-${local.current_env.environment}-mlkv"
  container_registry_id    = module.acr.acr_id["main"]
  high_business_impact     = local.current_env.ai_ml_config.high_business_impact

  public_network_access_enabled = local.current_env.ai_ml_config.public_network_access_enabled
  compute_clusters              = local.current_env.ai_ml_config.compute_clusters

  openai_enabled     = local.current_env.ai_ml_config.openai_enabled
  openai_location    = local.current_env.ai_ml_config.openai_location
  openai_deployments = local.current_env.ai_ml_config.openai_deployments

  search_enabled         = local.current_env.ai_ml_config.search_enabled
  search_sku             = local.current_env.ai_ml_config.search_sku
  search_replica_count   = local.current_env.ai_ml_config.search_replica_count
  search_partition_count = local.current_env.ai_ml_config.search_partition_count
}

output "ai_ml_workspace_name" {
  description = "Azure Machine Learning workspace name (null when AI/ML is disabled)."
  value       = try(module.ai_ml[0].workspace_name, null)
}

output "ai_ml_openai_endpoint" {
  description = "Azure OpenAI endpoint (null when disabled)."
  value       = try(module.ai_ml[0].openai_endpoint, null)
}

output "ai_ml_search_endpoint" {
  description = "Azure AI Search endpoint (null when disabled)."
  value       = try(module.ai_ml[0].search_endpoint, null)
}
