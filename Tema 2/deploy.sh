#!/bin/bash
set -e

RG=tema2-rg
LOCATION=northeurope
PLAN=tema2-plan
APP=tema2-app-$RANDOM
SQLSERVER=tema2sql$RANDOM
DB=itemsdb
ADMINUSER=sqladminuser
ADMINPASS='StrongPassword!123'

az group create -n $RG -l $LOCATION

az appservice plan create \
  -n $PLAN \
  -g $RG \
  --sku F1 \
  --is-linux

az webapp create \
  -n $APP \
  -g $RG \
  -p $PLAN \
  --runtime "NODE:20-lts"

az sql server create \
  -g $RG \
  -n $SQLSERVER \
  -l $LOCATION \
  -u $ADMINUSER \
  -p $ADMINPASS

az sql db create \
  -g $RG \
  -s $SQLSERVER \
  -n $DB \
  --service-objective Basic

az sql server firewall-rule delete \
  -g $RG \
  -s $SQLSERVER \
  -n AllowAllWindowsAzureIps || true

IPS=$(az webapp show -g $RG -n $APP --query outboundIpAddresses -o tsv | tr ',' '\n')

for ip in $IPS; do
  az sql server firewall-rule create \
    -g $RG \
    -s $SQLSERVER \
    -n "app-$ip" \
    --start-ip-address $ip \
    --end-ip-address $ip
done

az webapp config appsettings set \
  -g $RG \
  -n $APP \
  --settings \
  DB_USER=$ADMINUSER \
  DB_PASSWORD=$ADMINPASS \
  DB_SERVER=$SQLSERVER.database.windows.net \
  DB_NAME=$DB

zip -r app.zip .
az webapp deploy \
  -g $RG \
  -n $APP \
  --src-path app.zip

