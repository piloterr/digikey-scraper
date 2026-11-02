#!/usr/bin/env bash
# DigiKey Product API – cURL example
# Usage: PILOTERR_API_KEY=your-key ./product.sh
set -euo pipefail

curl -sS --fail-with-body -G "https://api.piloterr.com/v2/digikey/product" \
  -H "x-api-key: ${PILOTERR_API_KEY}" \
  --data-urlencode query=https://www.digikey.fr/fr/products/detail/phoenix-contact/2981965/3604293
