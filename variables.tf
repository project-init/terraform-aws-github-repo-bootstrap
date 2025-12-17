variable "aws_account_ids_and_policies" {
  type = list(object({
    account_id = string
    policy_arn = string
  }))
  default     = []
  nullable    = false
  description = "The AWS Account IDs to give access to with the given policy."
}

variable "service_name" {
  type        = string
  description = "The name of the service."
}

variable "ecr_repos" {
  type        = set(string)
  default     = []
  description = "The set of ecr repos (i.e. service types) to create."
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

variable "required_checks" {
  type = list(object({
    context        = string
    integration_id = number
  }))
  default     = []
  description = "A list of required checks that a PR has to pass before being eligible for merge."
}
