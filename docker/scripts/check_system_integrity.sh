#!/bin/bash

# improved system integrity check for ids experiment
# verifies bidirectional pings and traffic visibility via suricata

set -euo pipefail

tmp_log="/tmp/tcpdump_output.log"

echo "[*] starting network connectivity checks..."

# step 1: basic connectivity (ping each container to target)
echo "[*] checking container connectivity..."

# ping from adversary to target
echo "[*] pinging target (172.30.0.3) from adversary..."
docker exec adversary ping -c 3 172.30.0.3
echo

# ping from target to adversary
echo "[*] pinging adversary (172.28.0.4) from target..."
docker exec target ping -c 3 172.28.0.4
echo

echo "[+] basic network connectivity check complete."

# step 2: suricata traffic visibility check
echo "[*] checking suricata traffic visibility on eth0..."

check_visibility() {
  local source_container=$1
  local destination_ip=$2

  echo "[*] starting tcpdump inside suricata (listening for icmp)..."
  docker exec suricata timeout 10 tcpdump -i eth0 icmp > "$tmp_log" 2>&1 &
  local tcpdump_pid=$!

  sleep 2  # give tcpdump a moment to start

  echo "[*] pinging $destination_ip from $source_container..."
  docker exec "$source_container" ping -c 3 "$destination_ip"

  # wait for tcpdump to finish
  wait $tcpdump_pid || {
    exit_code=$?
    if [ "$exit_code" -ne 124 ]; then
      echo "[!] unexpected tcpdump termination (exit code $exit_code)"
      exit 1
    fi
  }

  # analyze tcpdump output
  if grep -q "icmp echo request" "$tmp_log"; then
    echo "[+] suricata detected icmp traffic from $source_container to $destination_ip."
  else
    echo "[!] suricata did not detect icmp traffic from $source_container to $destination_ip!"
    if [[ "${DEBUG:-0}" == "1" ]]; then
      echo "[debug] tcpdump output:"
      cat "$tmp_log"
    fi
    rm -f "$tmp_log"
    exit 1
  fi

  rm -f "$tmp_log"
}

# check both directions
check_visibility adversary 172.30.0.3
check_visibility target 172.28.0.4

echo "[+] traffic visibility check complete."
