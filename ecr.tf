locals {
  principal_arns = [for account_and_profile in var.aws_account_and_profiles : "arn:aws:iam::${account_and_profile.account_id}:root"]
}

module "ecr" {
  for_each = var.ecr_repos

  source          = "cloudposse/ecr/aws"
  version         = "v1.0.0"
  max_image_count = 50
  context         = module.ecr_label[each.key]

  principals_readonly_access = local.principal_arns

  providers = {
    aws = aws.provider1
  }
}