# SSL certs

Nginx needs these 2 files before it can start:
- `self-signed.key`
- `self-signed.crt`

Example command to create a self-signed SSL certificate/key pair.
```
HOSTNAME=photos.example.com
openssl req -x509 \
  -newkey rsa:2048 \
  -keyout self-signed.key \
  -out self-signed.crt \
  -sha256 \
  -days 3650 \
  -nodes \
  -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=$HOSTNAME"
```

## Tests
```
openssl x509 -in self-signed.crt -noout -text | grep -E "(Subject:|Not)"
openssl rsa -in self-signed.key -noout --modulus
openssl x509 -in self-signed.crt -noout --modulus
```
Note: Your certificate and private key must always have the same modulus.
