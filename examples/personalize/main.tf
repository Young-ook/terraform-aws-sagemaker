# Amazon Personalize with SageMaker

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

resource "random_pet" "name" {
  length    = 3
  separator = "-"
}

# vpc
module "vpc" {
  source = "Young-ook/vpc/aws"
  name   = random_pet.name.id
  tags   = var.tags
}

# s3
module "s3" {
  source        = "../../modules/s3"
  name          = random_pet.name.id
  tags          = var.tags
  force_destroy = true
}

# sagemaker
module "sagemaker" {
  source  = "../../"
  name    = random_pet.name.id
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
  name = join("-", [random_pet.name.id, "personalize-lab-required"])
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
          "iam:DetachRolePolicy",
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
  code_repository_name = "amazon-personalize-samples"
  git_config {
    repository_url = "https://github.com/aws-samples/amazon-personalize-samples.git"
  }
}
