# Site Recovery Module

Recovery Services vault and Azure Site Recovery for VM disaster recovery and migration.

## Resources

- `azurerm_automation_account`
- `azurerm_automation_runbook`
- `azurerm_log_analytics_workspace`
- `azurerm_monitor_diagnostic_setting`
- `azurerm_monitor_metric_alert`
- `azurerm_recovery_services_vault`
- `azurerm_site_recovery_fabric`
- `azurerm_site_recovery_network_mapping`
- `azurerm_site_recovery_protection_container`
- `azurerm_site_recovery_protection_container_mapping`
- `azurerm_site_recovery_replication_policy`
- `azurerm_storage_account`
- `local_file`

## Usage

```hcl
module "site_recovery" {
  source = "./modules/site-recovery"

  vault_name                 = ...
  resource_group_name        = ...
  location                   = ...
  target_location            = ...
  subscription_id            = ...
  cache_storage_account_name = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `vault_name` | Recovery Services Vault name | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `location` | Azure region for the vault | `string` | n/a | yes |
| `target_location` | Target Azure region for recovery | `string` | n/a | yes |
| `subscription_id` | Azure subscription ID | `string` | n/a | yes |
| `vault_sku` | Recovery Services Vault SKU (Standard or RS0) | `string` | `"Standard"` | no |
| `soft_delete_enabled` | Enable soft delete | `bool` | `true` | no |
| `storage_mode_type` | Storage mode type (GeoRedundant, LocallyRedundant, ZoneRedundant) | `string` | `"GeoRedundant"` | no |
| `source_fabrics` | Source recovery fabrics | `map(...)` | `{}` | no |
| `target_fabrics` | Target recovery fabrics | `map(...)` | `{}` | no |
| `source_protection_containers` | Source protection containers | `map(...)` | `{}` | no |
| `target_protection_containers` | Target protection containers | `map(...)` | `{}` | no |
| `replication_policies` | Replication policies | `map(...)` | `{}` | no |
| `protection_container_mappings` | Protection container mappings | `map(...)` | `{}` | no |
| `network_mappings` | Network mappings for ASR | `map(...)` | `{}` | no |
| `cache_storage_account_name` | Cache storage account name | `string` | n/a | yes |
| `create_target_storage` | Create target storage account | `bool` | `false` | no |
| `target_storage_account_name` | Target storage account name | `string` | `null` | no |
| `target_storage_replication_type` | Target storage replication type | `string` | `"LRS"` | no |
| `create_automation_account` | Create Automation Account for recovery plans | `bool` | `true` | no |
| `create_log_analytics` | Create Log Analytics workspace | `bool` | `true` | no |
| `log_analytics_workspace_id` | Existing Log Analytics workspace ID | `string` | `null` | no |
| `enable_diagnostics` | Enable diagnostic settings | `bool` | `true` | no |
| `enable_alerts` | Enable monitoring alerts | `bool` | `false` | no |
| `action_group_id` | Action group ID for alerts | `string` | `null` | no |
| `create_asr_config` | Create ASR configuration file | `bool` | `true` | no |
| `tags` | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `vault_id` | Recovery Services Vault ID | no |
| `vault_name` | Recovery Services Vault name | no |
| `source_fabric_ids` | Source fabric IDs | no |
| `target_fabric_ids` | Target fabric IDs | no |
| `source_protection_container_ids` | Source protection container IDs | no |
| `target_protection_container_ids` | Target protection container IDs | no |
| `replication_policy_ids` | Replication policy IDs | no |
| `protection_container_mapping_ids` | Protection container mapping IDs | no |
| `network_mapping_ids` | Network mapping IDs | no |
| `cache_storage_account_id` | Cache storage account ID | no |
| `cache_storage_account_name` | Cache storage account name | no |
| `target_storage_account_id` | Target storage account ID | no |
| `automation_account_id` | Automation Account ID | no |
| `automation_account_identity` | Automation Account managed identity | no |
| `log_analytics_workspace_id` | Log Analytics workspace ID | no |
| `log_analytics_workspace_workspace_id` | Log Analytics workspace workspace ID (GUID) | no |
| `asr_config_path` | Path to ASR configuration file | no |
<!-- END_TF_DOCS -->
