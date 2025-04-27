#!/bin/sh

set -e

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
