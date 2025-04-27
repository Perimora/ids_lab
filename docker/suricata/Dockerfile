FROM ubuntu:22.04

# install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    nano \
    vim \
    tcpdump \
    iputils-ping\
    lsb-release

# install suricata
RUN add-apt-repository ppa:oisf/suricata-stable -y && \
    apt-get update && \
    apt-get install -y suricata suricata-update && \    
    apt-get clean && rm -rf /var/lib/apt/lists/*

# copy suricata config
COPY config/suricata.yaml /etc/suricata/suricata.yaml

# copy custom rules into the container
COPY config/custom.rules /var/lib/suricata/rules/custom.rules