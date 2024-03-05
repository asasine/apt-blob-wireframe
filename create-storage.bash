#!/bin/bash
source env.bash
az account show 2>&1 >/dev/null || az login
az group create --name $REPO_NAME --location eastus
az storage account create --name $REPO_NAME --resource-group $REPO_NAME --location eastus --sku Standard_LRS \
    --allow-blob-public-access --enable-hierarchical-namespace --https-only --min-tls-version TLS1_2
