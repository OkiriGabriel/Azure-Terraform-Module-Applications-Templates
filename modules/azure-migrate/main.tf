# Azure Migrate Project
resource "azurerm_resource_group_template_deployment" "migrate_project" {
  name                = "${var.project_name}-deployment"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"

  template_content = jsonencode({
    "$schema" : "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion" : "1.0.0.0",
    "parameters" : {},
    "resources" : [
      {
        "type" : "Microsoft.Migrate/migrateProjects",
        "apiVersion" : "2020-05-01",
        "name" : var.project_name,
        "location" : var.location,
        "properties" : {
          "registeredTools" : var.registered_tools
        },
        "tags" : var.tags
      }
    ]
  })

  tags = var.tags
}

# Azure Migrate Assessment Project
resource "azurerm_resource_group_template_deployment" "assessment_project" {
  name                = "${var.project_name}-assessment-deployment"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"

  template_content = jsonencode({
    "$schema" : "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion" : "1.0.0.0",
    "parameters" : {},
    "resources" : [
      {
        "type" : "Microsoft.Migrate/assessmentProjects",
        "apiVersion" : "2020-05-01",
        "name" : "${var.project_name}-assessment",
        "location" : var.location,
        "properties" : {
          "assessmentSolutionId" : "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Migrate/migrateProjects/${var.project_name}/solutions/Servers-Assessment-ServerAssessment",
          "projectStatus" : "Active",
          "customerWorkspaceId" : var.log_analytics_workspace_id,
          "customerWorkspaceLocation" : var.log_analytics_workspace_location
        },
        "tags" : var.tags
      }
    ]
  })

  depends_on = [azurerm_resource_group_template_deployment.migrate_project]

  tags = var.tags
}

# Storage Account for Migration Data
resource "azurerm_storage_account" "migrate" {
  name                     = var.storage_account_name
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

resource "azurerm_storage_container" "migrate_data" {
  name                  = "migrate-data"
  storage_account_name  = azurerm_storage_account.migrate.name
  container_access_type = "private"
}

# Key Vault for Migration Secrets
resource "azurerm_key_vault" "migrate" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.service_principal_object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]

    storage_permissions = [
      "Get", "List", "Set", "Delete"
    ]
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

# Log Analytics for Migration Tracking
resource "azurerm_log_analytics_workspace" "migrate" {
  count               = var.create_log_analytics ? 1 : 0
  name                = "${var.project_name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

# Recovery Services Vault for Migration
resource "azurerm_recovery_services_vault" "migrate" {
  name                = "${var.project_name}-rsv"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  soft_delete_enabled = true

  tags = var.tags
}

# Backup Policy for Pre-Migration
resource "azurerm_backup_policy_vm" "migrate" {
  name                = "${var.project_name}-backup-policy"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.migrate.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }

  retention_weekly {
    count    = 4
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }
}

# Azure Migrate Appliance Configuration (for reference)
# Note: The appliance is typically deployed as a VM/physical appliance
# This creates a reference configuration file

resource "local_file" "appliance_config" {
  count    = var.create_appliance_config ? 1 : 0
  filename = "${path.module}/appliance-config.json"

  content = jsonencode({
    migrateProjectName        = var.project_name
    resourceGroupName         = var.resource_group_name
    subscriptionId            = var.subscription_id
    location                  = var.location
    assessmentProjectName     = "${var.project_name}-assessment"
    storageAccountName        = azurerm_storage_account.migrate.name
    keyVaultName              = azurerm_key_vault.migrate.name
    logAnalyticsWorkspaceId   = var.create_log_analytics ? azurerm_log_analytics_workspace.migrate[0].workspace_id : var.log_analytics_workspace_id
    recoveryServicesVaultName = azurerm_recovery_services_vault.migrate.name
    applianceType             = var.appliance_type
    discoveryScenario         = var.discovery_scenario
  })
}

# Network Watcher for Migration Connectivity Testing
resource "azurerm_network_watcher" "migrate" {
  count               = var.create_network_watcher ? 1 : 0
  name                = "${var.project_name}-nw"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Private Endpoint for Storage Account
resource "azurerm_private_endpoint" "storage" {
  count               = var.enable_private_endpoints ? 1 : 0
  name                = "${var.project_name}-storage-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.project_name}-storage-psc"
    private_connection_resource_id = azurerm_storage_account.migrate.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.tags
}

# Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "keyvault" {
  count               = var.enable_private_endpoints ? 1 : 0
  name                = "${var.project_name}-kv-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.project_name}-kv-psc"
    private_connection_resource_id = azurerm_key_vault.migrate.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  tags = var.tags
}

# Automation Account for Migration Runbooks
resource "azurerm_automation_account" "migrate" {
  count               = var.create_automation_account ? 1 : 0
  name                = "${var.project_name}-automation"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"

  tags = var.tags
}

# Sample Runbook for Pre-Migration Checks
resource "azurerm_automation_runbook" "pre_migration_check" {
  count                   = var.create_automation_account ? 1 : 0
  name                    = "PreMigrationCheck"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.migrate[0].name
  log_verbose             = true
  log_progress            = true
  runbook_type            = "PowerShell"

  content = <<-EOT
    param(
      [Parameter(Mandatory=$true)]
      [string]$ResourceGroupName,
      
      [Parameter(Mandatory=$true)]
      [string]$VMName
    )

    Write-Output "Starting pre-migration checks for VM: $VMName"
    
    # Check VM status
    $vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName
    Write-Output "VM Size: $($vm.HardwareProfile.VmSize)"
    Write-Output "VM Location: $($vm.Location)"
    
    # Check disk configuration
    Write-Output "OS Disk: $($vm.StorageProfile.OsDisk.Name)"
    Write-Output "Data Disks: $($vm.StorageProfile.DataDisks.Count)"
    
    # Check network configuration
    Write-Output "Network Interfaces: $($vm.NetworkProfile.NetworkInterfaces.Count)"
    
    Write-Output "Pre-migration checks completed"
  EOT

  tags = var.tags
}
