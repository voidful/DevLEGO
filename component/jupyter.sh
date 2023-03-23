#!/bin/bash

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

# Install pip
apt install -y python3-pip libffi-dev

# Install Node (JupyterLab extensions depend on it)
curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
apt install -y nodejs build-essential

# Install
pip3 install jupyterlab notebook jupyter-server
