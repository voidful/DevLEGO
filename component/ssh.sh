#!/bin/bash

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

# Install OpenSSH server
apt install -y openssh-server

# Enable TCP forwarding
sed -i 's/#AllowTcpForwarding no/AllowTcpForwarding yes/g' /etc/ssh/sshd_config

# Change listen port to 38005
sed -i 's/#Port 22/Port ${SSH_PORT}/g' /etc/ssh/sshd_config

# Only listen on loopback
sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 127.0.0.1/g' /etc/ssh/sshd_config


## Add the user's SSH keys to authorized_keys
#CONFIG_DIR=/root/.ssh
#mkdir -m 700 -p ${CONFIG_DIR}
#curl -L "${POJDE_SSH_KEY_URL}" | tee ${CONFIG_DIR}/authorized_keys
#chmod 600 ${CONFIG_DIR}/authorized_keys
#
## Enable & restart the services
#if [ "${POJDE_OPENRC}" = 'true' ]; then
#  rc-service dropbear restart
#  rc-update add dropbear default
#fi
