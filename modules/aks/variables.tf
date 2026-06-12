variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region for the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "default_node_pool" {
  description = "Configuration for the default node pool"
  type = object({
    name                = string
    node_count          = number
    vm_size             = string
    os_disk_size_gb     = number
    vnet_subnet_id      = string
    max_pods            = number
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    availability_zones  = list(string)
    max_surge           = string
  })
}

variable "additional_node_pools" {
  description = "Additional node pools for the AKS cluster"
  type = map(object({
    name                = string
    node_count          = number
    vm_size             = string
    os_disk_size_gb     = number
    vnet_subnet_id      = string
    max_pods            = number
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    availability_zones  = list(string)
    os_type             = string
    node_taints         = list(string)
    node_labels         = map(string)
    max_surge           = string
  }))
  default = {}
}

variable "network_profile" {
  description = "Network profile for the AKS cluster"
  type = object({
    network_plugin    = string
    network_policy    = string
    load_balancer_sku = string
    service_cidr      = string
    dns_service_ip    = string
    outbound_type     = string
  })
}

variable "enable_azure_ad_rbac" {
  description = "Enable Azure AD RBAC"
  type        = bool
  default     = true
}

variable "azure_ad_admin_group_object_ids" {
  description = "Azure AD admin group object IDs"
  type        = list(string)
  default     = []
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
  default     = null
}

variable "enable_monitoring" {
  description = "Enable Container Insights monitoring"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for monitoring"
  type        = string
  default     = null
}

variable "enable_azure_policy" {
  description = "Enable Azure Policy for AKS"
  type        = bool
  default     = true
}

variable "enable_key_vault_secrets_provider" {
  description = "Enable Key Vault Secrets Provider"
  type        = bool
  default     = true
}

variable "enable_cluster_autoscaler" {
  description = "Enable cluster autoscaler profile"
  type        = bool
  default     = true
}

variable "autoscaler_profile" {
  description = "Cluster autoscaler profile configuration"
  type = object({
    balance_similar_node_groups      = bool
    expander                         = string
    max_graceful_termination_sec     = string
    max_node_provisioning_time       = string
    max_unready_nodes                = number
    max_unready_percentage           = number
    new_pod_scale_up_delay           = string
    scale_down_delay_after_add       = string
    scale_down_delay_after_delete    = string
    scale_down_delay_after_failure   = string
    scan_interval                    = string
    scale_down_unneeded              = string
    scale_down_unready               = string
    scale_down_utilization_threshold = string
  })
  default = {
    balance_similar_node_groups      = false
    expander                         = "random"
    max_graceful_termination_sec     = "600"
    max_node_provisioning_time       = "15m"
    max_unready_nodes                = 3
    max_unready_percentage           = 45
    new_pod_scale_up_delay           = "10s"
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scale_down_delay_after_failure   = "3m"
    scan_interval                    = "10s"
    scale_down_unneeded              = "10m"
    scale_down_unready               = "20m"
    scale_down_utilization_threshold = "0.5"
  }
}

variable "enable_http_application_routing" {
  description = "Enable HTTP application routing"
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "Maintenance window configuration"
  type = object({
    day   = string
    hours = list(number)
  })
  default = {
    day   = "Sunday"
    hours = [2, 3, 4]
  }
}

variable "acr_id" {
  description = "Azure Container Registry ID for AKS to pull images from"
  type        = string
  default     = null
}

variable "vnet_id" {
  description = "VNet ID for network contributor role"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
