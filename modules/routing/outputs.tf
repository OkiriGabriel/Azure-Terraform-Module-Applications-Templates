output "route_table_ids" {
  description = "Route table IDs"
  value = {
    for k, v in azurerm_route_table.main : k => v.id
  }
}

output "route_table_names" {
  description = "Route table names"
  value = {
    for k, v in azurerm_route_table.main : k => v.name
  }
}

output "nva_ids" {
  description = "Network Virtual Appliance VM IDs"
  value = {
    for k, v in azurerm_linux_virtual_machine.nva : k => v.id
  }
}

output "nva_private_ips" {
  description = "Network Virtual Appliance private IP addresses"
  value = {
    for k, v in azurerm_network_interface.nva : k => v.ip_configuration[0].private_ip_address
  }
}

output "route_server_ids" {
  description = "Route Server IDs"
  value = {
    for k, v in azurerm_route_server.main : k => v.id
  }
}

output "route_server_virtual_router_ips" {
  description = "Route Server virtual router IPs"
  value = {
    for k, v in azurerm_route_server.main : k => v.virtual_router_ips
  }
}

output "traffic_manager_profile_ids" {
  description = "Traffic Manager profile IDs"
  value = {
    for k, v in azurerm_traffic_manager_profile.main : k => v.id
  }
}

output "traffic_manager_profile_fqdns" {
  description = "Traffic Manager profile FQDNs"
  value = {
    for k, v in azurerm_traffic_manager_profile.main : k => v.fqdn
  }
}

output "frontdoor_profile_ids" {
  description = "Front Door profile IDs"
  value = {
    for k, v in azurerm_cdn_frontdoor_profile.main : k => v.id
  }
}

output "frontdoor_endpoint_ids" {
  description = "Front Door endpoint IDs"
  value = {
    for k, v in azurerm_cdn_frontdoor_endpoint.endpoints : k => v.id
  }
}

output "frontdoor_endpoint_hostnames" {
  description = "Front Door endpoint hostnames"
  value = {
    for k, v in azurerm_cdn_frontdoor_endpoint.endpoints : k => v.host_name
  }
}

output "service_endpoint_policy_ids" {
  description = "Service endpoint policy IDs"
  value = {
    for k, v in azurerm_subnet_service_endpoint_storage_policy.storage_policies : k => v.id
  }
}
