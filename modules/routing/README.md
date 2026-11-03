# Advanced Routing Module

Route tables, user-defined routes (UDRs), Route Server and BGP configuration.

## Resources

- `azurerm_cdn_frontdoor_endpoint`
- `azurerm_cdn_frontdoor_origin`
- `azurerm_cdn_frontdoor_origin_group`
- `azurerm_cdn_frontdoor_profile`
- `azurerm_linux_virtual_machine`
- `azurerm_network_interface`
- `azurerm_public_ip`
- `azurerm_route`
- `azurerm_route_server`
- `azurerm_route_server_bgp_connection`
- `azurerm_route_table`
- `azurerm_subnet_route_table_association`
- `azurerm_subnet_service_endpoint_storage_policy`
- `azurerm_traffic_manager_azure_endpoint`
- `azurerm_traffic_manager_profile`

## Usage

```hcl
module "routing" {
  source = "./modules/routing"

  location            = ...
  resource_group_name = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `tags` | Tags to apply to resources | `map(string)` | `{}` | no |
| `route_tables` | Route tables configuration | `map(...)` | `{}` | no |
| `subnet_route_table_associations` | Subnet to route table associations | `map(...)` | `{}` | no |
| `network_virtual_appliances` | Network Virtual Appliances (NVAs) for advanced routing | `map(...)` | `{}` | no |
| `route_servers` | Azure Route Servers for dynamic routing | `map(...)` | `{}` | no |
| `route_server_bgp_connections` | BGP connections for Route Servers | `map(...)` | `{}` | no |
| `traffic_manager_profiles` | Traffic Manager profiles for global load balancing | `map(...)` | `{}` | no |
| `traffic_manager_endpoints` | Traffic Manager endpoints | `map(...)` | `{}` | no |
| `frontdoor_profiles` | Front Door profiles | `map(...)` | `{}` | no |
| `frontdoor_endpoints` | Front Door endpoints | `map(...)` | `{}` | no |
| `frontdoor_origin_groups` | Front Door origin groups | `map(...)` | `{}` | no |
| `frontdoor_origins` | Front Door origins | `map(...)` | `{}` | no |
| `service_endpoint_policies` | Service endpoint policies for storage | `map(...)` | `{}` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `route_table_ids` | Route table IDs | no |
| `route_table_names` | Route table names | no |
| `nva_ids` | Network Virtual Appliance VM IDs | no |
| `nva_private_ips` | Network Virtual Appliance private IP addresses | no |
| `route_server_ids` | Route Server IDs | no |
| `route_server_virtual_router_ips` | Route Server virtual router IPs | no |
| `traffic_manager_profile_ids` | Traffic Manager profile IDs | no |
| `traffic_manager_profile_fqdns` | Traffic Manager profile FQDNs | no |
| `frontdoor_profile_ids` | Front Door profile IDs | no |
| `frontdoor_endpoint_ids` | Front Door endpoint IDs | no |
| `frontdoor_endpoint_hostnames` | Front Door endpoint hostnames | no |
| `service_endpoint_policy_ids` | Service endpoint policy IDs | no |
<!-- END_TF_DOCS -->
