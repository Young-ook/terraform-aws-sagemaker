# SageMaker Notebook

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}


module "aws" {
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
  source  = "Young-ook/vpc/aws"
  version = "> 0.0.6"
  name    = join("-", [var.name, "aws"])
  tags    = var.tags
  vpc_config = var.use_default_vpc ? null : {
    cidr        = "10.10.0.0/16"
    azs         = var.azs
    subnet_type = "isolated"
    single_ngw  = true
  }
  vpce_config = var.use_default_vpc ? [] : local.s3_vpce_config
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
          AWS = flatten([module.aws.caller.account_id, ])
        }
        Resource = [module.s3.bucket.arn, join("/", [module.s3.bucket.arn, "*"]), ]
        Condition = {
          StringNotEquals = {
            "aws:sourceVpce" = module.vpc.vpce.s3.id
          }
        }
      },
      {
        Sid    = "AllowTerraformToReadBuckets"
        Action = "s3:ListBucket"
        Effect = "Allow"
        Principal = {
          AWS = flatten([module.aws.caller.account_id, ])
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
  vpc                = module.vpc.vpc.id
  subnets            = var.use_default_vpc ? values(module.vpc.subnets["public"]) : values(module.vpc.subnets["private"])
  notebook_instances = var.notebook_instances
}
