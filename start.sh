#!/bin/bash

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

sudo chown -R "${USERNAME}:${USERNAME}" /user_data
cp /etc/skel/.bashrc /user_data/
cp /etc/skel/.profile /user_data/

sudo chown -R "${USERNAME}:${USERNAME}" /opt/legodev
sudo chown -R "${USERNAME}:${USERNAME}" /opt/legodev


# Activate uv environment
source /user_data/.venv/bin/activate
echo "source /user_data/.venv/bin/activate" >> /user_data/.bashrc

# Register the kernel for Jupyter
python -m ipykernel install --user --name=python-uv --display-name "Python (uv)"








# Default to true if not set
ENABLE_CODE_SERVER=${ENABLE_CODE_SERVER:-true}
ENABLE_JUPYTER_LAB=${ENABLE_JUPYTER_LAB:-true}
ENABLE_JUPYTER_NOTEBOOK=${ENABLE_JUPYTER_NOTEBOOK:-true}
ENABLE_TTYD=${ENABLE_TTYD:-true}
ENABLE_WG_EASY=${ENABLE_WG_EASY:-true}

if [ "$ENABLE_CODE_SERVER" = "true" ]; then
    screen -S code-server -dm code-server --host 0.0.0.0 --config /opt/legodev/code-server/code-server.yaml
fi
sleep 2

if [ "$ENABLE_JUPYTER_LAB" = "true" ]; then
    screen -S jupyter-lab -dm jupyter-lab --ip 0.0.0.0 --port "${JUPYTER_LAB_PORT}" --allow-root --NotebookApp.token="${PASSWORD}" --NotebookApp.password="${PASSWORD}"
fi
sleep 2

if [ "$ENABLE_JUPYTER_NOTEBOOK" = "true" ]; then
    screen -S jupyter-notebook -dm jupyter-notebook --ip 0.0.0.0 --port "${JUPYTER_NOTEBOOK_PORT}" --allow-root --NotebookApp.token="${PASSWORD}" --NotebookApp.password="${PASSWORD}"
fi

sleep 2

if [ "$ENABLE_TTYD" = "true" ]; then
    screen -S ttyd -dm /usr/bin/ttyd -p "${TTYD_PORT}" -c "${USERNAME}:${PASSWORD}" bash
fi

if [ "$ENABLE_WG_EASY" = "true" ]; then
    cd /opt/legodev/wg-easy
    screen -S wg-easy -dm node src/index.js
fi
tail -f /dev/null

