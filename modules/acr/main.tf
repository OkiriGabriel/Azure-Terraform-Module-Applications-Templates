resource "azurerm_container_registry" "acr" {
  for_each            = var.acrs
  name                = lower(each.value.name)
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  tags                = var.tags

  dynamic "georeplications" {
    for_each = var.georeplications != null ? var.georeplications : []
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
      tags                    = georeplications.value.tags
    }
  }
}

# Output the ACR ID
# output "acr_id" {
#   value = {
#     for k, v in azurerm_container_registry.acr : k => v.id
#   }
# }

# Output the admin username
# output "admin_username" {
#   value = {
#     for k, v in azurerm_container_registry.acr : k => v.admin_username
#   }
# }

# # Output the admin password
# output "admin_password" {
#   value = {
#     for k, v in azurerm_container_registry.acr : k => v.admin_password
#   }
#   sensitive = true
# }

# Output the login server
output "login_server" {
  value = {
    for k, v in azurerm_container_registry.acr : k => v.login_server
  }
}

# Output the repositories
output "repositories" {
  value = {
    for k, v in var.acrs : k => v.repositories
  }
}