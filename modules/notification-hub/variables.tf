variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location of the notification hub"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the notification hub"
  type        = map(string)
  default     = {}
}

variable "namespaces" {
  description = "Map of notification hub namespace configurations"
  type = map(object({
    name           = string
    namespace_type = string
    sku_name       = string
  }))
}

variable "notification_hubs" {
  description = "Map of notification hub configurations"
  type = map(object({
    name          = string
    namespace_key = string
  }))
}

variable "authorization_rules" {
  description = "Map of authorization rule configurations"
  type = map(object({
    name          = string
    namespace_key = string
    hub_key       = string
    listen        = bool
    send          = bool
    manage        = bool
  }))
  default = {}
} 