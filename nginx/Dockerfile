FROM nginx:latest

# install certbot
RUN apt-get update
RUN apt-get install -y \
    certbot

# main config
COPY nginx.conf /etc/nginx/
COPY conf.d/*.conf /etc/nginx/conf.d/
COPY conf.d/*.include /etc/nginx/conf.d/

# self-signed certs
COPY --chmod=600 ssl/self-signed.* /etc/nginx/
