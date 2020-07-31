#!/bin/bash

# Variables
resourceGroupName="BlobPrivateEndpointRG"
storageAccountName="fufosbootdiaglogs"
apiVersion="2019-06-01"

# SubscriptionId of the current subscription
subscriptionId=$(az account show --query id --output tsv)
subscriptionName=$(az account show --query name --output tsv)

# Get storage account via REST API
armclient get "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageAccountName?api-version=$apiVersion"