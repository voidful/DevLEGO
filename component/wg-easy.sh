#!/bin/bash
set -e

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

# Install WireGuard tools
apt-get install -y wireguard-tools

# Install Node.js LTS (via NodeSource)
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

# Enable corepack for pnpm
corepack enable

# Clone wg-easy repository
cd /opt/legodev
git clone https://github.com/wg-easy/wg-easy.git
cd wg-easy

# Install dependencies
pnpm install

# Build the application
pnpm build

# Create configuration directory
mkdir -p /etc/wireguard

echo "wg-easy installation completed"
