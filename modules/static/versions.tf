terraform {
  required_version = "~> 1.9.8"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 6.11.0"
      configuration_aliases = [aws.us_east_1]
    }
  }
}
