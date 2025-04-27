FROM ubuntu:25.04

# non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# basic packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        wget \
        git \
        nano \
        vim \
        ca-certificates \
        sudo \
        openssl\
        python3 \
        python3.13-venv \
        python3-pip \
        pkg-config \
        libtool \
        libpcap-dev \
        libfixbuf-dev \
        libxml2-dev \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# clone and build yaf from source
WORKDIR /tmp
RUN wget https://tools.netsa.cert.org/releases/yaf-2.14.0.tar.gz && \
    tar -xzf yaf-2.14.0.tar.gz && \
    cd yaf-2.14.0 && \
    ./configure && \
    make && \
    make install && \
    ldconfig && \
    cd .. && rm -rf yaf-2.14.0 yaf-2.14.0.tar.gz

ENTRYPOINT [ "/bin/bash" ]
