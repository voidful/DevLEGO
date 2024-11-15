#!/bin/bash

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

sudo chown -R $USERNAME:$USERNAME /user_data
cp /etc/skel/.bashrc /user_data/
cp /etc/skel/.profile /user_data/

sudo chown -R $USERNAME:$USERNAME /opt/legodev
source /opt/legodev/miniconda/etc/profile.d/conda.sh
echo "source /opt/legodev/miniconda/etc/profile.d/conda.sh" >> /user_data/.bashrc
conda init
conda activate base

# Install nb_conda_kernels to allow Jupyter to read Conda environments
conda install -c conda-forge nb_conda_kernels

# Configure Jupyter to recognize all Conda environments under /user_data/miniconda3/envs
export CONDA_ENVS_PATH=/user_data/miniconda3/envs

screen -S code-server -dm code-server --host 0.0.0.0 --config /opt/legodev/code-server/code-server.yaml
sleep 2
screen -S jupyter-lab -dm jupyter-lab --ip 0.0.0.0 --port ${JUPYTER_LAB_PORT} --allow-root --NotebookApp.token=${PASSWORD} --NotebookApp.password=${PASSWORD}
sleep 2
screen -S jupyter-notebook -dm jupyter-notebook --ip 0.0.0.0 --port ${JUPYTER_NOTEBOOK_PORT} --allow-root --NotebookApp.token=${PASSWORD} --NotebookApp.password=${PASSWORD} --NotebookApp.kernel_spec_manager_class=nb_conda_kernels.CondaKernelSpecManager
sleep 2
screen -S ttyd -dm /usr/bin/ttyd -p ${TTYD_PORT} -c ${USERNAME}:${PASSWORD} bash
tail -f /dev/null