#!/bin/bash
set -e

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

# Install WireGuard tools
apt-get install -y wireguard-tools

node_major=0
if command -v node >/dev/null 2>&1; then
  node_major="$(node -p 'process.versions.node.split(".")[0]')"
fi

if [ "${node_major}" -lt 18 ]; then
  # Install Node.js LTS (via NodeSource)
  curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
  apt-get install -y nodejs
  node_major="$(node -p 'process.versions.node.split(".")[0]')"
fi

if [ "${node_major}" -lt 18 ]; then
  echo "Node.js 18+ is required, but found $(node --version). Check NodeSource apt setup." >&2
  exit 1
fi

# Enable corepack for pnpm
if ! command -v corepack >/dev/null 2>&1; then
  npm install -g corepack
fi
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
