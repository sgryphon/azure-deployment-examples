Deploy using an Azure Resource Manager (ARM) template
=====================================================

## Requirements

* [PowerShell](https://github.com/PowerShell/PowerShell) (latest, e.g. 7.2), cross platform
  * OR PowerShell 5, and manually remove AzureRm module and install Az.
* [Azure Powershell module](https://docs.microsoft.com/en-us/powershell/azure/)

## Usage

* Ensure the Az module is installed.
* Connect (login) to Azure.
* Select the subscription you want to use.
* Deploy the ARM template

``` pwsh
Install-Module -Name Az -Scope CurrentUser -Force

Connect-AzAccount

Set-AzContext -SubscriptionId $SubscriptionId

New-AzDeployment -Location 'australiaeast' -TemplateFile 'demoDeployment.json'
```

## Cleanup

``` pwsh
../powershell/remove-infrastructure.ps1
```
