# Azure Full Infrastructure - Terraform

![Terraform](https://img.shields.io/badge/Terraform-1.10.0-623CE4?logo=terraform)
![Azure](https://img.shields.io/badge/Azure-Cloud-0078D4?logo=microsoft-azure)
![License](https://img.shields.io/badge/License-Proprietary-red)
![Status](https://img.shields.io/badge/Status-Active-success)

This repository contains enterprise-grade Terraform configuration for Azure infrastructure, implementing a comprehensive hub-and-spoke network topology with advanced security, container orchestration (AKS), and on-premises to cloud migration capabilities.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Module Documentation](#module-documentation)
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

## c Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/your-org/Azure-full-infrastructure.git
cd Azure-full-infrastructure
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

### 4. Initialize Terraform
```bash
terraform init
```

### 5. Select or Create Workspace
```bash
# List available workspaces
terraform workspace list

# Select existing workspace
terraform workspace select example-infrastructure-dev

# Or create new workspace
terraform workspace new example-infrastructure-dev
```

### 6. Review Configuration
Edit environment-specific configuration:
- For dev: `vars_enviro_dev.tf`
- For prod: `var_enviro_prod.tf`

See `vars_module_examples.tf` for configuration examples.

### 7. Plan Infrastructure
```bash
terraform plan -out=tfplan
```

### 8. Apply Changes
```bash
terraform apply tfplan
```

### 9. Verify Deployment
```bash
# Check resources in Azure Portal or CLI
az resource list --resource-group example-dev-resource-group --output table
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

For detailed module documentation, see [MODULES_README.md](./MODULES_README.md)

## 🔄 CI/CD Pipeline

### Automated Checks

Every pull request automatically runs:

1. **Terraform Validation**
   - Format checking (`terraform fmt`)
   - Initialization (`terraform init`)
   - Validation (`terraform validate`)

2. **Security Scanning**
   - **TFSec**: Terraform security scanner
   - **Checkov**: Policy-as-code validation
   - **TruffleHog**: Secret detection
   - **Sensitive file checks**

3. **Quality Checks**
   - **TFLint**: Terraform linting
   - **Module testing**: Individual module validation
   - **Documentation checks**: Ensure README files exist

4. **PR Checks**
   - PR title format validation
   - PR size recommendations
   - Breaking changes detection
   - Label requirements

### GitHub Actions Workflows

- `.github/workflows/terraform-validate.yml` - Main validation pipeline
- `.github/workflows/pr-checks.yml` - PR-specific checks

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

Review costs in Azure Cost Management + Billing.

## 📖 Additional Documentation

- [Modules Documentation](./MODULES_README.md) - Detailed module documentation
- [Implementation Summary](./IMPLEMENTATION_SUMMARY.md) - Implementation details
- [Contributing Guide](./CONTRIBUTING.md) - How to contribute
- [Configuration Examples](./vars_module_examples.tf) - Example configurations

## 🆘 Support

### Getting Help

- **Issues**: [GitHub Issues](https://github.com/your-org/Azure-full-infrastructure/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-org/Azure-full-infrastructure/discussions)
- **Email**: thedavidoyebanji@gmail.com

### Resources

- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

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

**Last Updated**: June 2026  
**Version**: 2.0.0  
**Status**: Production Ready