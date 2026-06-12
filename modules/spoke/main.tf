resource "azurerm_virtual_network" "spoke" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}

# Combined Subnet Creation
# resource "azurerm_subnet" "spoke_subnets" {
#   for_each = var.subnet_prefixes

#   name                 = each.key

#   service_endpoints    = ["Microsoft.KeyVault"] 
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.spoke.name
#   address_prefixes     = [each.value]
# }

resource "azurerm_subnet" "spoke_subnets" {
  for_each = var.subnet_prefixes

  name                 = each.key
  service_endpoints    = ["Microsoft.KeyVault"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [each.value]
  lifecycle {
    ignore_changes = [
      delegation,
      service_endpoints,
      private_endpoint_network_policies
    ]
  }

  dynamic "delegation" {
    for_each = try(var.subnet_delegations[each.key], [])
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

resource "azurerm_network_security_group" "workload" {
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

# Update NSG association to use the subnet from for_each
resource "azurerm_subnet_network_security_group_association" "workload" {
  for_each = toset(var.subnets_with_nsg)

  subnet_id                 = azurerm_subnet.spoke_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.workload.id
}

# Route table association for all subnets
resource "azurerm_subnet_route_table_association" "workload" {
  for_each = var.subnet_prefixes

  subnet_id      = azurerm_subnet.spoke_subnets[each.key].id
  route_table_id = azurerm_route_table.spoke.id
}

resource "azurerm_route_table" "spoke" {
  name                = var.spoke_route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# # Update route table association to use the subnet from for_each
# resource "azurerm_subnet_route_table_association" "workload" {
#   subnet_id      = azurerm_subnet.spoke_subnets[var.].id
#   route_table_id = azurerm_route_table.spoke.id
# }


# Spoke to Hub peering
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = var.spoke_to_hub
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = var.hub_virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}

# Hub to Spoke peering
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = var.hub_to_spoke
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.hub_virtual_network_name
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false

  depends_on = [azurerm_virtual_network.spoke]
}

# Workload Subnets
# resource "azurerm_subnet" "spoke_subnets" {
#  for_each = var.subnet_prefixes

#   name                 = each.key
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.spoke.name
#   address_prefixes     = [each.value]
# }


output "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value = {
    for name, subnet in azurerm_subnet.spoke_subnets : name => subnet.id
  }
}

output "vnet_id" {
  description = "The ID of the spoke virtual network"
  value       = azurerm_virtual_network.spoke.id
}

output "vnet_name" {
  description = "The name of the spoke virtual network"
  value       = azurerm_virtual_network.spoke.name
}
