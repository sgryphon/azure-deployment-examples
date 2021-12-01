Deploy using an Azure Resource Manager (ARM) template
=====================================================

Requirements:

* PowerShell (latest, e.g. 7.2)
* OR PowerShell 5, and manually remove AzureRm module and install Az.

Usage:

* Ensure the Az module is installed.
* Connect (login) to Azure.
* Select the subscription you want to use.
* Deploy the ARM template

```pwsh
Install-Module -Name Az -Scope CurrentUser -Force

Connect-AzAccount

Set-AzContext -SubscriptionId $SubscriptionId

New-AzDeployment -Location 'australiaeast' -TemplateFile 'demoDeployment.json'
```

Cleanup:

```pwsh
../powershell/remove-infrastructure.ps1
```
