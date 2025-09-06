terraform {
  required_version = "~> 1.9.8"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 6.11.0"
      configuration_aliases = [aws.us_east_1]
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.9.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.4"
    }
  }
}
