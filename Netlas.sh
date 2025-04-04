curl -s -X POST "https://app.netlas.io/api/v1/search" \
  -H "Authorization: Bearer random" \
  -H "Content-Type: application/json" \
  -d '{"query": "<query>", "fields": ["adidas.co.in"], "size": 1000}' | jq -r '.results[].domain'
