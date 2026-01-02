module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  name = var.service_name
}

module "github_role_label" {
  source  = "cloudposse/label/null"
  version = "~> 0.25.0"

  context    = module.label.context
  attributes = concat(module.label.attributes, ["github"])
}