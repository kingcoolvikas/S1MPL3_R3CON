#!/bin/bash

# Check if domains.txt exists
if [ ! -f domains.txt ]; then
  echo "[-] domains.txt not found!"
  exit 1
fi

echo "[*] Starting anonymous FTP check on domains listed in domains.txt"

while read -r TARGET; do
  # Skip empty lines
  if [ -z "$TARGET" ]; then
    continue
  fi

  echo -e "\n[*] Checking $TARGET..."

  RESULT=$(ftp -inv "$TARGET" 2>/dev/null <<EOF
user anonymous anonymous@example.com
ls
bye
EOF
)

  if echo "$RESULT" | grep -q "230"; then
    echo "[+] $TARGET: Anonymous login successful!"
  else
    echo "[-] $TARGET: Anonymous login failed or FTP service unavailable."
  fi
done < domains.txt
