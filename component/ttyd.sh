#!/bin/bash

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

# Download the binary
VERSION="${TTYD_VERSION}"
curl -L -o /usr/bin/ttyd "https://github.com/tsl0922/ttyd/releases/download/${VERSION}/ttyd.$(uname -m)"
chmod +x /usr/bin/ttyd
