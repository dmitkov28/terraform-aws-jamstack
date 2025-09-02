# JAMStack Launchpad Terraform Module

A complete Terraform module for deploying containerized APIs to AWS Lambda with API Gateway, ECR, and Cloudflare DNS integration.

## Architecture

- **AWS Lambda** - Containerized API runtime (ARM64)
- **API Gateway v2** - HTTP API with custom domain
- **ECR** - Container registry with lifecycle policies
- **ACM** - SSL certificate management
- **Cloudflare** - DNS management and validation

## Features

- ✅ Containerized Lambda deployment
- ✅ Custom domain with SSL certificates
- ✅ Automated Docker build and push
- ✅ ECR lifecycle management
- ✅ CORS configuration
- ✅ CloudWatch logging
- ✅ Multiple Lambda aliases (dev/prod)

## Prerequisites

- AWS CLI configured
- Docker installed
- Terraform >= 1.9.8
- Cloudflare account with API token

## Quick Start

1. **Clone and configure**
```bash
git clone <repository>
cd jamstack-launchpad/terraform
cp terraform.tfvars.example terraform.tfvars
```

2. **Set variables**
```hcl
# terraform.tfvars
CLOUDFLARE_API_TOKEN = "your-cloudflare-token"
CLOUDFLARE_ZONE_ID   = "your-zone-id"
ecr_repo_name        = "my-api"
```

3. **Deploy**
```bash
terraform init
terraform plan
terraform apply
```

## Module Structure

```
terraform/
├── main.tf              # Root module configuration
├── variables.tf         # Input variables
├── locals.tf           # Local values
├── providers.tf        # Provider configurations
├── ecr.tf             # ECR repository
├── docker.tf          # Docker build process
└── module/api/        # API module
    ├── lambda.tf      # Lambda function
    ├── api_gateway.tf # API Gateway
    ├── cert.tf        # SSL certificates
    ├── cloudflare.tf  # DNS records
    └── variables.tf   # Module variables
```

## Variables

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `CLOUDFLARE_API_TOKEN` | Cloudflare API token | `string` | ✅ |
| `CLOUDFLARE_ZONE_ID` | Cloudflare DNS zone ID | `string` | ✅ |
| `ecr_repo_name` | ECR repository name | `string` | ✅ |

## API Module Variables

| Name | Description | Default |
|------|-------------|---------|
| `api_name` | API name | `my-awesome-jamstack-api` |
| `domain` | Base domain | `dimitarmitkov.com` |

## Outputs

The module creates:
- API Gateway URL
- Lambda function URLs (dev/prod)
- Custom domain endpoint
- ECR repository URL

## Docker Build Process

The module automatically:
1. Authenticates with ECR
2. Builds the API Docker image
3. Tags and pushes to ECR
4. Verifies deployment

## Lambda Configuration

- **Runtime**: Container (ARM64)
- **Memory**: 512MB
- **Timeout**: 120 seconds
- **Aliases**: dev, prod
- **Environment**: `AWS_LWA_PORT=8000`

## API Gateway Features

- HTTP API (v2)
- Custom domain with SSL
- CORS enabled
- CloudWatch logging
- Regional endpoint

## ECR Lifecycle Policy

- Keeps last 10 tagged images
- Automatic cleanup of old images
- Force delete enabled for development

## SSL Certificate

- ACM certificate for custom domain
- DNS validation via Cloudflare
- Automatic renewal

## Monitoring

- CloudWatch logs (14-day retention)
- API Gateway access logs (7-day retention)
- Structured JSON logging

## Development

### Local Testing
```bash
# Test Lambda function URLs
curl https://<function-url>/dev/
curl https://<function-url>/prod/
```

### Custom Domain
```bash
# Access via custom domain
curl https://my-awesome-jamstack-api.dimitarmitkov.com/
```

## Cleanup

```bash
terraform destroy
```

## License

MIT License - see LICENSE file for details.
