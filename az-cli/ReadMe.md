Deployment using Azure CLI
==========================

## Requirements

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)

## Usage

* Ensure the IoT extension is installed.
* Connect (login) to Azure.
* Select the subscription you want to use.
* Run the script

``` sh
az extension add --name azure-iot

az login

az account set --subscription <subscription id>

sh deploy-infrastructure.sh
```

## Cleanup

``` sh
az group delete --resource-group rg-codefirsttwins-dev-001
```
