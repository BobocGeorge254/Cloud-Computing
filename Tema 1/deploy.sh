#!/bin/bash

# ---------- CONFIGURATION ----------
RESOURCE_GROUP="static-web-rg"
LOCATION="westeurope"
STORAGE_ACCOUNT="aviationweb$RANDOM"
SOURCE_DIR="./website"

echo "🚀 Creating Azure resources..."

# Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create storage account
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2

# Enable static website hosting
az storage blob service-properties update \
  --account-name $STORAGE_ACCOUNT \
  --static-website \
  --index-document index.html

# Upload website files
az storage blob upload-batch \
  --account-name $STORAGE_ACCOUNT \
  -s $SOURCE_DIR \
  -d '$web'

# Get URL
WEB_URL=$(az storage account show \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --query "primaryEndpoints.web" -o tsv)

echo ""
echo "--------------------------------------"
echo "🎉 Deployment complete!"
echo "🌍 Website URL: $WEB_URL"
echo "--------------------------------------"

