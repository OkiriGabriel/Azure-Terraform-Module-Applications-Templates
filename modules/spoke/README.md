# Spoke Network Module

Spoke VNet with subnets, NSGs and subnet delegations for workload isolation.

## Resources

- `azurerm_network_security_group`
- `azurerm_route_table`
- `azurerm_subnet`
- `azurerm_subnet_network_security_group_association`
- `azurerm_subnet_route_table_association`
- `azurerm_virtual_network`
- `azurerm_virtual_network_peering`

## Usage

```hcl
module "spoke" {
  source = "./modules/spoke"

  resource_group_name      = ...
  location                 = ...
  prefix                   = ...
  address_space            = ...
  hub_virtual_network_id   = ...
  hub_virtual_network_name = ...
  tags                     = ...
  name                     = ...
  network_security_group   = ...
  spoke_to_hub             = ...
  hub_to_spoke             = ...
  spoke_route_table_name   = ...
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
| `hub_virtual_network_id` |  | `any` | n/a | yes |
| `hub_virtual_network_name` |  | `any` | n/a | yes |
| `tags` |  | `any` | n/a | yes |
| `dns_servers` | Custom DNS servers | `list(string)` | `[]` | no |
| `name` | Name of the spoke network | `string` | n/a | yes |
| `network_security_group` | Name of the virtual network | `string` | n/a | yes |
| `spoke_to_hub` | Name of the spoke to hub peering | `string` | n/a | yes |
| `hub_to_spoke` | Name of the hub to spoke peering | `string` | n/a | yes |
| `spoke_route_table_name` | Name of the route table  | `string` | n/a | yes |
| `subnets_with_nsg` | Map of subnet names to NSG names | `list(string)` | `[]` | no |
| `subnet_prefixes` | Map of subnet names to address prefixes | `map(string)` | `{}` | no |
| `subnet_delegations` | Map of subnet names to delegations | `map(...)` | `{}` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `subnet_ids` | Map of subnet names to subnet IDs | no |
| `vnet_id` | The ID of the spoke virtual network | no |
| `vnet_name` | The name of the spoke virtual network | no |
<!-- END_TF_DOCS -->
