resource "azurerm_redis_cache" "redis" {
  for_each            = var.redis_caches
  name                = lower(each.value.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = each.value.capacity
  family              = each.value.family
  sku_name            = each.value.sku_name
  minimum_tls_version = each.value.minimum_tls_version
  tags                = var.tags

  redis_configuration {
    maxmemory_reserved = each.value.maxmemory_reserved
    maxmemory_delta    = each.value.maxmemory_delta
    maxmemory_policy   = each.value.maxmemory_policy
  }
}

# Network rules for public access (only for Standard and Premium tiers)
resource "azurerm_redis_firewall_rule" "redis_public_access" {
  for_each = {
    for k, v in var.redis_caches : k => v
    if v.sku_name != "Basic"
  }
  name                = "public-access-${each.key}"
  redis_cache_name    = azurerm_redis_cache.redis[each.key].name
  resource_group_name = var.resource_group_name
  start_ip            = "0.0.0.0"
  end_ip              = "255.255.255.255"
}
