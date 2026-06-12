output "namespace_ids" {
  description = "The IDs of the notification hub namespaces"
  value       = { for k, v in azurerm_notification_hub_namespace.namespace : k => v.id }
}

output "namespace_names" {
  description = "The names of the notification hub namespaces"
  value       = { for k, v in azurerm_notification_hub_namespace.namespace : k => v.name }
}

output "hub_ids" {
  description = "The IDs of the notification hubs"
  value       = { for k, v in azurerm_notification_hub.hub : k => v.id }
}

output "hub_names" {
  description = "The names of the notification hubs"
  value       = { for k, v in azurerm_notification_hub.hub : k => v.name }
}

output "authorization_rule_ids" {
  description = "The IDs of the authorization rules"
  value       = { for k, v in azurerm_notification_hub_authorization_rule.rule : k => v.id }
}

output "authorization_rule_names" {
  description = "The names of the authorization rules"
  value       = { for k, v in azurerm_notification_hub_authorization_rule.rule : k => v.name }
}

output "primary_access_keys" {
  description = "The primary access keys of the authorization rules"
  value       = { for k, v in azurerm_notification_hub_authorization_rule.rule : k => v.primary_access_key }
  sensitive   = true
}

output "secondary_access_keys" {
  description = "The secondary access keys of the authorization rules"
  value       = { for k, v in azurerm_notification_hub_authorization_rule.rule : k => v.secondary_access_key }
  sensitive   = true
} 