# cdn-gateway

Cloudfront + Nginx gateway to safely open up your home lab to the Internet.

Using a custom domain users will be able to:

- Connect to `https://my-service.exmaple.com` via Cloudfront with a real-self-updating SSL Certificate.
  - Leveraging caching, web acceleration, security and annonymity from Cloudfront CDN.
- Ensure your home lab web services will only allow connections from your personal Cloudfront.
- Set up multiple subdomains and services in your home lab with this one gateway.
- Security harden access like allowing only certain countries to access your services.
- Support your ISP dynamic IP.

Users --https--> Cloudfront --https--> Home Router --https--> Nginx docker container --http--> docker services

## Requirements
- Custom domain, like `example.com`, you own and can update its DNS records.
- An AWS account
- A home lab server running Docker
- A home router you can access to configure port forward

## Usage (minimal)
- Clone repo
- Follow instructions in [cloudfront](./cloudfront/) to create your AWS Cloudfront distribution using your custom domain.
- Edit your port forward router to send port 80 and port 443 to your docker server
- Copy `.env-template` to `.env`
  - configure it with your personal settings
- Copy `nginx/conf.d/0_default.conf-teamplate` to `nginx/conf.d/0_default.conf`
  - configure the `MAPS` section with:
    - your secret CDN-Nginx key (CustomHeaderValue set up in Cloudfront)
    - the countries you want to grant access to
    - the local network range where the host is running
- Bring service up
```bash
# get the latest list of Cloudfront IP ranges (this list does not update automatically but it does not change much)
./update-nginx-proxy-list.sh
# create docker shared network for the cdn-gateway
docker network create shared-network
# bring container up
docker compose up -d
# check logs
docker compose logs --follow
```
- You should be able to browse the domains you configured in Clodufront, example:
  - https://photos.example.com -> should show `Nope.`.

## Usage (continuation)
- Run any other service you want to expose publically using the same `shared-network` for the cdn-gateway to access them
  - Unless these are in a different server.
- Used provided example templates in `nginx/conf.d/` to expose, for example:
  - [immich](https://docs.immich.app/install/docker-compose/)
  - [navidrome](https://www.navidrome.org/docs/installation/docker/)
  - [paperless-ngx](https://github.com/paperless-ngx/paperless-ngx/tree/dev/docker/compose)
