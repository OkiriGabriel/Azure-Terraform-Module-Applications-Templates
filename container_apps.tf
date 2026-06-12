# Container Apps Module
module "container_apps_v2" {
  source              = "./modules/container-apps"
  depends_on          = [module.redis, azurerm_key_vault.secrets_vault]
  tags                = local.current_env.tags
  prefix              = "example"
  environment         = local.current_env.environment
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  # subnet_id           = module.spoke1.subnet_ids["ContainerAppSubnet"]


  # Frontend configuration
  frontend_app_name = "example-${local.container_apps_v2_config.frontend_config.frontend_app_name}-${local.current_env.environment}"
  #   frontend_config                   = local.container_apps_v2_config.


  frontend_acr_server          = module.acr.login_server["main"]
  frontend_acr_username        = module.acr.admin_username["main"]
  frontend_acr_password        = module.acr.admin_password["main"]
  frontend_application_port    = local.container_apps_v2_config.frontend_config.frontend_application_port
  frontend_port                = local.container_apps_v2_config.frontend_config.frontend_port
  frontend                     = local.container_apps_v2_config.frontend_config.frontend
  frontend_port_https          = local.container_apps_v2_config.frontend_config.frontend_port_https
  frontend_storage_share_name  = local.container_apps_v2_config.frontend_config.frontend_storage_share_name
  frontend_storage_share_quota = local.container_apps_v2_config.frontend_config.frontend_storage_share_quota
  frontend_data_share_name     = local.container_apps_v2_config.frontend_config.frontend_data_share_name
  frontend_cpu                 = local.container_apps_v2_config.frontend_config.frontend_cpu
  frontend_memory              = local.container_apps_v2_config.frontend_config.frontend_memory
  frontend_image               = local.container_apps_v2_config.frontend_config.frontend_image
  #   frontend_acr_password_secret_name = local.container_apps_v2_config.frontend_config.frontend_acr_password_secret_name
  frontend_min_replicas = local.container_apps_v2_config.frontend_config.frontend_min_replicas
  frontend_max_replicas = local.container_apps_v2_config.frontend_config.frontend_max_replicas

  # Backend configuration
  backend_app_name = "example-${local.container_apps_v2_config.backend_config.backend_app_name}-${local.current_env.environment}"
  backend_config   = local.container_apps_v2_config.backend_config

  backend_acr_server   = module.acr.login_server["main"]
  backend_acr_username = module.acr.admin_username["main"]
  backend_acr_password = module.acr.admin_password["main"]

  # Redis configuration
  redis_hostname           = module.redis.redis_hostname["main"]
  redis_ssl_port           = module.redis.redis_ssl_port["main"]
  redis_primary_access_key = module.redis.redis_primary_access_key["main"]


  backend_application_port    = local.container_apps_v2_config.backend_config.backend_application_port
  backend_port                = local.container_apps_v2_config.backend_config.backend_port
  backend_port_https          = local.container_apps_v2_config.backend_config.backend_port_https
  backend                     = local.container_apps_v2_config.backend_config.backend
  backend_storage_share_name  = local.container_apps_v2_config.backend_config.backend_storage_share_name
  backend_storage_share_quota = local.container_apps_v2_config.backend_config.backend_storage_share_quota
  backend_data_share_name     = local.container_apps_v2_config.backend_config.backend_data_share_name
  backend_cpu                 = local.container_apps_v2_config.backend_config.backend_cpu
  backend_memory              = local.container_apps_v2_config.backend_config.backend_memory
  backend_image               = local.container_apps_v2_config.backend_config.backend_image
  # dns_cname_record            = local.container_apps_v2_config.backend_config.dns_cname_record
  # dns_zone                    = local.container_apps_v2_config.backend_config.dns_zone
  #   backend_acr_password_secret_name = local.container_apps_v2_config.backend_config.backend_acr_password_secret_name
  backend_min_replicas   = local.container_apps_v2_config.backend_config.backend_min_replicas
  backend_max_replicas   = local.container_apps_v2_config.backend_config.backend_max_replicas
  key_vault_url          = local.container_apps_v2_config.backend_config.key_vault_url
  key_vault_secrets_name = azurerm_key_vault.secrets_vault.name

  key_vault_id = module.key_vault.key_vault_id
  tenant_id    = local.current_env.tenant_id

  # Key Vault secret values
  jwt_expiry                         = azurerm_key_vault_secret.secrets["JWT-EXPIRY"].value
  jwt_secret                         = azurerm_key_vault_secret.secrets["JWT-SECRET"].value
  base_url                           = azurerm_key_vault_secret.secrets["BASE-URL"].value
  redis_url                          = azurerm_key_vault_secret.secrets["REDIS-URL"].value
  mongo_uri                          = azurerm_key_vault_secret.secrets["MONGO-URI"].value
  termii_api_key                     = azurerm_key_vault_secret.secrets["TERMII-API-KEY"].value
  sender_id                          = azurerm_key_vault_secret.secrets["SENDER-ID"].value
  mailgun_from_email                 = azurerm_key_vault_secret.secrets["MAILGUN-FROM-EMAIL"].value
  mailgun_domain                     = azurerm_key_vault_secret.secrets["MAILGUN-DOMAIN"].value
  mailgun_secret_key                 = azurerm_key_vault_secret.secrets["MAILGUN-SECRET-KEY"].value
  azure_storage_connection_string    = azurerm_key_vault_secret.secrets["AZURE-STORAGE-CONNECTION-STRING"].value
  access_secret                      = azurerm_key_vault_secret.secrets["ACCESS-SECRET"].value
  password_change_secret             = azurerm_key_vault_secret.secrets["PASSWORD-CHANGE-SECRET"].value
  password_reset_secret              = azurerm_key_vault_secret.secrets["PASSWORD-RESET-SECRET"].value
  verify_email_secret                = azurerm_key_vault_secret.secrets["VERIFY-EMAIL-SECRET"].value
  access_token_expires_at_in_seconds = azurerm_key_vault_secret.secrets["ACCESS-TOKEN-EXPIRES-AT-IN-SECONDS"].value
  encryption_key                     = azurerm_key_vault_secret.secrets["ENCRYPTION-KEY"].value
  google_credentials_b64             = azurerm_key_vault_secret.secrets["GOOGLE-CREDENTIALS-B64"].value
  google_scopes_api                  = azurerm_key_vault_secret.secrets["GOOGLE-SCOPES-API"].value
  currency_type                      = azurerm_key_vault_secret.secrets["CURRENCY-TYPE"].value
  stripe_key                         = azurerm_key_vault_secret.secrets["STRIPE-KEY"].value
  example_commission                 = azurerm_key_vault_secret.secrets["example-COMMISSION"].value

  # Shared configuration
  container_volume_name   = local.container_apps_v2_config.backend_config.container_volume_name
  log_analytics_workspace = "example-${local.current_env.environment}-la-wrk-container-apps"

  # Marketplace configuration
  marketplace_app_name     = "example-${local.container_apps_v2_config.marketplace_config.marketplace_app_name}-${local.current_env.environment}"
  marketplace_acr_server   = module.acr.login_server["main"]
  marketplace_acr_username = module.acr.admin_username["main"]
  marketplace_acr_password = module.acr.admin_password["main"]
  marketplace_port         = local.container_apps_v2_config.marketplace_config.marketplace_port
  marketplace              = local.container_apps_v2_config.marketplace_config.marketplace
  marketplace_cpu          = local.container_apps_v2_config.marketplace_config.marketplace_cpu
  marketplace_memory       = local.container_apps_v2_config.marketplace_config.marketplace_memory
  marketplace_image        = local.container_apps_v2_config.marketplace_config.marketplace_image
  marketplace_min_replicas = local.container_apps_v2_config.marketplace_config.marketplace_min_replicas
  marketplace_max_replicas = local.container_apps_v2_config.marketplace_config.marketplace_max_replicas


  # Admin Frontend configuration - COMMENTED OUT
  admin_frontend_app_name   = "example-${local.container_apps_v2_config.admin_frontend_config.admin_frontend_app_name}-${local.current_env.environment}"
  admin_frontend_acr_server = module.acr.login_server["main"]

  admin_frontend_acr_username = module.acr.admin_username["main"]
  admin_frontend_acr_password = module.acr.admin_password["main"]
  admin_frontend_port         = local.container_apps_v2_config.admin_frontend_config.admin_frontend_port
  admin_frontend              = local.container_apps_v2_config.admin_frontend_config.admin_frontend
  admin_frontend_cpu          = local.container_apps_v2_config.admin_frontend_config.admin_frontend_cpu
  admin_frontend_memory       = local.container_apps_v2_config.admin_frontend_config.admin_frontend_memory
  admin_frontend_image        = local.container_apps_v2_config.admin_frontend_config.admin_frontend_image
  admin_frontend_min_replicas = local.container_apps_v2_config.admin_frontend_config.admin_frontend_min_replicas
  admin_frontend_max_replicas = local.container_apps_v2_config.admin_frontend_config.admin_frontend_max_replicas
  # app_environment              = local.container_apps_v2_config.app_environment
  # container_app_environment_id = "${module.container_apps.container_app_environment_id}-${local.current_env.environment}"
}




resource "azurerm_key_vault_access_policy" "container_policy" {
  key_vault_id = module.key_vault.key_vault_id
  tenant_id    = local.current_env.tenant_id
  object_id    = module.container_apps_v2.backend_identity_principal_id

  secret_permissions = [
    "Get", "List"
  ]
}
