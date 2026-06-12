locals {

  dev = {
    environment                 = "dev"
    location                    = "centralus"
    prefix                      = "example"
    subscription_id             = "0fd19ccc-fcf5-42ff-8046-327b995ea8ee"
    tenant_id                   = "08743126-a95f-4eec-aef0-fd3b6262556a"
    service_principal_object_id = "022300fa-0846-402b-ad41-bb9af68342a4"
    deploy                      = true
    not_deploy                  = false
    key_vault_name              = "example-dev-secrets"
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
        subnets_with_nsg = ["WorkloadSubnet", "WebTier", "ContainerSubnet"]
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

    database_config = {
      admin_username               = "psqladmin"
      sku_name                     = "GP_Standard_D2s_v3" # Updated for flexible server (burstable tier)
      storage_mb                   = 32768                # Increased for flexible server (32GB)
      version                      = "14"
      aci_subnet_start_ip          = "10.1.6.0"
      aci_subnet_end_ip            = "10.1.6.255"
      high_availability_enabled    = true
      auto_grow_enabled            = true
      geo_redundant_backup_enabled = true
      backup_retention_days        = 7
      subresource_names            = ["postgresqlServer"]
      private_dns_zone_name        = "privatelink.postgres.database.azure.com"
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
      service_principal_object_id = "7fda51ce-bf98-4a90-a2c8-50531add5643"
    }


    redis_config = {
      capacity           = 0 # 250MB (Basic tier)
      family             = "C"
      sku_name           = "Basic"
      maxmemory_reserved = 0
      maxmemory_delta    = 0
      maxmemory_policy   = "volatile-lru"
      allowed_ip_start   = "0.0.0.0"         # Public access
      allowed_ip_end     = "255.255.255.255" # Public access
    }

    service_bus_config = {
      sku             = "Standard" # Basic, Standard, or Premium
      capacity        = 0          # Number of messaging units
      connection_name = "service_bus-connection-string"
      key_name        = "service_bus-primary-key"
    }

    # rabbitmq_config = {
    #   # Container settings
    #   cpu            = "1"
    #   memory         = "2"
    #   image          = "exampledevacr.azurecr.io/rabbitmq:v4"
    #   container_name = "rabbitmq-dev"
    #   cpu            = "1.0"
    #   memory         = "2.0"
    #   # Network settings
    #   subnet_name = "WorkloadSubnet" # The subnet where RabbitMQ will be deployed

    #   # RabbitMQ settings
    #   ports = {
    #     amqp       = 5672
    #     management = 15672
    #   }
    #   name = "rabbitmq"

    #   # Monitoring settings
    #   enable_monitoring = true
    #   retention_days    = 30

    #   # Backup settings
    #   enable_backup    = true
    #   backup_retention = 7
    # }
    acr_config = {
      client = {
        # name          = "productclient"
        sku           = "Basic" # Changed from Standard to Basic for dev cost optimization
        admin_enabled = true
        # admin_password = "example@1234567890"
      }
      api = {
        name          = "example-api"
        sku           = "Basic" # Changed from Standard to Basic for dev cost optimization
        admin_enabled = true
        # admin_password = "example@1234567890"
      }
    }

    tags = {
      Environment  = "Development"
      Project      = "example"
      Owner        = "DevOps"
      CostCenter   = "Dev-001"
      BusinessUnit = "Technology"
      ManagedBy    = "Terraform"
    }


    container_apps_v2_config = {
      app_environment = "dev"


      # Frontend configuration
      frontend_config = {
        image                             = "exampledevacr.azurecr.io/example-marchant:dev"
        cpu                               = 0.5 # Reduced from 1.0 to 0.5 for dev cost optimization
        memory_in_gb                      = 0.5 # Reduced from 1.0 to 0.5 for dev cost optimization
        frontend_app_name                 = "merchant"
        frontend_application_port         = 3000
        frontend_port                     = 3000
        frontend_port_https               = 443
        frontend_storage_share_name       = "frontend-data"
        frontend_data_share_name          = "frontenddatadev"
        frontend_storage_share_quota      = 100
        frontend_cpu                      = 0.25 # Reduced from 0.5 to 0.25 for dev cost optimization
        frontend_memory                   = 0.5  # Reduced from 1.0 to 0.5 for dev cost optimization
        frontend_image                    = "exampledevacr.azurecr.io/example-marchant:dev"
        frontend_acr_password_secret_name = "frontend-acr-password"
        frontend_min_replicas             = 1
        frontend_max_replicas             = 1
        frontend                          = "examplefrontendstorage"
      }
      #} Backend configuration
      backend_config = {
        image            = "exampledevacr.azurecr.io/example-backend:dev"
        cpu              = 0.5 # Reduced from 1.0 to 0.5 for dev cost optimization
        memory_in_gb     = 1.0 # Reduced from 2.0 to 1.0 for dev cost optimization
        key_vault_url    = "example-dev-api-secrets-kvt"
        dns_cname_record = "dev.api.example.example.com"
        dns_zone         = "example.com"

        backend_app_name                 = "api"
        backend_application_port         = 4600
        backend_port                     = 4600
        backend_port_https               = 443
        backend_storage_share_name       = "backend-data"
        backend_data_share_name          = "backenddatadev"
        backend_storage_share_quota      = 100
        backend_cpu                      = 0.25 # Reduced from 0.5 to 0.25 for dev cost optimization
        backend_memory                   = 0.5  # Reduced from 1.0 to 0.5 for dev cost optimization
        backend_image                    = "exampledevacr.azurecr.io/example-backend:dev"
        backend_acr_password_secret_name = "backend-acr-password"
        backend_min_replicas             = 1
        backend_max_replicas             = 1
        backend                          = "examplebackendstorage"
        # Shaed configuration
        container_volume_name = "containervolumesapp"
      }

      # Marketplace configuration
      marketplace_config = {
        image            = "exampledevacr.azurecr.io/example-marketplace:dev"
        cpu              = 0.25 # Reduced from 0.5 to 0.25 for dev cost optimization
        memory_in_gb     = 0.5  # Reduced from 1.0 to 0.5 for dev cost optimization
        key_vault_url    = "example-dev-marketplace-secrets-kvt"
        dns_cname_record = "dev.marketplace.example.com"
        dns_zone         = "example.com"

        marketplace_app_name                 = "marketplace"
        marketplace_application_port         = 3000
        marketplace_port                     = 3000
        marketplace_port_https               = 443
        marketplace_storage_share_name       = "marketplace-data"
        marketplace_data_share_name          = "marketplacedatadev"
        marketplace_storage_share_quota      = 100
        marketplace_cpu                      = 0.25 # Reduced from 0.5 to 0.25 for dev cost optimization
        marketplace_memory                   = 0.5  # Reduced from 1.0 to 0.5 for dev cost optimization
        marketplace_image                    = "exampledevacr.azurecr.io/example-marketplace:dev"
        marketplace_acr_password_secret_name = "marketplace-acr-password"
        marketplace_min_replicas             = 1
        marketplace_max_replicas             = 1
        marketplace                          = "examplemarketplacestorage"
      }

      # Admin Frontend configuration
      admin_frontend_config = {
        image            = "exampledevacr.azurecr.io/example-admin:dev"
        cpu              = 0.5
        memory_in_gb     = 1.0
        key_vault_url    = "example-dev-admin-frontend-secrets-kvt"
        dns_cname_record = "dev-admin.example.com"
        dns_zone         = "example.com"

        admin_frontend_app_name                 = "admin-frontend"
        admin_frontend_application_port         = 5173
        admin_frontend_port                     = 5173
        admin_frontend_port_https               = 443
        admin_frontend_storage_share_name       = "admin-frontend-data"
        admin_frontend_data_share_name          = "adminfrontenddatadev"
        admin_frontend_storage_share_quota      = 100
        admin_frontend_cpu                      = 0.5
        admin_frontend_memory                   = 1.0
        admin_frontend_image                    = "exampledevacr.azurecr.io/example-admin:dev"
        admin_frontend_acr_password_secret_name = "admin-frontend-acr-password"
        admin_frontend_min_replicas             = 1
        admin_frontend_max_replicas             = 1
        admin_frontend                          = "exampleadminfdstorage"
      }
    }

    blob_storage_config = {
      storage_accounts = {
        main = {
          name                            = "exampledevstorage"
          account_tier                    = "Standard"
          account_replication_type        = "LRS"
          account_kind                    = "StorageV2"
          access_tier                     = "Hot"
          min_tls_version                 = "TLS1_2"
          allow_nested_items_to_be_public = false
          container_delete_retention_policy = {
            days = 7
          }
          delete_retention_policy = {
            days = 30
          }
          network_rules = {
            default_action             = "Deny"
            ip_rules                   = ["0.0.0.0/0"]
            virtual_network_subnet_ids = []
            bypass                     = ["AzureServices"]
          }
        }
      }
      containers = {
        uploads = {
          name                  = "uploads"
          storage_account_key   = "main"
          container_access_type = "private"
          metadata = {
            purpose     = "user-uploads"
            environment = "dev"
          }
        }
        documents = {
          name                  = "documents"
          storage_account_key   = "main"
          container_access_type = "private"
          metadata = {
            purpose     = "document-storage"
            environment = "dev"
          }
        }
        backups = {
          name                  = "backups"
          storage_account_key   = "main"
          container_access_type = "private"
          metadata = {
            purpose     = "backup-storage"
            environment = "dev"
          }
        }
      }

      cdn_profiles = {
        main = {
          name = "example-dev-cdn-profile"
          sku  = "Standard_Microsoft"
        }
      }

      cdn_endpoints = {
        main = {
          name                = "example-dev-cdn-endpoint"
          profile_key         = "main"
          storage_account_key = "main"
          origin_name         = "storage-origin"
          optimization_type   = "GeneralWebDelivery"
          # Rules are not supported in this version
          # rules = [
          #   {
          #     name  = "cache-images"
          #     order = 1
          #     cache_expiration_action = {
          #       behavior = "SetIfMissing"
          #       duration = "P30D"
          #     }
          #   },
          #   {
          #     name  = "cache-documents"
          #     order = 2
          #     cache_expiration_action = {
          #       behavior = "SetIfMissing"
          #       duration = "P7D"
          #     }
          #   }
          # ]
        }
      }
    }

    notification_hub_config = {
      namespaces = {
        main = {
          name           = "example-dev-notification-namespace"
          namespace_type = "NotificationHub"
          sku_name       = "Free"
        }
      }
      notification_hubs = {
        main = {
          name          = "example-dev-notification-hub"
          namespace_key = "main"
        }
      }
      authorization_rules = {
        default = {
          name          = "DefaultListenSharedAccessSignature"
          namespace_key = "main"
          hub_key       = "main"
          listen        = true
          send          = true
          manage        = false
        }
        manage = {
          name          = "DefaultFullSharedAccessSignature"
          namespace_key = "main"
          hub_key       = "main"
          listen        = true
          send          = true
          manage        = true
        }
      }
    }

    monitoring_config = {
      # Prometheus Configuration
      prometheus_app_name             = "example-dev-prometheus"
      prometheus_port                 = 9090
      prometheus_image                = "prom/prometheus:latest"
      prometheus_cpu                  = 0.5 # Reduced from 1.0 to 0.5 for dev cost optimization
      prometheus_memory               = 1.0 # Reduced from 2.0 to 1.0 for dev cost optimization
      prometheus_min_replicas         = 1
      prometheus_max_replicas         = 3
      prometheus_storage_account_name = "exampledevprometheus"

      # Grafana Configuration
      grafana_app_name             = "example-dev-grafana"
      grafana_port                 = 3000
      grafana_image                = "grafana/grafana:latest"
      grafana_cpu                  = 0.5 # Reduced from 1.0 to 0.5 for dev cost optimization
      grafana_memory               = 1.0 # Reduced from 2.0 to 1.0 for dev cost optimization
      grafana_min_replicas         = 1
      grafana_max_replicas         = 3
      grafana_admin_password       = "CHANGE_ME_grafana_password"
      grafana_storage_account_name = "exampledevgrafana"

      # Loki Configuration
      loki_app_name             = "example-dev-loki"
      loki_port                 = 3100
      loki_image                = "grafana/loki:latest"
      loki_cpu                  = 0.5 # Reduced from 1.0 to 0.5 for dev cost optimization
      loki_memory               = 1.0 # Reduced from 2.0 to 1.0 for dev cost optimization
      loki_min_replicas         = 1
      loki_max_replicas         = 3
      loki_storage_account_name = "exampledevloki"
    }
  }

}
