/////////////////////////////////////////////////////////////
// production
/////////////////////////////////////////////////////////////

data "aws_iam_openid_connect_provider" "github_oidc_provider1" {
  count    = length(var.aws_account_ids_and_policies) > 0 ? 1 : 0
  provider = aws.provider1

  arn = "arn:aws:iam::${var.aws_account_ids_and_policies[0].account_id}:oidc-provider/token.actions.githubusercontent.com"
}

resource "aws_iam_role" "github_ecr_provider1" {
  count = length(var.aws_account_ids_and_policies) > 0 ? 1 : 0

  name     = module.github_role_label.id
  provider = aws.provider1

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github_oidc_provider1[0].arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:project-init/${var.repo}:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_provider1" {
  count = length(var.aws_account_ids_and_policies) > 0 ? 1 : 0

  provider = aws.provider1

  role       = aws_iam_role.github_ecr_provider1[0].name
  policy_arn = var.aws_account_ids_and_policies[0].policy_arn
}

/////////////////////////////////////////////////////////////
// staging
/////////////////////////////////////////////////////////////

data "aws_iam_openid_connect_provider" "github_oidc_provider2" {
  count    = length(var.aws_account_ids_and_policies) > 1 ? 1 : 0
  provider = aws.provider2

  arn = "arn:aws:iam::${var.aws_account_ids_and_policies[1].account_id}:oidc-provider/token.actions.githubusercontent.com"
}

resource "aws_iam_role" "github_ecr_provider2" {
  count = length(var.aws_account_ids_and_policies) > 1 ? 1 : 0

  name     = module.github_role_label.id
  provider = aws.provider2

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github_oidc_provider2[0].arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:project-init/${var.repo}:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_provider2" {
  count = length(var.aws_account_ids_and_policies) > 1 ? 1 : 0

  provider = aws.provider2

  role       = aws_iam_role.github_ecr_provider2[0].name
  policy_arn = var.aws_account_ids_and_policies[1].policy_arn
}
