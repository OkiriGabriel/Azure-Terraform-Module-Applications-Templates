# Redis Cache Module
module "redis" {
  source              = "./modules/redis"
  tags                = local.current_env.tags
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  redis_caches = {
    main = {
      name                = "example-${local.current_env.environment}-redis"
      capacity            = local.redis_config.capacity
      family              = local.redis_config.family
      sku_name            = local.redis_config.sku_name
      minimum_tls_version = "1.2"
      maxmemory_reserved  = local.redis_config.maxmemory_reserved
      maxmemory_delta     = local.redis_config.maxmemory_delta
      maxmemory_policy    = local.redis_config.maxmemory_policy
    }
  }
}
