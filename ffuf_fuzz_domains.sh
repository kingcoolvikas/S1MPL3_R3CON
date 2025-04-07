#!/bin/bash

WORDLIST="onelist.txt"
DOMAINS="domains.txt"
OUTPUT_DIR="ffuf-results"

mkdir -p "$OUTPUT_DIR"

if [ ! -f "$WORDLIST" ]; then
  echo "[-] Wordlist '$WORDLIST' not found!"
  exit 1
fi

if [ ! -f "$DOMAINS" ]; then
  echo "[-] domains.txt not found!"
  exit 1
fi

while read -r domain; do
  # Skip empty lines
  [ -z "$domain" ] && continue

  echo "[*] Fuzzing $domain..."

  ffuf -w "$WORDLIST" -u "http://$domain/FUZZ" -mc 200,204,301,302,307,401,403 \
       -t 40 -o "$OUTPUT_DIR/${domain//\//_}_ffuf.json" -of json

done < "$DOMAINS"
