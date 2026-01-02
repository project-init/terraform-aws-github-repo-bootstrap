locals {
  ecr_map = tomap({ for ecr_repo in var.ecr_repos : ecr_repo.name => ecr_repo })
}

resource "aws_ecr_repository" "ecr" {
  for_each = local.ecr_map
  provider = aws.production_environment_provider

  name                 = each.value.namespace == "" ? "${var.service_name}-${each.key}" : "${each.value.namespace}/${var.service_name}-${each.key}"
  image_tag_mutability = each.value.image_tag_mutability
  force_delete         = false

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecr_lifecycle_policy" "ecr" {
  for_each = local.ecr_map
  provider = aws.production_environment_provider

  repository = aws_ecr_repository.ecr[each.key].name
  policy     = <<EOF
{
    "rules": [
        {
            "action": {
                "type": "expire"
            },
            "description": "Remove untagged images",
            "rulePriority": 1,
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": 1
            }
        },
        {
            "action": {
                "type": "expire"
            },
            "description": "Rotate images when reach 50 images stored",
            "rulePriority": 2,
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 50
            }
        }
    ]
}
EOF
}

resource "aws_ecr_repository_policy" "ecr" {
  for_each = local.ecr_map
  provider = aws.production_environment_provider

  repository = aws_ecr_repository.ecr[each.key].name
  policy     = data.aws_iam_policy_document.ecr.json
}

data "aws_iam_policy_document" "ecr" {
  statement {
    sid    = "ReadonlyAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [for account_and_policy in var.aws_account_ids_and_policies : account_and_policy.account_id]
    }

    actions = [
      "ecr:ListTagsForResource",
      "ecr:ListImages",
      "ecr:GetRepositoryPolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetLifecyclePolicy",
      "ecr:GetDownloadUrlForLayer",
      "ecr:DescribeRepositories",
      "ecr:DescribeImages",
      "ecr:DescribeImageScanFindings",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]
  }
}