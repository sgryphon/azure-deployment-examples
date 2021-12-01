Deployment using Azure PowerShell
=================================

Deploy using a Bicep template
=============================

Requirements:

* Azure CLI (to trigger the deployment)

Usage:

* Connect (login) to Azure.
* Select the subscription you want to use.
* Deploy the Bicep template

```sh
az login
az account set --subscription <subscription id>
az deployment sub create -l australiaeast -f main.bicep
```

Cleanup (requires PowerShell):

```pwsh
../powershell/remove-infrastructure.ps1
```

Alternative, using Azure PowerShell to trigger deployment:

```pwsh
Install-Module -Name Az -Scope CurrentUser -Force

Connect-AzAccount

Set-AzContext -SubscriptionId $SubscriptionId

New-AzDeployment -Location 'australiaeast' -TemplateFile 'main.bicep'
```

TODO: Deploy using bicep
