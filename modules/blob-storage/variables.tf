variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location of the storage account"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the storage account"
  type        = map(string)
  default     = {}
}

variable "storage_accounts" {
  description = "Map of storage account configurations"
  type = map(object({
    name                            = string
    account_tier                    = string
    account_replication_type        = string
    account_kind                    = string
    access_tier                     = string
    min_tls_version                 = string
    allow_nested_items_to_be_public = bool
    container_delete_retention_policy = optional(object({
      days = number
    }))
    delete_retention_policy = optional(object({
      days = number
    }))
    network_rules = object({
      default_action             = string
      ip_rules                   = list(string)
      virtual_network_subnet_ids = list(string)
      bypass                     = list(string)
    })
  }))
}

variable "containers" {
  description = "Map of storage container configurations"
  type = map(object({
    name                  = string
    storage_account_key   = string
    container_access_type = string
    metadata              = optional(map(string))
  }))
  default = {}
}

variable "cdn_profiles" {
  description = "Map of CDN profile configurations"
  type = map(object({
    name = string
    sku  = string
  }))
  default = {}
}

variable "cdn_endpoints" {
  description = "Map of CDN endpoint configurations"
  type = map(object({
    name                = string
    profile_key         = string
    storage_account_key = string
    origin_name         = string
    optimization_type   = string
    rules = optional(list(object({
      name  = string
      order = number
      cache_expiration_action = optional(object({
        behavior = string
        duration = string
      }))
    })))
  }))
  default = {}
} 