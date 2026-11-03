# Resource Group Module

Creates the resource group that the other modules deploy into.

## Resources

- `azurerm_resource_group`

## Usage

```hcl
module "resource_group" {
  source = "./modules/resource_group"

  resource_group_name = ...
  location            = ...
  tags                = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `resource_group_name` |  | `any` | n/a | yes |
| `location` |  | `any` | n/a | yes |
| `tags` |  | `any` | n/a | yes |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `name` | The name of the resource group | no |
| `location` | The location of the resource group | no |
| `id` | The ID of the resource group | no |
<!-- END_TF_DOCS -->
