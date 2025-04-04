#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <domain>"
  exit 1
fi

DOMAIN=$1

curl --request GET \
     --url "https://api.securitytrails.com/v1/domain/${DOMAIN}/subdomains?children_only=false&include_inactive=true" \
     --header 'APIKEY: random' \
     --header 'accept: application/json' | jq -r '.subdomains[]' | awk -v domain="$DOMAIN" '{print $0 "." domain}'
