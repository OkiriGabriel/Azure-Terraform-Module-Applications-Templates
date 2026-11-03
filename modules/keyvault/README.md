# Key Vault Module

Key Vault with access policies, network ACLs and diagnostic settings for secrets and certificates.

## Resources

- `azurerm_key_vault`
- `azurerm_monitor_diagnostic_setting`

## Usage

```hcl
module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name        = ...
  location                   = ...
  tenant_id                  = ...
  log_analytics_workspace_id = ...
  diagnostic_settings        = ...
  vault_name                 = ...
  user_object_id             = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `resource_group_name` | Name of the resource group | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `tenant_id` | Azure tenant ID | `string` | n/a | yes |
| `sku_name` | SKU name for the key vault | `string` | `"standard"` | no |
| `allowed_ip_ranges` | Allowed IP ranges | `list(string)` | `[]` | no |
| `log_analytics_workspace_id` | ID of Log Analytics workspace | `string` | n/a | yes |
| `tags` | Tags to apply to resources | `map(string)` | `{}` | no |
| `diagnostic_settings` | Name of diagnostic settings | `string` | n/a | yes |
| `vault_name` | Name of the key vault | `string` | n/a | yes |
| `allowed_subnet_ids` | List of subnet IDs allowed to access the Key Vault | `list(string) # Changed from object to list(string)` | `[]` | no |
| `user_object_id` | Object ID of the user | `string` | n/a | yes |
| `app_identity_object_id` | Object ID of the app's managed identity | `string` | `null # Make it optional` | no |
| `postgres_uri` | PostgreSQL connection URI | `string` | `null` | no |
| `postgres_user` | PostgreSQL username | `string` | `null` | no |
| `postgres_password` | PostgreSQL password | `string` | `null` | no |
| `postgres_db` | PostgreSQL database name | `string` | `null` | no |
| `msal_client_id` | MSAL Client ID | `string` | `null` | no |
| `msal_client_secret` | MSAL Client Secret | `string` | `null` | no |
| `sharepoint_cert_thumbprint` | Sharepoint Certificate Thumbprint | `string` | `null` | no |
| `redis_auth` | Redis authentication key | `string` | `null` | no |
| `redis_host` | Redis host address | `string` | `null` | no |
| `server_name` | Name of the server | `string` | `null` | no |
| `service_principal_object_id` | Object ID of the Service Principal | `string` | `null # Make it optional` | no |
| `session_secret` | Secret key for session management | `string` | `null` | no |
| `base_url` | Base URL for the application | `string` | `null` | no |
| `msal_tenant_id` | MSAL Tenant ID | `string` | `null` | no |
| `rabbit_username` | RabbitMQ username | `string` | `null` | no |
| `rabbit_password` | RabbitMQ password | `string` | `null` | no |
| `api_scope` | API scope for authentication | `string` | `null` | no |
| `enable_rbac_authorization` | Enable RBAC authorization for Key Vault | `bool` | `true` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `key_vault_id` | The ID of the Key Vault | no |
| `key_vault_uri` | The URI of the Key Vault | no |
| `key_vault_name` | The name of the Key Vault | no |
<!-- END_TF_DOCS -->
