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

### machinelearning
module "sagemaker" {
  source             = "../../"
  name               = var.name
  tags               = var.tags
  vpc                = module.vpc.vpc.id
  subnets            = values(module.vpc.subnets[var.use_default_vpc ? "public" : "private"])
  studio             = var.studio
  notebook_instances = var.notebook_instances
}

### artifact/bucket
module "s3" {
  source        = "../../modules/s3"
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
}