# Hub Network Module

Hub VNet for the hub-and-spoke topology: gateway, firewall and Bastion subnets, plus NSG.

## Resources

- `azurerm_network_security_group`
- `azurerm_subnet`
- `azurerm_virtual_network`

## Usage

```hcl
module "hub" {
  source = "./modules/hub"

  resource_group_name    = ...
  location               = ...
  prefix                 = ...
  address_space          = ...
  gateway_subnet_prefix  = ...
  tags                   = ...
  name                   = ...
  network_security_group = ...
  gateway                = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `resource_group_name` |  | `any` | n/a | yes |
| `location` |  | `any` | n/a | yes |
| `prefix` |  | `any` | n/a | yes |
| `address_space` |  | `any` | n/a | yes |
| `gateway_subnet_prefix` |  | `any` | n/a | yes |
| `tags` |  | `any` | n/a | yes |
| `dns_servers` | Custom DNS servers | `list(string)` | `[]` | no |
| `subnet_prefixes` | Map of subnet names to address prefixes | `map(string)` | `{}` | no |
| `name` | Name of the hub network | `string` | n/a | yes |
| `network_security_group` | Name of the virtual network | `string` | n/a | yes |
| `gateway` | Name of the gateway network | `string` | n/a | yes |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `vnet_id` | The ID of the Hub Virtual Network | no |
| `vnet_name` | The name of the Hub Virtual Network | no |
| `resource_group_name` | The name of the resource group | no |
| `gateway_subnet_id` | ID of the gateway subnet | no |
| `subnet_ids` |  | no |
<!-- END_TF_DOCS -->
