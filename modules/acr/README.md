# Azure Container Registry Module

Private container registries (one per map entry) for application and ML images.

## Resources

- `azurerm_container_registry`

## Usage

```hcl
module "acr" {
  source = "./modules/acr"

  resource_group_name = ...
  location            = ...
  acrs                = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `resource_group_name` | Name of the resource group | `string` | n/a | yes |
| `location` | Location of the ACR | `string` | n/a | yes |
| `sku` | SKU of the ACR. Possible values: Basic, Standard, Premium | `string` | `"Standard"` | no |
| `admin_enabled` | Enable admin user | `bool` | `false` | no |
| `tags` | Tags to apply to the ACR | `map(string)` | `{}` | no |
| `georeplications` | List of locations for geo-replication | `list(...)` | `null` | no |
| `acrs` | Map of ACR configurations | `map(...)` | n/a | yes |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `login_server` |  | no |
| `repositories` |  | no |
| `admin_username` | The admin username | no |
| `admin_password` | The admin password | yes |
| `acr_login_server` | The login server URL for the Container Registry | no |
| `acr_id` | The ID of the Azure Container Registry | no |
<!-- END_TF_DOCS -->
