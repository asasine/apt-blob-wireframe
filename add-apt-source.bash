#!/bin/bash
source env.bash
cp repo/KEY.asc /etc/apt/keyrings/$REPO_NAME.asc

# TODO: detect arch
cat <<EOF > "/etc/apt/sources.list.d/$REPO_NAME.sources"
Types: deb
URIs: https://$REPO_NAME.blob.core.windows.net/debian
Suites: $SUITE
Components: $COMPONENT
Signed-By: /etc/apt/keyrings/$REPO_NAME.asc
Architectures: all

EOF
