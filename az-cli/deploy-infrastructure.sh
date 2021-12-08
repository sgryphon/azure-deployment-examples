#!/bin/bash

subscription_id=$(az account show --query id --output tsv)
echo "Using context subscription ID $subscription_id"

# Arguments (override with any flags)

app_name=codefirsttwins
org_id="0x$(echo $subscription_id | awk '{print substr($1,0,4)}')"
environment=Dev
location=australiaeast

while getopts a:o:e:l: flag
do
  case "${flag}" in
    a) app_name=${OPTARG};;
    o) org_id=${OPTARG};;
    e) environment=${OPTARG};;
    l) location=${OPTARG};;
  esac
done

# Following standard naming conventions from Azure Cloud Adoption Framework
# https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming

# Include an subscription or organisation identifier (after app name) in global names to make them unique 
rg_name=$(echo "rg-$app_name-$environment-001" | tr '[:upper:]' '[:lower:]')
digital_twins_name=$(echo "dt-$app_name-$org_id-$environment" | tr '[:upper:]' '[:lower:]')
iot_hub_name=$(echo "iot-$app_name-$org_id-$environment" | tr '[:upper:]' '[:lower:]')

# Following standard tagging conventions from  Azure Cloud Adoption Framework
# https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging

tags="WorkloadName=codefirsttwins DataClassification=Non-business Criticality=Low BusinessUnit=Demo ApplicationName=$app_name Env=$environment"

# Create

echo "--dt-name $digital_twins_name --resource-group $rg_name -l $location --tags $tags"

echo "Creating $rg_name"
az group create -g $rg_name -l $location --tags $tags

echo "Creating $digital_twins_name"
az dt create --dt-name $digital_twins_name --resource-group $rg_name -l $location --tags $tags

echo "Creating $iot_hub_name"
az iot hub create --name $iot_hub_name --resource-group $rg_name --sku S1 -l $location --tags $tags

# Output

az dt show --dt-name $digital_twins_name --query hostName --output tsv
az iot hub show --name $iot_hub_name --query properties.hostName --output tsv
