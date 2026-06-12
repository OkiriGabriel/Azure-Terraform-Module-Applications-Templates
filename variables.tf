# Service Principal credentials
variable "client_id" {
  description = "Service principal client ID"
  type        = string
  default     = null
}

variable "client_secret" {
  description = "Service principal client secret. Set via TF_VAR_client_secret or terraform.tfvars (never commit)."
  type        = string
  sensitive   = true
  default     = null
}
