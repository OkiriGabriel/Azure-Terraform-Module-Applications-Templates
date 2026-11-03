# ---------------------------------------------------------------------------
# Core
# ---------------------------------------------------------------------------
variable "name_prefix" {
  description = "Prefix used for all resource names (e.g. \"example-dev\")."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,20}$", var.name_prefix))
    error_message = "name_prefix must be 2-20 characters of lowercase letters, numbers and hyphens."
  }
}

variable "resource_group_name" {
  description = "Resource group that holds the AI/ML resources."
  type        = string
}

variable "location" {
  description = "Azure region for the AI/ML workspace and supporting resources."
  type        = string
}

variable "tenant_id" {
  description = "Microsoft Entra tenant ID used by the workspace Key Vault."
  type        = string
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace used for Application Insights and diagnostic settings."
  type        = string
}

variable "public_network_access_enabled" {
  description = "Allow public network access to the AI/ML endpoints. Secure by default (false); set to true only for dev/sandbox, otherwise supply private_endpoint_subnet_id."
  type        = bool
  default     = false
}

# ---------------------------------------------------------------------------
# Azure Machine Learning
# ---------------------------------------------------------------------------
variable "storage_account_name" {
  description = "Globally unique name (3-24 lowercase alphanumerics) for the ML workspace storage account."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "storage_account_name must be 3-24 lowercase letters and numbers."
  }
}

variable "storage_replication_type" {
  description = "Replication type for the ML storage account (LRS, ZRS, GRS, RAGRS, GZRS, RAGZRS). LRS is fine for dev."
  type        = string
  default     = "ZRS"

  validation {
    condition     = contains(["LRS", "ZRS", "GRS", "RAGRS", "GZRS", "RAGZRS"], var.storage_replication_type)
    error_message = "storage_replication_type must be one of LRS, ZRS, GRS, RAGRS, GZRS, RAGZRS."
  }
}

variable "key_vault_name" {
  description = "Globally unique name (3-24 chars) for the ML workspace Key Vault."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,22}[a-zA-Z0-9]$", var.key_vault_name))
    error_message = "key_vault_name must be 3-24 characters, start with a letter and contain only letters, numbers and hyphens."
  }
}

variable "container_registry_id" {
  description = "Optional existing Azure Container Registry ID for ML environment images."
  type        = string
  default     = null
}

variable "high_business_impact" {
  description = "Enable high business impact mode (reduces diagnostic data collected by Microsoft)."
  type        = bool
  default     = false
}

variable "compute_clusters" {
  description = <<-EOT
    Map of Azure ML compute clusters. Use GPU sizes (e.g. Standard_NC4as_T4_v3) for training.
    min_nodes = 0 lets clusters scale to zero when idle so they cost nothing.
  EOT
  type = map(object({
    vm_size              = string
    vm_priority          = optional(string, "LowPriority")
    min_nodes            = optional(number, 0)
    max_nodes            = optional(number, 2)
    idle_before_scale_in = optional(string, "PT15M")
    subnet_id            = optional(string)
  }))
  default = {}

  validation {
    condition     = alltrue([for c in values(var.compute_clusters) : contains(["Dedicated", "LowPriority"], c.vm_priority)])
    error_message = "vm_priority must be Dedicated or LowPriority."
  }

  validation {
    condition     = alltrue([for c in values(var.compute_clusters) : c.min_nodes >= 0 && c.max_nodes >= c.min_nodes])
    error_message = "Each cluster needs min_nodes >= 0 and max_nodes >= min_nodes."
  }
}

# ---------------------------------------------------------------------------
# Azure OpenAI
# ---------------------------------------------------------------------------
variable "openai_enabled" {
  description = "Deploy an Azure OpenAI account."
  type        = bool
  default     = true
}

variable "openai_location" {
  description = "Region for Azure OpenAI (model availability varies by region). Defaults to var.location."
  type        = string
  default     = null
}

variable "openai_local_auth_enabled" {
  description = "Allow API-key authentication. Keep false to force Microsoft Entra ID authentication."
  type        = bool
  default     = false
}

variable "openai_outbound_network_restricted" {
  description = "Data loss prevention: block OpenAI outbound calls except to openai_allowed_fqdns (the AI Search endpoint is added automatically)."
  type        = bool
  default     = true
}

variable "openai_allowed_fqdns" {
  description = "Extra FQDNs Azure OpenAI may reach when outbound access is restricted."
  type        = list(string)
  default     = []
}

variable "openai_deployments" {
  description = "Map of Azure OpenAI model deployments keyed by deployment name."
  type = map(object({
    model_name    = string
    model_version = string
    sku_name      = optional(string, "Standard")
    capacity      = optional(number, 10)
  }))
  default = {}
}

# ---------------------------------------------------------------------------
# Azure AI Search
# ---------------------------------------------------------------------------
variable "search_enabled" {
  description = "Deploy an Azure AI Search service (vector search / RAG)."
  type        = bool
  default     = true
}

variable "search_sku" {
  description = "Azure AI Search SKU (free, basic, standard, standard2, standard3)."
  type        = string
  default     = "basic"

  validation {
    condition     = contains(["free", "basic", "standard", "standard2", "standard3", "storage_optimized_l1", "storage_optimized_l2"], var.search_sku)
    error_message = "search_sku is not a valid Azure AI Search SKU."
  }
}

variable "search_replica_count" {
  description = "Number of search replicas (use >= 2 for read SLA, >= 3 for read/write SLA)."
  type        = number
  default     = 1

  validation {
    condition     = var.search_replica_count >= 1 && var.search_replica_count <= 12
    error_message = "search_replica_count must be between 1 and 12."
  }
}

variable "search_partition_count" {
  description = "Number of search partitions."
  type        = number
  default     = 1
}

# ---------------------------------------------------------------------------
# Private networking
# ---------------------------------------------------------------------------
variable "private_endpoint_subnet_id" {
  description = "Subnet for private endpoints. When null, no private endpoints are created."
  type        = string
  default     = null
}

variable "private_dns_zone_ids" {
  description = <<-EOT
    Optional private DNS zone IDs keyed by endpoint:
      aml      = privatelink.api.azureml.ms
      openai   = privatelink.openai.azure.com
      search   = privatelink.search.windows.net
      keyvault = privatelink.vaultcore.azure.net
      blob     = privatelink.blob.core.windows.net
      file     = privatelink.file.core.windows.net
  EOT
  type        = map(string)
  default     = {}
}
