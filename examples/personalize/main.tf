# Amazon Personalize with SageMaker

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

module "frigga" {
  source  = "Young-ook/spinnaker/aws//modules/frigga"
  version = "2.3.5"
}

# vpc
module "vpc" {
  source = "Young-ook/vpc/aws"
  name   = module.frigga.name
  tags   = var.tags
}

# s3
module "s3" {
  source        = "../../modules/s3"
  name          = module.frigga.name
  tags          = var.tags
  force_destroy = true
}

# sagemaker
module "sagemaker" {
  source  = "../../"
  name    = module.frigga.name
  tags    = var.tags
  vpc     = module.vpc.vpc.id
  subnets = values(module.vpc.subnets.public)
  notebook_instances = [
    {
      name                    = "default"
      instance_type           = "ml.m5.xlarge"
      default_code_repository = aws_sagemaker_code_repository.repo.code_repository_name
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
  name = join("-", [module.frigga.name, "personalize-lab-required"])
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
  code_repository_name = "samples"
  git_config {
    repository_url = "https://github.com/aws-samples/amazon-personalize-samples.git"
  }
}
