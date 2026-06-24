# cognito

Creates an Amazon Cognito user pool for the Investments Assistant UI, including
groups that map to gateway roles:

- `viewer`: chat with the assistant about news only.
- `investor`: use market data, news, simulations, and reports, but not
  portfolio or trading tools.
- `admin`: use every assistant service and trading control.

The app client is configured for ALB authentication with the OAuth code flow.
Use `https://<app-domain>/oauth2/idpresponse` as the callback URL.

## Example

```hcl
module "cognito" {
  source = "git::ssh://git@github.com/Investments-Assistant/opentofu-modules.git//cognito?ref=v0.0.1"

  cluster_name  = "investments-assistant"
  domain_prefix = "investments-assistant-auth"
  callback_urls = ["https://assistant.example.com/oauth2/idpresponse"]
  logout_urls   = ["https://assistant.example.com/"]
}
```

Create users with admin invitations and assign each user to exactly one of the
role groups unless you intentionally want the highest matching role to win.
