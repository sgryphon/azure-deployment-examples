Deploy using Azure PowerShell
=============================

Requirements:

* [PowerShell](https://github.com/PowerShell/PowerShell) (latest, e.g. 7.2), cross platform
  * OR PowerShell 5, and manually remove AzureRm module and install Az.
* [Azure Powershell module](https://docs.microsoft.com/en-us/powershell/azure/)

Usage:

* Ensure the Az is installed.
* As Digital Twins is currently in preview, it needs to be installed as a separate module, and added as a resource provider.
* Connect (login) to Azure.
* Select the subscription you want to use.
* Run the script.

```pwsh
Install-Module -Name Az -Scope CurrentUser -Force
Install-Module -Name Az.DigitalTwins -Scope CurrentUser -Force
Register-AzResourceProvider -ProviderNamespace Microsoft.DigitalTwins

Connect-AzAccount

Set-AzContext -SubscriptionId $SubscriptionId

./deploy-infrastructure.ps1
```

Cleanup:

```pwsh
./remove-infrastructure.ps1
```
