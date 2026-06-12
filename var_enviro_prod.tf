# Production Environment Variables

locals {
  prod = {
    environment                 = "prod"
    location                    = "centralus"
    prefix                      = "example"
    subscription_id             = "2dd44c49-8bb8-48d0-8df5-309dbf242655"
    tenant_id                   = "32038e49-0cb9-434a-b5d3-782e033647d7"
    service_principal_object_id = "1b36e61d-3116-4d9b-b3b9-7befd01a1ea3"
    deploy                      = true
    not_deploy                  = false
    key_vault_name              = "example-prod-secrets"
    # Network settings (remove resource_group_name)
    hub_config = {
      address_space         = ["10.0.0.0/16"]
      gateway_subnet_prefix = "10.0.1.0/24"
      subnet_prefixes = {
        AzureFirewallSubnet = "10.0.2.0/24"
        AzureBastionSubnet  = "10.0.3.0/24"
        # SharedServices      = "10.0.4.0/24"
        # Management          = "10.0.5.0/24"
      }
      names = {
        network = "hub-vnet"
        gateway = "hub-gateway"
        nsg     = "hub-nsg"
      }
    }

    environment     = "prod"
    location        = "centralus"
    prefix          = "example"
    subscription_id = "2dd44c49-8bb8-48d0-8df5-309dbf242655"
    tenant_id       = "32038e49-0cb9-434a-b5d3-782e033647d7"
    deploy          = true
    not_deploy      = false
    # Network settings (remove resource_group_name)
    hub_config = {
      address_space         = ["10.0.0.0/16"]
      gateway_subnet_prefix = "10.0.1.0/24"
      subnet_prefixes = {
        AzureFirewallSubnet = "10.0.2.0/24"
        AzureBastionSubnet  = "10.0.3.0/24"
        # SharedServices      = "10.0.4.0/24"
        # Management          = "10.0.5.0/24"
      }
      names = {
        network = "hub-vnet"
        gateway = "hub-gateway"
        nsg     = "hub-nsg"
      }
    }


    spoke_configs = {
      spoke1 = {
        address_space = ["10.1.0.0/16"]
        subnet_prefixes = {
          "WorkloadSubnet"  = "10.1.5.0/24"
          "WebTier"         = "10.1.2.0/24"
          "ContainerSubnet" = "10.1.6.0/24" # New subnet for RabbitMQ
        }
        # subnets_with_nsg = ["WorkloadSubnet", "WebTier"]
        subnets_with_nsg = ["WorkloadSubnet", "WebTier", "ContainerSubnet", "ContainerAppSubnet", "RedisSubnet"]
        subnet_delegations = {
          "ContainerSubnet" = [{
            name = "container-instance"
            service_delegation = {
              name    = "Microsoft.ContainerInstance/containerGroups"
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
            }
          }]
        }
      }
      spoke2 = {
        address_space = ["10.2.0.0/16"]
        subnet_prefixes = {
          "WorkloadSubnet" = "10.2.1.0/24"
          "WebTier"        = "10.2.2.0/24"
          # "AppTier"       = "10.2.3.0/24"
          # "DatabaseTier"  = "10.2.4.0/24"
        }
        subnets_with_nsg = ["WebTier", "AppTier"]
      }
    }

    app_service_config = {
      sku_name       = "B1"
      python_version = "3.9"
      app_settings = {
        "WEBSITE_RUN_FROM_PACKAGE" = "1"
        "WEBSITE_VNET_ROUTE_ALL"   = "1"
        "WEBSITE_DNS_SERVER"       = "168.63.129.16"
      }
    }

    log_analytics_config = {
      sku            = "PerGB2018"
      retention_days = 30

    }

    key_vault_config = {
      sku_name                    = "standard"
      allowed_ip_ranges           = ["0.0.0.0/0", "47.187.209.24"]
      allowed_subnet_ids          = ["WorkloadSubnet", "WebTier"]
      user_object_id              = "73d23254-ec10-4c7f-93b9-e725ac65b69a"
      service_principal_object_id = "1b36e61d-3116-4d9b-b3b9-7befd01a1ea3"
    }

    redis_config = {
      capacity           = 1
      family             = "C"
      sku_name           = "Basic"
      maxmemory_reserved = 0
      maxmemory_delta    = 0
      maxmemory_policy   = "volatile-lru"
      allowed_ip_start   = "0.0.0.0"         # Public access
      allowed_ip_end     = "255.255.255.255" # Public access
    }



    acr_config = {
      client = {
        name          = "productclient"
        sku           = "Standard"
        admin_enabled = true
        # admin_password = "example@1234567890"
      }
      api = {
        name          = "productapi"
        sku           = "Standard"
        admin_enabled = true
        # admin_password = "example@1234567890"
      }
      synapse = {
        name          = "txtsqlsynapseconnector"
        sku           = "Standard"
        admin_enabled = true
        # admin_password = "example@1234567890"
      }

      blobstoragesfunc = {
        name          = "blobstoragesfunc"
        sku           = "Standard"
        admin_enabled = true
        # suffix = "dev"
      }


      qdrant = {
        name          = "qdrantprod"
        sku           = "Standard"
        admin_enabled = true
        # admin_password = "prod!@1234567890"
      }
      rabbitmq = {
        name          = "rabbitmqprod"
        sku           = "Standard"
        admin_enabled = true
        username      = "admin"
        # admin_password = "example@1234567890"
      }
    }
    synapse_config = {
      name                             = "examplesynapseworkspaceprod"
      sql_administrator_login          = "examplesqladmin"
      sql_administrator_login_password = null # Set via TF_VAR or Key Vault; never commit
      dedicated_sql_pool = {
        name     = "examplesqlpoolprod"
        sku_name = "DW100c"
      }
      tags = {
        Environment = "prod"
      }
    }
    tags = {
      Environment  = "Production"
      Project      = "example"
      Owner        = "DevOps"
      CostCenter   = "Prod-001"
      BusinessUnit = "Technology"
      ManagedBy    = "Terraform"
    }
    container_apps_config = {
      frontend_acr_server   = "exampleprodacr.azurecr.io"
      backend_acr_server    = "exampleprodacr.azurecr.io"
      container_volume_name = "containervolumesappprod"
      frontend = {
        name         = "client"
        image        = "exampleprodacr.azurecr.io/example-product-client:main"
        cpu          = "4.0" # Increased from 2.0
        memory_in_gb = "8.0"

      }
      backend = {
        name         = "api"
        image        = "exampleprodacr.azurecr.io/example-product-api:main"
        cpu          = "4.0" # Increased from 2.0
        memory_in_gb = "8.0"
      }
      frontend_acr_username = "exampleprodacr.azurecr.io"
      # Set via Key Vault or TF_VAR; never commit ACR passwords
      frontend_acr_password = null
      backend_acr_username  = "exampleprodacr.azurecr.io"
      backend_acr_password  = null
    }



    container_apps_v2_config = {
      app_environment = "prod"


      # Frontend configuration
      frontend_config = {
        image                             = "exampleprodacr.azurecr.io/example-product-client:prod"
        cpu                               = 2.0
        memory_in_gb                      = 4.0
        frontend_app_name                 = "client"
        frontend_application_port         = 8080
        frontend_port                     = 80
        frontend_port_https               = 443
        frontend_storage_share_name       = "frontend-data"
        frontend_data_share_name          = "frontenddataprod"
        frontend_storage_share_quota      = 100
        frontend_cpu                      = 2.0
        frontend_memory                   = 4.0
        frontend_image                    = "exampleprodacr.azurecr.io/example-product-client:prod"
        frontend_acr_password_secret_name = "frontend-acr-password"
        frontend_min_replicas             = 1
        frontend_max_replicas             = 3
        frontend                          = "examplefrontendstorage"
      }
      #} Backend configuration
      backend_config = {
        image            = "exampleprodacr.azurecr.io/example-product-api:prod"
        cpu              = 2.0
        memory_in_gb     = 4.0
        key_vault_url    = "example-prod-api-secrets-kvt"
        dns_cname_record = "prod.api.exampleproduct.exampleplatform.ai"
        dns_zone         = "exampleplatform.ai"

        backend_app_name                 = "api"
        backend_application_port         = 8001
        backend_port                     = 80
        backend_port_https               = 443
        backend_storage_share_name       = "backend-data"
        backend_data_share_name          = "backenddataprod"
        backend_storage_share_quota      = 100
        backend_cpu                      = 2.0
        backend_memory                   = 4.0
        backend_image                    = "exampleprodacr.azurecr.io/example-product-api:prod"
        backend_acr_password_secret_name = "backend-acr-password"
        backend_min_replicas             = 1
        backend_max_replicas             = 3
        backend                          = "examplebackendstorageprod"
        # Shaed configuration
        container_volume_name = "containervolumesapp"
      }
    }

  }

}