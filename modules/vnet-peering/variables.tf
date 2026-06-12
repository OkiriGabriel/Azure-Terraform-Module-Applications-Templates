variable "peering_configurations" {
  description = "VNet peering configurations within same region"
  type = map(object({
    name                            = string
    source_resource_group_name      = string
    source_vnet_name                = string
    source_vnet_id                  = string
    destination_resource_group_name = string
    destination_vnet_name           = string
    destination_vnet_id             = string
    allow_virtual_network_access    = bool
    allow_forwarded_traffic         = bool
    allow_gateway_transit           = bool
    use_remote_gateways             = bool
    allow_gateway_transit_reverse   = bool
    use_remote_gateways_reverse     = bool
  }))
  default = {}
}

variable "global_peering_configurations" {
  description = "Global VNet peering configurations across regions"
  type = map(object({
    name                            = string
    source_resource_group_name      = string
    source_vnet_name                = string
    source_vnet_id                  = string
    destination_resource_group_name = string
    destination_vnet_name           = string
    destination_vnet_id             = string
    allow_virtual_network_access    = bool
    allow_forwarded_traffic         = bool
    allow_gateway_transit           = bool
    use_remote_gateways             = bool
    allow_gateway_transit_reverse   = bool
    use_remote_gateways_reverse     = bool
  }))
  default = {}
}

variable "enable_flow_logs" {
  description = "Enable NSG flow logs for peering monitoring"
  type        = bool
  default     = false
}

variable "flow_log_configurations" {
  description = "Flow log configurations for peering monitoring"
  type = map(object({
    network_watcher_name                = string
    network_watcher_resource_group_name = string
    nsg_name                            = string
    nsg_id                              = string
    storage_account_id                  = string
    retention_days                      = number
    enable_traffic_analytics            = bool
    log_analytics_workspace_id          = string
    log_analytics_workspace_region      = string
    log_analytics_workspace_resource_id = string
  }))
  default = {}
}

variable "enable_connection_monitoring" {
  description = "Enable connection monitoring for peering health"
  type        = bool
  default     = false
}

variable "connection_monitor_configurations" {
  description = "Connection monitor configurations"
  type = map(object({
    name                      = string
    network_watcher_id        = string
    location                  = string
    source_endpoint_name      = string
    source_vm_id              = string
    destination_endpoint_name = string
    destination_ip_address    = string
    test_port                 = number
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
