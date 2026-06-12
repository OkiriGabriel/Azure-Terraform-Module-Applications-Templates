variable "project_name" {
  description = "Azure Migrate project name"
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

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "service_principal_object_id" {
  description = "Service principal object ID for Key Vault access"
  type        = string
}

variable "registered_tools" {
  description = "List of registered tools for the migrate project"
  type        = list(string)
  default = [
    "ServerAssessment",
    "ServerMigration",
    "DatabaseAssessment",
    "DatabaseMigration",
    "WebAppAssessment",
    "WebAppMigration"
  ]
}

variable "storage_account_name" {
  description = "Storage account name for migration data"
  type        = string
}

variable "key_vault_name" {
  description = "Key Vault name for migration secrets"
  type        = string
}

variable "create_log_analytics" {
  description = "Create a new Log Analytics workspace"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "Existing Log Analytics workspace ID (if not creating new)"
  type        = string
  default     = null
}

variable "log_analytics_workspace_location" {
  description = "Log Analytics workspace location"
  type        = string
  default     = null
}

variable "create_appliance_config" {
  description = "Create appliance configuration file"
  type        = bool
  default     = true
}

variable "appliance_type" {
  description = "Type of appliance (VMware, Hyper-V, Physical)"
  type        = string
  default     = "VMware"
}

variable "discovery_scenario" {
  description = "Discovery scenario (AssessOnly, AssessAndMigrate)"
  type        = string
  default     = "AssessAndMigrate"
}

variable "create_network_watcher" {
  description = "Create Network Watcher for connectivity testing"
  type        = bool
  default     = false
}

variable "enable_private_endpoints" {
  description = "Enable private endpoints for storage and Key Vault"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoints"
  type        = string
  default     = null
}

variable "create_automation_account" {
  description = "Create Automation Account for migration runbooks"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
