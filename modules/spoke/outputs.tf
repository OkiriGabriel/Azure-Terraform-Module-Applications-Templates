output "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value = {
    for name, subnet in azurerm_subnet.spoke_subnets : name => subnet.id
  }
}

output "vnet_id" {
  description = "The ID of the spoke virtual network"
  value       = azurerm_virtual_network.spoke.id
}

output "vnet_name" {
  description = "The name of the spoke virtual network"
  value       = azurerm_virtual_network.spoke.name
}
