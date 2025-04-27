#!/bin/sh

# reset and set new default gateway
ip route del default
ip route add default via 172.30.0.5

# start required services
service ssh start
service nginx start

# keep container running
sleep infinity
