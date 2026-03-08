# cdn-gateway
CloudFront + Nginx gateway to safely expose your home lab to the Internet.
Using a custom domain, users will be able to:
- Connect to `https://my-service.example.com` via CloudFront with a real, auto-renewing SSL certificate, leveraging caching, web acceleration, security, and anonymity from the CloudFront CDN.
- Ensure your home lab services only accept connections from your personal CloudFront distribution.
- Set up multiple subdomains and services in your home lab with this single gateway.
- Harden access with rules like country allowlisting.
- Support dynamic IPs from your ISP.

```
Users --https--> CloudFront --https--> Home Router --https--> Nginx (Docker) --http--> Docker services
```

## Requirements
- A custom domain (e.g. `example.com`) whose DNS records you control.
- An AWS account.
- A home lab server running Docker.
- A home router you can configure for port forwarding.

## Usage

### 1. CloudFront setup
Follow the instructions in [cloudfront](./cloudfront/) to create your AWS CloudFront distribution with your custom domain.

### 2. Router
Configure port forwarding on your router to send ports 80 and 443 to your Docker host.

### 3. Configuration
- Copy `.env-template` to `.env` and fill in your settings.
- Copy `nginx/conf.d/0_default.conf-template` to `nginx/conf.d/0_default.conf` and configure the `MAPS` section with:
  - Your secret CDN-Nginx shared key (`CustomHeaderValue` set in CloudFront).
  - The countries you want to grant access to.
  - The local network range of the host.

### 4. Start the gateway
```bash
# Fetch the latest CloudFront IP ranges
# (does not auto-update, but changes infrequently)
./update-nginx-proxy-list.sh

# Create the shared Docker network
docker network create shared-network

# Start the container
docker compose up -d

# Tail logs
docker compose logs --follow
```

### 5. Verify
Browse to a domain you configured in CloudFront — e.g. `https://photos.example.com` — it should return `Nope.` (expected until a service is wired up).

## Exposing additional services
Run any service you want to expose publicly on the same `shared-network` so the gateway can reach it. Use the provided templates in `nginx/conf.d/` as a starting point. Tested with:
- [Immich](https://docs.immich.app/install/docker-compose/)
- [Navidrome](https://www.navidrome.org/docs/installation/docker/)
- [Paperless-ngx](https://github.com/paperless-ngx/paperless-ngx/tree/dev/docker/compose)
