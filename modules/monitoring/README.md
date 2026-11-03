# Monitoring Stack Module

Prometheus, Grafana and Loki on Container Apps, with persistent Azure Files storage.

## Resources

- `azurerm_container_app`
- `azurerm_container_app_environment_storage`
- `azurerm_storage_account`
- `azurerm_storage_share`

## Usage

```hcl
module "monitoring" {
  source = "./modules/monitoring"

  resource_group_name              = ...
  location                         = ...
  environment                      = ...
  container_app_environment_id     = ...
  container_app_environment_domain = ...
  prometheus_storage_account_name  = ...
  grafana_storage_account_name     = ...
  loki_storage_account_name        = ...
  frontend_app_name                = ...
  backend_app_name                 = ...
  marketplace_app_name             = ...
  admin_frontend_app_name          = ...
  frontend_port                    = ...
  backend_port                     = ...
  marketplace_port                 = ...
  admin_frontend_port              = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `resource_group_name` | Name of the resource group | `string` | n/a | yes |
| `location` | Location of the monitoring resources | `string` | n/a | yes |
| `environment` | Environment name | `string` | n/a | yes |
| `tags` | Tags to apply to the monitoring resources | `map(string)` | `{}` | no |
| `container_app_environment_id` | ID of the Container App Environment | `string` | n/a | yes |
| `container_app_environment_domain` | Domain of the Container App Environment | `string` | n/a | yes |
| `prometheus_app_name` | Name of the Prometheus container app | `string` | `"prometheus"` | no |
| `prometheus_port` | Port for Prometheus | `number` | `9090` | no |
| `prometheus_image` | Docker image for Prometheus | `string` | `"prom/prometheus:latest"` | no |
| `prometheus_cpu` | CPU allocation for Prometheus | `number` | `1.0` | no |
| `prometheus_memory` | Memory allocation for Prometheus in GB | `number` | `2.0` | no |
| `prometheus_min_replicas` | Minimum replicas for Prometheus | `number` | `1` | no |
| `prometheus_max_replicas` | Maximum replicas for Prometheus | `number` | `3` | no |
| `prometheus_storage_account_name` | Name of the storage account for Prometheus data | `string` | n/a | yes |
| `grafana_app_name` | Name of the Grafana container app | `string` | `"grafana"` | no |
| `grafana_port` | Port for Grafana | `number` | `3000` | no |
| `grafana_image` | Docker image for Grafana | `string` | `"grafana/grafana:latest"` | no |
| `grafana_cpu` | CPU allocation for Grafana | `number` | `1.0` | no |
| `grafana_memory` | Memory allocation for Grafana in GB | `number` | `2.0` | no |
| `grafana_min_replicas` | Minimum replicas for Grafana | `number` | `1` | no |
| `grafana_max_replicas` | Maximum replicas for Grafana | `number` | `3` | no |
| `grafana_admin_password` | Admin password for Grafana | `string` | `"admin123"` | no |
| `grafana_storage_account_name` | Name of the storage account for Grafana data | `string` | n/a | yes |
| `loki_app_name` | Name of the Loki container app | `string` | `"loki"` | no |
| `loki_port` | Port for Loki | `number` | `3100` | no |
| `loki_image` | Docker image for Loki | `string` | `"grafana/loki:latest"` | no |
| `loki_cpu` | CPU allocation for Loki | `number` | `1.0` | no |
| `loki_memory` | Memory allocation for Loki in GB | `number` | `2.0` | no |
| `loki_min_replicas` | Minimum replicas for Loki | `number` | `1` | no |
| `loki_max_replicas` | Maximum replicas for Loki | `number` | `3` | no |
| `loki_storage_account_name` | Name of the storage account for Loki data | `string` | n/a | yes |
| `frontend_app_name` | Name of the frontend container app | `string` | n/a | yes |
| `backend_app_name` | Name of the backend container app | `string` | n/a | yes |
| `marketplace_app_name` | Name of the marketplace container app | `string` | n/a | yes |
| `admin_frontend_app_name` | Name of the admin frontend container app | `string` | n/a | yes |
| `frontend_port` | Port of the frontend container app | `number` | n/a | yes |
| `backend_port` | Port of the backend container app | `number` | n/a | yes |
| `marketplace_port` | Port of the marketplace container app | `number` | n/a | yes |
| `admin_frontend_port` | Port of the admin frontend container app | `number` | n/a | yes |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `prometheus_app_name` | Name of the Prometheus container app | no |
| `prometheus_url` | URL of the Prometheus container app | no |
| `grafana_app_name` | Name of the Grafana container app | no |
| `grafana_url` | URL of the Grafana container app | no |
| `loki_app_name` | Name of the Loki container app | no |
| `loki_url` | URL of the Loki container app | no |
| `prometheus_storage_account_name` | Name of the Prometheus storage account | no |
| `grafana_storage_account_name` | Name of the Grafana storage account | no |
| `loki_storage_account_name` | Name of the Loki storage account | no |
<!-- END_TF_DOCS -->
