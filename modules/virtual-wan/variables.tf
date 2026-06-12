variable "virtual_wan_name" {
  description = "Name of the Virtual WAN"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "virtual_wan_type" {
  description = "Type of Virtual WAN (Standard or Basic)"
  type        = string
  default     = "Standard"
}

variable "disable_vpn_encryption" {
  description = "Disable VPN encryption"
  type        = bool
  default     = false
}

variable "allow_branch_to_branch_traffic" {
  description = "Allow branch to branch traffic"
  type        = bool
  default     = true
}

variable "office365_local_breakout_category" {
  description = "Office 365 local breakout category"
  type        = string
  default     = "None"
}

variable "virtual_hubs" {
  description = "Virtual hubs configuration"
  type = map(object({
    name           = string
    location       = string
    address_prefix = string
    sku            = string
  }))
  default = {}
}

variable "vpn_gateways" {
  description = "VPN gateways configuration"
  type = map(object({
    name            = string
    location        = string
    virtual_hub_key = string
    scale_unit      = number
    enable_bgp      = bool
    bgp_asn         = number
    bgp_peer_weight = number
  }))
  default = {}
}

variable "expressroute_gateways" {
  description = "ExpressRoute gateways configuration"
  type = map(object({
    name            = string
    location        = string
    virtual_hub_key = string
    scale_units     = number
  }))
  default = {}
}

variable "vnet_connections" {
  description = "Virtual network connections to hubs"
  type = map(object({
    name                          = string
    virtual_hub_key               = string
    remote_virtual_network_id     = string
    internet_security_enabled     = bool
    enable_routing                = bool
    associated_route_table_id     = string
    propagated_route_table_ids    = list(string)
    propagated_route_table_labels = list(string)
    static_routes = list(object({
      name                = string
      address_prefixes    = list(string)
      next_hop_ip_address = string
    }))
  }))
  default = {}
}

variable "virtual_hub_route_tables" {
  description = "Virtual hub route tables"
  type = map(object({
    name            = string
    virtual_hub_key = string
    labels          = list(string)
    routes = list(object({
      name              = string
      destinations_type = string
      destinations      = list(string)
      next_hop_type     = string
      next_hop          = string
    }))
  }))
  default = {}
}

variable "vpn_sites" {
  description = "VPN sites for site-to-site connections"
  type = map(object({
    name          = string
    location      = string
    address_cidrs = list(string)
    device_vendor = string
    device_model  = string
    links = list(object({
      name                = string
      ip_address          = string
      fqdn                = string
      speed_in_mbps       = number
      provider_name       = string
      enable_bgp          = bool
      bgp_asn             = number
      bgp_peering_address = string
    }))
  }))
  default = {}
}

variable "vpn_connections" {
  description = "VPN connections between gateway and sites"
  type = map(object({
    name                      = string
    vpn_gateway_key           = string
    vpn_site_key              = string
    internet_security_enabled = bool
    vpn_links = list(object({
      name                 = string
      link_index           = number
      bandwidth_mbps       = number
      bgp_enabled          = bool
      protocol             = string
      ratelimit_enabled    = bool
      route_weight         = number
      shared_key           = string
      enable_custom_ipsec  = bool
      ipsec_dh_group       = string
      ipsec_ike_encryption = string
      ipsec_ike_integrity  = string
      ipsec_encryption     = string
      ipsec_integrity      = string
      ipsec_pfs_group      = string
      ipsec_sa_data_size   = number
      ipsec_sa_lifetime    = number
    }))
  }))
  default = {}
}

variable "hub_firewalls" {
  description = "Azure Firewalls in Virtual Hubs (Secured Hubs)"
  type = map(object({
    name               = string
    location           = string
    virtual_hub_key    = string
    sku_tier           = string
    firewall_policy_id = string
    public_ip_count    = number
  }))
  default = {}
}

variable "routing_intents" {
  description = "Routing intents for secured hubs"
  type = map(object({
    name            = string
    virtual_hub_key = string
    firewall_key    = string
    routing_policies = list(object({
      name         = string
      destinations = list(string)
    }))
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
