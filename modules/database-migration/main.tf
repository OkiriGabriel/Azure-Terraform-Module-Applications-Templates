# Database Migration Service
resource "azurerm_database_migration_service" "main" {
  name                = var.dms_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  sku_name            = var.sku_name

  tags = var.tags
}

# Database Migration Project - SQL to Azure SQL
resource "azurerm_database_migration_project" "sql_to_azure_sql" {
  for_each = var.sql_to_azure_sql_projects

  name                = each.value.name
  service_name        = azurerm_database_migration_service.main.name
  resource_group_name = var.resource_group_name
  location            = var.location
  source_platform     = "SQL"
  target_platform     = "SQLDB"

  tags = var.tags
}

# Database Migration Project - PostgreSQL to Azure PostgreSQL
resource "azurerm_database_migration_project" "postgresql_to_azure" {
  for_each = var.postgresql_to_azure_projects

  name                = each.value.name
  service_name        = azurerm_database_migration_service.main.name
  resource_group_name = var.resource_group_name
  location            = var.location
  source_platform     = "PostgreSql"
  target_platform     = "AzureDbForPostgreSql"

  tags = var.tags
}

# Database Migration Project - MySQL to Azure MySQL
resource "azurerm_database_migration_project" "mysql_to_azure" {
  for_each = var.mysql_to_azure_projects

  name                = each.value.name
  service_name        = azurerm_database_migration_service.main.name
  resource_group_name = var.resource_group_name
  location            = var.location
  source_platform     = "MySQL"
  target_platform     = "AzureDbForMySql"

  tags = var.tags
}

# Storage Account for DMS Backups
resource "azurerm_storage_account" "dms_backup" {
  name                     = var.backup_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  blob_properties {
    delete_retention_policy {
      days = 30
    }
    versioning_enabled = true
  }

  tags = var.tags
}

resource "azurerm_storage_container" "dms_backup" {
  name                  = "dms-backups"
  storage_account_id    = azurerm_storage_account.dms_backup.id
  container_access_type = "private"
}

# Private Endpoint for DMS
resource "azurerm_private_endpoint" "dms" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.dms_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.dms_name}-psc"
    private_connection_resource_id = azurerm_database_migration_service.main.id
    is_manual_connection           = false
    subresource_names              = ["SqlMigrationService"]
  }

  tags = var.tags
}

# Log Analytics for DMS Monitoring
resource "azurerm_log_analytics_workspace" "dms" {
  count               = var.create_log_analytics ? 1 : 0
  name                = "${var.dms_name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

# Diagnostic Settings for DMS
resource "azurerm_monitor_diagnostic_setting" "dms" {
  count                      = var.enable_diagnostics ? 1 : 0
  name                       = "${var.dms_name}-diagnostics"
  target_resource_id         = azurerm_database_migration_service.main.id
  log_analytics_workspace_id = var.create_log_analytics ? azurerm_log_analytics_workspace.dms[0].id : var.log_analytics_workspace_id

  enabled_log {
    category = "DatabaseMigrationServiceEvent"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Azure Data Migration Assistant Configuration Script
resource "local_file" "dma_config" {
  count    = var.create_dma_config ? 1 : 0
  filename = "${path.module}/dma-config.json"

  content = jsonencode({
    dmsServiceName          = azurerm_database_migration_service.main.name
    resourceGroupName       = var.resource_group_name
    subscriptionId          = var.subscription_id
    location                = var.location
    backupStorageAccount    = azurerm_storage_account.dms_backup.name
    backupStorageContainer  = azurerm_storage_container.dms_backup.name
    logAnalyticsWorkspaceId = var.create_log_analytics ? azurerm_log_analytics_workspace.dms[0].workspace_id : var.log_analytics_workspace_id
  })
}

# Azure SQL Database for Migration Target
resource "azurerm_mssql_server" "target" {
  for_each = var.create_target_sql_servers

  name                         = each.value.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = each.value.version
  administrator_login          = each.value.admin_login
  administrator_login_password = each.value.admin_password

  azuread_administrator {
    login_username = each.value.azuread_admin_login
    object_id      = each.value.azuread_admin_object_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_mssql_database" "target" {
  for_each = var.create_target_sql_databases

  name           = each.value.name
  server_id      = azurerm_mssql_server.target[each.value.server_key].id
  collation      = each.value.collation
  max_size_gb    = each.value.max_size_gb
  sku_name       = each.value.sku_name
  zone_redundant = each.value.zone_redundant

  tags = var.tags
}

# PostgreSQL Flexible Server for Migration Target
resource "azurerm_postgresql_flexible_server" "target" {
  for_each = var.create_target_postgresql_servers

  name                   = each.value.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = each.value.version
  administrator_login    = each.value.admin_login
  administrator_password = each.value.admin_password
  storage_mb             = each.value.storage_mb
  sku_name               = each.value.sku_name
  zone                   = each.value.zone

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "target" {
  for_each = var.create_target_postgresql_databases

  name      = each.value.name
  server_id = azurerm_postgresql_flexible_server.target[each.value.server_key].id
  collation = each.value.collation
  charset   = each.value.charset
}

# MySQL Flexible Server for Migration Target
resource "azurerm_mysql_flexible_server" "target" {
  for_each = var.create_target_mysql_servers

  name                   = each.value.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = each.value.version
  administrator_login    = each.value.admin_login
  administrator_password = each.value.admin_password
  sku_name               = each.value.sku_name
  zone                   = each.value.zone

  storage {
    size_gb = each.value.storage_gb
  }

  tags = var.tags
}

resource "azurerm_mysql_flexible_database" "target" {
  for_each = var.create_target_mysql_databases

  name                = each.value.name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.target[each.value.server_key].name
  charset             = each.value.charset
  collation           = each.value.collation
}

# Automation Runbook for Pre-Migration Assessment
resource "azurerm_automation_account" "dms" {
  count               = var.create_automation_account ? 1 : 0
  name                = "${var.dms_name}-automation"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"

  tags = var.tags
}

resource "azurerm_automation_runbook" "db_assessment" {
  count                   = var.create_automation_account ? 1 : 0
  name                    = "DatabaseAssessment"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.dms[0].name
  log_verbose             = true
  log_progress            = true
  runbook_type            = "PowerShell"

  content = <<-EOT
    param(
      [Parameter(Mandatory=$true)]
      [string]$SourceServer,
      
      [Parameter(Mandatory=$true)]
      [string]$SourceDatabase,
      
      [Parameter(Mandatory=$true)]
      [string]$TargetPlatform
    )

    Write-Output "Starting database assessment"
    Write-Output "Source Server: $SourceServer"
    Write-Output "Source Database: $SourceDatabase"
    Write-Output "Target Platform: $TargetPlatform"
    
    # Assessment logic would go here
    # This is a template that would need to be customized
    
    Write-Output "Database assessment completed"
  EOT

  tags = var.tags
}
