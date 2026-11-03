# Blob Storage Module

Storage account and blob containers, with optional CDN integration.

## Resources

- `azurerm_storage_account`
- `azurerm_storage_container`

## Usage

```hcl
module "blob_storage" {
  source = "./modules/blob-storage"

  resource_group_name = ...
  location            = ...
  storage_accounts    = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `resource_group_name` | Name of the resource group | `string` | n/a | yes |
| `location` | Location of the storage account | `string` | n/a | yes |
| `tags` | Tags to apply to the storage account | `map(string)` | `{}` | no |
| `storage_accounts` | Map of storage account configurations | `map(...)` | n/a | yes |
| `containers` | Map of storage container configurations | `map(...)` | `{}` | no |
| `cdn_profiles` | Map of CDN profile configurations | `map(...)` | `{}` | no |
| `cdn_endpoints` | Map of CDN endpoint configurations | `map(...)` | `{}` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `storage_account_ids` | The IDs of the storage accounts | no |
| `storage_account_names` | The names of the storage accounts | no |
| `storage_account_primary_access_keys` | The primary access keys of the storage accounts | yes |
| `storage_account_primary_blob_endpoints` | The primary blob endpoints of the storage accounts | no |
| `storage_account_primary_connection_strings` | The primary connection strings of the storage accounts | yes |
| `container_ids` | The IDs of the storage containers | no |
| `container_names` | The names of the storage containers | no |
<!-- END_TF_DOCS -->
