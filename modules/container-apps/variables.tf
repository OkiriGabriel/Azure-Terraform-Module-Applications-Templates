variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# variable "subnet_id" {
#   description = "ID of the subnet for the container app environment"
#   type        = string
# }

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# variable "frontend_config" {
#   description = "Configuration for the frontend container"
#   type = object({
#     image         = string
#     cpu           = number
#     memory_in_gb  = number
#   })
# }

variable "backend_config" {
  description = "Configuration for the backend container"
  type = object({
    image        = string
    cpu          = number
    memory_in_gb = number
  })
}

variable "frontend_acr_server" {
  description = "Azure Container Registry server for frontend"
  type        = string
}

variable "frontend_acr_username" {
  description = "The username for the frontend ACR"
  type        = string
}

variable "frontend_acr_password" {
  description = "Azure Container Registry password for frontend"
  type        = string
  sensitive   = true
}

variable "frontend_acr_identity" {
  description = "Managed identity for frontend ACR authentication"
  type        = string
  default     = null
}

variable "backend_acr_server" {
  description = "Azure Container Registry server for backend"
  type        = string
}

variable "backend_acr_username" {
  description = "The username for the backend ACR"
  type        = string
}

variable "backend_acr_password" {
  description = "Azure Container Registry password for backend"
  type        = string
  sensitive   = true
}

variable "backend_acr_identity" {
  description = "Managed identity for backend ACR authentication"
  type        = string
  default     = null
}



variable "container_volume_name" {
  description = "Name for the container volume"
  type        = string
}

# variable "container_apps_config_v2" {
#   description = "Configuration for the container apps"
#   type = object({
#     frontend = object({
#       name         = string
#       image        = string
#       cpu          = number
#       memory_in_gb = number
#     })
#     backend = object({
#       name         = string
#       image        = string
#       cpu          = number
#       memory_in_gb = number
#     })
#     container_volume_name = string
#     tags = map(string)
#   })
# }

# variable "app_environment" {
#   description = "Environment for the container apps"
#   type        = string
# }
variable "log_analytics_workspace" {
  description = "Name for the container apps"
  type        = string
}

variable "frontend_app_name" {
  description = "Name for the container apps"
  type        = string
}

variable "backend_app_name" {
  description = "Name for the container apps"
  type        = string
}

variable "frontend_min_replicas" {
  description = "Minimum number of replicas for the frontend container"
  type        = number
}

variable "frontend_max_replicas" {
  description = "Maximum number of replicas for the frontend container"
  type        = number
}

variable "backend_min_replicas" {
  description = "Minimum number of replicas for the backend container"
  type        = number
}

variable "backend_max_replicas" {
  description = "Maximum number of replicas for the backend container"
  type        = number
}

# variable "frontend_acr_password_secret_name" {
#   description = "Name of the secret for the frontend ACR password"
#   type        = string
# }

# variable "backend_acr_password_secret_name" {
#   description = "Name of the secret for the backend ACR password"
#   type        = string
# }
# variable "frontend_storage_name" {
#   description = "Name of the storage account for the frontend"
#   type        = string
# }

# variable "backend_storage_name" {
#   description = "Name of the storage account for the backend"
#   type        = string  
# }

variable "frontend_storage_share_name" {
  description = "Name of the storage share for the frontend"
  type        = string
}
variable "backend_storage_share_name" {
  description = "Name of the storage share for the backend"
  type        = string
}

variable "frontend_storage_share_quota" {
  description = "Quota for the storage share for the frontend"
  type        = number
}
variable "backend_storage_share_quota" {
  description = "Quota for the storage share for the backend"
  type        = number
}

variable "environment" {
  description = "Environment for the container apps"
  type        = string
}
# variable "container_app_environment_id" {
#   description = "ID of the container app environment"
#   type        = string
# }

variable "frontend_image" {
  description = "Image for the frontend container"
  type        = string
}
variable "frontend_cpu" {
  description = "CPU for the frontend container"
  type        = number
}
variable "frontend_memory" {
  description = "Memory for the frontend container"
  type        = number
}

variable "backend_image" {
  description = "Image for the backend container"
  type        = string
}

variable "backend_cpu" {
  description = "CPU for the backend container"
  type        = number
}
variable "backend_memory" {
  description = "Memory for the backend container"
  type        = number
}

variable "frontend_port" {
  description = "Port for the frontend container"
  type        = number
}

variable "backend_port" {
  description = "Port for the backend container"
  type        = number
}

variable "key_vault_id" {
  description = "ID of the key vault"
  type        = string
}

variable "frontend_port_https" {
  description = "Port for the frontend container"
  type        = number
}


variable "backend_port_https" {
  description = "Port for the backend container"
  type        = number
}

variable "frontend_application_port" {
  description = "Port for the frontend application"
  type        = number
}


variable "backend_application_port" {
  description = "Port for the backend application"
  type        = number
}

variable "frontend" {
  description = "Name of the frontend storage account"
  type        = string
}


variable "backend" {
  description = "Name of the backend storage account"
  type        = string
}



variable "frontend_data_share_name" {
  description = "Name of the frontend data share"
  type        = string
}

variable "backend_data_share_name" {
  description = "Name of the backend data share"
  type        = string
}

variable "key_vault_secrets_name" {
  description = "Name of the Key Vault"
  type        = string
}


variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "key_vault_url" {
  description = "URL of the Key Vault"
  type        = string
}

# Key Vault secret values
variable "jwt_expiry" {
  description = "JWT expiry value"
  type        = string
}

variable "jwt_secret" {
  description = "JWT secret value"
  type        = string
  sensitive   = true
}

variable "base_url" {
  description = "Base URL value"
  type        = string
}

variable "redis_url" {
  description = "Redis URL value"
  type        = string
  sensitive   = true
}

variable "mongo_uri" {
  description = "MongoDB URI value"
  type        = string
  sensitive   = true
}

variable "termii_api_key" {
  description = "Termii API key value"
  type        = string
  sensitive   = true
}

variable "sender_id" {
  description = "Sender ID value"
  type        = string
}

variable "mailgun_from_email" {
  description = "Mailgun from email value"
  type        = string
}

variable "mailgun_domain" {
  description = "Mailgun domain value"
  type        = string
}

variable "mailgun_secret_key" {
  description = "Mailgun secret key value"
  type        = string
  sensitive   = true
}

variable "azure_storage_connection_string" {
  description = "Azure storage connection string value"
  type        = string
  sensitive   = true
}

variable "access_secret" {
  description = "Access secret value"
  type        = string
  sensitive   = true
}

variable "password_change_secret" {
  description = "Password change secret value"
  type        = string
  sensitive   = true
}

variable "password_reset_secret" {
  description = "Password reset secret value"
  type        = string
  sensitive   = true
}

variable "verify_email_secret" {
  description = "Verify email secret value"
  type        = string
  sensitive   = true
}

variable "access_token_expires_at_in_seconds" {
  description = "Access token expires at in seconds value"
  type        = string
}

variable "encryption_key" {
  description = "Encryption key value"
  type        = string
  sensitive   = true
}

variable "google_credentials_b64" {
  description = "Google credentials base64 value"
  type        = string
  sensitive   = true
}

variable "google_scopes_api" {
  description = "Google scopes API value"
  type        = string
}

variable "currency_type" {
  description = "Currency type value"
  type        = string
}

variable "stripe_key" {
  description = "Stripe key value"
  type        = string
  sensitive   = true
}

variable "example_commission" {
  description = "example commission value"
  type        = string
}

# Marketplace variables
variable "marketplace" {
  description = "Name of the marketplace storage account"
  type        = string
}

variable "marketplace_app_name" {
  description = "Name for the marketplace container app"
  type        = string
}

variable "marketplace_port" {
  description = "Port for the marketplace container"
  type        = number
}

variable "marketplace_image" {
  description = "Image for the marketplace container"
  type        = string
}

variable "marketplace_cpu" {
  description = "CPU for the marketplace container"
  type        = number
}

variable "marketplace_memory" {
  description = "Memory for the marketplace container"
  type        = number
}

variable "marketplace_min_replicas" {
  description = "Minimum number of replicas for the marketplace container"
  type        = number
}

variable "marketplace_max_replicas" {
  description = "Maximum number of replicas for the marketplace container"
  type        = number
}

variable "marketplace_acr_server" {
  description = "Azure Container Registry server for marketplace"
  type        = string
}

variable "marketplace_acr_username" {
  description = "The username for the marketplace ACR"
  type        = string
}

variable "marketplace_acr_password" {
  description = "Azure Container Registry password for marketplace"
  type        = string
  sensitive   = true
}

variable "marketplace_acr_identity" {
  description = "Managed identity for marketplace ACR authentication"
  type        = string
  default     = null
}

# Admin Frontend variables
variable "admin_frontend" {
  description = "Name of the admin frontend storage account"
  type        = string
}

variable "admin_frontend_app_name" {
  description = "Name for the admin frontend container app"
  type        = string
}

variable "admin_frontend_port" {
  description = "Port for the admin frontend container"
  type        = number
}

variable "admin_frontend_image" {
  description = "Image for the admin frontend container"
  type        = string
}

variable "admin_frontend_cpu" {
  description = "CPU for the admin frontend container"
  type        = number
}

variable "admin_frontend_memory" {
  description = "Memory for the admin frontend container"
  type        = number
}

variable "admin_frontend_min_replicas" {
  description = "Minimum number of replicas for the admin frontend container"
  type        = number
}

variable "admin_frontend_max_replicas" {
  description = "Maximum number of replicas for the admin frontend container"
  type        = number
}

variable "admin_frontend_acr_server" {
  description = "Azure Container Registry server for admin frontend"
  type        = string
}

variable "admin_frontend_acr_username" {
  description = "The username for the admin frontend ACR"
  type        = string
}

variable "admin_frontend_acr_password" {
  description = "Azure Container Registry password for admin frontend"
  type        = string
  sensitive   = true
}

variable "admin_frontend_acr_identity" {
  description = "Managed identity for admin frontend ACR authentication"
  type        = string
  default     = null
}

# Redis variables
variable "redis_hostname" {
  description = "Redis cache hostname"
  type        = string
}

variable "redis_ssl_port" {
  description = "Redis cache SSL port"
  type        = number
}

variable "redis_primary_access_key" {
  description = "Redis cache primary access key"
  type        = string
  sensitive   = true
}

# variable "dns_cname_record" {
#   description = "CNAME record for the API"
#   type        = string
# }

# variable "dns_zone" {
#   description = "Zone for the DNS"
#   type        = string
# }