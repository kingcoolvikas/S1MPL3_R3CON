#!/bin/bash

# File containing the list of domains
DOMAIN_FILE="global.com"

# Loop through each domain in the file
while read -r domain; do
    # Append a test path to the domain
    url="${domain}/put_test"

    # Make a PUT request using curl and capture the HTTP response code
    http_code=$(curl -o /dev/null -s -w "%{http_code}" -X PUT "$url" -d "test" -H "User-Agent: PUT-Method-Checker")

    # Check if the HTTP status code indicates PUT is enabled
    if [[ "$http_code" == "200" || "$http_code" == "201" || "$http_code" == "204" ]]; then
        echo "PUT method is enabled on: $domain"
    else
        echo "PUT method is NOT enabled on: $domain"
    fi
done < "$DOMAIN_FILE"
