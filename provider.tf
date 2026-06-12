terraform {
  required_version = ">= 1.10.0"

  # Terraform Cloud Backend (Optional)
  # Uncomment and configure if you want to use Terraform Cloud
  # cloud {
  #   organization = "your-organization-name"
  #   workspaces {
  #     tags = ["example-infrastructure-dev"]
  #   }
  # }

  # Local Backend (Default)
  # State files will be stored locally
  # For production, consider using Azure Storage backend or Terraform Cloud
  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.18.0"
    }
    # Uncomment if you need GitLab integration
    # gitlab = {
    #   source  = "gitlabhq/gitlab"
    #   version = "~> 16.0"
    # }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = local.current_env.subscription_id
  # skip_provider_registration is deprecated in v5.0
  # skip_provider_registration = true
}

