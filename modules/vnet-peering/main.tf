# VNet Peering from source to destination
resource "azurerm_virtual_network_peering" "source_to_destination" {
  for_each = var.peering_configurations

  name                         = each.value.name
  resource_group_name          = each.value.source_resource_group_name
  virtual_network_name         = each.value.source_vnet_name
  remote_virtual_network_id    = each.value.destination_vnet_id
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
}

# VNet Peering from destination to source (bidirectional)
resource "azurerm_virtual_network_peering" "destination_to_source" {
  for_each = var.peering_configurations

  name                         = "${each.value.name}-reverse"
  resource_group_name          = each.value.destination_resource_group_name
  virtual_network_name         = each.value.destination_vnet_name
  remote_virtual_network_id    = each.value.source_vnet_id
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit_reverse
  use_remote_gateways          = each.value.use_remote_gateways_reverse
}

# Global VNet Peering (cross-region)
resource "azurerm_virtual_network_peering" "global_source_to_destination" {
  for_each = var.global_peering_configurations

  name                         = each.value.name
  resource_group_name          = each.value.source_resource_group_name
  virtual_network_name         = each.value.source_vnet_name
  remote_virtual_network_id    = each.value.destination_vnet_id
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "global_destination_to_source" {
  for_each = var.global_peering_configurations

  name                         = "${each.value.name}-reverse"
  resource_group_name          = each.value.destination_resource_group_name
  virtual_network_name         = each.value.destination_vnet_name
  remote_virtual_network_id    = each.value.source_vnet_id
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit_reverse
  use_remote_gateways          = each.value.use_remote_gateways_reverse
}

# Network Watcher for connectivity monitoring
resource "azurerm_network_watcher_flow_log" "peering_flow_logs" {
  for_each = var.enable_flow_logs ? var.flow_log_configurations : {}

  network_watcher_name = each.value.network_watcher_name
  resource_group_name  = each.value.network_watcher_resource_group_name
  name                 = "${each.value.nsg_name}-flow-log"

  network_security_group_id = each.value.nsg_id
  storage_account_id        = each.value.storage_account_id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = each.value.retention_days
  }

  traffic_analytics {
    enabled               = each.value.enable_traffic_analytics
    workspace_id          = each.value.log_analytics_workspace_id
    workspace_region      = each.value.log_analytics_workspace_region
    workspace_resource_id = each.value.log_analytics_workspace_resource_id
    interval_in_minutes   = 10
  }
}

# Connection Monitor for peering health
resource "azurerm_network_connection_monitor" "peering_monitor" {
  for_each           = var.enable_connection_monitoring ? var.connection_monitor_configurations : {}
  name               = each.value.name
  network_watcher_id = each.value.network_watcher_id
  location           = each.value.location

  endpoint {
    name               = each.value.source_endpoint_name
    target_resource_id = each.value.source_vm_id
  }

  endpoint {
    name    = each.value.destination_endpoint_name
    address = each.value.destination_ip_address
  }

  test_configuration {
    name                      = "${each.value.name}-test-config"
    protocol                  = "Tcp"
    test_frequency_in_seconds = 60

    tcp_configuration {
      port                      = each.value.test_port
      destination_port_behavior = "None"
    }
  }

  test_group {
    name                     = "${each.value.name}-test-group"
    destination_endpoints    = [each.value.destination_endpoint_name]
    source_endpoints         = [each.value.source_endpoint_name]
    test_configuration_names = ["${each.value.name}-test-config"]
  }

  tags = var.tags
}
