# Notification Hub Module

Notification Hub namespace and hubs for mobile push notifications.

## Resources

- `azurerm_notification_hub`
- `azurerm_notification_hub_authorization_rule`
- `azurerm_notification_hub_namespace`

## Usage

```hcl
module "notification_hub" {
  source = "./modules/notification-hub"

  resource_group_name = ...
  location            = ...
  namespaces          = ...
  notification_hubs   = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `resource_group_name` | Name of the resource group | `string` | n/a | yes |
| `location` | Location of the notification hub | `string` | n/a | yes |
| `tags` | Tags to apply to the notification hub | `map(string)` | `{}` | no |
| `namespaces` | Map of notification hub namespace configurations | `map(...)` | n/a | yes |
| `notification_hubs` | Map of notification hub configurations | `map(...)` | n/a | yes |
| `authorization_rules` | Map of authorization rule configurations | `map(...)` | `{}` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `namespace_ids` | The IDs of the notification hub namespaces | no |
| `namespace_names` | The names of the notification hub namespaces | no |
| `hub_ids` | The IDs of the notification hubs | no |
| `hub_names` | The names of the notification hubs | no |
| `authorization_rule_ids` | The IDs of the authorization rules | no |
| `authorization_rule_names` | The names of the authorization rules | no |
| `primary_access_keys` | The primary access keys of the authorization rules | yes |
| `secondary_access_keys` | The secondary access keys of the authorization rules | yes |
<!-- END_TF_DOCS -->
