# data "azurerm_client_config" "current" {}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "${local.current_env.environment}-law"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = local.current_env.log_analytics_config.sku
  retention_in_days   = local.current_env.log_analytics_config.retention_days
  tags                = local.current_env.tags
}

# Add all necessary RBAC role assignme

module "key_vault" {
  source = "./modules/keyvault"

  vault_name                  = "example-${local.current_env.environment}-kvt"
  resource_group_name         = module.resource_group.name
  location                    = module.resource_group.location
  tags                        = local.current_env.tags
  sku_name                    = local.current_env.key_vault_config.sku_name
  allowed_ip_ranges           = local.current_env.key_vault_config.allowed_ip_ranges
  tenant_id                   = local.current_env.tenant_id
  user_object_id              = local.current_env.key_vault_config.user_object_id
  service_principal_object_id = data.azurerm_client_config.current.object_id

  diagnostic_settings        = "example-${local.current_env.environment}-kv-diag"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
}