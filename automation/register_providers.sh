#!/bin/bash

echo "Registering Azure providers for Terraform..."

# List of providers to register
PROVIDERS=(
    "Microsoft.App"
    "Microsoft.Storage"
    "Microsoft.KeyVault"
    "Microsoft.Network"
    "Microsoft.NotificationHubs"
    "Microsoft.ContainerRegistry"
    "Microsoft.Web"
    "Microsoft.Cache"
    "Microsoft.OperationalInsights"
    "Microsoft.Insights"
    "Microsoft.CDN"
)

# Register each provider
for provider in "${PROVIDERS[@]}"; do
    echo "Registering $provider..."
    az provider register --namespace "$provider"
done

echo ""
echo "Registration started. Checking status..."

# Wait a moment for registration to start
sleep 10

# Check registration status
for provider in "${PROVIDERS[@]}"; do
    status=$(az provider show --namespace "$provider" --query registrationState --output tsv)
    echo "$provider: $status"
done

echo ""
echo "Note: Registration may take several minutes to complete."
echo "Run 'az provider show --namespace PROVIDER_NAME --query registrationState' to check individual status." 