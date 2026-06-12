output "firewall_id" {
  description = "Azure Firewall ID"
  value       = var.enable_firewall ? azurerm_firewall.main[0].id : null
}

output "firewall_private_ip" {
  description = "Azure Firewall private IP address"
  value       = var.enable_firewall ? azurerm_firewall.main[0].ip_configuration[0].private_ip_address : null
}

output "firewall_public_ip" {
  description = "Azure Firewall public IP address"
  value       = var.enable_firewall ? azurerm_public_ip.firewall[0].ip_address : null
}

output "firewall_policy_id" {
  description = "Firewall policy ID"
  value       = var.enable_firewall ? azurerm_firewall_policy.main[0].id : null
}

output "ddos_protection_plan_id" {
  description = "DDoS protection plan ID"
  value       = var.enable_ddos_protection ? azurerm_network_ddos_protection_plan.main[0].id : null
}

output "network_security_groups" {
  description = "Network security group IDs"
  value = {
    for k, v in azurerm_network_security_group.custom : k => v.id
  }
}

output "private_dns_zones" {
  description = "Private DNS zone IDs"
  value = {
    for k, v in azurerm_private_dns_zone.main : k => v.id
  }
}

output "security_key_vault_id" {
  description = "Security Key Vault ID"
  value       = var.create_security_key_vault ? azurerm_key_vault.security[0].id : null
}

output "security_key_vault_uri" {
  description = "Security Key Vault URI"
  value       = var.create_security_key_vault ? azurerm_key_vault.security[0].vault_uri : null
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = var.enable_nat_gateway ? azurerm_nat_gateway.main[0].id : null
}

output "bastion_id" {
  description = "Bastion Host ID"
  value       = var.enable_bastion ? azurerm_bastion_host.main[0].id : null
}
