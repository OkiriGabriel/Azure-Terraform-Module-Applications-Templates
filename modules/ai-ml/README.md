# AI / ML Module

Deploys an AI/ML platform on Azure:

- **Azure Machine Learning workspace**: experiments, model registry, pipelines and managed endpoints.
- **Compute clusters**: CPU or GPU training clusters that scale to zero when idle.
- **Azure OpenAI**: GPT and embedding model deployments, Microsoft Entra ID authentication only by default.
- **Azure AI Search**: vector and hybrid search for Retrieval-Augmented Generation (RAG).
- **Supporting resources**:
  - a dedicated Key Vault (RBAC authorization, purge protection)
  - storage (TLS 1.2, no public blobs, soft delete)
  - workspace-based Application Insights
- **Security**:
  - managed identities with key-less role assignments between the services
  - diagnostic settings to Log Analytics
  - optional private endpoints

```text
                 ┌──────────────────────── Resource Group ────────────────────────┐
                 │                                                                 │
  Data scientist │   ┌──────────────────────┐        ┌──────────────────────┐      │
  ── az ml / SDK ─┼──▶│  Azure ML Workspace  │──MI──▶│     Azure OpenAI     │      │
                 │   │  (SystemAssigned MI) │        │ gpt-4o / embeddings  │      │
                 │   └──┬─────┬─────┬───────┘        └──────────▲───────────┘      │
                 │      │     │     │                           │ MI               │
                 │      ▼     ▼     ▼                ┌──────────┴───────────┐      │
                 │  Storage  Key   App Insights      │   Azure AI Search    │      │
                 │           Vault  ──▶ Log Analytics│ (vector index, RAG)  │      │
                 │      │                            └──────────────────────┘      │
                 │      ▼                                                          │
                 │  Compute clusters (CPU / GPU, scale-to-zero)                    │
                 │                                                                 │
                 │  Optional: private endpoints for AML, OpenAI and Search         │
                 └─────────────────────────────────────────────────────────────────┘
```

## Usage

```hcl
module "ai_ml" {
  source = "./modules/ai-ml"

  name_prefix                = "example-dev"
  resource_group_name        = module.resource_group.name
  location                   = "centralus"
  tenant_id                  = local.tenant_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  storage_account_name  = "exampledevmlsa"
  key_vault_name        = "example-dev-mlkv"
  container_registry_id = module.acr.acr_id["main"]

  compute_clusters = {
    gpu-t4 = { vm_size = "Standard_NC4as_T4_v3", max_nodes = 2 }
  }

  openai_location = "eastus2"
  openai_deployments = {
    gpt-4o-mini            = { model_name = "gpt-4o-mini", model_version = "2024-07-18", sku_name = "GlobalStandard" }
    text-embedding-3-small = { model_name = "text-embedding-3-small", model_version = "1" }
  }

  tags = local.tags
}
```

In this repository the module is wired up in [`ai_ml.tf`](../../ai_ml.tf) and configured per environment through
`ai_ml_config` in `vars_enviro_dev.tf` / `var_enviro_prod.tf`. See the
[AI/ML setup guide](../../docs/AI_ML_SETUP.md) for step-by-step instructions.

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `name_prefix` | Prefix for all resource names | `string` | n/a |
| `resource_group_name` | Target resource group | `string` | n/a |
| `location` | Region for the workspace and its dependencies | `string` | n/a |
| `tenant_id` | Entra tenant ID for the Key Vault | `string` | n/a |
| `log_analytics_workspace_id` | Log Analytics workspace for App Insights and diagnostics | `string` | n/a |
| `storage_account_name` | Globally unique storage name (3-24 lowercase alphanumerics) | `string` | n/a |
| `key_vault_name` | Globally unique Key Vault name (3-24 chars) | `string` | n/a |
| `tags` | Tags applied to every resource | `map(string)` | `{}` |
| `public_network_access_enabled` | Allow public access to endpoints | `bool` | `true` |
| `storage_replication_type` | LRS, ZRS, GRS, RAGRS, GZRS, RAGZRS | `string` | `"LRS"` |
| `container_registry_id` | Existing ACR for environment images | `string` | `null` |
| `high_business_impact` | Reduce diagnostic data collected by Microsoft | `bool` | `false` |
| `compute_clusters` | Map of clusters: `vm_size`, `vm_priority`, `min_nodes`, `max_nodes`, `idle_before_scale_in`, `subnet_id` | `map(object)` | `{}` |
| `openai_enabled` | Deploy Azure OpenAI | `bool` | `true` |
| `openai_location` | Region for Azure OpenAI (defaults to `location`) | `string` | `null` |
| `openai_local_auth_enabled` | Allow API keys (keep `false` for Entra ID only) | `bool` | `false` |
| `openai_deployments` | Map of deployments: `model_name`, `model_version`, `sku_name`, `capacity` | `map(object)` | `{}` |
| `search_enabled` | Deploy Azure AI Search | `bool` | `true` |
| `search_sku` | free, basic, standard, standard2, standard3, storage_optimized_l1/l2 | `string` | `"basic"` |
| `search_replica_count` | Search replicas (≥2 for read SLA, ≥3 for read/write SLA) | `number` | `1` |
| `search_partition_count` | Search partitions | `number` | `1` |
| `private_endpoint_subnet_id` | Subnet for private endpoints; `null` creates none | `string` | `null` |
| `private_dns_zone_ids` | DNS zone IDs keyed by `openai`, `search`, `aml` | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `workspace_id` / `workspace_name` | Azure ML workspace |
| `workspace_principal_id` | Workspace managed identity principal ID |
| `compute_cluster_ids` | Map of cluster name → ID |
| `openai_endpoint` / `openai_account_id` | Azure OpenAI account (null when disabled) |
| `openai_deployment_names` | Deployed model names |
| `search_endpoint` | Azure AI Search endpoint (null when disabled) |
| `application_insights_connection_string` | App Insights connection string (sensitive) |
| `key_vault_id` / `storage_account_id` | Workspace dependencies |

## Role assignments created

| Principal | Role | Scope | Purpose |
|-----------|------|-------|---------|
| ML workspace identity | Cognitive Services OpenAI User | OpenAI | Call models from pipelines and prompt flow |
| AI Search identity | Cognitive Services OpenAI User | OpenAI | Integrated vectorization (embedding during indexing) |
| OpenAI identity | Search Index Data Reader | AI Search | "On your data" / RAG retrieval |

## Testing

```bash
cd modules/ai-ml
terraform init -backend=false
terraform test
```

The tests in `tests/ai_ml.tftest.hcl` use a mocked `azurerm` provider, so they need no Azure credentials and
run in CI on every pull request. They cover:

- the default deployment
- disabling optional services
- GPU clusters and model deployments
- private endpoints
- input validation
