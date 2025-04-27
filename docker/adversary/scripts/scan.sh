#!/bin/bash

TARGET="$1"

if [ -z "$TARGET" ]; then
  echo "Usage: $0 <target-ip>"
  exit 1
fi

echo "Starting Nmap scans against $TARGET..."
echo ""

# 1. TCP SYN Scan (common port scan)
echo "[*] TCP SYN scan (basic ports)"
nmap -sS -T4 -Pn "$TARGET"
echo ""

# 2. TCP Connect Scan
echo "[*] TCP Connect scan"
nmap -sT -T4 -Pn "$TARGET"
echo ""

# 3. UDP Scan
echo "[*] UDP scan (top ports)"
nmap -sU --top-ports 50 -T4 -Pn "$TARGET"
echo " "

# 4. OS Detection
echo "[*] OS detection scan"
nmap -O -T4 -Pn "$TARGET"
echo ""

# 5. Full TCP Port Range Scan
echo "[*] Full TCP port range scan"
nmap -sS -p- -T4 -Pn "$TARGET"
echo ""

# 6. Service Version Detection
echo "[*] Service version detection scan"
nmap -sV -T4 -Pn "$TARGET"
echo ""

# 7. Xmas Tree Scan
echo "[*] Xmas tree scan"
nmap -sX -T4 -Pn "$TARGET"
echo ""

# 8. ACK Scan
echo "[*] ACK scan"
nmap -sA -T4 -Pn "$TARGET"
echo ""

# 9. FIN Scan
echo "[*] FIN scan"
nmap -sF -T4 -Pn "$TARGET"
echo ""

# 10. NULL Scan
echo "[*] NULL scan"
nmap -sN -T4 -Pn "$TARGET"
echo ""

echo "All scans completed."
