# Route Tables
resource "azurerm_route_table" "main" {
  for_each = var.route_tables

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Routes (User Defined Routes - UDRs)
resource "azurerm_route" "routes" {
  for_each = merge([
    for rt_key, rt in var.route_tables : {
      for route in rt.routes :
      "${rt_key}-${route.name}" => merge(route, { route_table_key = rt_key })
    }
  ]...)

  name                   = each.value.name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.main[each.value.route_table_key].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_type == "VirtualAppliance" ? each.value.next_hop_in_ip_address : null
}

# Subnet Route Table Associations
resource "azurerm_subnet_route_table_association" "associations" {
  for_each = var.subnet_route_table_associations

  subnet_id      = each.value.subnet_id
  route_table_id = azurerm_route_table.main[each.value.route_table_key].id
}

# Network Virtual Appliance (NVA)
resource "azurerm_network_interface" "nva" {
  for_each = var.network_virtual_appliances

  name                = "${each.value.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value.private_ip_address
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "nva" {
  for_each = var.network_virtual_appliances

  name                            = each.value.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = each.value.vm_size
  admin_username                  = each.value.admin_username
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.nva[each.key].id
  ]

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = each.value.ssh_public_key
  }

  os_disk {
    name                 = "${each.value.name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = each.value.os_disk_type
  }

  source_image_reference {
    publisher = each.value.image_publisher
    offer     = each.value.image_offer
    sku       = each.value.image_sku
    version   = each.value.image_version
  }

  identity {
    type = "SystemAssigned"
  }

  custom_data = each.value.custom_data != null ? base64encode(each.value.custom_data) : null

  tags = var.tags
}

# Azure Route Server for dynamic routing
resource "azurerm_public_ip" "route_server" {
  for_each = var.route_servers

  name                = "${each.value.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_route_server" "main" {
  for_each = var.route_servers

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  location             = var.location
  sku                  = each.value.sku
  public_ip_address_id = azurerm_public_ip.route_server[each.key].id
  subnet_id            = each.value.subnet_id

  tags = var.tags
}

# Route Server BGP Connection
resource "azurerm_route_server_bgp_connection" "bgp_connections" {
  for_each = var.route_server_bgp_connections

  name            = each.value.name
  route_server_id = azurerm_route_server.main[each.value.route_server_key].id
  peer_asn        = each.value.peer_asn
  peer_ip         = each.value.peer_ip
}

# Traffic Manager Profile for global load balancing
resource "azurerm_traffic_manager_profile" "main" {
  for_each = var.traffic_manager_profiles

  name                   = each.value.name
  resource_group_name    = var.resource_group_name
  traffic_routing_method = each.value.routing_method
  max_return             = each.value.max_return

  dns_config {
    relative_name = each.value.dns_relative_name
    ttl           = each.value.dns_ttl
  }

  monitor_config {
    protocol                     = each.value.monitor_protocol
    port                         = each.value.monitor_port
    path                         = each.value.monitor_path
    interval_in_seconds          = each.value.monitor_interval
    timeout_in_seconds           = each.value.monitor_timeout
    tolerated_number_of_failures = each.value.monitor_tolerated_failures
  }

  tags = var.tags
}

resource "azurerm_traffic_manager_azure_endpoint" "endpoints" {
  for_each = var.traffic_manager_endpoints

  name               = each.value.name
  profile_id         = azurerm_traffic_manager_profile.main[each.value.profile_key].id
  target_resource_id = each.value.target_resource_id
  weight             = each.value.weight
  priority           = each.value.priority
  enabled            = each.value.enabled

  dynamic "geo_mappings" {
    for_each = each.value.geo_mappings != null ? each.value.geo_mappings : []
    content {
      geo_mappings = geo_mappings.value
    }
  }
}

# Azure Front Door for global HTTP(S) routing
resource "azurerm_cdn_frontdoor_profile" "main" {
  for_each = var.frontdoor_profiles

  name                = each.value.name
  resource_group_name = var.resource_group_name
  sku_name            = each.value.sku_name

  tags = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoints" {
  for_each = var.frontdoor_endpoints

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main[each.value.profile_key].id
  enabled                  = each.value.enabled

  tags = var.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_groups" {
  for_each = var.frontdoor_origin_groups

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main[each.value.profile_key].id

  load_balancing {
    sample_size                        = each.value.sample_size
    successful_samples_required        = each.value.successful_samples_required
    additional_latency_in_milliseconds = each.value.additional_latency_ms
  }

  dynamic "health_probe" {
    for_each = each.value.enable_health_probe ? [1] : []
    content {
      protocol            = each.value.health_probe_protocol
      interval_in_seconds = each.value.health_probe_interval
      path                = each.value.health_probe_path
      request_type        = each.value.health_probe_request_type
    }
  }
}

resource "azurerm_cdn_frontdoor_origin" "origins" {
  for_each = var.frontdoor_origins

  name                          = each.value.name
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_groups[each.value.origin_group_key].id
  enabled                       = each.value.enabled

  certificate_name_check_enabled = each.value.certificate_name_check_enabled
  host_name                      = each.value.host_name
  http_port                      = each.value.http_port
  https_port                     = each.value.https_port
  origin_host_header             = each.value.origin_host_header
  priority                       = each.value.priority
  weight                         = each.value.weight
}

# Service Endpoint Policies
resource "azurerm_subnet_service_endpoint_storage_policy" "storage_policies" {
  for_each = var.service_endpoint_policies

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "definition" {
    for_each = each.value.definitions
    content {
      name              = definition.value.name
      description       = definition.value.description
      service_resources = definition.value.service_resources
    }
  }

  tags = var.tags
}
