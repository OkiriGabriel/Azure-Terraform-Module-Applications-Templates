#!/bin/bash

# Script to import existing notification hub authorization rules into Terraform state

echo "Importing notification hub authorization rules..."

# Import DefaultListenSharedAccessSignature rule
terraform import 'module.notification_hub.azurerm_notification_hub_authorization_rule.rule["default"]' \
  "/subscriptions/0fd19ccc-fcf5-42ff-8046-327b995ea8ee/resourceGroups/example-dev-resource-group/providers/Microsoft.NotificationHubs/namespaces/example-dev-notification-namespace/notificationHubs/example-dev-notification-hub/authorizationRules/DefaultListenSharedAccessSignature"

# Import DefaultFullSharedAccessSignature rule
terraform import 'module.notification_hub.azurerm_notification_hub_authorization_rule.rule["manage"]' \
  "/subscriptions/0fd19ccc-fcf5-42ff-8046-327b995ea8ee/resourceGroups/example-dev-resource-group/providers/Microsoft.NotificationHubs/namespaces/example-dev-notification-namespace/notificationHubs/example-dev-notification-hub/authorizationRules/DefaultFullSharedAccessSignature"

echo "Import completed!" 