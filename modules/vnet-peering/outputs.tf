output "peering_ids" {
  description = "VNet peering IDs"
  value = merge(
    { for k, v in azurerm_virtual_network_peering.source_to_destination : k => v.id },
    { for k, v in azurerm_virtual_network_peering.destination_to_source : "${k}-reverse" => v.id }
  )
}

output "global_peering_ids" {
  description = "Global VNet peering IDs"
  value = merge(
    { for k, v in azurerm_virtual_network_peering.global_source_to_destination : k => v.id },
    { for k, v in azurerm_virtual_network_peering.global_destination_to_source : "${k}-reverse" => v.id }
  )
}

output "flow_log_ids" {
  description = "Flow log IDs"
  value = {
    for k, v in azurerm_network_watcher_flow_log.peering_flow_logs : k => v.id
  }
}

output "connection_monitor_ids" {
  description = "Connection monitor IDs"
  value = {
    for k, v in azurerm_network_connection_monitor.peering_monitor : k => v.id
  }
}
