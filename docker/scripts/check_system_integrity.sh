#!/bin/bash

set -euo pipefail

# source common formatting helpers
source "$(dirname "$0")/lib/formatting.sh"

tmp_log="/tmp/tcpdump_output.log"

log_info "starting network connectivity checks..."

# step 1: basic connectivity
log_info "checking container connectivity..."

# ping from adversary to target
echo "[*] pinging target (172.30.0.3) from adversary..."
docker exec adversary ping -c 3 172.30.0.3
echo

# ping from target to adversary
echo "[*] pinging adversary (172.28.0.4) from target..."
docker exec target ping -c 3 172.28.0.4
echo

log_success "basic network connectivity check complete."

# step 2: suricata traffic visibility
log_info "checking suricata traffic visibility on eth0..."

check_visibility() {
  local source_container=$1
  local destination_ip=$2

  log_info "starting tcpdump inside suricata (listening for icmp)..."
  docker exec suricata timeout 10 tcpdump -i eth0 icmp > "$tmp_log" 2>&1 &
  local tcpdump_pid=$!

  sleep 2  # give tcpdump a moment to start

  log_info "pinging $destination_ip from $source_container..."
  docker exec "$source_container" ping -c 3 "$destination_ip"

  # wait for tcpdump to finish
  wait $tcpdump_pid || {
    exit_code=$?
    if [ "$exit_code" -ne 124 ]; then
      log_error "unexpected tcpdump termination (exit code $exit_code)"
      exit 1
    fi
  }

  # analyze tcpdump output
  if grep -Ei "icmp.*echo request" "$tmp_log"; then
    log_success "suricata detected icmp traffic from $source_container to $destination_ip."
  else
    log_error "suricata did not detect icmp traffic from $source_container to $destination_ip!"
    if [[ "${DEBUG:-0}" == "1" ]]; then
      echo "[debug] tcpdump output:"
      cat "$tmp_log"
    fi
    rm -f "$tmp_log"
    exit 1
  fi

  # optional debug output if DEBUG mode is active
  if [[ "${DEBUG:-0}" == "1" ]]; then
    echo "[debug] tcpdump full output:"
    cat "$tmp_log"
  fi

  rm -f "$tmp_log"
}


# check if traffic is visible to suricata container
check_visibility adversary target.lab

log_success "traffic visibility check complete."

# final success banner
success_banner "All network integrity checks passed!"
