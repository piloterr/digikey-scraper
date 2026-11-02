<p align="center">
  <a href="https://www.piloterr.com"><img src="images/banner.png" alt="DigiKey Scraper API by Piloterr – scrape DigiKey data as JSON" width="100%"></a>
</p>

# DigiKey Scraper API

[![Discord](https://img.shields.io/badge/Discord-Join%20the%20community-5865F2?logo=discord&logoColor=white)](https://discord.gg/CFj3ph8aHU) [![Get API key](https://img.shields.io/badge/Piloterr-Get%20a%20free%20API%20key-111827)](https://app.piloterr.com) [![API docs](https://img.shields.io/badge/Docs-OpenAPI-0EA5E9)](https://app.piloterr.com/openapi) [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

The **Piloterr DigiKey Scraper API** lets you extract public data from DigiKey as **clean, structured JSON** — no proxies, headless browsers or HTML parsing to maintain. Endpoints available in production:

- **DigiKey Product API** — Get a DigiKey product page: part numbers, manufacturer, price tiers, stock, images, datasheet and specs via browser rendering.
- **DigiKey Search API** — Search DigiKey country sites by keyword or result/filter URL.

Use it for price monitoring, assortment tracking, competitor analysis, product research or catalog enrichment.

| Endpoint | Path | Credits | What you get |
|---|---|---|---|
| [DigiKey Product API](#digikey-product-api) | `/v2/digikey/product` | 2 | Get a DigiKey product page |
| [DigiKey Search API](#digikey-search-api) | `/v2/digikey/search` | 2 | Search DigiKey country sites by keyword or result/filter URL. Returns category branches or product listings with pagination via browser rendering. |

## Table of contents

- [How it works](#how-it-works)
- [DigiKey Product API](#digikey-product-api)
- [DigiKey Search API](#digikey-search-api)
- [Code examples in other languages](#code-examples-in-other-languages)
- [Practical use cases](#practical-use-cases)
- [Why Piloterr?](#why-piloterr)
- [FAQ](#faq)
- [Related scrapers](#related-scrapers)
- [Support](#support)

## How it works

1. **Create a free Piloterr account** and copy your API key from the [dashboard](https://app.piloterr.com).
2. **Send a `GET` (or `POST`) request** to `https://api.piloterr.com/v2/...` with the header `x-api-key: YOUR_API_KEY`.
3. **Receive structured JSON** — Piloterr handles rendering, proxies, retries and parsing.

```bash
export PILOTERR_API_KEY="your-api-key"
pip install requests        # Python
# TypeScript: Node.js 18+ (native fetch), run with `npx tsx file.ts`
```

> Every endpoint accepts both `GET` (query string) and `POST` (JSON body with the same fields).

## DigiKey Product API

Get a DigiKey product page: part numbers, manufacturer, price tiers, stock, images, datasheet and specs via browser rendering.

`GET | POST https://api.piloterr.com/v2/digikey/product` · **2 credits per request** · [Full reference](https://app.piloterr.com/openapi)

### Request parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Full DigiKey product detail URL, or relative path. |
| `region` | string | — | DigiKey country TLD when `query` is a relative path. |
| `return_page_source` | boolean | — | When `true`, return rendered HTML as `{"result": "..."}` instead of JSON. Defaults to `false`. |

### Python example

```python
import json
import os
import requests

response = requests.get(
    "https://api.piloterr.com/v2/digikey/product",
    headers={"x-api-key": os.environ["PILOTERR_API_KEY"]},
    params={
        "query": "https://www.digikey.fr/fr/products/detail/phoenix-contact/2981965/3604293",
    },
    timeout=120,
)
response.raise_for_status()
data = response.json()

print(json.dumps(data, indent=2, ensure_ascii=False)[:2000])
```

### TypeScript example

```typescript
type DigikeyProduct = {
  url?: string;
  price?: number;
  stock?: string;
  title?: string;
  images?: string[];
  locale?: string;
  region?: string;
  pricing?: {
    packaging?: string;
    unit_price?: number;
    break_quantity?: number;
    extended_price?: number;
    digikey_part_number?: string;
  }[];
  currency?: string;
  description?: string;
  manufacturer?: string;
  datasheet_url?: string;
  is_unavailable?: boolean;
  specifications?: {
    Fabricant?: string;
    Conditionnement?: string;
    "Type d'accessoire"?: string;
    "Statut du composant"?: string;
  };
  digikey_part_number?: string;
  detailed_description?: string;
  manufacturer_part_number?: string;
};

const params = new URLSearchParams({
  "query": "https://www.digikey.fr/fr/products/detail/phoenix-contact/2981965/3604293",
});

const response = await fetch(`https://api.piloterr.com/v2/digikey/product?${params}`, {
  headers: { "x-api-key": process.env.PILOTERR_API_KEY! },
});
if (!response.ok) throw new Error(`Piloterr error ${response.status}: ${await response.text()}`);

const data = (await response.json()) as DigikeyProduct;

console.log(JSON.stringify(data, null, 2).slice(0, 2000));
```

<details>
<summary><b>POST variant</b></summary>

```http
POST https://api.piloterr.com/v2/digikey/product
x-api-key: YOUR_API_KEY
Content-Type: application/json

{"query": "https://www.digikey.fr/fr/products/detail/phoenix-contact/2981965/3604293"}
```
</details>

### Output example

Example response from the API reference, abridged — real values depend on the page you scrape.

```json
{
  "url": "https://www.digikey.fr/fr/products/detail/phoenix-contact/2981965/3604293",
  "price": 110.05,
  "stock": "49",
  "title": "2981965",
  "images": [
    "https://mm.digikey.com/Volume0/opasdata/d220001/derivates/6/002/833/060/2981965_web%28640x640%29.jpg?hidebanner=true"
  ],
  "locale": "fr",
  "region": "fr",
  "pricing": [
    {
      "packaging": "En vrac",
      "unit_price": 110.05,
      "break_quantity": 1,
      "extended_price": 110.05,
      "digikey_part_number": "277-17389-ND"
    }
  ],
  "currency": "EUR",
  "description": "UNIVERSAL SAFETY RELAY",
  "manufacturer": "Phoenix Contact",
  "datasheet_url": "https://mm.digikey.com/Volume0/opasdata/d220001/medias/docus/692/2981965_Ds.pdf",
  "is_unavailable": false,
  "specifications": {
    "Fabricant": "Phoenix Contact",
    "Conditionnement": "En vrac",
    "Type d'accessoire": "Relais de sécurité",
    "Statut du composant": "Actif"
  },
  "digikey_part_number": "277-17389-ND",
  "detailed_description": "Relais de sécurité",
  "manufacturer_part_number": "2981965"
}
```

### Response fields

| Field | Type | Description |
|---|---|---|
| `url` | string |  |
| `price` | number |  |
| `stock` | string |  |
| `title` | string |  |
| `images` | string[] |  |
| `locale` | string |  |
| `region` | string |  |
| `pricing[]` | object[] |  |
| `pricing[].packaging` | string |  |
| `pricing[].unit_price` | number |  |
| `pricing[].break_quantity` | integer |  |
| `pricing[].extended_price` | number |  |
| `pricing[].digikey_part_number` | string |  |
| `currency` | string |  |
| `description` | string |  |
| `manufacturer` | string |  |
| `datasheet_url` | string |  |
| `is_unavailable` | boolean |  |
| `specifications` | object |  |
| `specifications.Fabricant` | string |  |
| `specifications.Conditionnement` | string |  |
| `specifications.Type d'accessoire` | string |  |
| `specifications.Statut du composant` | string |  |
| `digikey_part_number` | string |  |
| `detailed_description` | string |  |

## DigiKey Search API

Search DigiKey country sites by keyword or result/filter URL. Returns category branches or product listings with pagination via browser rendering.

`GET | POST https://api.piloterr.com/v2/digikey/search` · **2 credits per request** · [Full reference](https://app.piloterr.com/openapi)

### Request parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Keyword, DigiKey result/filter URL, or relative path. |
| `region` | string | — | DigiKey country TLD when `query` is not a full URL. |
| `return_page_source` | boolean | — | When `true`, return rendered HTML as `{"result": "..."}` instead of JSON. Defaults to `false`. |

### Python example

```python
import json
import os
import requests

response = requests.get(
    "https://api.piloterr.com/v2/digikey/search",
    headers={"x-api-key": os.environ["PILOTERR_API_KEY"]},
    params={
        "query": "phoenix contact",
    },
    timeout=120,
)
response.raise_for_status()
data = response.json()

print(json.dumps(data, indent=2, ensure_ascii=False)[:2000])
```

### TypeScript example

```typescript
type DigikeySearch = {
  results?: {
    id?: string;
    url?: string;
    type?: string;
    title?: string;
    image_url?: string;
    product_count?: number;
    parent_category?: string;
  }[];
  pagination?: {
    page?: number;
    per_page?: number;
    total_pages?: number;
    has_next_page?: boolean;
    total_results?: number;
  };
};

const params = new URLSearchParams({
  "query": "phoenix contact",
});

const response = await fetch(`https://api.piloterr.com/v2/digikey/search?${params}`, {
  headers: { "x-api-key": process.env.PILOTERR_API_KEY! },
});
if (!response.ok) throw new Error(`Piloterr error ${response.status}: ${await response.text()}`);

const data = (await response.json()) as DigikeySearch;

console.log(JSON.stringify(data, null, 2).slice(0, 2000));
```

<details>
<summary><b>POST variant</b></summary>

```http
POST https://api.piloterr.com/v2/digikey/search
x-api-key: YOUR_API_KEY
Content-Type: application/json

{"query": "phoenix contact"}
```
</details>

### Output example

Example response from the API reference, abridged — real values depend on the page you scrape.

```json
{
  "results": [
    {
      "id": "370",
      "url": "https://www.digikey.fr/fr/products/filter/embases-fiches-et-prises/370",
      "type": "category",
      "title": "Embases, fiches et prises",
      "image_url": "https://mm.digikey.com/Volume0/opasdata/d220001/derivates/3/010/141/386/1751086_tmb.jpg",
      "product_count": 13796,
      "parent_category": "Blocs de jonction"
    }
  ],
  "pagination": {
    "page": 1,
    "per_page": 30,
    "total_pages": 1,
    "has_next_page": false,
    "total_results": 65793
  }
}
```

### Response fields

| Field | Type | Description |
|---|---|---|
| `results[]` | object[] |  |
| `results[].id` | string |  |
| `results[].url` | string |  |
| `results[].type` | string |  |
| `results[].title` | string |  |
| `results[].image_url` | string |  |
| `results[].product_count` | integer |  |
| `results[].parent_category` | string |  |
| `pagination` | object |  |
| `pagination.page` | integer |  |
| `pagination.per_page` | integer |  |
| `pagination.total_pages` | integer |  |
| `pagination.has_next_page` | boolean |  |
| `pagination.total_results` | integer |  |

## Code examples in other languages

Ready-to-run examples live in the [`examples/`](examples) folder. Each one reads your key from the `PILOTERR_API_KEY` environment variable.

| Language | Product | Search |
|---|---|---|
| cURL (Bash) | [`product`](examples/curl/product.sh) | [`search`](examples/curl/search.sh) |
| PHP | [`product`](examples/php/product.php) | [`search`](examples/php/search.php) |
| C# | [`product`](examples/csharp/Product.cs) | [`search`](examples/csharp/Search.cs) |
| Go | [`product`](examples/go/product.go) | [`search`](examples/go/search.go) |
| Java | [`product`](examples/java/ProductExample.java) | [`search`](examples/java/SearchExample.java) |
| Ruby | [`product`](examples/ruby/product.rb) | [`search`](examples/ruby/search.rb) |
| Node.js | [`product`](examples/nodejs/product.mjs) | [`search`](examples/nodejs/search.mjs) |

## Practical use cases

- **Price monitoring** — Track prices, promotions and availability over time to react to competitors.
- **Assortment & catalog tracking** — Follow new products, delisted items and category changes.
- **Competitor analysis** — Benchmark ranges, brands and positioning across retailers.
- **Product research** — Spot best-sellers and trends from search results.
- **Catalog enrichment** — Pull titles, images and attributes into your PIM or marketplace listings.

## Why Piloterr?

- **No infrastructure** — no proxies, headless browsers or CAPTCHA solving to run yourself.
- **Structured JSON** — stable, documented fields instead of brittle HTML selectors.
- **Pay per request** — transparent credit cost per endpoint, failed requests are retried for you.
- **One API key, hundreds of sources** — DigiKey plus many other e-commerce, search and company data endpoints in the [Piloterr library](https://www.piloterr.com/library).
- **Any language** — plain HTTPS + JSON, with examples for Python, TypeScript, cURL, PHP, C#, Go, Java, Ruby and Node.js.

## FAQ

### Is it legal to scrape DigiKey?

Collecting publicly available data is generally allowed in many jurisdictions, but rules depend on your country, the data you collect and how you use it. Avoid personal data unless you have a lawful basis, respect the website's terms where they apply, and get legal advice for your specific use case. This is not legal advice.

### Do I need proxies or a headless browser?

No. Piloterr handles rendering, proxy rotation and retries on its side. You only send an HTTPS request with your `x-api-key` header and receive JSON.

### How much does a request cost?

Credits per call: `/v2/digikey/product` **2**, `/v2/digikey/search` **2**. See the [Piloterr website](https://www.piloterr.com) for plans.

### What data does the DigiKey API return?

Each endpoint returns structured JSON: **DigiKey Product** — `url`, `price`, `stock`, `title`, `images`, `locale`; **DigiKey Search** — `results[]`, `results[].id`, `results[].url`, `results[].type`, `results[].title`, `results[].image_url`.

### Can I target a specific country or language?

Yes, use `region` — see the parameter tables above for accepted values.

### Can I get the raw HTML instead of JSON?

Yes. Set `return_page_source=true` and the response becomes `{"result": "..."}` with the page source.

### Which languages are supported?

Any language that can make an HTTP request. This README shows Python and TypeScript; the [`examples/`](examples) folder contains cURL, PHP, C#, Go, Java, Ruby and Node.js.

## Related scrapers

- [About You Scraper API](https://github.com/piloterr/aboutyou-scraper)
- [Action Scraper API](https://github.com/piloterr/action-scraper)
- [Aldi Scraper API](https://github.com/piloterr/aldi-scraper)
- [Alibaba Scraper API](https://github.com/piloterr/alibaba-scraper)
- [AliExpress Scraper API](https://github.com/piloterr/aliexpress-scraper)
- [Allegro Scraper API](https://github.com/piloterr/allegro-scraper)
- [All Piloterr scrapers on GitHub](https://github.com/piloterr)

## Support

- 💬 Join the [Piloterr Discord](https://discord.gg/CFj3ph8aHU) to ask questions and share what you build.
- 📚 Browse the [API reference (OpenAPI)](https://app.piloterr.com/openapi) and the [Piloterr library](https://www.piloterr.com/library).
- 🔑 [Get your API key](https://app.piloterr.com).

---

<p align="center">
  <a href="https://www.piloterr.com">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="images/logo-dark.svg">
      <img src="images/logo.svg" alt="Piloterr" height="32">
    </picture>
  </a>
  <br>
  <sub>Built by <a href="https://www.piloterr.com">Piloterr</a> — web scraping APIs for e-commerce, search, real estate and more, one API key.</sub>
</p>

<sub>DigiKey is a trademark of its respective owner. This repository is not affiliated with or endorsed by DigiKey. Examples are released under the MIT license.</sub>
