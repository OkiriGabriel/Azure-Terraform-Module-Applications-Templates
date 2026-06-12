variable "dms_name" {
  description = "Database Migration Service name"
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

variable "subnet_id" {
  description = "Subnet ID for DMS"
  type        = string
}

variable "sku_name" {
  description = "DMS SKU name (Standard_1vCore, Standard_2vCores, Standard_4vCores, Premium_4vCores)"
  type        = string
  default     = "Standard_1vCore"
}

variable "backup_storage_account_name" {
  description = "Storage account name for DMS backups"
  type        = string
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for DMS"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
  default     = null
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

variable "create_dma_config" {
  description = "Create Data Migration Assistant configuration file"
  type        = bool
  default     = true
}

variable "sql_to_azure_sql_projects" {
  description = "SQL Server to Azure SQL Database migration projects"
  type = map(object({
    name = string
  }))
  default = {}
}

variable "postgresql_to_azure_projects" {
  description = "PostgreSQL to Azure PostgreSQL migration projects"
  type = map(object({
    name = string
  }))
  default = {}
}

variable "mysql_to_azure_projects" {
  description = "MySQL to Azure MySQL migration projects"
  type = map(object({
    name = string
  }))
  default = {}
}

variable "create_target_sql_servers" {
  description = "Create target Azure SQL Servers"
  type = map(object({
    name                    = string
    version                 = string
    admin_login             = string
    admin_password          = string
    azuread_admin_login     = string
    azuread_admin_object_id = string
  }))
  default = {}
}

variable "create_target_sql_databases" {
  description = "Create target Azure SQL Databases"
  type = map(object({
    name           = string
    server_key     = string
    collation      = string
    max_size_gb    = number
    sku_name       = string
    zone_redundant = bool
  }))
  default = {}
}

variable "create_target_postgresql_servers" {
  description = "Create target Azure PostgreSQL Flexible Servers"
  type = map(object({
    name           = string
    version        = string
    admin_login    = string
    admin_password = string
    storage_mb     = number
    sku_name       = string
    zone           = string
  }))
  default = {}
}

variable "create_target_postgresql_databases" {
  description = "Create target PostgreSQL databases"
  type = map(object({
    name       = string
    server_key = string
    collation  = string
    charset    = string
  }))
  default = {}
}

variable "create_target_mysql_servers" {
  description = "Create target Azure MySQL Flexible Servers"
  type = map(object({
    name           = string
    version        = string
    admin_login    = string
    admin_password = string
    sku_name       = string
    storage_gb     = number
    zone           = string
  }))
  default = {}
}

variable "create_target_mysql_databases" {
  description = "Create target MySQL databases"
  type = map(object({
    name       = string
    server_key = string
    charset    = string
    collation  = string
  }))
  default = {}
}

variable "create_automation_account" {
  description = "Create Automation Account for migration scripts"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
