terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27.0"
      configuration_aliases = [
        aws.production_environment_provider,
        aws.test_environment_provider,
      ]
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.9.0"
    }
  }
}