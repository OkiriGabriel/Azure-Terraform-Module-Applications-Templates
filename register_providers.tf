# Register Microsoft.App provider for Container Apps
resource "azurerm_resource_provider_registration" "microsoft_app" {
  name = "Microsoft.App"
} 