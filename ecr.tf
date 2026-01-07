locals {
  principal_arns = [for account_and_policy in var.aws_account_ids_and_policies : "arn:aws:iam::${account_and_policy.account_id}:root"]
  ecr_map        = tomap({ for ecr_repo in var.ecr_repos : "${ecr_repo.namespace}-${ecr_repo.name}" => ecr_repo })
}

module "ecr" {
  for_each = local.ecr_map

  source          = "cloudposse/ecr/aws"
  version         = "v1.0.0"
  max_image_count = 50
  context         = module.ecr_label[each.key]

  principals_readonly_access = local.principal_arns

  image_tag_mutability                  = each.value # each.value.image_tag_mutability
  image_tag_mutability_exclusion_filter = each.value.image_tag_mutability_exclusion_filter

  providers = {
    aws = aws.production_environment_provider
  }
}