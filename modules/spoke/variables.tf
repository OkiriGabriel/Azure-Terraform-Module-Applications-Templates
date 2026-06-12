variable "resource_group_name" {}
variable "location" {}
variable "prefix" {}
variable "address_space" {}
# variable "workload_subnet_prefix" {}
variable "hub_virtual_network_id" {}
# variable "hub_resource_group_name" {}
variable "hub_virtual_network_name" {}
# variable "route_table_id" {}
variable "tags" {}

variable "dns_servers" {
  type        = list(string)
  description = "Custom DNS servers"
  default     = []
}
variable "name" {
  description = "Name of the spoke network"
  type        = string
}

variable "network_security_group" {
  description = "Name of the virtual network"
  type        = string
}

# variable "gatway" {
#   description = "Name of the gateway network"
#   type        = string
# }

variable "spoke_to_hub" {
  description = "Name of the spoke to hub peering"
  type        = string
}

variable "hub_to_spoke" {
  description = "Name of the hub to spoke peering"
  type        = string
}

variable "spoke_route_table_name" {
  description = "Name of the route table "
  type        = string
}

# variable "workload_subnet" {
#   description = "Prefix for the workload subnet"
#   type        = string
# }

variable "subnets_with_nsg" {
  description = "Map of subnet names to NSG names"
  type        = list(string)
  default     = []
}


variable "subnet_prefixes" {
  description = "Map of subnet names to address prefixes"
  type        = map(string)
  default     = {}
}

variable "subnet_delegations" {
  description = "Map of subnet names to delegations"
  type = map(list(object({
    name = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  })))
  default = {}
}

