module "account_context_production" {
  source = "project-init/account-context/aws"
  # Project Init recommends pinning every module to a specific version
  # version = "vX.X.X"

  providers = {
    aws = aws.production
  }

  aws_account_name = "core-production"
  account_id       = ""
}

module "account_context_staging" {
  source = "project-init/account-context/aws"
  # Project Init recommends pinning every module to a specific version
  # version = "vX.X.X"

  providers = {
    aws = aws.staging
  }

  aws_account_name = "core-staging"
  account_id       = ""
}

module "bootstrap" {
  source = "project-init/github-repo-bootstrap/aws"
  # Project Init recommends pinning every module to a specific version
  # version = "vX.X.X"

  # The first account is assumed to be the production account
  aws_account_ids_and_policies = [
    # Production Account Comes First
    {
      account_id = module.account_context_production.account_id
      policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
    },
    # Test Account is the 2nd provider Used
    {
      account_id = module.account_context_staging.account_id
      policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
    }
  ]
  organization = "your-organization"
  repo         = "data-platform"
  service_name = "data-platform"
  ecr_repos = [
    {
      name      = "api",
      namespace = "release"
    },
    {
      name      = "api",
      namespace = "development"
    },
    {
      name = "worker"
    },
  ]

  required_checks = [
    {
      context        = "ci / test"
      integration_id = 15368
    },
    {
      context        = "lint-and-format / lint-and-format"
      integration_id = 15368
    }
  ]

  providers = {
    aws.provider1 = aws.production
    aws.provider2 = aws.staging
  }
}
