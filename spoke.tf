module "spoke1" {
  source                   = "./modules/spoke"
  name                     = "example-${local.current_env.environment}-spoke-virtual-network"
  spoke_route_table_name   = "${local.current_env.environment}-spoke-route-table"
  network_security_group   = "${local.current_env.environment}-spoke-network-security-group"
  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location
  hub_virtual_network_id   = module.hub.vnet_id
  hub_virtual_network_name = module.hub.vnet_name


  subnet_prefixes    = local.current_env.spoke_configs.spoke1.subnet_prefixes # Changed from hub_config
  subnets_with_nsg   = local.current_env.spoke_configs.spoke1.subnets_with_nsg
  subnet_delegations = local.current_env.spoke_configs.spoke1.subnet_delegations
  hub_to_spoke       = "${local.current_env.environment}-hub-to-spoke"
  spoke_to_hub       = "${local.current_env.environment}-spoke-to-hub"
  prefix             = "${local.current_env.environment}-spoke"
  address_space      = local.current_env.spoke_configs.spoke1.address_space
  tags               = local.current_env.tags
}

