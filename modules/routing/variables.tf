variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Route Tables
variable "route_tables" {
  description = "Route tables configuration"
  type = map(object({
    name                          = string
    disable_bgp_route_propagation = bool
    routes = list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
    }))
  }))
  default = {}
}

# Subnet Route Table Associations
variable "subnet_route_table_associations" {
  description = "Subnet to route table associations"
  type = map(object({
    subnet_id       = string
    route_table_key = string
  }))
  default = {}
}

# Network Virtual Appliances
variable "network_virtual_appliances" {
  description = "Network Virtual Appliances (NVAs) for advanced routing"
  type = map(object({
    name                          = string
    subnet_id                     = string
    private_ip_address            = string
    vm_size                       = string
    admin_username                = string
    ssh_public_key                = string
    os_disk_type                  = string
    enable_accelerated_networking = bool
    image_publisher               = string
    image_offer                   = string
    image_sku                     = string
    image_version                 = string
    custom_data                   = string
  }))
  default = {}
}

# Route Servers
variable "route_servers" {
  description = "Azure Route Servers for dynamic routing"
  type = map(object({
    name                             = string
    subnet_id                        = string
    sku                              = string
    branch_to_branch_traffic_enabled = bool
  }))
  default = {}
}

# Route Server BGP Connections
variable "route_server_bgp_connections" {
  description = "BGP connections for Route Servers"
  type = map(object({
    name             = string
    route_server_key = string
    peer_asn         = number
    peer_ip          = string
  }))
  default = {}
}

# Traffic Manager
variable "traffic_manager_profiles" {
  description = "Traffic Manager profiles for global load balancing"
  type = map(object({
    name                       = string
    routing_method             = string
    max_return                 = number
    dns_relative_name          = string
    dns_ttl                    = number
    monitor_protocol           = string
    monitor_port               = number
    monitor_path               = string
    monitor_interval           = number
    monitor_timeout            = number
    monitor_tolerated_failures = number
  }))
  default = {}
}

variable "traffic_manager_endpoints" {
  description = "Traffic Manager endpoints"
  type = map(object({
    name               = string
    profile_key        = string
    target_resource_id = string
    weight             = number
    priority           = number
    enabled            = bool
    geo_mappings       = list(string)
  }))
  default = {}
}

# Azure Front Door
variable "frontdoor_profiles" {
  description = "Front Door profiles"
  type = map(object({
    name     = string
    sku_name = string
  }))
  default = {}
}

variable "frontdoor_endpoints" {
  description = "Front Door endpoints"
  type = map(object({
    name        = string
    profile_key = string
    enabled     = bool
  }))
  default = {}
}

variable "frontdoor_origin_groups" {
  description = "Front Door origin groups"
  type = map(object({
    name                        = string
    profile_key                 = string
    sample_size                 = number
    successful_samples_required = number
    additional_latency_ms       = number
    enable_health_probe         = bool
    health_probe_protocol       = string
    health_probe_interval       = number
    health_probe_path           = string
    health_probe_request_type   = string
  }))
  default = {}
}

variable "frontdoor_origins" {
  description = "Front Door origins"
  type = map(object({
    name                           = string
    origin_group_key               = string
    enabled                        = bool
    certificate_name_check_enabled = bool
    host_name                      = string
    http_port                      = number
    https_port                     = number
    origin_host_header             = string
    priority                       = number
    weight                         = number
  }))
  default = {}
}

# Service Endpoint Policies
variable "service_endpoint_policies" {
  description = "Service endpoint policies for storage"
  type = map(object({
    name = string
    definitions = list(object({
      name              = string
      description       = string
      service_resources = list(string)
    }))
  }))
  default = {}
}
