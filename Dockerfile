# Build from official Nvidia PyTorch image
# https://ngc.nvidia.com/catalog/containers/nvidia:pytorch
# Tags: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch/tags
FROM nvcr.io/nvidia/mxnet:23.03-py3
#FROM ubuntu

# Disable interactive prompts
ENV DEBIAN_FRONTEND noninteractive
ARG USERNAME
ENV USERNAME=$USERNAME
ARG PASSWORD
ENV PASSWORD=$PASSWORD

# Setup environment
RUN mkdir -p /opt/legodev
WORKDIR /opt/legodev

# Add versions
COPY versions.sh .
COPY ports.sh .

COPY component/init.sh .
RUN bash ./init.sh

COPY component/ssh.sh .
RUN bash ./ssh.sh

COPY component/code-server.sh .
RUN bash ./code-server.sh

COPY component/jupyter.sh .
RUN bash ./jupyter.sh

COPY component/ttyd.sh .
RUN bash ./ttyd.sh

COPY component/conda.sh .
RUN sudo bash ./conda.sh

WORKDIR /home/
ENV SHELL=/bin/bash

# set user info
RUN useradd -m -d /user_data $USERNAME
RUN echo $USERNAME:$PASSWORD | chpasswd
RUN usermod -aG root $USERNAME
RUN adduser $USERNAME sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> \
/etc/sudoers
RUN chsh -s /bin/bash $USERNAME
RUN su - $USERNAME
RUN mkdir -p /user_data
RUN usermod -d /user_data $USERNAME
USER $USERNAME
WORKDIR /user_data
ENTRYPOINT /bin/bash
COPY start.sh /opt/legodev/
RUN sudo chmod +x /opt/legodev/start.sh
ENTRYPOINT /opt/legodev/start.sh && /bin/bash
