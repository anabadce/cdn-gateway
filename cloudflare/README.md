# cloudflare
To configure Cloudflare

- DNS record (example)
  - Type: `CNAME`
  - Name: `cloud`
  - Content: `home.example.com`
  - Proxy Status: `Proxied`
  - TTL: `Auto`

- Rules:
  - Request Header Transform Rule
    - Name: `add x_home_key header`
    - Custom filter expression: `(http.host in {"cloud.example.com"})`
    - Set static:
      - Header Name: `x-home-key`
      - Value: `secret value`
