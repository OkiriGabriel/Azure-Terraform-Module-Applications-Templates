resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name            = var.default_node_pool.name
    node_count      = var.default_node_pool.node_count
    vm_size         = var.default_node_pool.vm_size
    os_disk_size_gb = var.default_node_pool.os_disk_size_gb
    vnet_subnet_id  = var.default_node_pool.vnet_subnet_id
    max_pods        = var.default_node_pool.max_pods
    zones           = var.default_node_pool.availability_zones

    upgrade_settings {
      max_surge = var.default_node_pool.max_surge
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = var.network_profile.network_plugin
    network_policy    = var.network_profile.network_policy
    load_balancer_sku = var.network_profile.load_balancer_sku
    service_cidr      = var.network_profile.service_cidr
    dns_service_ip    = var.network_profile.dns_service_ip
    outbound_type     = var.network_profile.outbound_type
  }

  role_based_access_control_enabled = true

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.enable_azure_ad_rbac ? [1] : []
    content {
      admin_group_object_ids = var.azure_ad_admin_group_object_ids
      azure_rbac_enabled     = true
      tenant_id              = var.tenant_id
    }
  }

  dynamic "oms_agent" {
    for_each = var.enable_monitoring ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  azure_policy_enabled = var.enable_azure_policy

  dynamic "key_vault_secrets_provider" {
    for_each = var.enable_key_vault_secrets_provider ? [1] : []
    content {
      secret_rotation_enabled  = true
      secret_rotation_interval = "2m"
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = var.enable_cluster_autoscaler ? [1] : []
    content {
      balance_similar_node_groups      = var.autoscaler_profile.balance_similar_node_groups
      expander                         = var.autoscaler_profile.expander
      max_graceful_termination_sec     = var.autoscaler_profile.max_graceful_termination_sec
      max_node_provisioning_time       = var.autoscaler_profile.max_node_provisioning_time
      max_unready_nodes                = var.autoscaler_profile.max_unready_nodes
      max_unready_percentage           = var.autoscaler_profile.max_unready_percentage
      new_pod_scale_up_delay           = var.autoscaler_profile.new_pod_scale_up_delay
      scale_down_delay_after_add       = var.autoscaler_profile.scale_down_delay_after_add
      scale_down_delay_after_delete    = var.autoscaler_profile.scale_down_delay_after_delete
      scale_down_delay_after_failure   = var.autoscaler_profile.scale_down_delay_after_failure
      scan_interval                    = var.autoscaler_profile.scan_interval
      scale_down_unneeded              = var.autoscaler_profile.scale_down_unneeded
      scale_down_unready               = var.autoscaler_profile.scale_down_unready
      scale_down_utilization_threshold = var.autoscaler_profile.scale_down_utilization_threshold
    }
  }

  http_application_routing_enabled = var.enable_http_application_routing

  maintenance_window {
    allowed {
      day   = var.maintenance_window.day
      hours = var.maintenance_window.hours
    }
  }

  tags = var.tags
}

# Additional Node Pools
resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  for_each = var.additional_node_pools

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  vnet_subnet_id        = each.value.vnet_subnet_id
  max_pods              = each.value.max_pods
  os_disk_size_gb       = each.value.os_disk_size_gb
  os_type               = each.value.os_type
  zones                 = each.value.availability_zones
  node_taints           = each.value.node_taints
  node_labels           = each.value.node_labels

  upgrade_settings {
    max_surge = each.value.max_surge
  }

  tags = var.tags
}

# Role Assignment for AKS to access ACR
resource "azurerm_role_assignment" "aks_acr" {
  count                = var.acr_id != null ? 1 : 0
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

# Role Assignment for AKS to manage VNet
resource "azurerm_role_assignment" "aks_network" {
  scope                = var.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "aks" {
  count                      = var.enable_monitoring ? 1 : 0
  name                       = "${var.cluster_name}-diagnostics"
  target_resource_id         = azurerm_kubernetes_cluster.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_log {
    category = "kube-scheduler"
  }

  enabled_log {
    category = "kube-audit"
  }

  enabled_log {
    category = "cluster-autoscaler"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
