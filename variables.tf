########################################################################################################################
### Common
########################################################################################################################

variable "service_name" {
  type        = string
  description = "The name of the service."
}

variable "organization" {
  type        = string
  nullable    = false
  description = "The name of the organization the repo exists in."
}

variable "repo" {
  type        = string
  nullable    = false
  description = "The name of the repo using this module."
}

########################################################################################################################
### ECR
########################################################################################################################

variable "ecr_repos" {
  type = list(object({
    name                    = string
    namespace               = optional(string, "")
    immage_tag_immutability = optional(string, "IMMUTABLE")
    image_tag_mutability_exclusion_filter = optional(list(object({
      filter      = string
      filter_type = optional(string, "WILDCARD")
    })), [])
  }))
  default     = []
  description = "The set of ecr repos (i.e. service types) and namespaces (i.e. release/dev) to create."
}

########################################################################################################################
### OIDC
########################################################################################################################

variable "aws_account_ids_and_policies" {
  type = list(object({
    account_id = string
    policy_arn = string
  }))
  default     = []
  nullable    = false
  description = "The AWS Account IDs to give access to with the given policy."
}

########################################################################################################################
### Ruleset
########################################################################################################################

variable "create_default_repo_ruleset" {
  default     = false
  type        = bool
  description = "Set to true to create an opinionated default ruleset."
}

variable "required_checks" {
  type = list(object({
    context        = string
    integration_id = number
  }))
  default     = []
  description = "A list of required checks that a PR has to pass before being eligible for merge."
}
