output "frontend_container_app_id" {
  description = "The ID of the frontend container app"
  value       = azurerm_container_app.frontend.id
}

output "frontend_container_app_name" {
  description = "The name of the frontend container app"
  value       = azurerm_container_app.frontend.name
}

output "frontend_container_app_fqdn" {
  description = "The FQDN of the frontend container app"
  value       = azurerm_container_app.frontend.outbound_ip_addresses
}

output "backend_container_app_id" {
  description = "The ID of the backend container app"
  value       = azurerm_container_app.backend.id
}

output "backend_container_app_name" {
  description = "The name of the backend container app"
  value       = azurerm_container_app.backend.name
}

output "backend_container_app_fqdn" {
  description = "The FQDN of the backend container app"
  value       = azurerm_container_app.backend.outbound_ip_addresses
}

output "container_app_environment_id" {
  description = "The ID of the Container App Environment"
  value       = azurerm_container_app_environment.main.id
}

output "container_app_environment_name" {
  description = "The name of the container app environment"
  value       = azurerm_container_app_environment.main.name
}

output "container_app_environment_domain" {
  description = "The domain of the container app environment"
  value       = azurerm_container_app_environment.main.default_domain
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.container_apps.id
}

output "frontend_identity_principal_id" {
  description = "The principal ID of the frontend container app's managed identity"
  value       = azurerm_container_app.frontend.identity[0].principal_id
}

output "backend_identity_principal_id" {
  description = "The principal ID of the backend container app's managed identity"
  value       = azurerm_container_app.backend.identity[0].principal_id
}

output "marketplace_container_app_id" {
  description = "The ID of the marketplace container app"
  value       = azurerm_container_app.marketplace.id
}

output "marketplace_container_app_name" {
  description = "The name of the marketplace container app"
  value       = azurerm_container_app.marketplace.name
}

output "marketplace_container_app_fqdn" {
  description = "The FQDN of the marketplace container app"
  value       = azurerm_container_app.marketplace.outbound_ip_addresses
}

output "marketplace_identity_principal_id" {
  description = "The principal ID of the marketplace container app's managed identity"
  value       = azurerm_container_app.marketplace.identity[0].principal_id
}

# Admin Frontend outputs - COMMENTED OUT
# output "admin_frontend_container_app_id" {
#   description = "The ID of the admin frontend container app"
#   value       = azurerm_container_app.admin_frontend.id
# }

# output "admin_frontend_container_app_name" {
#   description = "The name of the admin frontend container app"
#   value       = azurerm_container_app.admin_frontend.name
# }

# output "admin_frontend_container_app_fqdn" {
#   description = "The FQDN of the admin frontend container app"
#   value       = azurerm_container_app.admin_frontend.outbound_ip_addresses
# }

# output "admin_frontend_identity_principal_id" {
#   description = "The principal ID of the admin frontend container app's managed identity"
#   value       = azurerm_container_app.admin_frontend.identity[0].principal_id
# } 