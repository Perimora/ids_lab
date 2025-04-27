FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y dnsmasq \
    dnsutils &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 53

CMD ["dnsmasq", "--no-daemon", "--conf-file=/etc/dnsmasq.d/00-lab.conf"]
