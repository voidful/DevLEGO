#!/bin/bash

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh
# Read users
. /opt/legodev/user.sh

screen -S code-server -dm code-server --host 0.0.0.0 --config /opt/legodev/code-server/code-server.yaml
sleep 2
screen -S jupyter-lab -dm jupyter-lab --ip 0.0.0.0 --port ${JUPYTER_LAB_PORT} --allow-root --NotebookApp.token ${PASSWORD} --NotebookApp.password ${PASSWORD}
sleep 2
screen -S jupyter-notebook -dm jupyter-notebook --ip 0.0.0.0 --port ${JUPYTER_NOTEBOOK_PORT} --allow-root --NotebookApp.token ${PASSWORD} --NotebookApp.password ${PASSWORD}
tail -f /dev/null
