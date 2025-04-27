#!/bin/sh

set -e

# ensure IP forwarding
sysctl -w net.ipv4.ip_forward=1

echo "[*] Cleaning existing tc rules (if any)..."

# clean existing qdiscs (if present)
tc qdisc del dev eth0 ingress 2>/dev/null || true
tc qdisc del dev eth1 ingress 2>/dev/null || true

echo "[*] Setting up tc-mirrored TAP on eth0 and eth1 to eth2..."

# setup ingress qdisc
tc qdisc add dev eth0 ingress
tc qdisc add dev eth1 ingress

# setup mirroring filter
tc filter add dev eth0 parent ffff: protocol ip u32 match u32 0 0 action mirred egress mirror dev eth2
tc filter add dev eth1 parent ffff: protocol ip u32 match u32 0 0 action mirred egress mirror dev eth2

echo "[*] tc-mirrored TAP setup complete."

# enable masquerading for outgoing traffic on external-net
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# specific nat rules for dns requests (udp and tcp port 53)
iptables -t nat -A PREROUTING -i eth1 -p udp --dport 53 -j DNAT --to-destination 172.28.0.53:53
iptables -t nat -A PREROUTING -i eth2 -p udp --dport 53 -j DNAT --to-destination 172.28.0.53:53

iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 53 -j DNAT --to-destination 172.28.0.53:53
iptables -t nat -A PREROUTING -i eth2 -p tcp --dport 53 -j DNAT --to-destination 172.28.0.53:53

echo "[+] gateway initialization complete."