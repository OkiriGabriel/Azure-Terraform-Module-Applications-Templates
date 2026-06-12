variable "resource_group_name" {}
variable "location" {}
variable "prefix" {}
variable "address_space" {}
variable "gateway_subnet_prefix" {}
variable "tags" {}
variable "dns_servers" {
  type        = list(string)
  description = "Custom DNS servers"
  default     = []
}

variable "subnet_prefixes" {
  description = "Map of subnet names to address prefixes"
  type        = map(string)
  default     = {}
  # default = {
  #   AzureFirewallSubnet = "10.0.2.0/24"
  #   AzureBastionSubnet  = "10.0.3.0/24"
  #   SharedServices      = "10.0.4.0/24"
  #   Management          = "10.0.5.0/24"
  # }
}

variable "name" {
  description = "Name of the hub network"
  type        = string
}

variable "network_security_group" {
  description = "Name of the virtual network"
  type        = string
}

variable "gateway" {
  description = "Name of the gateway network"
  type        = string
}