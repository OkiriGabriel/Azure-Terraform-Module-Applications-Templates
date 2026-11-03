# Azure Full Infrastructure - Terraform

![Release](https://img.shields.io/github/v/tag/OkiriGabriel/terraform-azure-platform?label=release&sort=semver)
![Terraform](https://img.shields.io/badge/Terraform-1.10.0-623CE4?logo=terraform)
![Azure](https://img.shields.io/badge/Azure-Cloud-0078D4?logo=microsoft-azure)
![License](https://img.shields.io/badge/License-Proprietary-red)
![Status](https://img.shields.io/badge/Status-Active-success)
![AI/ML](https://img.shields.io/badge/AI%2FML-Azure%20ML%20%7C%20OpenAI%20%7C%20AI%20Search-8A2BE2)
![CI](https://img.shields.io/badge/CI-fmt%20%7C%20validate%20%7C%20test%20%7C%20tfsec%20%7C%20checkov-blue)

This repository contains enterprise-grade Terraform configuration for Azure infrastructure. It provides:

- a hub-and-spoke network topology with advanced security
- container orchestration (AKS and Container Apps)
- an **AI/ML platform**: Azure Machine Learning, Azure OpenAI and Azure AI Search
- on-premises to cloud migration capabilities

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Features](#features)
- [AI / ML Platform](#-ai--ml-platform)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#-project-structure)
- [Module Documentation](#module-documentation)
- [Standards & Conventions](#-standards--conventions)
- [CI/CD Pipeline](#cicd-pipeline)
- [Contributing](#contributing)
- [Security](#security)
- [Maintenance](#maintenance)
- [Support](#support)

## 🏗️ Architecture Overview

### Network Topology
- **Hub-Spoke Architecture**: Central hub VNet with multiple spoke VNets for workload isolation
- **Azure Virtual WAN**: Global transit network architecture (Azure's transit gateway)
- **VNet Peering**: Regional and global peering for multi-region connectivity
- **Advanced Routing**: Custom route tables, UDRs, Route Servers, and BGP support

### Core Infrastructure
- **Azure Kubernetes Service (AKS)**: Production-ready container orchestration
- **Security Infrastructure**: Azure Firewall, NSGs, DDoS protection, Security Center
- **Networking**: Hub-spoke topology, VNet peering, Virtual WAN
- **Container Apps**: Serverless container hosting
- **Redis Cache**: Distributed caching
- **Azure Container Registry**: Private container image registry
- **Key Vault**: Secret and certificate management
- **Storage**: Blob storage with CDN integration
- **Notification Hub**: Push notifications
- **Monitoring**: Log Analytics, Application Insights

### AI / ML Infrastructure
- **Azure Machine Learning**: Workspace, model registry, pipelines and managed endpoints
- **Compute Clusters**: CPU/GPU training clusters (e.g. NVIDIA T4) that scale to zero when idle
- **Azure OpenAI**: GPT-4o / GPT-4o-mini and embedding model deployments
- **Azure AI Search**: Vector and hybrid search for Retrieval-Augmented Generation (RAG)
- **Key-less Security**: Managed identities and Entra ID role assignments between services, no API keys

### Migration Capabilities
- **Azure Migrate**: On-premises discovery and assessment
- **Database Migration Service**: SQL, PostgreSQL, MySQL migrations
- **Azure Site Recovery**: VM disaster recovery and migration
- **Automation**: Pre/post migration runbooks

## ✨ Features

### Networking
-  Hub-and-spoke network topology
-  Azure Virtual WAN for global transit
-  Regional and global VNet peering
-  Azure Firewall with threat intelligence
-  Network Security Groups with custom rules
-  Route Server for dynamic BGP routing
-  Traffic Manager for global load balancing
-  Azure Front Door for HTTP(S) routing

### Security
-  Azure Firewall with application and network rules
-  DDoS Protection Standard (optional)
-  Azure Security Center (Defender for Cloud)
-  Azure Bastion for secure VM access
-  Private endpoints for PaaS services
-  Key Vault integration
-  Managed identities
-  Automated security scanning (TFSec, Checkov)

### Container & Compute
-  Azure Kubernetes Service (AKS)
-  Container Apps for serverless workloads
-  Auto-scaling node pools
-  Azure CNI networking
-  Azure AD RBAC integration
-  Container Insights monitoring

### AI / ML
-  Azure Machine Learning workspace with dedicated Key Vault, storage and App Insights
-  GPU and CPU compute clusters with scale-to-zero and low-priority VMs
-  Azure OpenAI model deployments (Standard / GlobalStandard SKUs)
-  Azure AI Search for vector search / RAG
-  Entra ID-only auth (local/API-key auth disabled by default)
-  Optional private endpoints and private DNS integration
-  Diagnostic logs to Log Analytics
-  Per-environment feature flag (`ai_ml_config.enabled`)
-  Unit tests with mocked providers (`terraform test`)

### Migration & DR
-  Azure Migrate for assessment
-  Database Migration Service
-  Azure Site Recovery
-  Backup and recovery policies
-  Replication health monitoring

### Automation & Monitoring
-  GitHub Actions CI/CD pipeline
-  Automated Terraform validation
-  Security scanning on every PR
-  Log Analytics workspace
-  Diagnostic settings
-  Pre-migration assessment runbooks

## 🤖 AI / ML Platform

The [`ai-ml`](./modules/ai-ml/README.md) module adds an AI platform on top of the existing hub-and-spoke foundation.
It reuses the shared Log Analytics workspace and Container Registry.

```text
                 ┌────────────────────────┐   managed identity   ┌──────────────────────┐
  az ml / SDK ──▶│  Azure ML Workspace    │─────────────────────▶│     Azure OpenAI     │
                 │  + compute clusters    │                      │ gpt-4o / embeddings  │
                 └──┬──────┬──────┬───────┘                      └──────────▲───────────┘
                    │      │      │                                         │ MI
                    ▼      ▼      ▼                              ┌──────────┴───────────┐
               Storage  Key Vault  App Insights ──▶ Log Analytics│   Azure AI Search    │
                                                                 │  (vector index, RAG) │
               ACR (shared, environment images)                  └──────────────────────┘
```

### Enable it

The platform is **disabled by default** so it adds no cost until you opt in. Turn it on per environment:

```hcl
# vars_enviro_dev.tf
ai_ml_config = {
  enabled         = true
  openai_location = "eastus2"   # region with your model quota
  compute_clusters = {
    cpu-dev = { vm_size = "Standard_DS3_v2", max_nodes = 2 }
  }
  openai_deployments = {
    gpt-4o-mini = { model_name = "gpt-4o-mini", model_version = "2024-07-18", sku_name = "GlobalStandard" }
  }
  # ...see vars_enviro_dev.tf for every option
}
```

```bash
./automation/register_providers.sh     # registers MachineLearningServices, CognitiveServices, Search
terraform plan -out=tfplan && terraform apply tfplan
terraform output ai_ml_openai_endpoint
```

| | Dev default | Prod default |
|---|---|---|
| Network | Public | Private (set `private_endpoint_subnet_id`) |
| Compute | `cpu-dev` (low priority) | `cpu-train` + `gpu-t4` (dedicated) |
| Models | gpt-4o-mini, text-embedding-3-small | gpt-4o, text-embedding-3-large |
| AI Search | basic, 1 replica | standard, 3 replicas |
| Storage | LRS | ZRS |

📘 **Full guide:** [docs/AI_ML_SETUP.md](./docs/AI_ML_SETUP.md). It covers:

- prerequisites and quota
- data-plane RBAC
- calling OpenAI with Entra ID
- submitting training jobs
- RAG setup
- production hardening, costs and troubleshooting

## 📦 Prerequisites

### Required Tools
- **Terraform** >= 1.10.0 ([Download](https://www.terraform.io/downloads))
- **Azure CLI** >= 2.50.0 ([Install](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
- **Git** >= 2.30
- **Azure Subscription** with appropriate permissions

### Optional Tools
- **TFLint** - Terraform linter ([Install](https://github.com/terraform-linters/tflint))
- **TFSec** - Security scanner ([Install](https://github.com/aquasecurity/tfsec))
- **Checkov** - Policy-as-code scanner ([Install](https://www.checkov.io/))
- **Pre-commit** - Git hooks ([Install](https://pre-commit.com/))

### Azure Permissions
Ensure you have:
- Contributor role on the subscription
- User Access Administrator (for RBAC assignments)
- Or Owner role (recommended)

## 🚀 Quick Start

### 1. Clone the Repository
```bash
# Latest stable release (recommended)
git clone --branch v2.1.0 https://github.com/OkiriGabriel/terraform-azure-platform.git
cd terraform-azure-platform

# Or the latest development code
git clone https://github.com/OkiriGabriel/terraform-azure-platform.git
```

#### Using a module from another project

Pin a module to a release tag with `?ref=` so upstream changes never reach you unannounced:

```hcl
module "ai_ml" {
  source = "git::https://github.com/OkiriGabriel/terraform-azure-platform.git//modules/ai-ml?ref=v2.1.0"
  # ...inputs, see modules/ai-ml/README.md
}
```

### 2. Configure Azure Authentication
```bash
# Login to Azure
az login

# Set subscription
az account set --subscription "your-subscription-id"

# Verify
az account show
```

### 3. Configure Terraform Cloud (Optional)
If using Terraform Cloud:
```bash
# Login to Terraform Cloud
terraform login

# The configuration is already set in provider.tf
```

### 4. Register Resource Providers
```bash
./automation/register_providers.sh
```

### 5. Initialize Terraform
```bash
terraform init
```

### 6. Select or Create Workspace
```bash
# List available workspaces
terraform workspace list

# Select existing workspace
terraform workspace select example-infrastructure-dev

# Or create new workspace
terraform workspace new example-infrastructure-dev
```

### 7. Review Configuration
Edit environment-specific configuration:
- For dev: `vars_enviro_dev.tf`
- For prod: `var_enviro_prod.tf`

See `vars_module_examples.tf` for configuration examples. To enable the AI/ML platform, set
`ai_ml_config.enabled = true` (see [AI / ML Platform](#-ai--ml-platform)).

### 8. Plan Infrastructure
```bash
terraform plan -out=tfplan
```

### 9. Apply Changes
```bash
terraform apply tfplan
```

### 10. Verify Deployment
```bash
# Check resources in Azure Portal or CLI
az resource list --resource-group example-dev-resource-group --output table
```

## 🗂️ Project Structure

```text
.
├── provider.tf               # Terraform + provider versions, backend
├── locals.tf                 # Workspace → environment selection
├── vars_enviro_dev.tf        # Dev environment configuration (local.dev)
├── var_enviro_prod.tf        # Prod environment configuration (local.prod)
├── ai_ml.tf                  # AI/ML platform wiring
├── acr.tf, keyvault.tf, ...  # One root file per capability
├── modules/
│   └── <module>/
│       ├── main.tf           # Resources
│       ├── variables.tf      # Inputs (with descriptions & validation)
│       ├── outputs.tf        # Outputs
│       ├── versions.tf       # Terraform + provider constraints
│       ├── README.md         # Module documentation
│       └── tests/            # Optional `terraform test` suites
├── docs/
│   └── AI_ML_SETUP.md        # AI/ML setup guide
├── automation/               # Helper scripts (provider registration, imports)
└── .github/workflows/        # CI pipelines
```

## 📚 Module Documentation

### Core Modules

| Module | Description | Documentation |
|--------|-------------|---------------|
| **aks** | Azure Kubernetes Service | [README](./modules/aks/README.md) |
| **security** | Security infrastructure | [README](./modules/security/README.md) |
| **vnet-peering** | VNet peering management | [README](./modules/vnet-peering/README.md) |
| **virtual-wan** | Azure Virtual WAN | [README](./modules/virtual-wan/README.md) |
| **routing** | Advanced routing | [README](./modules/routing/README.md) |
| **azure-migrate** | Migration assessment | [README](./modules/azure-migrate/README.md) |
| **database-migration** | Database migration | [README](./modules/database-migration/README.md) |
| **site-recovery** | VM DR and migration | [README](./modules/site-recovery/README.md) |
| **hub** | Hub network | [README](./modules/hub/README.md) |
| **spoke** | Spoke network | [README](./modules/spoke/README.md) |
| **container-apps** | Container Apps | [README](./modules/container-apps/README.md) |
| **acr** | Container Registry | [README](./modules/acr/README.md) |
| **keyvault** | Key Vault | [README](./modules/keyvault/README.md) |
| **redis** | Redis Cache | [README](./modules/redis/README.md) |
| **ai-ml** 🆕 | Azure ML, OpenAI, AI Search | [README](./modules/ai-ml/README.md) |
| **blob-storage** | Blob storage + CDN | [README](./modules/blob-storage/README.md) |
| **monitoring** | Prometheus, Grafana, Loki | [README](./modules/monitoring/README.md) |
| **notification-hub** | Push notifications | [README](./modules/notification-hub/README.md) |
| **resource_group** | Resource group | [README](./modules/resource_group/README.md) |

For detailed module documentation, see [MODULES_README.md](./MODULES_README.md)

## 📐 Standards & Conventions

Every module follows the same layout and rules, and CI enforces them:

| Standard | Rule |
|----------|------|
| **File layout** | `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md`. No outputs inside `main.tf` |
| **Version pinning** | Each module declares `required_version >= 1.10.0` and `azurerm ~> 4.18` in `versions.tf`, so it validates on its own |
| **Formatting** | `terraform fmt -recursive` (CI fails on unformatted code) |
| **Naming** | `<prefix>-<env>-<service>` (e.g. `example-dev-mlw`). Storage and ACR names are alphanumeric only (`exampledevmlsa`) |
| **Inputs** | Every variable has a `description` and `type`. Constrained values get a `validation` block |
| **Outputs** | Every output has a `description`. Secrets are marked `sensitive = true` |
| **Tagging** | All resources take `tags`: `Environment`, `Project`, `Owner`, `CostCenter`, `BusinessUnit`, `ManagedBy`, plus a `Workload` tag where useful |
| **Feature flags** | Optional or costly capabilities are switched with `<feature>_config.enabled` and default to off |
| **Security** | Managed identities over keys, TLS 1.2+, diagnostic settings to Log Analytics, private endpoints in prod |
| **Testing** | New modules ship `tests/*.tftest.hcl` with mocked providers |
| **Documentation** | Every module has a README (CI fails without one) |

## 🔄 CI/CD Pipeline

### Automated Checks

Every pull request automatically runs:

1. **Terraform Validation**
   - Format checking (`terraform fmt`). **Fails the build** if code is unformatted
   - Initialization (`terraform init`)
   - Validation (`terraform validate`) for the dev and prod workspaces

2. **Security Scanning**
   - **TFSec**: Terraform security scanner
   - **Checkov**: Policy-as-code validation
   - **TruffleHog**: Secret detection
   - **Sensitive file checks**

3. **Quality Checks**
   - **TFLint**: Terraform linting
   - **Module testing**: Every module is discovered automatically. For each one, CI runs
     `fmt`, `init`, `validate` and `terraform test` (mocked providers, no Azure credentials needed)
   - **Documentation checks**: The root docs and a README in every module are required

4. **PR Checks**
   - PR title format validation
   - PR size recommendations
   - Breaking changes detection
   - Label requirements

### GitHub Actions Workflows

- `.github/workflows/terraform-validate.yml` - Main validation pipeline
- `.github/workflows/pr-checks.yml` - PR-specific checks

### Running the checks locally

```bash
terraform fmt -recursive
terraform init -backend=false && terraform validate
for m in modules/*/; do (cd "$m" && terraform init -backend=false -input=false >/dev/null && terraform validate); done
(cd modules/ai-ml && terraform test)
tflint --recursive
tfsec . --config-file .tfsec.yml
```

### PR title format

PR titles must follow [Conventional Commits](https://www.conventionalcommits.org/). Otherwise the
*PR Title Check* fails with `No release type found in pull request title`. Examples:

```text
feat: add AI/ML platform module
fix(spoke): correct NSG association
docs: update AI/ML setup guide
ci: run terraform test for all modules
```

### Required Secrets

Add these secrets to your GitHub repository:

| Secret | Description |
|--------|-------------|
| `TF_API_TOKEN` | Terraform Cloud API token (if using TF Cloud) |
| `GITHUB_TOKEN` | Automatically provided by GitHub |

### Status Badges

The CI/CD pipeline provides real-time status for:
- Terraform validation status
- Security scan results
- Test coverage
- Documentation completeness

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](./CONTRIBUTING.md) for details.

### Quick Contribution Steps

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests locally:
   ```bash
   terraform fmt -recursive
   terraform validate
   tfsec .
   tflint --recursive
   ```
5. Commit your changes (follow [conventional commits](https://www.conventionalcommits.org/))
6. Push to your fork
7. Open a Pull Request

### Commit Message Format
```
<type>(<scope>): <subject>

Examples:
feat(aks): add support for multiple node pools
fix(security): correct firewall rule priority
docs(readme): update installation instructions
```

### Code Review Process
1. Automated checks must pass
2. At least one maintainer approval required
3. No unresolved conversations
4. Up-to-date with main branch

## 🔒 Security

### Reporting Security Issues

**DO NOT** create public issues for security vulnerabilities.

Email: security@yourcompany.com

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (optional)

### Security Features

- 🔐 No secrets in code (verified by TruffleHog)
- 🛡️ TFSec security scanning on every PR
-  Checkov policy validation
- 🔍 Automated sensitive file detection
- 📊 Security Center (Defender for Cloud) integration
- 🔑 Key Vault for secret management
- 🌐 Private endpoints for PaaS services
- 🚪 Azure Bastion for secure VM access

### Best Practices

1. Never commit `.tfvars` files with secrets
2. Use Key Vault for all secrets
3. Enable Azure AD authentication where possible
4. Implement least-privilege access
5. Enable diagnostic logs
6. Use private endpoints
7. Review security scan results

## 🔧 Maintenance

### Regular Tasks

1. **Update Dependencies**
   ```bash
   # Update provider versions in provider.tf
   # Test in dev environment first
   terraform init -upgrade
   ```

2. **Review Security Scans**
   ```bash
   tfsec . --config-file .tfsec.yml
   checkov -d . --framework terraform
   ```

3. **Update Documentation**
   - Keep README files current
   - Update examples
   - Document breaking changes

### Troubleshooting

Common issues and solutions:

1. **Terraform Init Fails**
   - Check Terraform Cloud authentication
   - Verify workspace exists
   - Check internet connectivity

2. **Validation Errors**
   - Run `terraform fmt -recursive`
   - Check variable definitions
   - Verify provider versions

3. **Security Scan Failures**
   - Review TFSec output
   - Fix issues or add exceptions in `.tfsec.yml`
   - Document reasons for exceptions

4. **Module Not Found**
   - Ensure module path is correct
   - Run `terraform init`
   - Check module source

## 📊 Environment Configuration

### Development Environment
File: `vars_enviro_dev.tf`
- Lower-cost SKUs
- Single-instance deployments
- Basic monitoring
- Non-production workloads

### Production Environment
File: `var_enviro_prod.tf`
- Production-grade SKUs
- High availability
- Advanced monitoring
- Multi-region support

### Configuration Examples
See `vars_module_examples.tf` for detailed configuration examples.

## 📈 Monitoring and Observability

- **Log Analytics**: Centralized logging
- **Application Insights**: Application monitoring
- **Diagnostic Settings**: Enabled for all resources
- **Container Insights**: AKS monitoring
- **Azure Monitor**: Metrics and alerts

## 💰 Cost Management

All resources are tagged for cost tracking:
- `Environment`: dev/prod
- `Project`: example
- `Owner`: Team name
- `CostCenter`: Cost center code
- `BusinessUnit`: Business unit
- `ManagedBy`: Terraform
- `Workload`: e.g. `ai-ml` (lets you filter AI spend in Cost Management)

> AI/ML cost drivers are GPU node-minutes, OpenAI tokens and the always-on AI Search SKU. Clusters
> scale to zero by default. See the [cost overview](./docs/AI_ML_SETUP.md#6-cost-overview-approximate).

Review costs in Azure Cost Management + Billing.

## 📖 Additional Documentation

- [AI / ML Setup Guide](./docs/AI_ML_SETUP.md) - Enable and use Azure ML, OpenAI and AI Search
- [AI / ML Module](./modules/ai-ml/README.md) - Module inputs, outputs and role assignments
- [Modules Documentation](./MODULES_README.md) - Detailed module documentation
- [Implementation Summary](./IMPLEMENTATION_SUMMARY.md) - Implementation details
- [Contributing Guide](./CONTRIBUTING.md) - How to contribute
- [Configuration Examples](./vars_module_examples.tf) - Example configurations

## 🆘 Support

### Getting Help

- **Issues**: [GitHub Issues](https://github.com/OkiriGabriel/terraform-azure-platform/issues)
- **Discussions**: [GitHub Discussions](https://github.com/OkiriGabriel/terraform-azure-platform/discussions)
- **Email**: thedavidoyebanji@gmail.com

### Resources

- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Machine Learning](https://learn.microsoft.com/azure/machine-learning/)
- [Azure OpenAI](https://learn.microsoft.com/azure/ai-services/openai/)
- [Azure AI Search](https://learn.microsoft.com/azure/search/)

## 📜 License

This project is proprietary and confidential.

## 👥 Team

Maintained by the DevOps Team

## 🙏 Acknowledgments

- Microsoft Azure team for excellent documentation
- HashiCorp for Terraform
- Open source security tools (TFSec, Checkov, TruffleHog)
- All contributors to this project

---

**Last Updated**: November 2026  
**Version**: [v2.1.0](https://github.com/OkiriGabriel/terraform-azure-platform/releases/tag/v2.1.0)  
**Status**: Production Ready