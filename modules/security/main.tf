# Azure Firewall Public IP
resource "azurerm_public_ip" "firewall" {
  count               = var.enable_firewall ? 1 : 0
  name                = "${var.prefix}-firewall-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.availability_zones
  tags                = var.tags
}

# Azure Firewall
resource "azurerm_firewall" "main" {
  count               = var.enable_firewall ? 1 : 0
  name                = "${var.prefix}-firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.firewall_sku_name
  sku_tier            = var.firewall_sku_tier
  firewall_policy_id  = var.enable_firewall ? azurerm_firewall_policy.main[0].id : null
  zones               = var.availability_zones
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall[0].id
  }
}

# Firewall Policy
resource "azurerm_firewall_policy" "main" {
  count               = var.enable_firewall ? 1 : 0
  name                = "${var.prefix}-firewall-policy"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.firewall_sku_tier

  threat_intelligence_mode = var.firewall_threat_intelligence_mode

  dns {
    proxy_enabled = true
  }

  intrusion_detection {
    mode = var.firewall_intrusion_detection_mode
  }

  tags = var.tags
}

# Firewall Policy Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "network" {
  count              = var.enable_firewall ? 1 : 0
  name               = "${var.prefix}-network-rules"
  firewall_policy_id = azurerm_firewall_policy.main[0].id
  priority           = 100

  network_rule_collection {
    name     = "allow-network-rules"
    priority = 100
    action   = "Allow"

    dynamic "rule" {
      for_each = var.firewall_network_rules
      content {
        name                  = rule.value.name
        protocols             = rule.value.protocols
        source_addresses      = rule.value.source_addresses
        destination_addresses = rule.value.destination_addresses
        destination_ports     = rule.value.destination_ports
      }
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "application" {
  count              = var.enable_firewall ? 1 : 0
  name               = "${var.prefix}-application-rules"
  firewall_policy_id = azurerm_firewall_policy.main[0].id
  priority           = 200

  application_rule_collection {
    name     = "allow-application-rules"
    priority = 200
    action   = "Allow"

    dynamic "rule" {
      for_each = var.firewall_application_rules
      content {
        name              = rule.value.name
        source_addresses  = rule.value.source_addresses
        destination_fqdns = rule.value.destination_fqdns

        dynamic "protocols" {
          for_each = rule.value.protocols
          content {
            type = protocols.value.type
            port = protocols.value.port
          }
        }
      }
    }
  }
}

# DDoS Protection Plan
resource "azurerm_network_ddos_protection_plan" "main" {
  count               = var.enable_ddos_protection ? 1 : 0
  name                = "${var.prefix}-ddos-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Network Security Groups
resource "azurerm_network_security_group" "custom" {
  for_each            = var.network_security_groups
  name                = "${var.prefix}-${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# NSG Rules
resource "azurerm_network_security_rule" "custom" {
  for_each = merge([
    for nsg_key, nsg in var.network_security_groups : {
      for rule in nsg.rules :
      "${nsg_key}-${rule.name}" => merge(rule, { nsg_key = nsg_key })
    }
  ]...)

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.custom[each.value.nsg_key].name
}

# Azure Security Center (Defender for Cloud)
resource "azurerm_security_center_subscription_pricing" "defender_plans" {
  for_each      = var.enable_security_center ? var.defender_plans : {}
  tier          = each.value.tier
  resource_type = each.key
}

# Security Center Contact
resource "azurerm_security_center_contact" "main" {
  count               = var.enable_security_center && var.security_contact_email != null ? 1 : 0
  name                = "${var.prefix}-security-contact"
  email               = var.security_contact_email != null ? var.security_contact_email : null
  phone               = var.security_contact_phone != null ? var.security_contact_phone : null
  alert_notifications = true
  alerts_to_admins    = true
}

# Security Center Auto Provisioning
resource "azurerm_security_center_auto_provisioning" "main" {
  count          = var.enable_security_center ? 1 : 0
  auto_provision = "On"
}

# Azure Private DNS Zones for Private Endpoints
resource "azurerm_private_dns_zone" "main" {
  for_each            = var.private_dns_zones
  name                = each.value
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Link Private DNS Zones to VNets
resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  for_each              = var.private_dns_zones
  name                  = "${var.prefix}-${each.key}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.main[each.key].name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

# Azure Key Vault for Security Secrets
resource "azurerm_key_vault" "security" {
  count                      = var.create_security_key_vault ? 1 : 0
  name                       = "${var.prefix}-security-kv"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 90
  purge_protection_enabled   = true

  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = var.key_vault_allowed_ips
    virtual_network_subnet_ids = var.key_vault_allowed_subnet_ids
  }

  tags = var.tags
}

# Diagnostic Settings for Firewall
resource "azurerm_monitor_diagnostic_setting" "firewall" {
  count                      = var.enable_firewall && var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.prefix}-firewall-diagnostics"
  target_resource_id         = azurerm_firewall.main[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }

  enabled_log {
    category = "AzureFirewallNetworkRule"
  }

  enabled_log {
    category = "AzureFirewallDnsProxy"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# NAT Gateway for secure outbound connectivity
resource "azurerm_public_ip" "nat_gateway" {
  count               = var.enable_nat_gateway ? 1 : 0
  name                = "${var.prefix}-nat-gateway-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.availability_zones
  tags                = var.tags
}

resource "azurerm_nat_gateway" "main" {
  count                   = var.enable_nat_gateway ? 1 : 0
  name                    = "${var.prefix}-nat-gateway"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = var.availability_zones
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "main" {
  count                = var.enable_nat_gateway ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.main[0].id
  public_ip_address_id = azurerm_public_ip.nat_gateway[0].id
}

# Bastion for secure management access
resource "azurerm_public_ip" "bastion" {
  count               = var.enable_bastion ? 1 : 0
  name                = "${var.prefix}-bastion-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "main" {
  count               = var.enable_bastion ? 1 : 0
  name                = "${var.prefix}-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.bastion_sku

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }

  tags = var.tags
}
