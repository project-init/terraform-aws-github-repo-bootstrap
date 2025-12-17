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
  ]
  organization = "your-organization"
  repo         = "repo-name"
  service_name = "service-name"
  ecr_repos = toset([
    "api",
    "worker"
  ])

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
