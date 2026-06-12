

module "blob_storage" {
  source = "./modules/blob-storage"

  resource_group_name = module.resource_group.name
  location            = local.current_env.location
  storage_accounts    = local.current_env.blob_storage_config.storage_accounts
  containers          = local.current_env.blob_storage_config.containers
  cdn_profiles        = local.current_env.blob_storage_config.cdn_profiles
  cdn_endpoints       = local.current_env.blob_storage_config.cdn_endpoints
  tags                = local.current_env.tags
}

