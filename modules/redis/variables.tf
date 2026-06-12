variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location of the Redis Cache"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Redis Cache"
  type        = map(string)
  default     = {}
}

variable "redis_caches" {
  description = "Map of Redis Cache configurations"
  type = map(object({
    name                = string
    capacity            = number
    family              = string
    sku_name            = string
    minimum_tls_version = string
    maxmemory_reserved  = number
    maxmemory_delta     = number
    maxmemory_policy    = string
  }))
}
