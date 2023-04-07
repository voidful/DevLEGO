#!/bin/bash

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

cp /etc/skel/.bashrc /user_data;
cp /etc/skel/.profile /user_data
chown -R $USERNAME:$USERNAME /user_data

mkdir /user_data/.jupyter;
chmod -R 775 /user_data/.jupyter

screen -S code-server -dm code-server --host 0.0.0.0 --config /opt/legodev/code-server/code-server.yaml
sleep 2
screen -S jupyter-lab -dm jupyter-lab --ip 0.0.0.0 --port ${JUPYTER_LAB_PORT} --allow-root --NotebookApp.token ${PASSWORD} --NotebookApp.password ${PASSWORD}
sleep 2
screen -S jupyter-notebook -dm jupyter-notebook --ip 0.0.0.0 --port ${JUPYTER_NOTEBOOK_PORT} --allow-root --NotebookApp.token ${PASSWORD} --NotebookApp.password ${PASSWORD}
sleep 2
screen -S ttyd -dm /usr/bin/ttyd -p ${TTYD_PORT} -c ${USERNAME}:${PASSWORD} bash
tail -f /dev/null
