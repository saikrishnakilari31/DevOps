terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.50.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  # prefer using OIDC or environment credentials for CI
}
