output "prometheus_app_name" {
  description = "Name of the Prometheus container app"
  value       = azurerm_container_app.prometheus.name
}

output "prometheus_url" {
  description = "URL of the Prometheus container app"
  value       = "https://${azurerm_container_app.prometheus.ingress[0].fqdn}"
}

output "grafana_app_name" {
  description = "Name of the Grafana container app"
  value       = azurerm_container_app.grafana.name
}

output "grafana_url" {
  description = "URL of the Grafana container app"
  value       = "https://${azurerm_container_app.grafana.ingress[0].fqdn}"
}

output "loki_app_name" {
  description = "Name of the Loki container app"
  value       = azurerm_container_app.loki.name
}

output "loki_url" {
  description = "URL of the Loki container app"
  value       = "https://${azurerm_container_app.loki.ingress[0].fqdn}"
}

output "prometheus_storage_account_name" {
  description = "Name of the Prometheus storage account"
  value       = azurerm_storage_account.prometheus_storage.name
}

output "grafana_storage_account_name" {
  description = "Name of the Grafana storage account"
  value       = azurerm_storage_account.grafana_storage.name
}

output "loki_storage_account_name" {
  description = "Name of the Loki storage account"
  value       = azurerm_storage_account.loki_storage.name
} 