# Azure Kubernetes Service Module

Production AKS cluster with Azure CNI, autoscaling node pools, Entra ID RBAC and Container Insights.

## Resources

- `azurerm_kubernetes_cluster`
- `azurerm_kubernetes_cluster_node_pool`
- `azurerm_monitor_diagnostic_setting`
- `azurerm_role_assignment`

## Usage

```hcl
module "aks" {
  source = "./modules/aks"

  cluster_name        = ...
  location            = ...
  resource_group_name = ...
  dns_prefix          = ...
  default_node_pool   = ...
  network_profile     = ...
  vnet_id             = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cluster_name` | Name of the AKS cluster | `string` | n/a | yes |
| `location` | Azure region for the AKS cluster | `string` | n/a | yes |
| `resource_group_name` | Name of the resource group | `string` | n/a | yes |
| `dns_prefix` | DNS prefix for the AKS cluster | `string` | n/a | yes |
| `kubernetes_version` | Kubernetes version | `string` | `"1.28"` | no |
| `default_node_pool` | Configuration for the default node pool | `object(...)` | n/a | yes |
| `additional_node_pools` | Additional node pools for the AKS cluster | `map(...)` | `{}` | no |
| `network_profile` | Network profile for the AKS cluster | `object(...)` | n/a | yes |
| `enable_azure_ad_rbac` | Enable Azure AD RBAC | `bool` | `true` | no |
| `azure_ad_admin_group_object_ids` | Azure AD admin group object IDs | `list(string)` | `[]` | no |
| `tenant_id` | Azure AD tenant ID | `string` | `null` | no |
| `enable_monitoring` | Enable Container Insights monitoring | `bool` | `true` | no |
| `log_analytics_workspace_id` | Log Analytics workspace ID for monitoring | `string` | `null` | no |
| `enable_azure_policy` | Enable Azure Policy for AKS | `bool` | `true` | no |
| `enable_key_vault_secrets_provider` | Enable Key Vault Secrets Provider | `bool` | `true` | no |
| `enable_cluster_autoscaler` | Enable cluster autoscaler profile | `bool` | `true` | no |
| `autoscaler_profile` | Cluster autoscaler profile configuration | `object(...)` | `see source` | no |
| `enable_http_application_routing` | Enable HTTP application routing | `bool` | `false` | no |
| `maintenance_window` | Maintenance window configuration | `object(...)` | `see source` | no |
| `acr_id` | Azure Container Registry ID for AKS to pull images from | `string` | `null` | no |
| `vnet_id` | VNet ID for network contributor role | `string` | n/a | yes |
| `tags` | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `cluster_id` | AKS cluster ID | no |
| `cluster_name` | AKS cluster name | no |
| `cluster_fqdn` | AKS cluster FQDN | no |
| `kube_config_raw` | Raw Kubernetes config | yes |
| `kube_config` | Kubernetes config | yes |
| `kubelet_identity` | Kubelet identity | no |
| `cluster_identity` | Cluster identity | no |
| `node_resource_group` | Node resource group name | no |
| `oidc_issuer_url` | OIDC issuer URL | no |
| `portal_fqdn` | Portal FQDN | no |
<!-- END_TF_DOCS -->
