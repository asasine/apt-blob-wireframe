#!/bin/bash
source env.bash
cp repo/KEY.asc /etc/apt/keyrings/$REPO_NAME.asc

# TODO: detect arch
echo "deb [arch=all] https://$REPO_NAME.blob.core.windows.net/debian $(lsb_release -cs) unstable" > "/etc/apt/sources.list.d/$REPO_NAME.list"
