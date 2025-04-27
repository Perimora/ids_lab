FROM ubuntu:22.04

# install basic packages
RUN apt-get update && apt-get install -y \
    iputils-ping \
    netcat \
    openssh-server \
    nginx \
    nano \
    vim \
    iputils-ping \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# SSH Config (damit Port 22 offen ist)
RUN mkdir /var/run/sshd

# expose Ports (22 = SSH, 80 = HTTP, 443 = HTTPS)
EXPOSE 22 80 443

# copy init script
COPY scripts/init.sh scripts/init.sh
RUN chmod +x scripts/init.sh

# start SSH and Nginx in the background, then keep container alive
CMD ["sh", "-c", "service ssh start && service nginx start && tail -f /dev/null"]

