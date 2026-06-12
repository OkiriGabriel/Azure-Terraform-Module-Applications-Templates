
# module "bastion" {
#   source = "./modules/monitoring"

#   bastion_name        = "example-${local.current_env.environment}-monitoring"
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   bastion_subnet_id   = module.hub.subnet_ids["AzureBastionSubnet"]
#   tags                = local.current_env.tags
# }