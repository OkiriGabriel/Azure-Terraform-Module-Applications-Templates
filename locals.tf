locals {
  env = {
    "example-infrastructure-dev"  = local.dev
    "example-infrastructure-prod" = local.prod
  }
  subscription_id = local.current_env.subscription_id
  tenant_id       = local.current_env.tenant_id

  current_env = try(local.env[terraform.workspace], local.dev)
  deploy      = local.current_env.deploy
  not_deploy  = local.current_env.not_deploy
  # Basic Settings
  environment    = local.current_env.environment
  location       = local.current_env.location
  key_vault_name = local.current_env.key_vault_name

  # Network Configurations
  hub_config = {
    address_space         = local.current_env.hub_config.address_space
    gateway_subnet_prefix = local.current_env.hub_config.gateway_subnet_prefix
    subnet_prefixes       = local.current_env.hub_config.subnet_prefixes
    names                 = local.current_env.hub_config.names
  }

  spoke_configs = {
    spoke1 = {
      address_space      = local.current_env.spoke_configs.spoke1.address_space
      subnet_prefixes    = local.current_env.spoke_configs.spoke1.subnet_prefixes
      subnets_with_nsg   = local.current_env.spoke_configs.spoke1.subnets_with_nsg
      subnet_delegations = local.current_env.spoke_configs.spoke1.subnet_delegations
    }
    spoke2 = {
      address_space    = local.current_env.spoke_configs.spoke2.address_space
      subnet_prefixes  = local.current_env.spoke_configs.spoke2.subnet_prefixes
      subnets_with_nsg = local.current_env.spoke_configs.spoke2.subnets_with_nsg
    }
  }

  # Application Configuration

  # Log Analytics Configuration
  log_analytics_config = {
    sku            = local.current_env.log_analytics_config.sku
    retention_days = local.current_env.log_analytics_config.retention_days
  }

  # Security Configurations
  key_vault_config = {
    sku_name                    = local.current_env.key_vault_config.sku_name
    allowed_ip_ranges           = local.current_env.key_vault_config.allowed_ip_ranges
    allowed_subnet_ids          = local.current_env.key_vault_config.allowed_subnet_ids
    user_object_id              = local.current_env.key_vault_config.user_object_id
    service_principal_object_id = local.current_env.key_vault_config.service_principal_object_id
  }

  redis_config = {
    capacity = local.current_env.redis_config.capacity
    family   = local.current_env.redis_config.family
    sku_name = local.current_env.redis_config.sku_name

    maxmemory_reserved = local.current_env.redis_config.maxmemory_reserved
    maxmemory_delta    = local.current_env.redis_config.maxmemory_delta
    maxmemory_policy   = local.current_env.redis_config.maxmemory_policy
    allowed_ip_start   = local.current_env.redis_config.allowed_ip_start
    allowed_ip_end     = local.current_env.redis_config.allowed_ip_end
  }

  service_bus_config = {
    sku             = local.current_env.service_bus_config.sku
    capacity        = local.current_env.service_bus_config.capacity
    connection_name = local.current_env.service_bus_config.connection_name
    key_name        = local.current_env.service_bus_config.key_name
  }

  acr_config = local.current_env.acr_config

  # ACR credentials are not available in current_env
  # acr_username             = local.current_env.acr_username
  # acr_password             = local.current_env.acr_password
  container_apps_v2_config = local.current_env.container_apps_v2_config

  # container_apps_config is not available in current_env
  # container_apps_config = local.current_env.container_apps_config

  # Common Settings
  tags = local.current_env.tags
}

