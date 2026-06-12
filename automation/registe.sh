#!/bin/bash

# Array of providers we need
providers=(
    "Microsoft.Network"
    "Microsoft.Storage"
    "Microsoft.Compute"
    "Microsoft.KeyVault"
    "Microsoft.Monitor"
    "Microsoft.OperationalInsights"
    "Microsoft.OperationsManagement"
    "Microsoft.Security"
    "Microsoft.Insights"
    "Microsoft.ContainerService"
    "Microsoft.ManagedIdentity"
    "Microsoft.Authorization"
    "Microsoft.CertificateRegistration"
    "Microsoft.AAD"
    "Microsoft.ServiceBus"
    "Microsoft.EventHub"
    "Microsoft.Web"
    "Microsoft.DBforPostgreSQL"
    "Microsoft.DocumentDB"
    "Microsoft.Cache"
)

# Print current Azure subscription
echo "Current Azure Subscription:"
az account show --query name -o tsv

# Register each provider
for provider in "${providers[@]}"
do
    echo "Registering provider: $provider"
    az provider register --namespace $provider
done

# Function to check registration status
check_status() {
    echo "Checking registration status..."
    for provider in "${providers[@]}"
    do
        status=$(az provider show --namespace $provider --query registrationState -o tsv)
        echo "$provider: $status"
    done
}

# Initial status check
check_status

echo "Waiting for registrations to complete (this may take a few minutes)..."
sleep 30

# Final status check
check_status

echo "Provider registration process completed!"