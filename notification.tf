# module "notification_hub" {
#   source = "./modules/notification-hub"

#   resource_group_name   = module.resource_group.name
#   location              = local.current_env.location
#   namespaces            = local.current_env.notification_hub_config.namespaces
#   notification_hubs     = local.current_env.notification_hub_config.notification_hubs
#   authorization_rules   = local.current_env.notification_hub_config.authorization_rules
#   tags                  = local.current_env.tags
# }