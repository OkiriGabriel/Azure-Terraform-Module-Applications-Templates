output "storage_account_ids" {
  description = "The IDs of the storage accounts"
  value       = { for k, v in azurerm_storage_account.storage : k => v.id }
}

output "storage_account_names" {
  description = "The names of the storage accounts"
  value       = { for k, v in azurerm_storage_account.storage : k => v.name }
}

output "storage_account_primary_access_keys" {
  description = "The primary access keys of the storage accounts"
  value       = { for k, v in azurerm_storage_account.storage : k => v.primary_access_key }
  sensitive   = true
}

output "storage_account_primary_blob_endpoints" {
  description = "The primary blob endpoints of the storage accounts"
  value       = { for k, v in azurerm_storage_account.storage : k => v.primary_blob_endpoint }
}

output "storage_account_primary_connection_strings" {
  description = "The primary connection strings of the storage accounts"
  value       = { for k, v in azurerm_storage_account.storage : k => v.primary_connection_string }
  sensitive   = true
}

output "container_ids" {
  description = "The IDs of the storage containers"
  value       = { for k, v in azurerm_storage_container.containers : k => v.id }
}

output "container_names" {
  description = "The names of the storage containers"
  value       = { for k, v in azurerm_storage_container.containers : k => v.name }
}

# CDN outputs commented out as CDN resources are disabled
# output "cdn_profile_ids" {
#   description = "The IDs of the CDN profiles"
#   value       = { for k, v in azurerm_cdn_profile.profile : k => v.id }
# }

# output "cdn_profile_names" {
#   description = "The names of the CDN profiles"
#   value       = { for k, v in azurerm_cdn_profile.profile : k => v.name }
# }

# output "cdn_endpoint_ids" {
#   description = "The IDs of the CDN endpoints"
#   value       = { for k, v in azurerm_cdn_endpoint.endpoint : k => v.id }
# }

# output "cdn_endpoint_names" {
#   description = "The names of the CDN endpoints"
#   value       = { for k, v in azurerm_cdn_endpoint.endpoint : k => v.name }
# }

# output "cdn_endpoint_hostnames" {
#   description = "The hostnames of the CDN endpoints"
#   value       = { for k, v in azurerm_cdn_endpoint.endpoint : k => v.fqdn }
# } 