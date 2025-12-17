/////////////////////////////////////////////////////////////
// production
/////////////////////////////////////////////////////////////

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
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.organization}/${var.repo}:*"
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
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.organization}/${var.repo}:*"
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
