module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  name = var.service_name
}

module "ecr_label" {
  for_each = local.ecr_map

  source  = "cloudposse/label/null"
  version = "~> 0.25.0"

  attributes = concat([each.value.namespace], ["${var.service_name}-${each.key}"])
  delimiter  = "/"
}

module "github_role_label" {
  source  = "cloudposse/label/null"
  version = "~> 0.25.0"

  context    = module.label.context
  attributes = concat(module.label.attributes, ["github"])
}