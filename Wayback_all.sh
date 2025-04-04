#!/bin/bash

# Input file containing domains
DOMAIN_FILE="domains.txt"

# Check if the file exists
if [ ! -f "$DOMAIN_FILE" ]; then
  echo "Domain file not found: $DOMAIN_FILE"
  exit 1
fi

# Create directories to store output
mkdir -p outputs/wayback
mkdir -p outputs/virustotal
mkdir -p outputs/alienvault

# Loop through each domain in the file
while IFS= read -r DOMAIN; do
  echo "Processing domain: $DOMAIN"

  # 1. Query Wayback Machine
  WAYBACK_URL="https://web.archive.org/cdx/search/cdx?url=*.$DOMAIN/*&collapse=urlkey&output=text&fl=original"
  curl -sG "$WAYBACK_URL" > "outputs/wayback/${DOMAIN}_wayback.txt"

  # Filter specific file extensions
  cat "outputs/wayback/${DOMAIN}_wayback.txt" | uro | grep -E '\.xls|\.xml|\.xlsx|\.json|\.pdf|\.sql|\.doc|\.docx|\.pptx|\.txt|\.zip|\.tar\.gz|\.tgz|\.bak|\.7z|\.rar|\.log|\.cache|\.secret|\.db|\.backup|\.yml|\.gz|\.config|\.csv|\.yaml|\.md|\.md5|\.exe|\.dll|\.bin|\.ini|\.bat|\.sh|\.tar|\.deb|\.rpm|\.iso|\.img|\.apk|\.msi|\.dmg|\.tmp|\.crt|\.pem|\.key|\.pub|\.asc' > "outputs/wayback/${DOMAIN}_filtered.txt"

  # 2. Query VirusTotal
  VT_URL="https://www.virustotal.com/vtapi/v2/domain/report?apikey=&domain=$DOMAIN"
  curl -sG "$VT_URL" > "outputs/virustotal/${DOMAIN}_vt.json"

  # 3. Query AlienVault OTX
  ALIENVAULT_URL="https://otx.alienvault.com/api/v1/indicators/hostname/$DOMAIN/url_list?limit=500&page=1"
  curl -sG "$ALIENVAULT_URL" > "outputs/alienvault/${DOMAIN}_otx.json"

done < "$DOMAIN_FILE"

echo "Processing completed. Check the 'outputs' directory for results."
