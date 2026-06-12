output "virtual_wan_id" {
  description = "Virtual WAN ID"
  value       = azurerm_virtual_wan.main.id
}

output "virtual_wan_name" {
  description = "Virtual WAN name"
  value       = azurerm_virtual_wan.main.name
}

output "virtual_hub_ids" {
  description = "Virtual hub IDs"
  value = {
    for k, v in azurerm_virtual_hub.hubs : k => v.id
  }
}

output "virtual_hub_default_route_table_ids" {
  description = "Virtual hub default route table IDs"
  value = {
    for k, v in azurerm_virtual_hub.hubs : k => v.default_route_table_id
  }
}

output "vpn_gateway_ids" {
  description = "VPN gateway IDs"
  value = {
    for k, v in azurerm_vpn_gateway.gateways : k => v.id
  }
}

output "expressroute_gateway_ids" {
  description = "ExpressRoute gateway IDs"
  value = {
    for k, v in azurerm_express_route_gateway.gateways : k => v.id
  }
}

output "vnet_connection_ids" {
  description = "VNet connection IDs"
  value = {
    for k, v in azurerm_virtual_hub_connection.vnet_connections : k => v.id
  }
}

output "vpn_site_ids" {
  description = "VPN site IDs"
  value = {
    for k, v in azurerm_vpn_site.sites : k => v.id
  }
}

output "vpn_connection_ids" {
  description = "VPN connection IDs"
  value = {
    for k, v in azurerm_vpn_gateway_connection.connections : k => v.id
  }
}

output "hub_firewall_ids" {
  description = "Hub firewall IDs"
  value = {
    for k, v in azurerm_firewall.hub_firewall : k => v.id
  }
}

output "hub_firewall_private_ips" {
  description = "Hub firewall private IP addresses"
  value = {
    for k, v in azurerm_firewall.hub_firewall : k => v.virtual_hub[0].private_ip_address
  }
}

output "routing_intent_ids" {
  description = "Routing intent IDs"
  value = {
    for k, v in azurerm_virtual_hub_routing_intent.routing_intent : k => v.id
  }
}

output "route_table_ids" {
  description = "Virtual hub route table IDs"
  value = {
    for k, v in azurerm_virtual_hub_route_table.route_tables : k => v.id
  }
}
