# Amazon Personalize with SageMaker

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# vpc
module "vpc" {
  source = "Young-ook/vpc/aws"
  name   = local.name
  tags   = var.tags
}

# s3
module "s3" {
  source        = "../../modules/s3"
  name          = local.name
  tags          = var.tags
  force_destroy = true
}

# sagemaker
module "sagemaker" {
  source  = "../../"
  name    = local.name
  tags    = var.tags
  vpc     = module.vpc.vpc.id
  subnets = values(module.vpc.subnets.public)
  notebook_instances = [
    {
      name                    = "default"
      instance_type           = "ml.m5.xlarge"
      default_code_repository = aws_sagemaker_code_repository.repo[var.personalize_example].code_repository_name
    }
  ]
  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonPersonalizeFullAccess",
    aws_iam_policy.personalize-lab-required.arn,
    module.s3.policy_arns["read"],
    module.s3.policy_arns["write"],
  ]
}

# security/policy
resource "aws_iam_policy" "personalize-lab-required" {
  name = join("-", [local.name, "personalize-lab-required"])
  policy = jsonencode({
    Statement = [
      {
        Action   = ["s3:PutBucketPolicy", ]
        Effect   = "Allow"
        Resource = [module.s3.bucket.arn, ]
      },
      {
        Action = [
          "iam:AttachRolePolicy",
          "iam:CreateRole",
          "iam:DeleteRole",
        ]
        Effect   = "Allow"
        Resource = ["*"]
      }
    ]
    Version = "2012-10-17"
  })
}

# personalize sample
resource "aws_sagemaker_code_repository" "repo" {
  for_each = {
    for r in [
      {
        name = "samples",
        url  = "https://github.com/aws-samples/amazon-personalize-samples.git"
      },
      {
        name = "retailstore",
        url  = "https://github.com/Young-ook/terraform-aws-sagemaker.git"
      },
    ] : r.name => r
  }
  code_repository_name = each.value["name"]
  git_config {
    repository_url = each.value["url"]
  }
}
