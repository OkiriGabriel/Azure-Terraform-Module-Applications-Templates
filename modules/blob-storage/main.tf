resource "azurerm_storage_account" "storage" {
  for_each                        = var.storage_accounts
  name                            = lower(each.value.name)
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = each.value.account_tier
  account_replication_type        = each.value.account_replication_type
  account_kind                    = each.value.account_kind
  access_tier                     = each.value.access_tier
  min_tls_version                 = each.value.min_tls_version
  allow_nested_items_to_be_public = each.value.allow_nested_items_to_be_public

  blob_properties {
    dynamic "container_delete_retention_policy" {
      for_each = each.value.container_delete_retention_policy != null ? [each.value.container_delete_retention_policy] : []
      content {
        days = container_delete_retention_policy.value.days
      }
    }

    dynamic "delete_retention_policy" {
      for_each = each.value.delete_retention_policy != null ? [each.value.delete_retention_policy] : []
      content {
        days = delete_retention_policy.value.days
      }
    }
  }

  network_rules {
    default_action             = each.value.network_rules.default_action
    ip_rules                   = each.value.network_rules.ip_rules
    virtual_network_subnet_ids = each.value.network_rules.virtual_network_subnet_ids
    bypass                     = each.value.network_rules.bypass
  }

  tags = var.tags
}

resource "azurerm_storage_container" "containers" {
  for_each              = var.containers
  name                  = each.value.name
  storage_account_id    = azurerm_storage_account.storage[each.value.storage_account_key].id
  container_access_type = each.value.container_access_type

  # Metadata is not supported in this version, removing for now
  # dynamic "metadata" {
  #   for_each = each.value.metadata != null ? each.value.metadata : {}
  #   content {
  #     name  = metadata.key
  #     value = metadata.value
  #   }
  # }
}

# CDN Profile - Commented out as Azure CDN from Microsoft (classic) no longer supports new profile creation
# resource "azurerm_cdn_profile" "profile" {
#   for_each            = var.cdn_profiles
#   name                = each.value.name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   sku                 = each.value.sku
#   tags                = var.tags
# }

# CDN Endpoint - Commented out as Azure CDN from Microsoft (classic) no longer supports new profile creation
# resource "azurerm_cdn_endpoint" "endpoint" {
#   for_each            = var.cdn_endpoints
#   name                = each.value.name
#   profile_name        = azurerm_cdn_profile.profile[each.value.profile_key].name
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   origin {
#     name       = each.value.origin_name
#     host_name  = azurerm_storage_account.storage[each.value.storage_account_key].primary_blob_host
#   }

#   optimization_type = each.value.optimization_type

#   # CDN rules are not supported in this version, removing for now
#   # dynamic "rule" {
#   #   for_each = each.value.rules != null ? each.value.rules : []
#   #   content {
#   #     name = rule.value.name
#   #     order = rule.value.order
#   #     
#   #     dynamic "cache_expiration_action" {
#   #       for_each = rule.value.cache_expiration_action != null ? [rule.value.cache_expiration_action] : []
#   #       content {
#   #         behavior = cache_expiration_action.value.behavior
#         duration = cache_expiration_action.value.duration
#       }
#     }
#   }
# }

#   tags = var.tags
# } 