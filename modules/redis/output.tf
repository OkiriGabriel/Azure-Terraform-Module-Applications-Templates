output "redis_hostname" {
  description = "The hostname of the Redis Cache"
  value       = { for k, v in azurerm_redis_cache.redis : k => v.hostname }
}

output "redis_ssl_port" {
  description = "The SSL port of the Redis Cache"
  value       = { for k, v in azurerm_redis_cache.redis : k => v.ssl_port }
}

output "redis_port" {
  description = "The non-SSL port of the Redis Cache"
  value       = { for k, v in azurerm_redis_cache.redis : k => v.port }
}

output "redis_primary_access_key" {
  description = "The primary access key for the Redis Cache"
  value       = { for k, v in azurerm_redis_cache.redis : k => v.primary_access_key }
  sensitive   = true
}

output "redis_secondary_access_key" {
  description = "The secondary access key for the Redis Cache"
  value       = { for k, v in azurerm_redis_cache.redis : k => v.secondary_access_key }
  sensitive   = true
}

output "redis_id" {
  description = "The ID of the Redis Cache"
  value       = { for k, v in azurerm_redis_cache.redis : k => v.id }
}
