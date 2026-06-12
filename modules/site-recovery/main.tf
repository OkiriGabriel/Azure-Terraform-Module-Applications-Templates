# Recovery Services Vault
resource "azurerm_recovery_services_vault" "main" {
  name                = var.vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.vault_sku
  soft_delete_enabled = var.soft_delete_enabled
  storage_mode_type   = var.storage_mode_type

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Site Recovery Fabric (Source - On-Premises or another region)
resource "azurerm_site_recovery_fabric" "source" {
  for_each = var.source_fabrics

  name                = each.value.name
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.main.name
  location            = each.value.location
}

# Site Recovery Fabric (Target - Azure region)
resource "azurerm_site_recovery_fabric" "target" {
  for_each = var.target_fabrics

  name                = each.value.name
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.main.name
  location            = each.value.location
}

# Site Recovery Protection Container (Source)
resource "azurerm_site_recovery_protection_container" "source" {
  for_each = var.source_protection_containers

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  recovery_vault_name  = azurerm_recovery_services_vault.main.name
  recovery_fabric_name = azurerm_site_recovery_fabric.source[each.value.fabric_key].name
}

# Site Recovery Protection Container (Target)
resource "azurerm_site_recovery_protection_container" "target" {
  for_each = var.target_protection_containers

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  recovery_vault_name  = azurerm_recovery_services_vault.main.name
  recovery_fabric_name = azurerm_site_recovery_fabric.target[each.value.fabric_key].name
}

# Site Recovery Replication Policy
resource "azurerm_site_recovery_replication_policy" "main" {
  for_each = var.replication_policies

  name                                                 = each.value.name
  resource_group_name                                  = var.resource_group_name
  recovery_vault_name                                  = azurerm_recovery_services_vault.main.name
  recovery_point_retention_in_minutes                  = each.value.recovery_point_retention_minutes
  application_consistent_snapshot_frequency_in_minutes = each.value.app_consistent_snapshot_frequency_minutes
}

# Site Recovery Protection Container Mapping
resource "azurerm_site_recovery_protection_container_mapping" "main" {
  for_each = var.protection_container_mappings

  name                                      = each.value.name
  resource_group_name                       = var.resource_group_name
  recovery_vault_name                       = azurerm_recovery_services_vault.main.name
  recovery_fabric_name                      = azurerm_site_recovery_fabric.source[each.value.source_fabric_key].name
  recovery_source_protection_container_name = azurerm_site_recovery_protection_container.source[each.value.source_container_key].name
  recovery_target_protection_container_id   = azurerm_site_recovery_protection_container.target[each.value.target_container_key].id
  recovery_replication_policy_id            = azurerm_site_recovery_replication_policy.main[each.value.policy_key].id
}

# Network Mapping for ASR
resource "azurerm_site_recovery_network_mapping" "main" {
  for_each = var.network_mappings

  name                        = each.value.name
  resource_group_name         = var.resource_group_name
  recovery_vault_name         = azurerm_recovery_services_vault.main.name
  source_recovery_fabric_name = azurerm_site_recovery_fabric.source[each.value.source_fabric_key].name
  target_recovery_fabric_name = azurerm_site_recovery_fabric.target[each.value.target_fabric_key].name
  source_network_id           = each.value.source_network_id
  target_network_id           = each.value.target_network_id
}

# Storage Account for Cache Storage
resource "azurerm_storage_account" "cache" {
  name                     = var.cache_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  tags = var.tags
}

# Storage Account for Target VMs (if needed)
resource "azurerm_storage_account" "target" {
  count                    = var.create_target_storage ? 1 : 0
  name                     = var.target_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.target_location
  account_tier             = "Standard"
  account_replication_type = var.target_storage_replication_type
  account_kind             = "StorageV2"

  tags = var.tags
}

# Automation Account for ASR Runbooks
resource "azurerm_automation_account" "asr" {
  count               = var.create_automation_account ? 1 : 0
  name                = "${var.vault_name}-automation"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Recovery Plan Runbook (Pre/Post Actions)
resource "azurerm_automation_runbook" "recovery_plan_actions" {
  count                   = var.create_automation_account ? 1 : 0
  name                    = "RecoveryPlanActions"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.asr[0].name
  log_verbose             = true
  log_progress            = true
  runbook_type            = "PowerShell"

  content = <<-EOT
    param(
      [Parameter(Mandatory=$true)]
      [object]$RecoveryPlanContext
    )

    Write-Output "Recovery Plan Action Started"
    Write-Output "Recovery Plan Name: $($RecoveryPlanContext.RecoveryPlanName)"
    Write-Output "Failover Direction: $($RecoveryPlanContext.FailoverDirection)"
    Write-Output "Failover Type: $($RecoveryPlanContext.FailoverType)"
    
    # Add custom pre/post failover actions here
    # Examples:
    # - Update DNS records
    # - Configure load balancers
    # - Run database scripts
    # - Send notifications
    
    Write-Output "Recovery Plan Action Completed"
  EOT

  tags = var.tags
}

# Monitoring with Log Analytics
resource "azurerm_log_analytics_workspace" "asr" {
  count               = var.create_log_analytics ? 1 : 0
  name                = "${var.vault_name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

# Diagnostic Settings for Recovery Services Vault
resource "azurerm_monitor_diagnostic_setting" "vault" {
  count                      = var.enable_diagnostics ? 1 : 0
  name                       = "${var.vault_name}-diagnostics"
  target_resource_id         = azurerm_recovery_services_vault.main.id
  log_analytics_workspace_id = var.create_log_analytics ? azurerm_log_analytics_workspace.asr[0].id : var.log_analytics_workspace_id

  enabled_log {
    category = "AzureBackupReport"
  }

  enabled_log {
    category = "CoreAzureBackup"
  }

  enabled_log {
    category = "AddonAzureBackupJobs"
  }

  enabled_log {
    category = "AddonAzureBackupAlerts"
  }

  enabled_log {
    category = "AddonAzureBackupPolicy"
  }

  enabled_log {
    category = "AddonAzureBackupStorage"
  }

  enabled_log {
    category = "AddonAzureBackupProtectedInstance"
  }

  enabled_log {
    category = "AzureSiteRecoveryJobs"
  }

  enabled_log {
    category = "AzureSiteRecoveryEvents"
  }

  enabled_log {
    category = "AzureSiteRecoveryReplicatedItems"
  }

  enabled_log {
    category = "AzureSiteRecoveryReplicationStats"
  }

  enabled_log {
    category = "AzureSiteRecoveryRecoveryPoints"
  }

  enabled_log {
    category = "AzureSiteRecoveryReplicationDataUploadRate"
  }

  enabled_log {
    category = "AzureSiteRecoveryProtectedDiskDataChurn"
  }

  metric {
    category = "Health"
    enabled  = true
  }
}

# Alert Rules for Replication Health
resource "azurerm_monitor_metric_alert" "replication_health" {
  count               = var.enable_alerts ? 1 : 0
  name                = "${var.vault_name}-replication-health-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_recovery_services_vault.main.id]
  description         = "Alert when replication health is critical"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.RecoveryServices/vaults"
    metric_name      = "ReplicationHealth"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 80
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}

# Configuration Script for ASR
resource "local_file" "asr_config" {
  count    = var.create_asr_config ? 1 : 0
  filename = "${path.module}/asr-config.json"

  content = jsonencode({
    vaultName               = azurerm_recovery_services_vault.main.name
    resourceGroupName       = var.resource_group_name
    subscriptionId          = var.subscription_id
    location                = var.location
    targetLocation          = var.target_location
    cacheStorageAccount     = azurerm_storage_account.cache.name
    targetStorageAccount    = var.create_target_storage ? azurerm_storage_account.target[0].name : null
    automationAccountName   = var.create_automation_account ? azurerm_automation_account.asr[0].name : null
    logAnalyticsWorkspaceId = var.create_log_analytics ? azurerm_log_analytics_workspace.asr[0].workspace_id : var.log_analytics_workspace_id
  })
}
