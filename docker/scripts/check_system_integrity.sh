#!/bin/bash

# Simple system integrity check for IDS experiment
# Step 1: Verify basic network connectivity (ping tests)

set -e

echo "[*] Starting network connectivity checks..."

# Array of container names
containers=("suricata" "target" "adversary")

# Step 1.1: Ping each container from suricata
for target in "${containers[@]}"; do
  if [ "$target" != "suricata" ]; then
    echo "[*] Pinging $target from suricata..."
    docker exec suricata ping -c 3 "$target"
    echo
  fi
done

# Step 1.2: Ping each container from adversary
for target in "${containers[@]}"; do
  if [ "$target" != "adversary" ]; then
    echo "[*] Pinging $target from adversary..."
    docker exec adversary ping -c 3 "$target"
    echo
  fi
done

# Step 1.3: Ping each container from target
for target in "${containers[@]}"; do
  if [ "$target" != "target" ]; then
    echo "[*] Pinging $target from target..."
    docker exec target ping -c 3 "$target"
    echo
  fi
done

echo "[+] Network connectivity check complete."

# Step 2: Verify Suricata can see network traffic

echo "[*] Checking if Suricata can see traffic on eth0..."

# Step 2.1: Start tcpdump in background inside suricata container
echo "[*] Starting tcpdump..."
docker exec suricata timeout 10 tcpdump -i eth0 icmp &
TCPDUMP_PID=$!

# Step 2.2: Generate traffic: Ping from adversary to target
sleep 2  # give tcpdump 2 seconds to start
echo "[*] Sending ICMP ping from adversary to target..."
docker exec adversary ping -c 3 target

# Step 2.3: Wait for tcpdump to finish
wait $TCPDUMP_PID

echo "[+] Traffic visibility check complete."

