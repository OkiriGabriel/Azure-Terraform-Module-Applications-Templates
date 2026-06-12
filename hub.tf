

data "azurerm_client_config" "current" {}


module "hub" {
  #  count  = local.current_env.not_deploy ? 0 : 1
  source                 = "./modules/hub"
  name                   = "example-${local.current_env.environment}-hub-virtual-network"
  resource_group_name    = module.resource_group.name
  location               = module.resource_group.location
  gateway                = "example-${local.current_env.environment}-hub-gateway"
  network_security_group = "${local.current_env.environment}-hub-network-security-group"
  prefix                 = local.current_env.environment
  address_space          = local.current_env.hub_config.address_space
  subnet_prefixes        = local.current_env.hub_config.subnet_prefixes
  gateway_subnet_prefix  = local.current_env.hub_config.gateway_subnet_prefix
  tags                   = local.current_env.tags
  # depends_on             = [module.spoke1.vnet_id]
}