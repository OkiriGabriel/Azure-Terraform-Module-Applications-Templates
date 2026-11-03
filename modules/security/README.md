# Security Module

Azure Firewall, NSGs, DDoS protection and Defender for Cloud settings.

## Resources

- `azurerm_bastion_host`
- `azurerm_firewall`
- `azurerm_firewall_policy`
- `azurerm_firewall_policy_rule_collection_group`
- `azurerm_key_vault`
- `azurerm_monitor_diagnostic_setting`
- `azurerm_nat_gateway`
- `azurerm_nat_gateway_public_ip_association`
- `azurerm_network_ddos_protection_plan`
- `azurerm_network_security_group`
- `azurerm_network_security_rule`
- `azurerm_private_dns_zone`
- `azurerm_private_dns_zone_virtual_network_link`
- `azurerm_public_ip`
- `azurerm_security_center_auto_provisioning`
- `azurerm_security_center_contact`
- `azurerm_security_center_subscription_pricing`

## Usage

```hcl
module "security" {
  source = "./modules/security"

  prefix              = ...
  location            = ...
  resource_group_name = ...
  vnet_id             = ...
  tenant_id           = ...
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `prefix` | Prefix for resource naming | `string` | n/a | yes |
| `location` | Azure region | `string` | n/a | yes |
| `resource_group_name` | Resource group name | `string` | n/a | yes |
| `vnet_id` | Virtual network ID | `string` | n/a | yes |
| `tenant_id` | Azure AD tenant ID | `string` | n/a | yes |
| `tags` | Tags to apply to resources | `map(string)` | `{}` | no |
| `enable_firewall` | Enable Azure Firewall | `bool` | `true` | no |
| `firewall_subnet_id` | Subnet ID for Azure Firewall | `string` | `null` | no |
| `firewall_sku_name` | Azure Firewall SKU name | `string` | `"AZFW_VNet"` | no |
| `firewall_sku_tier` | Azure Firewall SKU tier | `string` | `"Standard"` | no |
| `firewall_threat_intelligence_mode` | Threat intelligence mode | `string` | `"Alert"` | no |
| `firewall_intrusion_detection_mode` | Intrusion detection mode | `string` | `"Alert"` | no |
| `firewall_network_rules` | Network rules for Azure Firewall | `list(...)` | `[]` | no |
| `firewall_application_rules` | Application rules for Azure Firewall | `list(...)` | `[]` | no |
| `availability_zones` | Availability zones for resources | `list(string)` | `["1", "2", "3"]` | no |
| `enable_ddos_protection` | Enable DDoS Protection Plan | `bool` | `false` | no |
| `network_security_groups` | Network security groups and their rules | `map(...)` | `{}` | no |
| `enable_security_center` | Enable Microsoft Defender for Cloud configuration. Off by default because paid (Standard) plans incur charges. | `bool` | `false` | no |
| `defender_plans` | Defender for Cloud plans | `map(...)` | `see source` | no |
| `security_contact_email` | Security contact email | `string` | `null` | no |
| `security_contact_phone` | Security contact phone | `string` | `null` | no |
| `private_dns_zones` | Private DNS zones to create | `map(string)` | `see source` | no |
| `create_security_key_vault` | Create a Key Vault for security secrets | `bool` | `false` | no |
| `key_vault_allowed_ips` | Allowed IP addresses for Key Vault | `list(string)` | `[]` | no |
| `key_vault_allowed_subnet_ids` | Allowed subnet IDs for Key Vault | `list(string)` | `[]` | no |
| `log_analytics_workspace_id` | Log Analytics workspace ID | `string` | `null` | no |
| `enable_nat_gateway` | Enable NAT Gateway | `bool` | `false` | no |
| `enable_bastion` | Enable Azure Bastion | `bool` | `false` | no |
| `bastion_subnet_id` | Subnet ID for Azure Bastion | `string` | `null` | no |
| `bastion_sku` | Azure Bastion SKU | `string` | `"Basic"` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `firewall_id` | Azure Firewall ID | no |
| `firewall_private_ip` | Azure Firewall private IP address | no |
| `firewall_public_ip` | Azure Firewall public IP address | no |
| `firewall_policy_id` | Firewall policy ID | no |
| `ddos_protection_plan_id` | DDoS protection plan ID | no |
| `network_security_groups` | Network security group IDs | no |
| `private_dns_zones` | Private DNS zone IDs | no |
| `security_key_vault_id` | Security Key Vault ID | no |
| `security_key_vault_uri` | Security Key Vault URI | no |
| `nat_gateway_id` | NAT Gateway ID | no |
| `bastion_id` | Bastion Host ID | no |
<!-- END_TF_DOCS -->
