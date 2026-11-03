# output "id" {
#   description = "The ID of the Container Registry"
#   value       = azurerm_container_registry.acr.id
# }

# output "login_server" {
#   description = "The login server URL for the Container Registry"
#   value       = azurerm_container_registry.acr.login_server
# }

# output "admin_username" {
#   description = "The admin username for the Container Registry"
#   value       = azurerm_container_registry.acr.admin_username
# }

# output "admin_password" {
#   description = "The admin password for the Container Registry"
#   value       = azurerm_container_registry.acr.admin_password
#   sensitive   = true
# }
output "admin_username" {
  description = "The admin username"
  value       = { for k, v in azurerm_container_registry.acr : k => v.admin_username }
}

output "admin_password" {
  description = "The admin password"
  value       = { for k, v in azurerm_container_registry.acr : k => v.admin_password }
  sensitive   = true
}

output "acr_login_server" {
  description = "The login server URL for the Container Registry"
  value       = { for k, v in azurerm_container_registry.acr : k => v.login_server }
}


output "acr_id" {
  description = "The ID of the Azure Container Registry"
  value       = { for k, v in azurerm_container_registry.acr : k => v.id }
}
