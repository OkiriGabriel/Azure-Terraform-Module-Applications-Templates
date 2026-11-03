# AI / ML Platform Setup Guide

This guide takes you from a fresh subscription to a working AI/ML platform:

- an Azure Machine Learning workspace
- GPU and CPU compute clusters
- Azure OpenAI model deployments
- Azure AI Search for RAG

The infrastructure lives in [`modules/ai-ml`](../modules/ai-ml/README.md) and is wired up in
[`ai_ml.tf`](../ai_ml.tf).

> **Disabled by default.** `ai_ml_config.enabled = false` in both environments, so a normal
> `terraform apply` creates nothing new and costs nothing extra. Enable it on purpose using the steps below.

---

## 1. Prerequisites

| Requirement | How to check / get it |
|-------------|-----------------------|
| Base infrastructure deployed (resource group, Log Analytics, ACR) | `terraform apply` from the [Quick Start](../README.md#-quick-start) |
| Azure CLI ≥ 2.50 with the ML extension | `az extension add -n ml` |
| Owner, or Contributor + User Access Administrator | Needed because the module creates role assignments |
| Azure OpenAI access on the subscription | Azure portal → *Azure OpenAI* → *Create*. If blocked, request access |
| Regional model quota | `az cognitiveservices usage list -l eastus2 -o table` |
| GPU quota (only if using GPU clusters) | Portal → *Quotas* → *Machine learning* → e.g. *Standard NCASv3_T4 Family* |

### Register resource providers

```bash
./automation/register_providers.sh      # includes MachineLearningServices, CognitiveServices, Search
# or individually:
az provider register --namespace Microsoft.MachineLearningServices
az provider register --namespace Microsoft.CognitiveServices
az provider register --namespace Microsoft.Search
```

---

## 2. Configure the environment

Edit `ai_ml_config` in `vars_enviro_dev.tf` (dev) or `var_enviro_prod.tf` (prod):

```hcl
ai_ml_config = {
  enabled                       = true           # ← turn the platform on
  public_network_access_enabled = true           # false in prod (use private endpoints)
  storage_replication_type      = "LRS"
  high_business_impact          = false

  compute_clusters = {
    cpu-dev = { vm_size = "Standard_DS3_v2", max_nodes = 2 }
    # gpu-t4 = { vm_size = "Standard_NC4as_T4_v3", max_nodes = 2 }   # needs GPU quota
  }

  openai_enabled  = true
  openai_location = "eastus2"                    # pick a region where your models are available
  openai_deployments = {
    gpt-4o-mini            = { model_name = "gpt-4o-mini", model_version = "2024-07-18", sku_name = "GlobalStandard", capacity = 10 }
    text-embedding-3-small = { model_name = "text-embedding-3-small", model_version = "1", capacity = 10 }
  }

  search_enabled         = true
  search_sku             = "basic"
  search_replica_count   = 1
  search_partition_count = 1
}
```

### Choosing values

| Setting | Dev | Prod |
|---------|-----|------|
| `public_network_access_enabled` | `true` | `false` + private endpoints |
| `storage_replication_type` | `LRS` | `ZRS` / `GZRS` |
| Cluster `vm_priority` | `LowPriority` (cheap, can be pre-empted) | `Dedicated` |
| Cluster `min_nodes` | `0` | `0` (raise only for latency-sensitive jobs) |
| `search_sku` / replicas | `basic` / 1 | `standard` / 3 (read/write SLA) |
| OpenAI `capacity` | 10 (thousands of tokens per minute) | Size to traffic; check quota |

**Model versions and regions change often.** Before applying, check the current list with
`az cognitiveservices model list -l <region> -o table`.

---

## 3. Deploy

```bash
terraform workspace select example-infrastructure-dev
terraform init
terraform plan -out=tfplan        # review: about 12-15 new resources for the default dev config
terraform apply tfplan
```

Read the outputs:

```bash
terraform output ai_ml_workspace_name
terraform output ai_ml_openai_endpoint
terraform output ai_ml_search_endpoint
```

---

## 4. Use the platform

### Give yourself data-plane access

The module only grants service-to-service roles. Grant your user or group access to the data plane:

```bash
ME=$(az ad signed-in-user show --query id -o tsv)
RG=example-dev-resource-group

az role assignment create --assignee $ME --role "AzureML Data Scientist" \
  --scope $(az ml workspace show -n example-dev-mlw -g $RG --query id -o tsv)

az role assignment create --assignee $ME --role "Cognitive Services OpenAI User" \
  --scope $(az cognitiveservices account show -n example-dev-oai -g $RG --query id -o tsv)

az role assignment create --assignee $ME --role "Search Index Data Contributor" \
  --scope $(az search service show -n example-dev-srch -g $RG --query id -o tsv)
```

### Call Azure OpenAI (Entra ID, no API keys)

```python
# pip install openai azure-identity
from azure.identity import DefaultAzureCredential, get_bearer_token_provider
from openai import AzureOpenAI

client = AzureOpenAI(
    azure_endpoint="https://example-dev-oai.openai.azure.com/",
    azure_ad_token_provider=get_bearer_token_provider(
        DefaultAzureCredential(), "https://cognitiveservices.azure.com/.default"
    ),
    api_version="2024-10-21",
)
resp = client.chat.completions.create(
    model="gpt-4o-mini",  # the deployment name
    messages=[{"role": "user", "content": "Hello from Azure!"}],
)
print(resp.choices[0].message.content)
```

### Submit a training job

```bash
az configure --defaults group=example-dev-resource-group workspace=example-dev-mlw

cat > job.yml <<'EOF'
$schema: https://azuremlschemas.azureedge.net/latest/commandJob.schema.json
command: python -c "import torch; print('CUDA available:', torch.cuda.is_available())"
environment: azureml://registries/azureml/environments/acpt-pytorch-2.2-cuda12.1/labels/latest
compute: azureml:cpu-dev
EOF

az ml job create -f job.yml --stream
```

The cluster scales up for the job and back to zero after `idle_before_scale_in` (15 minutes by default).

### RAG with AI Search

1. Upload documents to a blob container.
2. Azure portal → AI Search → **Import and vectorize data**.
3. Choose the blob source and the `text-embedding-3-small` deployment. Search calls OpenAI with its managed
   identity, using the role the module already assigned.
4. Query the index from your app, or use **Azure OpenAI On Your Data**. OpenAI reads the index using its
   *Search Index Data Reader* role.

---

## 5. Production hardening checklist

- [ ] `public_network_access_enabled = false`
- [ ] Set `private_endpoint_subnet_id` to a spoke subnet. For the endpoints to resolve, supply
  `private_dns_zone_ids` for these zones:
  - `privatelink.openai.azure.com`
  - `privatelink.search.windows.net`
  - `privatelink.api.azureml.ms`
- [ ] Put compute clusters in a VNet with `subnet_id` (this disables node public IPs automatically)
- [ ] `storage_replication_type = "ZRS"` or `"GZRS"`
- [ ] `search_replica_count >= 3` for the read/write SLA
- [ ] Keep `openai_local_auth_enabled = false`
- [ ] Add Azure Monitor alerts on OpenAI `Processed Prompt Tokens` and throttling (HTTP 429)
- [ ] Set budgets in Cost Management for the `Workload = ai-ml` tag

---

## 6. Cost overview (approximate)

| Resource | Idle cost | Notes |
|----------|-----------|-------|
| ML workspace | ~$0 | You pay for compute and storage, not the workspace |
| Compute clusters (`min_nodes = 0`) | $0 | Billed per node-minute while jobs run. GPUs are the main cost driver |
| Azure OpenAI (Standard / GlobalStandard) | $0 | Pay per token |
| AI Search `basic` | ~$75/month | Always on. `standard` is ~$250/month per replica |
| Storage, Key Vault, App Insights | Low | Depends on usage |

Check the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) for current prices.

---

## 7. Troubleshooting

| Symptom | Fix |
|---------|-----|
| `InsufficientQuota` on a deployment | Lower `capacity`, change `openai_location`, or request quota |
| `DeploymentModelNotSupported` | The model or version isn't available in that region or SKU. Check `az cognitiveservices model list` |
| `CustomDomainInUse` | The OpenAI subdomain `<name_prefix>-oai` is taken globally. Change `name_prefix` |
| `VaultAlreadyExists` / storage name taken | Key Vault and storage names are global. Change them in `ai_ml.tf` |
| Soft-deleted vault blocks recreate | `az keyvault purge -n <name>` (purge protection keeps it for 7 days) |
| Cluster never scales up | Check the VM family quota and the job's `compute:` name |
| 401/403 calling OpenAI | Assign *Cognitive Services OpenAI User*. API keys are disabled by design |

## 8. Disable / tear down

Set `ai_ml_config.enabled = false` and run `terraform apply`. Terraform removes the module's resources.
The Key Vault stays soft-deleted for 7 days.
