## CloudFront
CloudFront helps shield your local server from the Internet and provides useful request headers, such as the country the traffic originates from.

The steps below assume you have a custom domain and DNS access to it.

### Deploy AWS CloudFront using a CloudFormation template

#### 1. Issue an SSL certificate
In the AWS console, go to **AWS Certificate Manager** and issue a free certificate for the subdomains you want to expose.

> **Important:** the certificate must be in the **US East (N. Virginia) `us-east-1`** region — CloudFront requires this regardless of where your other resources are.

Validate the certificate via DNS. Example subdomains:
- `photos.example.com`
- `docs.example.com`

#### 2. Install the AWS CLI
See the [official installation guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) for your OS. Example for Ubuntu/snap:
```bash
sudo snap install aws-cli --classic
```

#### 3. Authenticate the AWS CLI
```bash
aws login
# or, for SSO:
aws configure sso
aws sso login --profile my-profile
```

#### 4. Configure the stack
Copy `config-template.json` to `config.json` and edit the following fields:

- **`DomainName`** — the public domain used to access your services (e.g. `photos.example.com`).
- **`CertificateArn`** — the ARN of the certificate you issued in step 1.
- **`OriginDomainName`** — the domain pointing to your home server IP. Must be reachable over HTTPS with a valid certificate.
  - Once Nginx is running and reachable on port 80, you can issue a free Let's Encrypt certificate for this domain.
- **`CustomHeaderValue`** — a secret value CloudFront injects into requests to your origin. Nginx will reject any request that doesn't include it, ensuring only your CloudFront distribution can reach your server.

#### 5. Deploy the stack
```bash
./deploy-stack.sh
```

### Notes
- CloudFront will not work until the origin domain is reachable via HTTPS with a valid certificate — e.g. `https://home.example.com` must resolve to your home IP.
- If your ISP assigns a dynamic IP, you can automate DNS updates with:
  - [DynDNS](https://account.dyn.com/)
  - This simple Cloudflare cron script: [python-cloudflare-dynamic-ip](https://github.com/anabadce/python-cloudflare-dynamic-ip)

### Costs
AWS will only charge you for CloudFront bandwidth if you exceed the free tier allowance. See the [CloudFront pricing page](https://aws.amazon.com/cloudfront/pricing/) for details.
