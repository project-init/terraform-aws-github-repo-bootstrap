# Project Init AWS GitHub Repo Bootstrap

Module used to set up protections/defaults on a github repo and associate it with a service deployed in AWS.

## Quick Start

1. `mise format`
2. `mise docs`

## Usage

Check our [Examples](examples) for full usage information.

## Useful Docs

* [Code of Conduct](./CODE_OF_CONDUCT.md)
* [Contribution Guide](./CONTRIBUTING.md)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.25.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.25.0 |
| <a name="provider_aws.production_environment_provider"></a> [aws.production\_environment\_provider](#provider\_aws.production\_environment\_provider) | ~> 6.25.0 |
| <a name="provider_aws.test_environment_provider"></a> [aws.test\_environment\_provider](#provider\_aws.test\_environment\_provider) | ~> 6.25.0 |
| <a name="provider_github"></a> [github](#provider\_github) | ~> 6.9.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_github_role_label"></a> [github\_role\_label](#module\_github\_role\_label) | cloudposse/label/null | ~> 0.25.0 |
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_iam_role.github_ecr_production_environment_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.github_ecr_test_environment_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.github_production_environment_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.github_test_environment_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [github_repository_ruleset.default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |
| [aws_iam_openid_connect_provider.github_oidc_production_environment_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_openid_connect_provider.github_oidc_test_environment_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_ids_and_policies"></a> [aws\_account\_ids\_and\_policies](#input\_aws\_account\_ids\_and\_policies) | The AWS Account IDs to give access to with the given policy. | <pre>list(object({<br/>    account_id = string<br/>    policy_arn = string<br/>  }))</pre> | `[]` | no |
| <a name="input_ecr_repos"></a> [ecr\_repos](#input\_ecr\_repos) | The set of ecr repos (i.e. service types) and namespaces (i.e. release/dev) to create. | <pre>list(object({<br/>    name                 = string<br/>    namespace            = optional(string, "")<br/>    image_tag_mutability = optional(string, "IMMUTABLE")<br/>  }))</pre> | `[]` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | The name of the organization the repo exists in. | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | The name of the repo using this module. | `string` | n/a | yes |
| <a name="input_required_checks"></a> [required\_checks](#input\_required\_checks) | A list of required checks that a PR has to pass before being eligible for merge. | <pre>list(object({<br/>    context        = string<br/>    integration_id = number<br/>  }))</pre> | `[]` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The name of the service. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->