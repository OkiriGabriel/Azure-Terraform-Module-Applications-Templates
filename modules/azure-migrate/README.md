# Azure Migrate Module

Azure Migrate project for discovering and assessing on-premises servers before migration.

## Resources

- `azurerm_automation_account`
- `azurerm_automation_runbook`
- `azurerm_backup_policy_vm`
- `azurerm_key_vault`
- `azurerm_log_analytics_workspace`
- `azurerm_network_watcher`
- `azurerm_private_endpoint`
- `azurerm_recovery_services_vault`
- `azurerm_resource_group_template_deployment`
- `azurerm_storage_account`
- `azurerm_storage_container`
- `local_file`

## Usage

```hcl
module "azure_migrate" {
  source = "./modules/azure-migrate"

  project_name                = ...
  resource_group_name         = ...
  location                    = ...
  subscription_id             = ...
  tenant_id                   = ...
  service_principal_object_id = ...
  storage_account_name        = ...
  key_vault_name              = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_name` | Azure Migrate project name | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `subscription_id` | Azure subscription ID | `string` | n/a | yes |
| `tenant_id` | Azure AD tenant ID | `string` | n/a | yes |
| `service_principal_object_id` | Service principal object ID for Key Vault access | `string` | n/a | yes |
| `registered_tools` | List of registered tools for the migrate project | `list(string)` | `see source` | no |
| `storage_account_name` | Storage account name for migration data | `string` | n/a | yes |
| `key_vault_name` | Key Vault name for migration secrets | `string` | n/a | yes |
| `create_log_analytics` | Create a new Log Analytics workspace | `bool` | `true` | no |
| `log_analytics_workspace_id` | Existing Log Analytics workspace ID (if not creating new) | `string` | `null` | no |
| `log_analytics_workspace_location` | Log Analytics workspace location | `string` | `null` | no |
| `create_appliance_config` | Create appliance configuration file | `bool` | `true` | no |
| `appliance_type` | Type of appliance (VMware, Hyper-V, Physical) | `string` | `"VMware"` | no |
| `discovery_scenario` | Discovery scenario (AssessOnly, AssessAndMigrate) | `string` | `"AssessAndMigrate"` | no |
| `create_network_watcher` | Create Network Watcher for connectivity testing | `bool` | `false` | no |
| `enable_private_endpoints` | Enable private endpoints for storage and Key Vault | `bool` | `false` | no |
| `private_endpoint_subnet_id` | Subnet ID for private endpoints | `string` | `null` | no |
| `create_automation_account` | Create Automation Account for migration runbooks | `bool` | `true` | no |
| `tags` | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `migrate_project_id` | Azure Migrate project ID | no |
| `assessment_project_id` | Azure Migrate assessment project ID | no |
| `storage_account_id` | Migration storage account ID | no |
| `storage_account_name` | Migration storage account name | no |
| `storage_account_primary_blob_endpoint` | Storage account primary blob endpoint | no |
| `key_vault_id` | Migration Key Vault ID | no |
| `key_vault_uri` | Migration Key Vault URI | no |
| `log_analytics_workspace_id` | Log Analytics workspace ID | no |
| `log_analytics_workspace_workspace_id` | Log Analytics workspace workspace ID (GUID) | no |
| `recovery_services_vault_id` | Recovery Services Vault ID | no |
| `recovery_services_vault_name` | Recovery Services Vault name | no |
| `backup_policy_id` | Backup policy ID | no |
| `automation_account_id` | Automation Account ID | no |
| `automation_account_dsc_server_endpoint` | Automation Account DSC server endpoint | no |
| `private_endpoint_storage_id` | Storage private endpoint ID | no |
| `private_endpoint_keyvault_id` | Key Vault private endpoint ID | no |
| `appliance_config_path` | Path to appliance configuration file | no |
<!-- END_TF_DOCS -->
