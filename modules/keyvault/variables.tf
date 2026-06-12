variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

# variable "prefix" {}
variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

# variable "admin_object_id" {
#   description = "Object ID of the admin"
#   type        = string
# }

variable "sku_name" {
  description = "SKU name for the key vault"
  type        = string
  default     = "standard"
}

variable "allowed_ip_ranges" {
  description = "Allowed IP ranges"
  type        = list(string)
  default     = []
}

# variable "allowed_subnet_ids" {}
# variable "app_service_principal_id" {}
variable "log_analytics_workspace_id" {
  description = "ID of Log Analytics workspace"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "diagnostic_settings" {
  description = "Name of diagnostic settings"
  type        = string
}

variable "vault_name" {
  description = "Name of the key vault"
  type        = string
}

variable "allowed_subnet_ids" {
  description = "List of subnet IDs allowed to access the Key Vault"
  type        = list(string) # Changed from object to list(string)
  default     = []
}

variable "user_object_id" {
  description = "Object ID of the user"
  type        = string
}

variable "app_identity_object_id" {
  description = "Object ID of the app's managed identity"
  type        = string
  default     = null # Make it optional
}

# Make all secret-related variables optional by adding defaults
variable "postgres_uri" {
  description = "PostgreSQL connection URI"
  type        = string
  default     = null
  sensitive   = true
}

variable "postgres_user" {
  description = "PostgreSQL username"
  type        = string
  default     = null
  sensitive   = true
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  default     = null
  sensitive   = true
}

variable "postgres_db" {
  description = "PostgreSQL database name"
  type        = string
  default     = null
  sensitive   = true
}

variable "msal_client_id" {
  description = "MSAL Client ID"
  type        = string
  default     = null
  sensitive   = true
}

variable "msal_client_secret" {
  description = "MSAL Client Secret"
  type        = string
  default     = null
  sensitive   = true
}

variable "sharepoint_cert_thumbprint" {
  description = "Sharepoint Certificate Thumbprint"
  type        = string
  default     = null
  sensitive   = true
}

# Redis related variables
variable "redis_auth" {
  description = "Redis authentication key"
  type        = string
  default     = null
  sensitive   = true
}

variable "redis_host" {
  description = "Redis host address"
  type        = string
  default     = null
  sensitive   = true
}

# Server configuration variables
variable "server_name" {
  description = "Name of the server"
  type        = string
  default     = null
  sensitive   = true
}

variable "service_principal_object_id" {
  description = "Object ID of the Service Principal"
  type        = string
  default     = null # Make it optional
}

variable "session_secret" {
  description = "Secret key for session management"
  type        = string
  default     = null
  sensitive   = true
}

variable "base_url" {
  description = "Base URL for the application"
  type        = string
  default     = null
  sensitive   = true
}

# MSAL related variables
variable "msal_tenant_id" {
  description = "MSAL Tenant ID"
  type        = string
  default     = null
  sensitive   = true
}

# RabbitMQ related variables
variable "rabbit_username" {
  description = "RabbitMQ username"
  type        = string
  default     = null
  sensitive   = true
}

variable "rabbit_password" {
  description = "RabbitMQ password"
  type        = string
  default     = null
  sensitive   = true
}

variable "api_scope" {
  description = "API scope for authentication"
  type        = string
  default     = null
  sensitive   = true
}

variable "enable_rbac_authorization" {
  description = "Enable RBAC authorization for Key Vault"
  type        = bool
  default     = true
}


# variable "tenant_id" {
#   description = "Tenant ID for QA environment"
#   type        = string
# }


# variable "service_qa_principal_object_id" {
#   description = "Principal Object ID for QA environment"
#   type        = string
# }
