#!/bin/sh

# configure dns server
echo 'nameserver 172.28.0.53' > /etc/resolv.conf

# configure routing
ip route add 172.30.0.0/24 via 172.28.0.5 dev eth0

# keep container running
sleep infinity
