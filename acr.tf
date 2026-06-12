resource "random_password" "acr_password" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"

  keepers = {
    acr_name    = "example${local.current_env.environment}acr"
    environment = local.current_env.environment
  }
}

module "acr" {
  source = "./modules/acr"

  acrs = {
    main = {
      name = "example${local.current_env.environment}acr"
      repositories = [
        "exampleproductclient${local.current_env.environment}",
        "exampleproductapi${local.current_env.environment}",
      ]
    }
  }
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = "Basic" # Changed from Standard to Basic for dev cost optimization
  admin_enabled       = true
  tags                = local.current_env.tags

  depends_on = [module.resource_group]
}

# Get the service principal using the client ID from the current config
# data "azuread_service_principal" "terraform_sp" {
#   client_id = local.current_env.service_principal_object_id
# }

# # Add acrpull for provisioning principle to ACR scope
# resource "azurerm_role_assignment" "acr_pull" {
#   scope                = module.acr.acr_id["main"]
#   role_definition_name = "AcrPull"
#   principal_id         = data.azuread_service_principal.terraform_sp.object_id
#   depends_on           = [module.acr]
# }

# # Add acrpush for provisioning principle to ACR scope
# resource "azurerm_role_assignment" "acr_push" {
#   scope                = module.acr.acr_id["main"]
#   role_definition_name = "AcrPush"
#   principal_id         = data.azuread_service_principal.terraform_sp.object_id
#   depends_on           = [module.acr]
# }

# Store the Azure-generated credentials in Key Vault
resource "azurerm_key_vault_secret" "acr_username" {
  name         = "acr-${local.current_env.environment}-username"
  value        = module.acr.admin_username["main"]
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.key_vault, module.acr]
}

resource "azurerm_key_vault_secret" "acr_password" {
  name         = "acr-${local.current_env.environment}-password"
  value        = module.acr.admin_password["main"]
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.key_vault, module.acr]
}



output "acr_name" {
  value = "example${local.current_env.environment}acr"
}

output "acr_repositories" {
  value = [
    "exampleproductclient${local.current_env.environment}",
    "exampleproductapi${local.current_env.environment}",
  ]
}
