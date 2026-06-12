# Quick Start Guide

## ✅ Your Infrastructure is Ready!

Terraform has been successfully initialized and validated. Here's what you can do now:

##  Immediate Next Steps

### 1. Deploy Core Infrastructure

Your existing modules are ready to deploy:

```bash
# Plan deployment
terraform plan

# Apply changes
terraform apply
```

Current modules enabled:
- ✅ Resource Group
- ✅ Hub Network
- ✅ Spoke Networks
- ✅ Container Apps
- ✅ Azure Container Registry (ACR)
- ✅ Key Vault
- ✅ Redis Cache
- ✅ Blob Storage

## 📦 Optional Modules (Available but Disabled)

The following advanced modules are available but **currently disabled**. Enable them when you need them:

### Available Modules:
1. **AKS (Azure Kubernetes Service)** - `aks.tf.disabled`
2. **Security Infrastructure** - `security.tf.disabled`
3. **VNet Peering** - `vnet-peering.tf.disabled`
4. **Virtual WAN** - `virtual-wan.tf.disabled`
5. **Advanced Routing** - `routing.tf.disabled`
6. **Migration Tools** - `migration.tf.disabled`

## 🔧 How to Enable Optional Modules

### Step 1: Choose Module to Enable

For example, let's enable **AKS**:

### Step 2: Add Configuration

Copy the configuration from `vars_module_examples.tf` to your environment file:

```bash
# For dev environment
code vars_enviro_dev.tf

# Add the aks_config section from vars_module_examples.tf
```

### Step 3: Enable the Module

```bash
# Rename to enable
mv aks.tf.disabled aks.tf

# Reinitialize
terraform init

# Validate
terraform validate

# Plan
terraform plan
```

### Example: Enable AKS

1. **Add to `vars_enviro_dev.tf`**:

```hcl
# Add to local.dev block
aks_config = {
  kubernetes_version = "1.28"
  
  default_node_pool = {
    name                = "default"
    node_count          = 2
    vm_size             = "Standard_D2s_v3"
    os_disk_size_gb     = 100
    subnet_name         = "WorkloadSubnet"
    max_pods            = 30
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 5
    availability_zones  = ["1", "2"]
    max_surge           = "33%"
  }

  additional_node_pools = {}

  network_profile = {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
    service_cidr      = "10.100.0.0/16"
    dns_service_ip    = "10.100.0.10"
    outbound_type     = "loadBalancer"
  }

  enable_azure_ad_rbac             = false
  azure_ad_admin_group_object_ids  = []
  enable_monitoring                = true
  log_analytics_workspace_id       = null
  enable_azure_policy              = false
  enable_key_vault_secrets_provider = true
  enable_cluster_autoscaler        = true
  acr_id                           = null
}
```

2. **Enable the module**:

```bash
mv aks.tf.disabled aks.tf
terraform init
terraform validate
terraform plan
```

## 📝 Configuration Examples

See `vars_module_examples.tf` for complete configuration examples for all modules.

## 🔍 Current Status

### Backend Configuration
- ✅ Using **local backend** (state stored locally)
- 📂 State file: `terraform.tfstate`
- 🔄 For production, consider:
  - Azure Storage backend (team collaboration)
  - Terraform Cloud (policy enforcement)
  - See: `backend-examples.tf.example`

### Terraform Cloud (Optional)
If you want to use Terraform Cloud:

1. Create organization at https://app.terraform.io
2. Update `provider.tf`:
   ```hcl
   cloud {
     organization = "your-org-name"
     workspaces {
       tags = ["example-infrastructure-dev"]
     }
   }
   ```
3. Login: `terraform login`
4. Reinitialize: `terraform init -migrate-state`

## 🏗️ Module Enablement Order (Recommended)

If you plan to enable all modules, do it in this order:

1. **Security** (foundational security)
   - Provides firewall, NSGs, Security Center
   
2. **Routing** (network routing)
   - Sets up route tables and UDRs
   
3. **VNet Peering** (network connectivity)
   - Connects networks
   
4. **AKS** (container orchestration)
   - Requires security and networking
   
5. **Virtual WAN** (global transit - optional)
   - For multi-region deployments
   
6. **Migration** (only when migrating)
   - Azure Migrate, DMS, Site Recovery

## ⚠️ Important Notes

### Cost Awareness
- **Current setup**: Minimal cost (basic tier resources)
- **Enabling AKS**: ~$200-400/month depending on node pools
- **Enabling Firewall**: ~$900/month + data charges
- **Enabling Virtual WAN**: ~$180/month per hub

### Before Deploying to Production
1. Review all configurations in `vars_enviro_prod.tf`
2. Update subscription IDs and tenant IDs
3. Configure proper RBAC
4. Set up remote backend (Azure Storage or Terraform Cloud)
5. Enable state locking
6. Review security settings

## 🧪 Testing Your Setup

### Run Validation
```bash
terraform validate
```

### Check Formatting
```bash
terraform fmt -check -recursive
```

### Security Scan
```bash
# Install tfsec first: brew install tfsec
tfsec . --config-file .tfsec.yml
```

### Plan Without Apply
```bash
terraform plan -out=tfplan
```

## 📚 Documentation

- **Module Documentation**: `MODULES_README.md`
- **Implementation Details**: `IMPLEMENTATION_SUMMARY.md`
- **Contributing**: `CONTRIBUTING.md`
- **Security**: `SECURITY.md`
- **Configuration Examples**: `vars_module_examples.tf`
- **Backend Options**: `backend-examples.tf.example`

## 🆘 Common Issues

### Issue: Module Not Found
**Solution**: Run `terraform init`

### Issue: Invalid Configuration
**Solution**: Check that required variables are defined in `vars_enviro_dev.tf`

### Issue: State Locked
**Solution**: 
```bash
# For local backend, remove lock file
rm .terraform.tfstate.lock.info
```

### Issue: Provider Authentication
**Solution**:
```bash
# Login to Azure
az login
az account show
```

## 🎯 Next Actions

Choose one:

### Option A: Deploy Current Infrastructure
```bash
terraform plan
terraform apply
```

### Option B: Enable a New Module
1. Choose module from list above
2. Add configuration to `vars_enviro_dev.tf`
3. Enable: `mv <module>.tf.disabled <module>.tf`
4. Initialize: `terraform init`
5. Validate: `terraform validate`
6. Plan: `terraform plan`

### Option C: Review and Plan
```bash
# Review what would be deployed
terraform plan

# Export plan for review
terraform plan -out=tfplan
terraform show tfplan > plan-output.txt
```

## 📞 Get Help

- **Issues**: Check CONTRIBUTING.md
- **Security**: Check SECURITY.md
- **Documentation**: Check MODULES_README.md
- **Examples**: Check vars_module_examples.tf

---

**Status**: ✅ Ready for deployment
**Last Updated**: June 2026
**Terraform Version**: >= 1.10.0
