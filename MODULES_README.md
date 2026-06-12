# New Infrastructure Modules Documentation

This document provides an overview of the new infrastructure modules added to support AKS, security, networking, and on-premises to Azure migration.

## Table of Contents

1. [AKS Module](#aks-module)
2. [Security Module](#security-module)
3. [VNet Peering Module](#vnet-peering-module)
4. [Virtual WAN Module](#virtual-wan-module)
5. [Routing Module](#routing-module)
6. [Azure Migrate Module](#azure-migrate-module)
7. [Database Migration Module](#database-migration-module)
8. [Site Recovery Module](#site-recovery-module)

## AKS Module

### Overview
Deploys a production-ready Azure Kubernetes Service (AKS) cluster with comprehensive features including RBAC, monitoring, auto-scaling, and network integration.

### Location
`./modules/aks/`

### Key Features
- **Networking**: Azure CNI with custom VNet integration
- **RBAC**: Azure AD integration with admin groups
- **Monitoring**: Container Insights with Log Analytics
- **Autoscaling**: Cluster autoscaler and HPA support
- **Security**: Azure Policy, Key Vault Secrets Provider
- **Node Pools**: Support for multiple node pools with different VM sizes
- **High Availability**: Zone-redundant deployment

### Usage Example
```hcl
module "aks" {
  source = "./modules/aks"
  
  cluster_name        = "my-aks-cluster"
  location            = "centralus"
  resource_group_name = "my-rg"
  
  # See aks.tf for full configuration
}
```

### Outputs
- `cluster_id`: AKS cluster ID
- `kube_config`: Kubernetes configuration (sensitive)
- `kubelet_identity`: Managed identity for kubelet

## Security Module

### Overview
Comprehensive security infrastructure including Azure Firewall, NSGs, DDoS protection, Azure Security Center, Bastion, and private DNS zones.

### Location
`./modules/security/`

### Key Features
- **Azure Firewall**: Stateful firewall with threat intelligence
- **Network Security Groups**: Custom NSG rules for subnet protection
- **DDoS Protection**: DDoS Protection Standard plan
- **Azure Security Center**: Defender for Cloud with multiple plans
- **Bastion**: Secure RDP/SSH access
- **NAT Gateway**: Secure outbound connectivity
- **Private DNS**: Private DNS zones for private endpoints

### Usage Example
```hcl
module "security" {
  source = "./modules/security"
  
  prefix              = "example-dev"
  location            = "centralus"
  resource_group_name = "my-rg"
  
  enable_firewall = true
  enable_security_center = true
  
  # See security.tf for full configuration
}
```

### Outputs
- `firewall_id`: Azure Firewall ID
- `firewall_private_ip`: Firewall private IP for routing
- `network_security_groups`: Map of NSG IDs

## VNet Peering Module

### Overview
Manages VNet peering relationships for hub-spoke and multi-region connectivity with flow logs and connection monitoring.

### Location
`./modules/vnet-peering/`

### Key Features
- **Regional Peering**: Same-region VNet peering
- **Global Peering**: Cross-region VNet peering
- **Gateway Transit**: Support for gateway transit
- **Flow Logs**: NSG flow logs with traffic analytics
- **Connection Monitoring**: Health monitoring for peering

### Usage Example
```hcl
module "vnet_peering" {
  source = "./modules/vnet-peering"
  
  peering_configurations = {
    hub_to_spoke = {
      # Configuration
    }
  }
}
```

### Outputs
- `peering_ids`: Map of peering IDs
- `global_peering_ids`: Map of global peering IDs

## Virtual WAN Module

### Overview
Azure Virtual WAN implementation (equivalent to AWS Transit Gateway) for global network transit architecture.

### Location
`./modules/virtual-wan/`

### Key Features
- **Virtual Hubs**: Regional hub deployment
- **VPN Gateway**: Site-to-site VPN connectivity
- **ExpressRoute Gateway**: Private connectivity
- **VNet Connections**: Hub-spoke connectivity
- **Routing**: Custom route tables and policies
- **Secured Hubs**: Azure Firewall integration

### Usage Example
```hcl
module "virtual_wan" {
  source = "./modules/virtual-wan"
  
  virtual_wan_name = "my-vwan"
  location         = "centralus"
  
  virtual_hubs = {
    primary = {
      name           = "hub-primary"
      address_prefix = "10.200.0.0/24"
    }
  }
}
```

### Outputs
- `virtual_wan_id`: Virtual WAN ID
- `virtual_hub_ids`: Map of hub IDs
- `vpn_gateway_ids`: Map of VPN gateway IDs

## Routing Module

### Overview
Advanced routing infrastructure with route tables, UDRs, Route Servers, Traffic Manager, and Azure Front Door.

### Location
`./modules/routing/`

### Key Features
- **Route Tables**: Custom route tables with UDRs
- **NVAs**: Network Virtual Appliances support
- **Route Server**: Azure Route Server for dynamic routing
- **BGP**: BGP peering support
- **Traffic Manager**: Global load balancing
- **Front Door**: Global HTTP(S) routing and WAF

### Usage Example
```hcl
module "routing" {
  source = "./modules/routing"
  
  location            = "centralus"
  resource_group_name = "my-rg"
  
  route_tables = {
    spoke_rt = {
      name = "spoke-route-table"
      routes = [...]
    }
  }
}
```

### Outputs
- `route_table_ids`: Map of route table IDs
- `route_server_ids`: Map of route server IDs
- `frontdoor_profile_ids`: Map of Front Door profile IDs

## Azure Migrate Module

### Overview
Azure Migrate project setup for on-premises discovery, assessment, and migration planning.

### Location
`./modules/azure-migrate/`

### Key Features
- **Migrate Project**: Assessment and migration project
- **Storage**: Dedicated storage for migration data
- **Key Vault**: Secrets management
- **Log Analytics**: Migration tracking and monitoring
- **Recovery Vault**: Backup and recovery
- **Automation**: Pre-migration runbooks

### Usage Example
```hcl
module "azure_migrate" {
  source = "./modules/azure-migrate"
  
  project_name         = "migration-project"
  resource_group_name  = "my-rg"
  storage_account_name = "migratestg"
  key_vault_name       = "migrate-kv"
}
```

### Outputs
- `migrate_project_id`: Migrate project ID
- `storage_account_name`: Storage account for migration data
- `key_vault_uri`: Key Vault URI

## Database Migration Module

### Overview
Azure Database Migration Service for migrating SQL Server, PostgreSQL, and MySQL databases to Azure.

### Location
`./modules/database-migration/`

### Key Features
- **DMS**: Database Migration Service
- **Multi-Database**: SQL, PostgreSQL, MySQL support
- **Target Servers**: Create target database servers
- **Backup Storage**: Dedicated backup storage
- **Monitoring**: Diagnostic settings and alerts
- **Automation**: Pre-migration assessment runbooks

### Usage Example
```hcl
module "database_migration" {
  source = "./modules/database-migration"
  
  dms_name            = "my-dms"
  resource_group_name = "my-rg"
  subnet_id           = "subnet-id"
  
  sql_to_azure_sql_projects = {
    project1 = { name = "sql-migration" }
  }
}
```

### Outputs
- `dms_id`: DMS service ID
- `target_sql_server_fqdns`: Target server FQDNs
- `backup_storage_account_name`: Backup storage account

## Site Recovery Module

### Overview
Azure Site Recovery for VM replication and disaster recovery from on-premises to Azure.

### Location
`./modules/site-recovery/`

### Key Features
- **Recovery Vault**: Recovery Services Vault
- **Replication**: VM replication policies
- **Fabrics**: Source and target fabrics
- **Protection Containers**: Replication groups
- **Network Mapping**: Network failover mapping
- **Automation**: Recovery plan runbooks
- **Monitoring**: Replication health alerts

### Usage Example
```hcl
module "site_recovery" {
  source = "./modules/site-recovery"
  
  vault_name          = "recovery-vault"
  resource_group_name = "my-rg"
  location            = "centralus"
  target_location     = "eastus"
  
  cache_storage_account_name = "asrcachestg"
}
```

### Outputs
- `vault_id`: Recovery Services Vault ID
- `replication_policy_ids`: Replication policy IDs
- `network_mapping_ids`: Network mapping IDs

## Configuration Files

### Main Module Files
- `aks.tf` - AKS cluster configuration
- `security.tf` - Security infrastructure
- `vnet-peering.tf` - VNet peering setup
- `virtual-wan.tf` - Virtual WAN configuration
- `routing.tf` - Advanced routing
- `migration.tf` - All migration modules

### Configuration Examples
See `vars_module_examples.tf` for example configurations that can be added to your environment-specific variable files.

## Getting Started

1. **Review the examples** in `vars_module_examples.tf`
2. **Copy relevant configurations** to your `vars_enviro_dev.tf` or `vars_enviro_prod.tf`
3. **Customize values** based on your requirements
4. **Uncomment module blocks** in the main .tf files (aks.tf, security.tf, etc.)
5. **Run Terraform**:
   ```bash
   terraform workspace select example-infrastructure-dev
   terraform init
   terraform plan
   terraform apply
   ```

## Important Notes

### Cost Considerations
- AKS clusters incur compute costs based on node pool VMs
- Azure Firewall has hourly and data processing charges
- Virtual WAN has hub and gateway costs
- Site Recovery has per-VM replication costs
- Review Azure pricing calculator before deployment

### Network Planning
- Ensure no IP address overlap between VNets
- Plan service CIDR carefully for AKS (cannot overlap with VNet)
- Reserve IP ranges for future growth
- Document your IP addressing scheme

### Security Best Practices
- Enable Azure AD authentication where available
- Use private endpoints for PaaS services
- Implement least-privilege access
- Enable diagnostic logs and monitoring
- Use Azure Policy for governance

### Migration Considerations
- Test migrations in non-production first
- Plan for downtime windows
- Validate application dependencies
- Have rollback plans ready
- Monitor replication health continuously

## Support and Troubleshooting

### Common Issues

1. **AKS Node Pool Failures**
   - Check subnet has enough available IPs
   - Verify NSG rules allow required traffic
   - Ensure VM SKU is available in the region

2. **Firewall Rules Not Working**
   - Verify route tables point to firewall
   - Check rule priorities and ordering
   - Review diagnostic logs

3. **Migration Failures**
   - Verify source connectivity
   - Check credentials and permissions
   - Review migration service diagnostic logs

### Getting Help
- Review Azure documentation
- Check Terraform provider documentation
- Review module README files
- Contact your cloud team

## License
This infrastructure code is proprietary to your organization.

## Maintenance
Last updated: June 2026
Maintained by: DevOps Team
