# VNet Peering Module

Regional and global VNet peering between the hub and spokes.

## Resources

- `azurerm_network_connection_monitor`
- `azurerm_network_watcher_flow_log`
- `azurerm_virtual_network_peering`

## Usage

```hcl
module "vnet_peering" {
  source = "./modules/vnet-peering"

}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `peering_configurations` | VNet peering configurations within same region | `map(...)` | `{}` | no |
| `global_peering_configurations` | Global VNet peering configurations across regions | `map(...)` | `{}` | no |
| `enable_flow_logs` | Enable NSG flow logs for peering monitoring | `bool` | `false` | no |
| `flow_log_configurations` | Flow log configurations for peering monitoring | `map(...)` | `{}` | no |
| `enable_connection_monitoring` | Enable connection monitoring for peering health | `bool` | `false` | no |
| `connection_monitor_configurations` | Connection monitor configurations | `map(...)` | `{}` | no |
| `tags` | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `peering_ids` | VNet peering IDs | no |
| `global_peering_ids` | Global VNet peering IDs | no |
| `flow_log_ids` | Flow log IDs | no |
| `connection_monitor_ids` | Connection monitor IDs | no |
<!-- END_TF_DOCS -->
