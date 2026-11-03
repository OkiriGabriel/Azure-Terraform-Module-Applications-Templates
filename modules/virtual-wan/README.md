# Virtual WAN Module

Azure Virtual WAN and virtual hubs for global transit networking.

## Resources

- `azurerm_express_route_gateway`
- `azurerm_firewall`
- `azurerm_virtual_hub`
- `azurerm_virtual_hub_connection`
- `azurerm_virtual_hub_route_table`
- `azurerm_virtual_hub_routing_intent`
- `azurerm_virtual_wan`
- `azurerm_vpn_gateway`
- `azurerm_vpn_gateway_connection`
- `azurerm_vpn_site`

## Usage

```hcl
module "virtual_wan" {
  source = "./modules/virtual-wan"

  virtual_wan_name    = ...
  resource_group_name = ...
  location            = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `virtual_wan_name` | Name of the Virtual WAN | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `virtual_wan_type` | Type of Virtual WAN (Standard or Basic) | `string` | `"Standard"` | no |
| `disable_vpn_encryption` | Disable VPN encryption | `bool` | `false` | no |
| `allow_branch_to_branch_traffic` | Allow branch to branch traffic | `bool` | `true` | no |
| `office365_local_breakout_category` | Office 365 local breakout category | `string` | `"None"` | no |
| `virtual_hubs` | Virtual hubs configuration | `map(...)` | `{}` | no |
| `vpn_gateways` | VPN gateways configuration | `map(...)` | `{}` | no |
| `expressroute_gateways` | ExpressRoute gateways configuration | `map(...)` | `{}` | no |
| `vnet_connections` | Virtual network connections to hubs | `map(...)` | `{}` | no |
| `virtual_hub_route_tables` | Virtual hub route tables | `map(...)` | `{}` | no |
| `vpn_sites` | VPN sites for site-to-site connections | `map(...)` | `{}` | no |
| `vpn_connections` | VPN connections between gateway and sites | `map(...)` | `{}` | no |
| `hub_firewalls` | Azure Firewalls in Virtual Hubs (Secured Hubs) | `map(...)` | `{}` | no |
| `routing_intents` | Routing intents for secured hubs | `map(...)` | `{}` | no |
| `tags` | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `virtual_wan_id` | Virtual WAN ID | no |
| `virtual_wan_name` | Virtual WAN name | no |
| `virtual_hub_ids` | Virtual hub IDs | no |
| `virtual_hub_default_route_table_ids` | Virtual hub default route table IDs | no |
| `vpn_gateway_ids` | VPN gateway IDs | no |
| `expressroute_gateway_ids` | ExpressRoute gateway IDs | no |
| `vnet_connection_ids` | VNet connection IDs | no |
| `vpn_site_ids` | VPN site IDs | no |
| `vpn_connection_ids` | VPN connection IDs | no |
| `hub_firewall_ids` | Hub firewall IDs | no |
| `hub_firewall_private_ips` | Hub firewall private IP addresses | no |
| `routing_intent_ids` | Routing intent IDs | no |
| `route_table_ids` | Virtual hub route table IDs | no |
<!-- END_TF_DOCS -->
