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

## Certbot initial set up:

Initially Nginx uses a self-signed cert, great for local tests but not good for public Internet traffic.

You should issue a valid SSL certificate that validates the public domain that points to your home.
- Example: `home.example.com`, this will only be visible and used by AWS Cloudfront to connect securely to your origin (home).
- No need to use certbot for `photos.example.com` (if that is the subdomain you want users to use), that cert will be issued and managed by AWS Cloudfront.

Once issued a valid cert update `0-default.conf` cert paths.

Example of initial issue:
```bash
# open shell in the Nginx container
docker exec -it certbot sh

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
