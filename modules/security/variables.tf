variable "prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "vnet_id" {
  description = "Virtual network ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Firewall Configuration
variable "enable_firewall" {
  description = "Enable Azure Firewall"
  type        = bool
  default     = true
}

variable "firewall_subnet_id" {
  description = "Subnet ID for Azure Firewall"
  type        = string
  default     = null
}

variable "firewall_sku_name" {
  description = "Azure Firewall SKU name"
  type        = string
  default     = "AZFW_VNet"
}

variable "firewall_sku_tier" {
  description = "Azure Firewall SKU tier"
  type        = string
  default     = "Standard"
}

variable "firewall_threat_intelligence_mode" {
  description = "Threat intelligence mode"
  type        = string
  default     = "Alert"
}

variable "firewall_intrusion_detection_mode" {
  description = "Intrusion detection mode"
  type        = string
  default     = "Alert"
}

variable "firewall_network_rules" {
  description = "Network rules for Azure Firewall"
  type = list(object({
    name                  = string
    protocols             = list(string)
    source_addresses      = list(string)
    destination_addresses = list(string)
    destination_ports     = list(string)
  }))
  default = []
}

variable "firewall_application_rules" {
  description = "Application rules for Azure Firewall"
  type = list(object({
    name              = string
    source_addresses  = list(string)
    destination_fqdns = list(string)
    protocols = list(object({
      type = string
      port = number
    }))
  }))
  default = []
}

variable "availability_zones" {
  description = "Availability zones for resources"
  type        = list(string)
  default     = ["1", "2", "3"]
}

# DDoS Protection
variable "enable_ddos_protection" {
  description = "Enable DDoS Protection Plan"
  type        = bool
  default     = false
}

# Network Security Groups
variable "network_security_groups" {
  description = "Network security groups and their rules"
  type = map(object({
    rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
  default = {}
}

# Security Center (Defender for Cloud)
variable "enable_security_center" {
  description = "Enable Azure Security Center"
  type        = bool
  default     = true
}

variable "defender_plans" {
  description = "Defender for Cloud plans"
  type = map(object({
    tier = string
  }))
  default = {
    VirtualMachines               = { tier = "Standard" }
    AppServices                   = { tier = "Standard" }
    Containers                    = { tier = "Standard" }
    SqlServers                    = { tier = "Standard" }
    SqlServerVirtualMachines      = { tier = "Standard" }
    StorageAccounts               = { tier = "Standard" }
    KeyVaults                     = { tier = "Standard" }
    Arm                           = { tier = "Standard" }
    OpenSourceRelationalDatabases = { tier = "Standard" }
  }
}

variable "security_contact_email" {
  description = "Security contact email"
  type        = string
  default     = null
}

variable "security_contact_phone" {
  description = "Security contact phone"
  type        = string
  default     = null
}

# Private DNS Zones
variable "private_dns_zones" {
  description = "Private DNS zones to create"
  type        = map(string)
  default = {
    blob  = "privatelink.blob.core.windows.net"
    file  = "privatelink.file.core.windows.net"
    queue = "privatelink.queue.core.windows.net"
    table = "privatelink.table.core.windows.net"
    sql   = "privatelink.database.windows.net"
    vault = "privatelink.vaultcore.azure.net"
    acr   = "privatelink.azurecr.io"
    aks   = "privatelink.azmk8s.io"
  }
}

# Key Vault
variable "create_security_key_vault" {
  description = "Create a Key Vault for security secrets"
  type        = bool
  default     = false
}

variable "key_vault_allowed_ips" {
  description = "Allowed IP addresses for Key Vault"
  type        = list(string)
  default     = []
}

variable "key_vault_allowed_subnet_ids" {
  description = "Allowed subnet IDs for Key Vault"
  type        = list(string)
  default     = []
}

# Monitoring
variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  type        = string
  default     = null
}

# NAT Gateway
variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = false
}

# Bastion
variable "enable_bastion" {
  description = "Enable Azure Bastion"
  type        = bool
  default     = false
}

variable "bastion_subnet_id" {
  description = "Subnet ID for Azure Bastion"
  type        = string
  default     = null
}

variable "bastion_sku" {
  description = "Azure Bastion SKU"
  type        = string
  default     = "Basic"
}
