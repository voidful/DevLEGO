#!/bin/bash

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

# Install noVNC
apt install -y xvfb x11vnc novnc net-tools

# Install desktop
# Install XFCE4
apt install -y xfce4 onboard

# Add temporary password
x11vnc -storepasswd changeme /etc/vncsecret

# Set screen resultion
RESOLUTION="1280x720x24"

# Create services
# Create systemd service for Xvfb
cat <<EOT >/usr/lib/systemd/system/xvfb@.service
[Unit]
Description=Xvfb

[Service]
Type=simple
ExecStart=/usr/bin/Xvfb :1 -screen 0 ${RESOLUTION} +iglx
Restart=always
User=%i

[Install]
WantedBy=multi-user.target
EOT

# Create systemd service for XFCE4
cat <<EOT >/usr/lib/systemd/system/desktop@.service
[Unit]
Description=XFCE4

[Service]
Type=simple
ExecStart=/usr/bin/startxfce4
WorkingDirectory=/home/%i
Environment="DISPLAY=:1"
Restart=always
User=%i

[Install]
WantedBy=multi-user.target
EOT

# Create systemd service for x11vnc
cat <<EOT >/usr/lib/systemd/system/x11vnc@.service
[Unit]
Description=x11vnc

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -display :1 -rfbauth /etc/vncsecret@%i -forever
Restart=always
User=%i

[Install]
WantedBy=multi-user.target
EOT

# Create systemd service for noVNC with the listen port set
cat <<EOT >/usr/lib/systemd/system/novnc@.service
[Unit]
Description=noVNC

[Service]
Type=simple
ExecStart=/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen $(NOVNC_PORT)
Restart=always
User=%i

[Install]
WantedBy=multi-user.target
EOT

# Disable LightDM so that it doesn't take over in privileged mode
systemctl disable lightdm
