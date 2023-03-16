# Build from official Nvidia PyTorch image
# https://ngc.nvidia.com/catalog/containers/nvidia:pytorch
# Tags: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch/tags
FROM nvcr.io/nvidia/pytorch:21.12-py3
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
COPY user.sh .

COPY component/init.sh .
RUN bash ./init.sh

COPY component/ssh.sh .
RUN bash ./ssh.sh

COPY component/code-server.sh .
RUN bash ./code-server.sh

COPY component/jupyter.sh .
RUN bash ./jupyter.sh

WORKDIR /home/
COPY start.sh /opt/legodev/
RUN chmod +x /opt/legodev/start.sh
ENV SHELL=/bin/bash

# set user info
RUN useradd -m $USERNAME
RUN echo $USERNAME:$PASSWORD | chpasswd
RUN usermod -aG root $USERNAME
RUN chsh -s /bin/bash $USERNAME
RUN su - $USERNAME
USER $USERNAME

ENTRYPOINT /opt/legodev/start.sh && /bin/bash