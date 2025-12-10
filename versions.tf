terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.8.0"
      configuration_aliases = [
        aws.provider1,
        aws.provider2,
      ]
    }
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
}