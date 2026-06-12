# variable "name" {
#   description = "Name of the Azure Container Registry"
#   type        = string
# }

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location of the ACR"
  type        = string
}

variable "sku" {
  description = "SKU of the ACR. Possible values: Basic, Standard, Premium"
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Enable admin user"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the ACR"
  type        = map(string)
  default     = {}
}

variable "georeplications" {
  description = "List of locations for geo-replication"
  type = list(object({
    location                = string
    zone_redundancy_enabled = bool
    tags                    = map(string)
  }))
  default = null
}

variable "acrs" {
  description = "Map of ACR configurations"
  type = map(object({
    name         = string
    repositories = optional(list(string), [])
  }))
}


# variable "admin_passwords" {
#   description = "Map of admin passwords for each ACR"
#   type = map(string)
# }

# variable "usernames" {
#   description = "Map of usernames for each ACR"
#   type = map(string)
# }