module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  name = var.service_name
}

module "ecr_label" {
  for_each = var.ecr_repos

  source  = "cloudposse/label/null"
  version = "~> 0.25.0"

  context    = module.label.context
  attributes = concat([each.value.namespace], module.label.attributes, [each.value.name])
}

module "github_role_label" {
  source  = "cloudposse/label/null"
  version = "~> 0.25.0"

  context    = module.label.context
  attributes = concat(module.label.attributes, ["github"])
}