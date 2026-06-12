resource "azurerm_notification_hub_namespace" "namespace" {
  for_each            = var.namespaces
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  namespace_type      = each.value.namespace_type
  sku_name            = each.value.sku_name
  tags                = var.tags
}

resource "azurerm_notification_hub" "hub" {
  for_each            = var.notification_hubs
  name                = each.value.name
  namespace_name      = azurerm_notification_hub_namespace.namespace[each.value.namespace_key].name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_notification_hub_authorization_rule" "rule" {
  for_each              = var.authorization_rules
  name                  = each.value.name
  notification_hub_name = azurerm_notification_hub.hub[each.value.hub_key].name
  namespace_name        = azurerm_notification_hub_namespace.namespace[each.value.namespace_key].name
  resource_group_name   = var.resource_group_name

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage
} 