Deploy using a Bicep template
=============================

## Requirements

* Azure CLI
* [Azure Bicep plug-in](https://github.com/Azure/bicep)

## Usage

* Ensure the bicep plugin in installed and updated.
* Connect (login) to Azure.
* Select the subscription you want to use.
* Deploy the Bicep template

``` sh
az bicep install
az bicep upgrade

az login

az account set --subscription <subscription id>

az deployment sub create -l australiaeast -f main.bicep
```

## Alternative using Azure PowerShell

You can also use Azure PowerShell to deploy a Bicep template, however you need to install the Bicep CLI. For more details see https://docs.microsoft.com/en-gb/azure/azure-resource-manager/bicep/install#azure-powershell

``` pwsh
# Manually install the Bicep CLI

Install-Module -Name Az -Scope CurrentUser -Force

Connect-AzAccount

Set-AzContext -SubscriptionId $SubscriptionId

New-AzDeployment -Location 'australiaeast' -TemplateFile 'main.bicep'
```

## Cleanup

``` pwsh
az group delete --resource-group rg-codefirsttwins-demo-001
```
