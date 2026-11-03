# Database Migration Service Module

Azure Database Migration Service for SQL Server, PostgreSQL and MySQL migrations.

## Resources

- `azurerm_automation_account`
- `azurerm_automation_runbook`
- `azurerm_database_migration_project`
- `azurerm_database_migration_service`
- `azurerm_log_analytics_workspace`
- `azurerm_monitor_diagnostic_setting`
- `azurerm_mssql_database`
- `azurerm_mssql_server`
- `azurerm_mysql_flexible_database`
- `azurerm_mysql_flexible_server`
- `azurerm_postgresql_flexible_server`
- `azurerm_postgresql_flexible_server_database`
- `azurerm_private_endpoint`
- `azurerm_storage_account`
- `azurerm_storage_container`
- `local_file`

## Usage

```hcl
module "database_migration" {
  source = "./modules/database-migration"

  dms_name                    = ...
  resource_group_name         = ...
  location                    = ...
  subscription_id             = ...
  subnet_id                   = ...
  backup_storage_account_name = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `dms_name` | Database Migration Service name | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `subscription_id` | Azure subscription ID | `string` | n/a | yes |
| `subnet_id` | Subnet ID for DMS | `string` | n/a | yes |
| `sku_name` | DMS SKU name (Standard_1vCore, Standard_2vCores, Standard_4vCores, Premium_4vCores) | `string` | `"Standard_1vCore"` | no |
| `backup_storage_account_name` | Storage account name for DMS backups | `string` | n/a | yes |
| `enable_private_endpoint` | Enable private endpoint for DMS | `bool` | `false` | no |
| `private_endpoint_subnet_id` | Subnet ID for private endpoint | `string` | `null` | no |
| `create_log_analytics` | Create Log Analytics workspace | `bool` | `true` | no |
| `log_analytics_workspace_id` | Existing Log Analytics workspace ID | `string` | `null` | no |
| `enable_diagnostics` | Enable diagnostic settings | `bool` | `true` | no |
| `create_dma_config` | Create Data Migration Assistant configuration file | `bool` | `true` | no |
| `sql_to_azure_sql_projects` | SQL Server to Azure SQL Database migration projects | `map(...)` | `{}` | no |
| `postgresql_to_azure_projects` | PostgreSQL to Azure PostgreSQL migration projects | `map(...)` | `{}` | no |
| `mysql_to_azure_projects` | MySQL to Azure MySQL migration projects | `map(...)` | `{}` | no |
| `create_target_sql_servers` | Create target Azure SQL Servers | `map(...)` | `{}` | no |
| `create_target_sql_databases` | Create target Azure SQL Databases | `map(...)` | `{}` | no |
| `create_target_postgresql_servers` | Create target Azure PostgreSQL Flexible Servers | `map(...)` | `{}` | no |
| `create_target_postgresql_databases` | Create target PostgreSQL databases | `map(...)` | `{}` | no |
| `create_target_mysql_servers` | Create target Azure MySQL Flexible Servers | `map(...)` | `{}` | no |
| `create_target_mysql_databases` | Create target MySQL databases | `map(...)` | `{}` | no |
| `create_automation_account` | Create Automation Account for migration scripts | `bool` | `true` | no |
| `tags` | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `dms_id` | Database Migration Service ID | no |
| `dms_name` | Database Migration Service name | no |
| `sql_migration_project_ids` | SQL to Azure SQL migration project IDs | no |
| `postgresql_migration_project_ids` | PostgreSQL to Azure PostgreSQL migration project IDs | no |
| `mysql_migration_project_ids` | MySQL to Azure MySQL migration project IDs | no |
| `backup_storage_account_id` | Backup storage account ID | no |
| `backup_storage_account_name` | Backup storage account name | no |
| `log_analytics_workspace_id` | Log Analytics workspace ID | no |
| `target_sql_server_ids` | Target SQL Server IDs | no |
| `target_sql_server_fqdns` | Target SQL Server FQDNs | no |
| `target_sql_database_ids` | Target SQL Database IDs | no |
| `target_postgresql_server_ids` | Target PostgreSQL Server IDs | no |
| `target_postgresql_server_fqdns` | Target PostgreSQL Server FQDNs | no |
| `target_mysql_server_ids` | Target MySQL Server IDs | no |
| `target_mysql_server_fqdns` | Target MySQL Server FQDNs | no |
| `automation_account_id` | Automation Account ID | no |
| `dma_config_path` | Path to Data Migration Assistant configuration file | no |
<!-- END_TF_DOCS -->
