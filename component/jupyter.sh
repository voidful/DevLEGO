#!/bin/bash
set -e

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

# Install pip
apt-get install -y python3-pip libffi-dev

# Install Node (JupyterLab extensions depend on it)
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs build-essential

node_major="$(node -p 'process.versions.node.split(".")[0]')"
if [ "${node_major}" -lt 18 ]; then
  echo "Node.js 18+ is required, but found $(node --version). Check NodeSource apt setup." >&2
  exit 1
fi

# Use uv to install
if ! command -v uv >/dev/null 2>&1; then
  echo "uv is required but was not found in PATH. component/init.sh should install it to /usr/local/bin." >&2
  exit 1
fi

uv pip install --system jupyterlab notebook jupyter-server ipykernel
