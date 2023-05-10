### SageMaker Blueprint

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

### network/vpc
module "vpc" {
  source  = "Young-ook/vpc/aws"
  version = "1.0.3"
  name    = var.name
  tags    = var.tags
  vpc_config = var.use_default_vpc ? null : {
    azs         = var.azs
    cidr        = "10.10.0.0/16"
    subnet_type = "private"
    single_ngw  = true
  }
  vpce_config = [
    {
      service             = "ecr.dkr"
      type                = "Interface"
      private_dns_enabled = false
    },
    {
      service             = "ecr.api"
      type                = "Interface"
      private_dns_enabled = true
    },
    {
      service             = "logs"
      type                = "Interface"
      private_dns_enabled = true
    },
    {
      service             = "monitoring"
      type                = "Interface"
      private_dns_enabled = true
    },
    {
      service             = "s3"
      type                = "Interface"
      private_dns_enabled = false
    },
    {
      service             = "sts"
      type                = "Interface"
      private_dns_enabled = true
    },
    {
      service             = "sagemaker.api"
      type                = "Interface"
      private_dns_enabled = true
    },
    {
      service             = "sagemaker.runtime"
      type                = "Interface"
      private_dns_enabled = true
    },
    {
      service             = "notebook"
      type                = "Interface"
      private_dns_enabled = true
    },
  ]
}

### application/ml
module "studio" {
  for_each = toset(var.studio != null ? ["enabled"] : [])
  source   = "Young-ook/sagemaker/aws//modules/studio"
  version  = "0.3.5"
  name     = var.name
  tags     = var.tags
  vpc      = module.vpc.vpc.id
  subnets  = values(module.vpc.subnets[var.use_default_vpc ? "public" : "private"])
  studio   = var.studio
}

module "notebook" {
  for_each           = toset(var.studio == null && var.notebook_instances != null ? ["enabled"] : [])
  source             = "Young-ook/sagemaker/aws"
  version            = "0.3.5"
  name               = var.name
  tags               = var.tags
  vpc                = module.vpc.vpc.id
  subnets            = values(module.vpc.subnets[var.use_default_vpc ? "public" : "private"])
  notebook_instances = var.notebook_instances
}

### artifact/bucket
module "s3" {
  source        = "Young-ook/sagemaker/aws//modules/s3"
  version       = "0.3.4"
  name          = var.name
  tags          = var.tags
  force_destroy = var.force_destroy
  bucket_policy = {
    vpce-only = {
      policy = jsonencode({
        Version = "2012-10-17"
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
            Resource = [join("/", [module.s3.bucket.arn, "*"]), module.s3.bucket.arn, ]
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
      })
    }
  }
  lifecycle_rules = [
    {
      id     = "s3-intelligent-tiering"
      status = "Enabled"
      filter = {
        prefix = ""
      }
      transition = [
        {
          days = 0
          # valid values for 'storage_class':
          #   STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING,
          #   GLACIER, DEEP_ARCHIVE, GLACIER_IR
          storage_class = "INTELLIGENT_TIERING"
        },
      ]
    },
  ]
  intelligent_tiering_archive_rules = [
    {
      state = "Enabled"
      filter = [
        {
          prefix = "logs/"
          tags = {
            priority = "high"
            class    = "blue"
          }
        },
      ]
      tiering = [
        {
          # allowed values for 'access_tier':
          #   ARCHIVE_ACCESS, DEEP_ARCHIVE_ACCESS
          access_tier = "ARCHIVE_ACCESS"
          days        = 125
        },
        {
          access_tier = "DEEP_ARCHIVE_ACCESS"
          days        = 180
        },
      ]
    }
  ]
}
