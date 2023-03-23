#!/bin/bash

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

# Download the binary
VERSION="${TTYD_VERSION}"
curl -L -o /usr/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/${VERSION}/ttyd.$(uname -m)
chmod +x /usr/bin/ttyd

cat <<EOT >/usr/lib/systemd/system/ttyd@.service
[Unit]
Description=ttyd

[Service]
Type=simple
EnvironmentFile=/opt/legodev/ttyd/env
ExecStart=/usr/bin/ttyd -i lo -p $(TTYD_PORT) -c \${USERNAME_PASSWORD} bash
WorkingDirectory=/home/%i
Restart=always
User=%i

[Install]
WantedBy=multi-user.target
EOT
