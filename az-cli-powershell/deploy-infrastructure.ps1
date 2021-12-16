#!/usr/bin/env pwsh

<# .SYNOPSIS
  Deploy the Azure infrastructure. #>
[CmdletBinding()]
param (
    ## Identifier for the organisation or subscription to make global names unique.
    [string]$OrgId = "0x$((Get-AzContext).Subscription.Id.Substring(0,4))",
    ## Deployment environment, e.g. Prod, Dev, QA, Stage, Test.
    [string]$Environment = 'Dev',
    ## The Azure region where the resource is deployed.
    [string]$Location = 'australiaeast'
)

# Pre-requisites:

# Running these scripts requires the following to be installed:
#  * PowerShell, https://github.com/PowerShell/PowerShell
#  * Azure CLI, https://docs.microsoft.com/en-us/cli/azure/
#
# To run:
#   az extension add --name azure-iot
#   az login
#   az account set --subscription <subscription id>
#   $VerbosePreference = 'Continue'
#   ./deploy-infrastructure.ps1

$ErrorActionPreference="Stop"

$SubscriptionId = (Get-AzContext).Subscription.Id
Write-Verbose "Using context subscription ID $SubscriptionId"

# Following standard naming conventions from Azure Cloud Adoption Framework
# https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
# With an additional organisation or subscription identifier (after app name) in global names to make them unique 

$appName = 'codefirsttwins'

$rgName = "rg-$appName-$Environment-001".ToLowerInvariant()
$dtName = "dt-$appName-$OrgId-$Environment".ToLowerInvariant()
$iotName = "iot-$appName-$OrgId-$Environment".ToLowerInvariant()

# Following standard tagging conventions from  Azure Cloud Adoption Framework
# https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging

$TagDictionary = @{ WorkloadName = 'codefirsttwins'; DataClassification = 'Non-business'; Criticality = 'Low';
  BusinessUnit = 'Demo'; ApplicationName = $appName; Env = $Environment }

# Create

Write-Host "Creating group $rgName"

# Convert dictionary to tags format used by Azure CLI create command
$tags = $TagDictionary.Keys | ForEach-Object { $key = $_; "$key=$($TagDictionary[$key])" }
az group create -g $rgName -l $location --tags $tags

Write-Host "Creating digital twins $dtName"

# Convert tags returned from JSON result to the format used by Azure CLI create command
$rg = az group show --name $rgName | ConvertFrom-Json
$rgTags = $rg.tags | Get-Member -MemberType NoteProperty | ForEach-Object { "$($_.Name)=$($rg.tags.$($_.Name))" }

az dt create --dt-name $dtName --resource-group $rgName -l $rg.location --tags $rgTags

Write-Host "Creating IoT hub $iotName"

az iot hub create --name $iotName --resource-group $rgName --sku S1 -l $rg.location --tags $rgTags

# Output

az dt show --dt-name $dtName --query hostName --output tsv
az iot hub show --name $iotName --query properties.hostName --output tsv
