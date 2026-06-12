#!/bin/bash

# Set your subscription and resource group
SUBSCRIPTION_ID="your-subscription-id"
RESOURCE_GROUP="your-resource-group-name"

echo "Importing Azure resources into Terraform state..."

# Get resource IDs
echo "Getting resource IDs..."

# Container Apps
CONTAINER_APPS=$(az containerapp list --resource-group $RESOURCE_GROUP --query "[].{name:name, id:id}" --output table)
echo "Container Apps:"
echo "$CONTAINER_APPS"

# Storage Accounts
STORAGE_ACCOUNTS=$(az storage account list --resource-group $RESOURCE_GROUP --query "[].{name:name, id:id}" --output table)
echo "Storage Accounts:"
echo "$STORAGE_ACCOUNTS"

# Key Vaults
KEY_VAULTS=$(az keyvault list --resource-group $RESOURCE_GROUP --query "[].{name:name, id:id}" --output table)
echo "Key Vaults:"
echo "$KEY_VAULTS"

# Virtual Networks
VNETS=$(az network vnet list --resource-group $RESOURCE_GROUP --query "[].{name:name, id:id}" --output table)
echo "Virtual Networks:"
echo "$VNETS"

# Container Registries
ACRS=$(az acr list --resource-group $RESOURCE_GROUP --query "[].{name:name, id:id}" --output table)
echo "Container Registries:"
echo "$ACRS"

# App Services
APP_SERVICES=$(az webapp list --resource-group $RESOURCE_GROUP --query "[].{name:name, id:id}" --output table)
echo "App Services:"
echo "$APP_SERVICES"

# Redis Caches
REDIS_CACHES=$(az redis list --resource-group $RESOURCE_GROUP --query "[].{name:name, id:id}" --output table)
echo "Redis Caches:"
echo "$REDIS_CACHES"

echo ""
echo "Use the IDs above to run terraform import commands."
echo "Example: terraform import module.blob_storage.azurerm_storage_account.storage[\"main\"] /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/STORAGE_NAME" 