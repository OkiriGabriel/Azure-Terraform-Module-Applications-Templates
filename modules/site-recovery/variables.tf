variable "vault_name" {
  description = "Recovery Services Vault name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region for the vault"
  type        = string
}

variable "target_location" {
  description = "Target Azure region for recovery"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "vault_sku" {
  description = "Recovery Services Vault SKU (Standard or RS0)"
  type        = string
  default     = "Standard"
}

variable "soft_delete_enabled" {
  description = "Enable soft delete"
  type        = bool
  default     = true
}

variable "storage_mode_type" {
  description = "Storage mode type (GeoRedundant, LocallyRedundant, ZoneRedundant)"
  type        = string
  default     = "GeoRedundant"
}

variable "source_fabrics" {
  description = "Source recovery fabrics"
  type = map(object({
    name     = string
    location = string
  }))
  default = {}
}

variable "target_fabrics" {
  description = "Target recovery fabrics"
  type = map(object({
    name     = string
    location = string
  }))
  default = {}
}

variable "source_protection_containers" {
  description = "Source protection containers"
  type = map(object({
    name       = string
    fabric_key = string
  }))
  default = {}
}

variable "target_protection_containers" {
  description = "Target protection containers"
  type = map(object({
    name       = string
    fabric_key = string
  }))
  default = {}
}

variable "replication_policies" {
  description = "Replication policies"
  type = map(object({
    name                                      = string
    recovery_point_retention_minutes          = number
    app_consistent_snapshot_frequency_minutes = number
  }))
  default = {}
}

variable "protection_container_mappings" {
  description = "Protection container mappings"
  type = map(object({
    name                 = string
    source_fabric_key    = string
    source_container_key = string
    target_container_key = string
    policy_key           = string
  }))
  default = {}
}

variable "network_mappings" {
  description = "Network mappings for ASR"
  type = map(object({
    name              = string
    source_fabric_key = string
    target_fabric_key = string
    source_network_id = string
    target_network_id = string
  }))
  default = {}
}

variable "cache_storage_account_name" {
  description = "Cache storage account name"
  type        = string
}

variable "create_target_storage" {
  description = "Create target storage account"
  type        = bool
  default     = false
}

variable "target_storage_account_name" {
  description = "Target storage account name"
  type        = string
  default     = null
}

variable "target_storage_replication_type" {
  description = "Target storage replication type"
  type        = string
  default     = "LRS"
}

variable "create_automation_account" {
  description = "Create Automation Account for recovery plans"
  type        = bool
  default     = true
}

variable "create_log_analytics" {
  description = "Create Log Analytics workspace"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "Existing Log Analytics workspace ID"
  type        = string
  default     = null
}

variable "enable_diagnostics" {
  description = "Enable diagnostic settings"
  type        = bool
  default     = true
}

variable "enable_alerts" {
  description = "Enable monitoring alerts"
  type        = bool
  default     = false
}

variable "action_group_id" {
  description = "Action group ID for alerts"
  type        = string
  default     = null
}

variable "create_asr_config" {
  description = "Create ASR configuration file"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
