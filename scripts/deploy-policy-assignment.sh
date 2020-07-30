#!/bin/bash

# Variables
policyAssignmentName="storage-accounts-should-use-a-private-endpoint-policy-assignment"
policyDefinitionName="storage-accounts-should-use-a-private-endpoint-policy-definition"
location="WestEurope"

# ARM template and parameters files
template="../templates/azuredeploy.policy.assignment.json"
parameters="../templates/azuredeploy.policy.assignment.parameters.json"

# SubscriptionId of the current subscription
subscriptionId=$(az account show --query id --output tsv)
subscriptionName=$(az account show --query name --output tsv)
policyScope="/subscriptions/$subscriptionId"

# Check if the policy definition exists
echo "Checking if [$policyDefinitionName] policy definition exists in [$subscriptionName] subscription..."
policyDefinitionId=$(az policy definition show --name $policyDefinitionName --query id --output tsv 2>/dev/null)

if [ -z $policyDefinitionId ]; then
    echo "No [$policyDefinitionName] policy exists in [$subscriptionName] subscription"
    exit
else
    echo "[$policyDefinitionName] policy definition found in [$subscriptionName] subscription"
fi

# Deploy the ARM template
echo "Deploying ["$template"] ARM template in the [$subscriptionName] subscription..."

az deployment sub create \
    --location $location \
    --template-file $template \
    --parameters $parameters \
    --parameters policyDefinitionName=$policyDefinitionName \
                 policyAssignmentName=$policyAssignmentName \
                 policyScope=$policyScope \
    --only-show-errors

if [[ $? == 0 ]]; then
    echo "["$template"] ARM template successfully provisioned in the [$subscriptionName] subscription"
    deploymentName=$(echo $template | awk -F'/' '{print $NF}' | awk -F'.' '{print $1}')
else
    echo "Failed to provision the ["$template"] ARM template in the [$subscriptionName] subscription"
    exit -1
fi