FROM ubuntu:24.04

# install basic tools
RUN apt-get update && apt-get install -y \
    sudo \
    iproute2 \
    iputils-ping \
    iptables \
    tcpdump \
    nano \
    vim \
    && apt-get clean

# Copy setup script into container
COPY scripts/tc_init.sh /tmp/tc_init.sh
RUN chmod +x /tmp/tc_init.sh

# keep container alive
CMD ["sh", "-c", "sleep infinity"]
