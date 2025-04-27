#!/bin/bash

# color codes
COLOR_RESET="\033[0m"
COLOR_GREEN="\033[32m"
COLOR_RED="\033[31m"
COLOR_YELLOW="\033[33m"

# simple log helpers
log_info() {
  echo -e "${COLOR_YELLOW}[*] $1${COLOR_RESET}"
}

log_success() {
  echo -e "${COLOR_GREEN}[+] $1${COLOR_RESET}"
}

log_error() {
  echo -e "${COLOR_RED}[!] $1${COLOR_RESET}"
}

# success banner
success_banner() {
  echo -e "${COLOR_GREEN}"
  echo "============================================"
  echo " ✅  $1 ✅ "
  echo "============================================"
  echo -e "${COLOR_RESET}"
}
