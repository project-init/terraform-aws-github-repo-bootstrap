locals {
  principal_arns = [for account_and_policy in var.aws_account_ids_and_policies : "arn:aws:iam::${account_and_policy.account_id}:root"]
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