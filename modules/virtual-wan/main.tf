# Azure Virtual WAN
resource "azurerm_virtual_wan" "main" {
  name                = var.virtual_wan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  type                = var.virtual_wan_type

  disable_vpn_encryption            = var.disable_vpn_encryption
  allow_branch_to_branch_traffic    = var.allow_branch_to_branch_traffic
  office365_local_breakout_category = var.office365_local_breakout_category

  tags = var.tags
}

# Virtual Hubs
resource "azurerm_virtual_hub" "hubs" {
  for_each = var.virtual_hubs

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = each.value.location
  virtual_wan_id      = azurerm_virtual_wan.main.id
  address_prefix      = each.value.address_prefix
  sku                 = each.value.sku

  tags = var.tags
}

# VPN Gateway in Virtual Hub
resource "azurerm_vpn_gateway" "gateways" {
  for_each = var.vpn_gateways

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = each.value.location
  virtual_hub_id      = azurerm_virtual_hub.hubs[each.value.virtual_hub_key].id
  scale_unit          = each.value.scale_unit

  dynamic "bgp_settings" {
    for_each = each.value.enable_bgp ? [1] : []
    content {
      asn         = each.value.bgp_asn
      peer_weight = each.value.bgp_peer_weight
    }
  }

  tags = var.tags
}

# ExpressRoute Gateway in Virtual Hub
resource "azurerm_express_route_gateway" "gateways" {
  for_each = var.expressroute_gateways

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = each.value.location
  virtual_hub_id      = azurerm_virtual_hub.hubs[each.value.virtual_hub_key].id
  scale_units         = each.value.scale_units

  tags = var.tags
}

# Virtual Hub Connection to VNets
resource "azurerm_virtual_hub_connection" "vnet_connections" {
  for_each = var.vnet_connections

  name                      = each.value.name
  virtual_hub_id            = azurerm_virtual_hub.hubs[each.value.virtual_hub_key].id
  remote_virtual_network_id = each.value.remote_virtual_network_id
  internet_security_enabled = each.value.internet_security_enabled

  dynamic "routing" {
    for_each = each.value.enable_routing ? [1] : []
    content {
      associated_route_table_id = each.value.associated_route_table_id

      dynamic "propagated_route_table" {
        for_each = each.value.propagated_route_table_ids != null ? [1] : []
        content {
          route_table_ids = each.value.propagated_route_table_ids
          labels          = each.value.propagated_route_table_labels
        }
      }

      dynamic "static_vnet_route" {
        for_each = each.value.static_routes
        content {
          name                = static_vnet_route.value.name
          address_prefixes    = static_vnet_route.value.address_prefixes
          next_hop_ip_address = static_vnet_route.value.next_hop_ip_address
        }
      }
    }
  }
}

# Virtual Hub Route Table
resource "azurerm_virtual_hub_route_table" "route_tables" {
  for_each = var.virtual_hub_route_tables

  name           = each.value.name
  virtual_hub_id = azurerm_virtual_hub.hubs[each.value.virtual_hub_key].id
  labels         = each.value.labels

  dynamic "route" {
    for_each = each.value.routes
    content {
      name              = route.value.name
      destinations_type = route.value.destinations_type
      destinations      = route.value.destinations
      next_hop_type     = route.value.next_hop_type
      next_hop          = route.value.next_hop
    }
  }
}

# VPN Site
resource "azurerm_vpn_site" "sites" {
  for_each = var.vpn_sites

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = each.value.location
  virtual_wan_id      = azurerm_virtual_wan.main.id
  address_cidrs       = each.value.address_cidrs

  dynamic "link" {
    for_each = each.value.links
    content {
      name          = link.value.name
      ip_address    = link.value.ip_address
      fqdn          = link.value.fqdn
      speed_in_mbps = link.value.speed_in_mbps
      provider_name = link.value.provider_name

      dynamic "bgp" {
        for_each = link.value.enable_bgp ? [1] : []
        content {
          asn             = link.value.bgp_asn
          peering_address = link.value.bgp_peering_address
        }
      }
    }
  }

  device_vendor = each.value.device_vendor
  device_model  = each.value.device_model

  tags = var.tags
}

# VPN Connection
resource "azurerm_vpn_gateway_connection" "connections" {
  for_each = var.vpn_connections

  name               = each.value.name
  vpn_gateway_id     = azurerm_vpn_gateway.gateways[each.value.vpn_gateway_key].id
  remote_vpn_site_id = azurerm_vpn_site.sites[each.value.vpn_site_key].id

  dynamic "vpn_link" {
    for_each = each.value.vpn_links
    content {
      name              = vpn_link.value.name
      vpn_site_link_id  = azurerm_vpn_site.sites[each.value.vpn_site_key].link[vpn_link.value.link_index].id
      bandwidth_mbps    = vpn_link.value.bandwidth_mbps
      bgp_enabled       = vpn_link.value.bgp_enabled
      protocol          = vpn_link.value.protocol
      ratelimit_enabled = vpn_link.value.ratelimit_enabled
      route_weight      = vpn_link.value.route_weight
      shared_key        = vpn_link.value.shared_key

      dynamic "ipsec_policy" {
        for_each = vpn_link.value.enable_custom_ipsec ? [1] : []
        content {
          dh_group                 = vpn_link.value.ipsec_dh_group
          ike_encryption_algorithm = vpn_link.value.ipsec_ike_encryption
          ike_integrity_algorithm  = vpn_link.value.ipsec_ike_integrity
          encryption_algorithm     = vpn_link.value.ipsec_encryption
          integrity_algorithm      = vpn_link.value.ipsec_integrity
          pfs_group                = vpn_link.value.ipsec_pfs_group
          sa_data_size_kb          = vpn_link.value.ipsec_sa_data_size
          sa_lifetime_sec          = vpn_link.value.ipsec_sa_lifetime
        }
      }
    }
  }

  internet_security_enabled = each.value.internet_security_enabled
}

# Azure Firewall in Virtual Hub (Secured Hub)
resource "azurerm_firewall" "hub_firewall" {
  for_each = var.hub_firewalls

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = each.value.location
  sku_name            = "AZFW_Hub"
  sku_tier            = each.value.sku_tier
  firewall_policy_id  = each.value.firewall_policy_id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.hubs[each.value.virtual_hub_key].id
    public_ip_count = each.value.public_ip_count
  }

  tags = var.tags
}

# Routing Intent (for secured hubs)
resource "azurerm_virtual_hub_routing_intent" "routing_intent" {
  for_each = var.routing_intents

  name           = each.value.name
  virtual_hub_id = azurerm_virtual_hub.hubs[each.value.virtual_hub_key].id

  dynamic "routing_policy" {
    for_each = each.value.routing_policies
    content {
      name         = routing_policy.value.name
      destinations = routing_policy.value.destinations
      next_hop     = azurerm_firewall.hub_firewall[each.value.firewall_key].id
    }
  }
}
