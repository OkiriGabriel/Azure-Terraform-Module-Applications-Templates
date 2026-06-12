# Example configuration for new infrastructure modules
# Copy these configurations into your vars_enviro_dev.tf or vars_enviro_prod.tf files

locals {
  module_examples = {
    # AKS Configuration Example
    aks_config = {
      kubernetes_version = "1.28"

      default_node_pool = {
        name                = "default"
        node_count          = 3
        vm_size             = "Standard_D4s_v3"
        os_disk_size_gb     = 100
        subnet_name         = "WorkloadSubnet"
        max_pods            = 30
        enable_auto_scaling = true
        min_count           = 3
        max_count           = 10
        availability_zones  = ["1", "2", "3"]
        max_surge           = "33%"
      }

      additional_node_pools = {
        workload = {
          name                = "workload"
          node_count          = 2
          vm_size             = "Standard_D8s_v3"
          os_disk_size_gb     = 128
          vnet_subnet_id      = "" # Reference to subnet
          max_pods            = 50
          enable_auto_scaling = true
          min_count           = 2
          max_count           = 5
          availability_zones  = ["1", "2", "3"]
          os_type             = "Linux"
          node_taints         = []
          node_labels         = { "workload" = "true" }
          max_surge           = "33%"
        }
      }

      network_profile = {
        network_plugin    = "azure"
        network_policy    = "calico"
        load_balancer_sku = "standard"
        service_cidr      = "10.100.0.0/16"
        dns_service_ip    = "10.100.0.10"
        outbound_type     = "loadBalancer"
      }

      enable_azure_ad_rbac              = true
      azure_ad_admin_group_object_ids   = []
      enable_monitoring                 = true
      log_analytics_workspace_id        = null
      enable_azure_policy               = true
      enable_key_vault_secrets_provider = true
      enable_cluster_autoscaler         = true
      acr_id                            = null
    }

    # Security Configuration Example
    security_config = {
      enable_firewall   = true
      firewall_sku_tier = "Standard"

      firewall_network_rules = [
        {
          name                  = "allow-internal"
          protocols             = ["TCP", "UDP"]
          source_addresses      = ["10.0.0.0/8"]
          destination_addresses = ["10.0.0.0/8"]
          destination_ports     = ["*"]
        }
      ]

      firewall_application_rules = [
        {
          name              = "allow-windows-update"
          source_addresses  = ["10.0.0.0/8"]
          destination_fqdns = ["*.windowsupdate.microsoft.com", "*.update.microsoft.com"]
          protocols = [
            { type = "Http", port = 80 },
            { type = "Https", port = 443 }
          ]
        }
      ]

      enable_ddos_protection = false

      network_security_groups = {
        web_nsg = {
          rules = [
            {
              name                       = "allow-https"
              priority                   = 100
              direction                  = "Inbound"
              access                     = "Allow"
              protocol                   = "Tcp"
              source_port_range          = "*"
              destination_port_range     = "443"
              source_address_prefix      = "Internet"
              destination_address_prefix = "*"
            }
          ]
        }
      }

      enable_security_center     = true
      security_contact_email     = "security@example.com"
      security_contact_phone     = "+1-555-0100"
      log_analytics_workspace_id = null
      enable_nat_gateway         = false
      enable_bastion             = false
    }

    # VNet Peering Configuration Example
    vnet_peering_config = {
      peering_configurations = {
        hub_to_spoke = {
          name                            = "hub-to-spoke1"
          source_resource_group_name      = "rg-hub"
          source_vnet_name                = "vnet-hub"
          source_vnet_id                  = "" # Reference
          destination_resource_group_name = "rg-spoke"
          destination_vnet_name           = "vnet-spoke1"
          destination_vnet_id             = "" # Reference
          allow_virtual_network_access    = true
          allow_forwarded_traffic         = true
          allow_gateway_transit           = true
          use_remote_gateways             = false
          allow_gateway_transit_reverse   = false
          use_remote_gateways_reverse     = true
        }
      }

      global_peering_configurations     = {}
      enable_flow_logs                  = false
      flow_log_configurations           = {}
      enable_connection_monitoring      = false
      connection_monitor_configurations = {}
    }

    # Virtual WAN Configuration Example
    virtual_wan_config = {
      type                           = "Standard"
      allow_branch_to_branch_traffic = true

      virtual_hubs = {
        primary = {
          name           = "hub-primary"
          location       = "centralus"
          address_prefix = "10.200.0.0/24"
          sku            = "Standard"
        }
      }

      vpn_gateways             = {}
      expressroute_gateways    = {}
      vnet_connections         = {}
      virtual_hub_route_tables = {}
      vpn_sites                = {}
      vpn_connections          = {}
      hub_firewalls            = {}
      routing_intents          = {}
    }

    # Routing Configuration Example
    routing_config = {
      route_tables = {
        spoke_rt = {
          name                          = "spoke-route-table"
          disable_bgp_route_propagation = false
          routes = [
            {
              name                   = "to-firewall"
              address_prefix         = "0.0.0.0/0"
              next_hop_type          = "VirtualAppliance"
              next_hop_in_ip_address = "10.0.2.4"
            }
          ]
        }
      }

      subnet_route_table_associations = {}
      network_virtual_appliances      = {}
      route_servers                   = {}
      route_server_bgp_connections    = {}
      traffic_manager_profiles        = {}
      traffic_manager_endpoints       = {}
      frontdoor_profiles              = {}
      frontdoor_endpoints             = {}
      frontdoor_origin_groups         = {}
      frontdoor_origins               = {}
      service_endpoint_policies       = {}
    }

    # Migration Configuration Example
    migration_config = {
      # Azure Migrate
      storage_account_name       = "examplemigratestg"
      key_vault_name             = "example-migrate-kv"
      create_log_analytics       = true
      log_analytics_workspace_id = null
      appliance_type             = "VMware"
      discovery_scenario         = "AssessAndMigrate"
      enable_private_endpoints   = false
      create_automation_account  = true

      # Database Migration Service
      dms_sku_name                  = "Standard_1vCore"
      dms_backup_storage_account    = "exampledmsbkpstg"
      dms_enable_private_endpoint   = false
      dms_create_log_analytics      = true
      dms_enable_diagnostics        = true
      dms_create_automation_account = true

      sql_to_azure_sql_projects    = {}
      postgresql_to_azure_projects = {}
      mysql_to_azure_projects      = {}

      # Azure Site Recovery
      asr_target_location           = "eastus"
      asr_vault_sku                 = "Standard"
      asr_soft_delete_enabled       = true
      asr_storage_mode_type         = "GeoRedundant"
      asr_cache_storage_account     = "exampleasrcachestg"
      asr_create_automation_account = true
      asr_create_log_analytics      = true
      asr_enable_diagnostics        = true

      asr_source_fabrics                = {}
      asr_target_fabrics                = {}
      asr_source_protection_containers  = {}
      asr_target_protection_containers  = {}
      asr_replication_policies          = {}
      asr_protection_container_mappings = {}
      asr_network_mappings              = {}
    }
  }
}
