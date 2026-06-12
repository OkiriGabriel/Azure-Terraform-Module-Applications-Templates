output "dms_id" {
  description = "Database Migration Service ID"
  value       = azurerm_database_migration_service.main.id
}

output "dms_name" {
  description = "Database Migration Service name"
  value       = azurerm_database_migration_service.main.name
}

output "sql_migration_project_ids" {
  description = "SQL to Azure SQL migration project IDs"
  value = {
    for k, v in azurerm_database_migration_project.sql_to_azure_sql : k => v.id
  }
}

output "postgresql_migration_project_ids" {
  description = "PostgreSQL to Azure PostgreSQL migration project IDs"
  value = {
    for k, v in azurerm_database_migration_project.postgresql_to_azure : k => v.id
  }
}

output "mysql_migration_project_ids" {
  description = "MySQL to Azure MySQL migration project IDs"
  value = {
    for k, v in azurerm_database_migration_project.mysql_to_azure : k => v.id
  }
}

output "backup_storage_account_id" {
  description = "Backup storage account ID"
  value       = azurerm_storage_account.dms_backup.id
}

output "backup_storage_account_name" {
  description = "Backup storage account name"
  value       = azurerm_storage_account.dms_backup.name
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  value       = var.create_log_analytics ? azurerm_log_analytics_workspace.dms[0].id : null
}

output "target_sql_server_ids" {
  description = "Target SQL Server IDs"
  value = {
    for k, v in azurerm_mssql_server.target : k => v.id
  }
}

output "target_sql_server_fqdns" {
  description = "Target SQL Server FQDNs"
  value = {
    for k, v in azurerm_mssql_server.target : k => v.fully_qualified_domain_name
  }
}

output "target_sql_database_ids" {
  description = "Target SQL Database IDs"
  value = {
    for k, v in azurerm_mssql_database.target : k => v.id
  }
}

output "target_postgresql_server_ids" {
  description = "Target PostgreSQL Server IDs"
  value = {
    for k, v in azurerm_postgresql_flexible_server.target : k => v.id
  }
}

output "target_postgresql_server_fqdns" {
  description = "Target PostgreSQL Server FQDNs"
  value = {
    for k, v in azurerm_postgresql_flexible_server.target : k => v.fqdn
  }
}

output "target_mysql_server_ids" {
  description = "Target MySQL Server IDs"
  value = {
    for k, v in azurerm_mysql_flexible_server.target : k => v.id
  }
}

output "target_mysql_server_fqdns" {
  description = "Target MySQL Server FQDNs"
  value = {
    for k, v in azurerm_mysql_flexible_server.target : k => v.fqdn
  }
}

output "automation_account_id" {
  description = "Automation Account ID"
  value       = var.create_automation_account ? azurerm_automation_account.dms[0].id : null
}

output "dma_config_path" {
  description = "Path to Data Migration Assistant configuration file"
  value       = var.create_dma_config ? local_file.dma_config[0].filename : null
}
