
# # Public IP for Bastion
# resource "azurerm_public_ip" "bastion" {
#   name                = "example-${local.environment}-bastion-ip"
#   location            = local.location
#   resource_group_name = module.resource_group.name
#   allocation_method   = "Static"
#   sku                = "Standard"
# }

# # # Bastion Host
# # resource "azurerm_bastion_host" "main" {
# #   name                = "example-${local.environment}-bastion"
# #   location            = local.location
# #   resource_group_name = module.resource_group.name

# #   ip_configuration {
# #     name                 = "configuration"
# #     subnet_id           = module.hub.subnet_ids["AzureBastionSubnet"]
# #     public_ip_address_id = azurerm_public_ip.bastion.id
# #   }
# # }

# # Test VM
# resource "azurerm_network_interface" "bastion" {
#   # count  = local.current_env.not_deploy ? 0 : 1
#   name                = "example-${local.environment}-bastion-vm-nic"
#   location            = local.location
#   resource_group_name = module.resource_group.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = module.spoke1.subnet_ids["WorkloadSubnet"]
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_linux_virtual_machine" "bastion" {
#   # count  = local.current_env.not_deploy ? 0 : 1
#   name                = "example-${local.environment}-bastion-vm"
#   location            = local.location
#   resource_group_name = module.resource_group.name
#   size                = "Standard_B2s"
#   admin_username      = "azureuser"

#   network_interface_ids = [
#     azurerm_network_interface.bastion.id
#   ]

#   admin_ssh_key {
#     username   = "azureuser"
#     public_key = file("./key/id_rsa.pub")
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   tags = local.tags
# }

module "resource_group" {
  # count  = local.current_env.not_deploy ? 0 : 1
  source = "./modules/resource_group"

  location            = local.current_env.location
  resource_group_name = "example-${local.current_env.environment}-resource-group"
  tags                = local.current_env.tags
}

# # Monitoring Stack
# module "monitoring" {
#   source = "./modules/monitoring"

#   resource_group_name = module.resource_group.name
#   location            = local.location
#   environment         = local.environment
#   tags                = local.tags

#   container_app_environment_id = module.container_apps_v2.container_app_environment_id
#   container_app_environment_domain = module.container_apps_v2.container_app_environment_domain

#   # Prometheus Configuration
#   prometheus_app_name = local.current_env.monitoring_config.prometheus_app_name
#   prometheus_port = local.current_env.monitoring_config.prometheus_port
#   prometheus_image = local.current_env.monitoring_config.prometheus_image
#   prometheus_cpu = local.current_env.monitoring_config.prometheus_cpu
#   prometheus_memory = local.current_env.monitoring_config.prometheus_memory
#   prometheus_min_replicas = local.current_env.monitoring_config.prometheus_min_replicas
#   prometheus_max_replicas = local.current_env.monitoring_config.prometheus_max_replicas
#   prometheus_storage_account_name = local.current_env.monitoring_config.prometheus_storage_account_name

#   # Grafana Configuration
#   grafana_app_name = local.current_env.monitoring_config.grafana_app_name
#   grafana_port = local.current_env.monitoring_config.grafana_port
#   grafana_image = local.current_env.monitoring_config.grafana_image
#   grafana_cpu = local.current_env.monitoring_config.grafana_cpu
#   grafana_memory = local.current_env.monitoring_config.grafana_memory
#   grafana_min_replicas = local.current_env.monitoring_config.grafana_min_replicas
#   grafana_max_replicas = local.current_env.monitoring_config.grafana_max_replicas
#   grafana_admin_password = local.current_env.monitoring_config.grafana_admin_password
#   grafana_storage_account_name = local.current_env.monitoring_config.grafana_storage_account_name

#   # Loki Configuration
#   loki_app_name = local.current_env.monitoring_config.loki_app_name
#   loki_port = local.current_env.monitoring_config.loki_port
#   loki_image = local.current_env.monitoring_config.loki_image
#   loki_cpu = local.current_env.monitoring_config.loki_cpu
#   loki_memory = local.current_env.monitoring_config.loki_memory
#   loki_min_replicas = local.current_env.monitoring_config.loki_min_replicas
#   loki_max_replicas = local.current_env.monitoring_config.loki_max_replicas
#   loki_storage_account_name = local.current_env.monitoring_config.loki_storage_account_name

#   # Container App Names for Monitoring
#   frontend_app_name = local.current_env.container_apps_v2_config.frontend_config.frontend_app_name
#   backend_app_name = local.current_env.container_apps_v2_config.backend_config.backend_app_name
#   marketplace_app_name = local.current_env.container_apps_v2_config.marketplace_config.marketplace_app_name
#   admin_frontend_app_name = local.current_env.container_apps_v2_config.admin_frontend_config.admin_frontend_app_name

#   # Container App Ports for Monitoring
#   frontend_port = local.current_env.container_apps_v2_config.frontend_config.frontend_port
#   backend_port = local.current_env.container_apps_v2_config.backend_config.backend_port
#   marketplace_port = local.current_env.container_apps_v2_config.marketplace_config.marketplace_port
#   admin_frontend_port = local.current_env.container_apps_v2_config.admin_frontend_config.admin_frontend_port
# }