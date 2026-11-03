# Redis Cache Module

Azure Cache for Redis with configurable SKU, memory policies and firewall rules.

## Resources

- `azurerm_redis_cache`
- `azurerm_redis_firewall_rule`

## Usage

```hcl
module "redis" {
  source = "./modules/redis"

  resource_group_name = ...
  location            = ...
  redis_caches        = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `resource_group_name` | Name of the resource group | `string` | n/a | yes |
| `location` | Location of the Redis Cache | `string` | n/a | yes |
| `tags` | Tags to apply to the Redis Cache | `map(string)` | `{}` | no |
| `redis_caches` | Map of Redis Cache configurations | `map(...)` | n/a | yes |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `redis_hostname` | The hostname of the Redis Cache | no |
| `redis_ssl_port` | The SSL port of the Redis Cache | no |
| `redis_port` | The non-SSL port of the Redis Cache | no |
| `redis_primary_access_key` | The primary access key for the Redis Cache | yes |
| `redis_secondary_access_key` | The secondary access key for the Redis Cache | yes |
| `redis_id` | The ID of the Redis Cache | no |
<!-- END_TF_DOCS -->
