FROM ubuntu:22.04

# Install basic tools: nmap for scanning, curl for HTTP attacks, iproute2 for routing
RUN apt-get update && \
    apt-get install -y nmap nano vim curl iputils-ping iproute2 && \
    apt-get clean

COPY scripts/scan.sh /scripts/scan.sh

RUN chmod +x /scripts/scan.sh
