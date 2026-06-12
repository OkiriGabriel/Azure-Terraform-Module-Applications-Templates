output "vnet_id" {
  description = "The ID of the Hub Virtual Network"
  value       = azurerm_virtual_network.hub.id
}

output "vnet_name" {
  description = "The name of the Hub Virtual Network"
  value       = azurerm_virtual_network.hub.name
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = var.resource_group_name
}

output "gateway_subnet_id" {
  description = "ID of the gateway subnet"
  value       = azurerm_subnet.gateway.id
}

output "subnet_ids" {
  value = { for k, v in azurerm_subnet.hub_subnets : k => v.id }
}