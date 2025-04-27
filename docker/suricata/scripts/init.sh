#!/bin/sh

# update suricata rules and start suricata
suricata-update
suricata -i eth0 -c /etc/suricata/suricata.yaml -v
