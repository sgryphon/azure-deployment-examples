#!/usr/bin/env pwsh

<# .SYNOPSIS
  Deploy the Azure infrastructure. #>
[CmdletBinding()]
param (
    ## Name of the application, workload, or service that the resource is a part of.
    [string]$AppName = 'codefirsttwins',
    ## Identifier for the organisation or subscription to make global names unique.
    [string]$OrgId = "0x$((Get-AzContext).Subscription.Id.Substring(0,4))",
    ## Deployment environment, e.g. Prod, Dev, QA, Stage, Test.
    [string]$Environment = 'Dev',
    ## The Azure region where the resource is deployed.
    [string]$Location = 'australiaeast'
)

# Pre-requisites:
#
# Running these scripts requires the following to be installed:
# * PowerShell, https://github.com/PowerShell/PowerShell
# * Azure PowerShell module, https://docs.microsoft.com/en-us/powershell/azure/install-az-ps
#     Install-Module -Name Az -Scope CurrentUser -Force
# * Azure Digital Twins module (preview installed separately)
#     Install-Module -Name Az.DigitalTwins -Scope CurrentUser -Force
#     Register-AzResourceProvider -ProviderNamespace Microsoft.DigitalTwins
#
# You also need to authenticate and set subscription you are using:
#  Connect-AzAccount
#  Set-AzContext -SubscriptionId $SubscriptionId
#
# To see messages, set verbose preference before running:
#   $VerbosePreference = 'Continue'
#   ./deploy-infrastructure.ps1

$ErrorActionPreference="Stop"

$SubscriptionId = (Get-AzContext).Subscription.Id
Write-Verbose "Using context subscription ID $SubscriptionId"

# Following standard naming conventions from Azure Cloud Adoption Framework
# https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
# With an additional organisation or subscription identifier (after app name) in global names to make them unique 

$ResourceGroupName = "rg-$AppName-$Environment-001".ToLowerInvariant()
$DigitalTwinsName = "dt-$AppName-$OrgId-$Environment".ToLowerInvariant()
$IotHubName = "iot-$AppName-$OrgId-$Environment".ToLowerInvariant()

# Following standard tagging conventions from  Azure Cloud Adoption Framework
# https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging

$Tag = @{ WorkloadName = 'codefirsttwins'; DataClassification = 'Non-business'; Criticality = 'Low';
  BusinessUnit = 'Demo'; ApplicationName = $AppName; Env = $Environment }

# Create

New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Tag $Tag -Force

New-AzDigitalTwinsInstance -ResourceGroupName $ResourceGroupName -ResourceName $DigitalTwinsName -Location $Location -Tag $Tag

New-AzIotHub -ResourceGroupName $ResourceGroupName -Name $IotHubName -SkuName S1 -Units 1 -Location $Location -Tag $Tag

# Output

(Get-AzDigitalTwinsInstance -ResourceGroupName $ResourceGroupName -ResourceName $DigitalTwinsName).HostName
(Get-AzIotHub $ResourceGroupName).Properties.HostName

