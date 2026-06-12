# resource "azurerm_resource_group" "hub" {
#   name     = var.resource_group_name
#   location = var.location
#   tags     = var.tags
# }

resource "azurerm_virtual_network" "hub" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  tags = var.tags
}

resource "azurerm_subnet" "gateway" {
  name                 = var.gateway
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.gateway_subnet_prefix]
}

resource "azurerm_network_security_group" "hub_nsg" {
  name                = var.network_security_group
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowInternalTraffic"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = var.tags
}

resource "azurerm_subnet" "hub_subnets" {
  for_each = var.subnet_prefixes

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [each.value]
}