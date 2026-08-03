/////////////////////////////////////////////////////////////
// production
/////////////////////////////////////////////////////////////

locals {
  // GitHub currently emits the ID-qualified subject format, while older tokens
  // use the name-only format. Keep both during the transition so existing
  // consumers and repositories with either token shape continue to work.
  github_oidc_subjects = [
    "repo:${var.organization}/${var.repo}:*",
    "repo:${var.organization}@*/${var.repo}@*:*",
  ]
}

data "aws_iam_openid_connect_provider" "github_oidc_production_environment_provider" {
  count    = length(var.aws_account_ids_and_policies) > 0 ? 1 : 0
  provider = aws.production_environment_provider

  arn = "arn:aws:iam::${var.aws_account_ids_and_policies[0].account_id}:oidc-provider/token.actions.githubusercontent.com"
}

resource "aws_iam_role" "github_ecr_production_environment_provider" {
  count = length(var.aws_account_ids_and_policies) > 0 ? 1 : 0

  name     = module.github_role_label.id
  provider = aws.production_environment_provider

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github_oidc_production_environment_provider[0].arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = local.github_oidc_subjects
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_production_environment_provider" {
  count = length(var.aws_account_ids_and_policies) > 0 ? 1 : 0

  provider = aws.production_environment_provider

  role       = aws_iam_role.github_ecr_production_environment_provider[0].name
  policy_arn = var.aws_account_ids_and_policies[0].policy_arn
}

/////////////////////////////////////////////////////////////
// staging
/////////////////////////////////////////////////////////////

data "aws_iam_openid_connect_provider" "github_oidc_test_environment_provider" {
  count    = length(var.aws_account_ids_and_policies) > 1 ? 1 : 0
  provider = aws.test_environment_provider

  arn = "arn:aws:iam::${var.aws_account_ids_and_policies[1].account_id}:oidc-provider/token.actions.githubusercontent.com"
}

resource "aws_iam_role" "github_ecr_test_environment_provider" {
  count = length(var.aws_account_ids_and_policies) > 1 ? 1 : 0

  name     = module.github_role_label.id
  provider = aws.test_environment_provider

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github_oidc_test_environment_provider[0].arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = local.github_oidc_subjects
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_test_environment_provider" {
  count = length(var.aws_account_ids_and_policies) > 1 ? 1 : 0

  provider = aws.test_environment_provider

  role       = aws_iam_role.github_ecr_test_environment_provider[0].name
  policy_arn = var.aws_account_ids_and_policies[1].policy_arn
}
