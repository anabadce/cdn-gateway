## Cloudfront

Recommended to use a CDN like Cloudfront to protect all traffic.

Cloudfront helps to shield your local server from the Internet as well as provide useful headers like which country the traffic comes from. 

Assuming you have a custom domain and DNS access to it.

### Deploy AWS Cloudfront using Cloudformation template

- Install `awscli` : https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
```bash
# Example:
sudo snap install aws-cli --classic
```

- Login to AWS in your console `aws-cli`
```bash
aws configure
# or
aws configure sso
aws sso login --profile my-profile
```

- Copy `config-template.json` to `config.json` and edit it:
  - `DomainName` is the public domain you want to use to access your site on the web.
  - `CertificateArn` is the certificate id in AWS you must have issued and valid for the "DomainName".
  - `OriginDomainName` is the domain that points to your server/home IP, this must support HTTPS and have a valid certificate.
  - `CustomHeaderValue` is a custom header Cloudfront will inject between AWS and your server, this secret will ensure only your Cloudfront can access your server.

- Deploy stack
```bash
./deploy-stack.sh
```

### Alternative manual set up of CloudFront

- FREE: Issue an SSL certificate using ACM (AWS Certificate Manager)
  - Ensure it is in US East (N. Virginia) Region (us-east-1).
  - Validate the Certificate with DNS.
- FREE: Create Cloudfront distribution
  - Alternate domain names must contain your chosen domain and the certificate issued
  - Origin:
    - HTTPS Only
    - Custom header name like `x-home-key` = <some private passphrase>
      - In your local Nginx `nginx/conf.d/immich.conf` update "# SECRET KEY #" so only requests with this key are accepted.
      - Also adjust what countries are allowed (recommended)
      - This is so attackers don't bypass Cloudfront
    - Origin Shield: off
  - Delete all Behaviours but the `Default (*)`
  - Default Behaviour:
    - Viewer protocol policy: Redirect HTTP to HTTPS
    - Legacy cache settings:
      - Headers: all
      - Query strings: all
      - Cookies: all
- NOT Free: enable AWS WAF if you want extra security
