FROM ubuntu:22.04

# install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    iproute2 \
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

# copy init script
COPY scripts/init.sh scripts/init.sh
RUN chmod +x scripts/init.sh

# copy custom rules into the container
COPY config/custom.rules /var/lib/suricata/rules/custom.rules