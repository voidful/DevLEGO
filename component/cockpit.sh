#!/bin/bash

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

# Install Cockpit
apt install -y cockpit

# Change the listen port
mkdir -p /etc/systemd/system/cockpit.socket.d
cat <<EOT >/etc/systemd/system/cockpit.socket.d/listen.conf
[Socket]
ListenStream=
ListenStream=${COCKPIT_PORT}
EOT

# Enable CORS
cat <<EOT >/etc/cockpit/cockpit.conf
[WebService]
AllowUnencrypted = true
Origins = http://0.0.0.0:${COCKPIT_PORT}
EOT
