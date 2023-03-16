#!/bin/bash

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh
# Read users
. /opt/legodev/user.sh

VERSION="${CODE_SERVER_VERSION}"
curl -fsSL https://code-server.dev/install.sh | sh -s -- --version "${VERSION}"

# Change the listen port
mkdir -p /opt/legodev/code-server
CONFIG_FILE=/opt/legodev/code-server/code-server.yaml
cat <<EOT >$CONFIG_FILE
bind-addr: 0.0.0.0:${CODE_SERVER_PORT}
auth: password
password: ${PASSWORD}
EOT
