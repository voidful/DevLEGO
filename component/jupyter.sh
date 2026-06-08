#!/bin/bash

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

# Install pip
apt install -y python3-pip libffi-dev

# Install Node (JupyterLab extensions depend on it)
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt install -y nodejs build-essential

# Use uv to install
if ! command -v uv >/dev/null 2>&1; then
  echo "uv is required but was not found in PATH. component/init.sh should install it to /usr/local/bin." >&2
  exit 1
fi

uv pip install --system jupyterlab notebook jupyter-server ipykernel
