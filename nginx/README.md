# cdn-gateway
Docker Nginx + AWS Cloudfront to expose home-lab services to the Internet

Nginx is used for some or all of the following:

- SSL offloading
- Block all traffic if not routed via CDN first
- Caching
- Rate limit
- IP filtering
- Country restricitons (using CDN's provided headers)
- Rewrites
- Error handling

## Dockerfile

We start from official latest Nginx container
- Install certbot
- Copy our config with our custom `server {}` block

## Host cronjob

To automatically renew the local LE certificate we need to set up a cron job in the host running docker
```bash
sudo cp nginx/host-cron.d-cdn-gateway-nginx-certbot /etc/cron.d
```

## Certbot initial set up:

Initially Nginx uses a self-signed cert, great for local tests but not good for public Internet traffic.

You should issue a valid SSL certificate that validates the public domain that points to your home.
- Example: `home.example.com`, this will only be visible and used by AWS Cloudfront to connect securely to your origin (home).
- No need to use certbot for `photos.example.com` (if that is the subdomain you want users to use), that cert will be issued and managed by AWS Cloudfront.

Once issued a valid cert update `0-default.conf` cert paths.

Example of initial issue:
```bash
# open shell in the Nginx container
docker exec -it nginx bash

# Once inside the container
DOMAIN=home.example.com
EMAIL=myname@example.com
WEBROOT=/usr/share/nginx/html

certbot certonly \
  -d $DOMAIN \
  --webroot -w $WEBROOT \
  --email $EMAIL \
  --agree-tos \
  -n
```
