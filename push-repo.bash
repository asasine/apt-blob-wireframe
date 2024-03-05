#!/bin/bash
source env.bash
az account show 2>&1 >/dev/null || az login
container=debian
az storage container create --name $container --public-access blob --account-name $REPO_NAME --auth-mode login
az storage blob upload-batch --account-name $REPO_NAME --destination $container --source repo/ --auth-mode login
