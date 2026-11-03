locals {
  openai_location = coalesce(var.openai_location, var.location)

  # Private endpoints to create when a subnet is supplied.
  private_endpoints = var.private_endpoint_subnet_id == null ? {} : merge(
    {
      aml = {
        resource_id = azurerm_machine_learning_workspace.this.id
        subresource = "amlworkspace"
      }
    },
    var.openai_enabled ? {
      openai = {
        resource_id = azurerm_cognitive_account.openai[0].id
        subresource = "account"
      }
    } : {},
    var.search_enabled ? {
      search = {
        resource_id = azurerm_search_service.this[0].id
        subresource = "searchService"
      }
    } : {}
  )
}

# ---------------------------------------------------------------------------
# Workspace dependencies
# ---------------------------------------------------------------------------
resource "azurerm_application_insights" "this" {
  name                = "${var.name_prefix}-mlw-appi"
  resource_group_name = var.resource_group_name
  location            = var.location
  workspace_id        = var.log_analytics_workspace_id
  application_type    = "web"
  tags                = var.tags
}

resource "azurerm_key_vault" "this" {
  name                          = var.key_vault_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  enable_rbac_authorization     = true
  purge_protection_enabled      = true
  soft_delete_retention_days    = 7
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags

  network_acls {
    bypass         = "AzureServices"
    default_action = var.public_network_access_enabled ? "Allow" : "Deny"
  }
}

resource "azurerm_storage_account" "this" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = var.storage_replication_type
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = var.public_network_access_enabled
  tags                            = var.tags

  network_rules {
    bypass         = ["AzureServices"]
    default_action = var.public_network_access_enabled ? "Allow" : "Deny"
  }

  blob_properties {
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }
}

# ---------------------------------------------------------------------------
# Azure Machine Learning workspace + compute
# ---------------------------------------------------------------------------
resource "azurerm_machine_learning_workspace" "this" {
  name                          = "${var.name_prefix}-mlw"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  application_insights_id       = azurerm_application_insights.this.id
  key_vault_id                  = azurerm_key_vault.this.id
  storage_account_id            = azurerm_storage_account.this.id
  container_registry_id         = var.container_registry_id
  public_network_access_enabled = var.public_network_access_enabled
  high_business_impact          = var.high_business_impact
  sku_name                      = "Basic"
  tags                          = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_machine_learning_compute_cluster" "this" {
  for_each = var.compute_clusters

  name                          = each.key
  location                      = var.location
  machine_learning_workspace_id = azurerm_machine_learning_workspace.this.id
  vm_size                       = each.value.vm_size
  vm_priority                   = each.value.vm_priority
  subnet_resource_id            = each.value.subnet_id
  local_auth_enabled            = false
  node_public_ip_enabled        = each.value.subnet_id == null
  tags                          = var.tags

  scale_settings {
    min_node_count                       = each.value.min_nodes
    max_node_count                       = each.value.max_nodes
    scale_down_nodes_after_idle_duration = each.value.idle_before_scale_in
  }

  identity {
    type = "SystemAssigned"
  }
}

# ---------------------------------------------------------------------------
# Azure OpenAI
# ---------------------------------------------------------------------------
resource "azurerm_cognitive_account" "openai" {
  count = var.openai_enabled ? 1 : 0

  name                          = "${var.name_prefix}-oai"
  resource_group_name           = var.resource_group_name
  location                      = local.openai_location
  kind                          = "OpenAI"
  sku_name                      = "S0"
  custom_subdomain_name         = "${var.name_prefix}-oai"
  local_auth_enabled            = var.openai_local_auth_enabled
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags

  identity {
    type = "SystemAssigned"
  }

  network_acls {
    default_action = var.public_network_access_enabled ? "Allow" : "Deny"
  }
}

resource "azurerm_cognitive_deployment" "this" {
  for_each = var.openai_enabled ? var.openai_deployments : {}

  name                 = each.key
  cognitive_account_id = azurerm_cognitive_account.openai[0].id

  model {
    format  = "OpenAI"
    name    = each.value.model_name
    version = each.value.model_version
  }

  sku {
    name     = each.value.sku_name
    capacity = each.value.capacity
  }
}

# ---------------------------------------------------------------------------
# Azure AI Search
# ---------------------------------------------------------------------------
resource "azurerm_search_service" "this" {
  count = var.search_enabled ? 1 : 0

  name                          = "${var.name_prefix}-srch"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.search_sku
  replica_count                 = var.search_replica_count
  partition_count               = var.search_partition_count
  public_network_access_enabled = var.public_network_access_enabled
  local_authentication_enabled  = false
  tags                          = var.tags

  identity {
    type = "SystemAssigned"
  }
}

# ---------------------------------------------------------------------------
# Identity-based access between services (no keys)
# ---------------------------------------------------------------------------
resource "azurerm_role_assignment" "aml_openai_user" {
  count = var.openai_enabled ? 1 : 0

  scope                = azurerm_cognitive_account.openai[0].id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = azurerm_machine_learning_workspace.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "search_openai_user" {
  count = var.openai_enabled && var.search_enabled ? 1 : 0

  scope                = azurerm_cognitive_account.openai[0].id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = azurerm_search_service.this[0].identity[0].principal_id
}

resource "azurerm_role_assignment" "openai_search_reader" {
  count = var.openai_enabled && var.search_enabled ? 1 : 0

  scope                = azurerm_search_service.this[0].id
  role_definition_name = "Search Index Data Reader"
  principal_id         = azurerm_cognitive_account.openai[0].identity[0].principal_id
}

# ---------------------------------------------------------------------------
# Diagnostics
# ---------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "openai" {
  count = var.openai_enabled ? 1 : 0

  name                       = "${var.name_prefix}-oai-diag"
  target_resource_id         = azurerm_cognitive_account.openai[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "search" {
  count = var.search_enabled ? 1 : 0

  name                       = "${var.name_prefix}-srch-diag"
  target_resource_id         = azurerm_search_service.this[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

# ---------------------------------------------------------------------------
# Private endpoints (optional)
# ---------------------------------------------------------------------------
resource "azurerm_private_endpoint" "this" {
  for_each = local.private_endpoints

  name                = "${var.name_prefix}-${each.key}-pe"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.name_prefix}-${each.key}-psc"
    private_connection_resource_id = each.value.resource_id
    subresource_names              = [each.value.subresource]
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = contains(keys(var.private_dns_zone_ids), each.key) ? [1] : []
    content {
      name                 = "default"
      private_dns_zone_ids = [var.private_dns_zone_ids[each.key]]
    }
  }
}
