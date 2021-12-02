# SageMaker Notebook

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}


module "current" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

locals {
  s3_vpce_config = [
    {
      service             = "s3"
      type                = "Interface"
      private_dns_enabled = false
    },
  ]
}

# vpc
module "vpc" {
  count               = var.use_default_vpc ? 0 : 1
  source              = "Young-ook/spinnaker/aws//modules/spinnaker-aware-aws-vpc"
  name                = join("-", [var.name, "aws"])
  tags                = var.tags
  azs                 = var.azs
  cidr                = "10.10.0.0/16"
  vpc_endpoint_config = var.use_default_vpc ? [] : local.s3_vpce_config
  enable_igw          = false
  enable_ngw          = false
}

# s3
module "s3" {
  source          = "../../modules/s3"
  name            = var.name
  tags            = var.tags
  force_destroy   = var.force_destroy
  versioning      = var.versioning
  lifecycle_rules = var.lifecycle_rules
}

resource "aws_s3_bucket_policy" "access_from_vpc_only" {
  count      = var.use_default_vpc ? 0 : 1
  depends_on = [module.s3, module.vpc]
  bucket     = module.s3.bucket.id
  policy = jsonencode({
    Statement = [
      {
        Sid = "AllowAccessFromVpcEndpoint"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect = "Deny"
        Principal = {
          AWS = flatten([module.current.caller.account_id, ])
        }
        Resource = [module.s3.bucket.arn, join("/", [module.s3.bucket.arn, "*"]), ]
        Condition = {
          StringNotEquals = {
            "aws:sourceVpce" = module.vpc.0.vpce.s3.id
          }
        }
      },
      {
        Sid    = "AllowTerraformToReadBuckets"
        Action = "s3:ListBucket"
        Effect = "Allow"
        Principal = {
          AWS = flatten([module.current.caller.account_id, ])
        }
        Resource = [module.s3.bucket.arn, ]
      }
    ]
    Version = "2012-10-17"
  })
}

# sagemaker
module "sagemaker" {
  source             = "../../"
  name               = var.name
  tags               = var.tags
  vpc                = var.use_default_vpc ? null : module.vpc.0.vpc.id
  subnets            = var.use_default_vpc ? null : values(module.vpc.0.subnets["private"])
  notebook_instances = var.notebook_instances
}
