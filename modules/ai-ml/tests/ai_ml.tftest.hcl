# Unit tests for the ai-ml module. Run with: terraform test
# Uses a mocked azurerm provider, so no Azure credentials are required.

mock_provider "azurerm" {
  mock_resource "azurerm_machine_learning_workspace" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.MachineLearningServices/workspaces/test-mlw"
    }
  }
  mock_resource "azurerm_cognitive_account" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.CognitiveServices/accounts/test-oai"
    }
  }
  mock_resource "azurerm_search_service" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Search/searchServices/test-srch"
    }
  }
  mock_resource "azurerm_key_vault" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/testmlkv"
    }
  }
  mock_resource "azurerm_storage_account" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/testmlsa"
    }
  }
  mock_resource "azurerm_application_insights" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Insights/components/test-appi"
    }
  }
}

variables {
  name_prefix                = "test"
  resource_group_name        = "rg-test"
  location                   = "eastus2"
  tenant_id                  = "00000000-0000-0000-0000-000000000000"
  storage_account_name       = "testmlsa"
  key_vault_name             = "testmlkv"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.OperationalInsights/workspaces/test-law"
}

run "defaults_deploy_full_stack" {
  command = plan

  assert {
    condition     = length(azurerm_cognitive_account.openai) == 1 && length(azurerm_search_service.this) == 1
    error_message = "OpenAI and AI Search should be deployed by default."
  }

  assert {
    condition     = azurerm_cognitive_account.openai[0].local_auth_enabled == false
    error_message = "OpenAI must default to Entra ID authentication (no API keys)."
  }

  assert {
    condition     = azurerm_storage_account.this.min_tls_version == "TLS1_2"
    error_message = "Storage must enforce TLS 1.2."
  }

  assert {
    condition     = length(azurerm_private_endpoint.this) == 0
    error_message = "No private endpoints should be created without a subnet."
  }
}

run "optional_services_disabled" {
  command = plan

  variables {
    openai_enabled = false
    search_enabled = false
  }

  assert {
    condition     = length(azurerm_cognitive_account.openai) == 0 && length(azurerm_search_service.this) == 0
    error_message = "Disabled services must not be created."
  }

  assert {
    condition     = length(azurerm_role_assignment.openai_search_reader) == 0
    error_message = "Cross-service role assignments must be skipped when services are disabled."
  }
}

run "gpu_cluster_and_models" {
  command = plan

  variables {
    compute_clusters = {
      gpu-t4 = { vm_size = "Standard_NC4as_T4_v3", max_nodes = 4 }
    }
    openai_deployments = {
      gpt-4o = { model_name = "gpt-4o", model_version = "2024-11-20", sku_name = "GlobalStandard" }
    }
  }

  assert {
    condition     = azurerm_machine_learning_compute_cluster.this["gpu-t4"].scale_settings[0].min_node_count == 0
    error_message = "Compute clusters should scale to zero by default."
  }

  assert {
    condition     = azurerm_cognitive_deployment.this["gpt-4o"].sku[0].name == "GlobalStandard"
    error_message = "Deployment SKU should be configurable."
  }
}

run "private_endpoints_created" {
  command = plan

  variables {
    public_network_access_enabled = false
    private_endpoint_subnet_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworks/vnet/subnets/pe"
  }

  assert {
    condition     = length(azurerm_private_endpoint.this) == 3
    error_message = "Expected private endpoints for AML, OpenAI and Search."
  }
}

run "rejects_bad_storage_name" {
  command = plan

  variables {
    storage_account_name = "Invalid_Name"
  }

  expect_failures = [var.storage_account_name]
}
