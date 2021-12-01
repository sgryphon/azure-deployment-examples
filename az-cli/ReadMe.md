Deployment using Azure CLI
==========================

Requirements:

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)


TODO: Write this as a shell script / command script.

``` sh
az login
az account set --subscription "<your-Azure-subscription-ID>"
```


```
az group create --location <region> --name <name-for-your-resource-group>
az dt create --dt-name <name-for-your-Azure-Digital-Twins-instance> --resource-group <your-resource-group> --location <region>
az dt show --dt-name <your-Azure-Digital-Twins-instance>.

az iot hub create --name <name-for-your-IoT-hub> --resource-group <your-resource-group> --sku S1
```

