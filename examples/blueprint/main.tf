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
      service             = "lambda"
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

### drawing lots for choosing a subnet
resource "random_integer" "subnet" {
  min = 0
  max = length(values(module.vpc.subnets[var.use_default_vpc ? "public" : "private"])) - 1
}

### application/ml
module "studio" {
  for_each = toset(local.studio_enabled ? ["enabled"] : [])
  source   = "Young-ook/sagemaker/aws//modules/sagemaker-studio"
  version  = "0.4.6"
  name     = var.name
  tags     = var.tags
  vpc      = module.vpc.vpc.id
  subnets  = values(module.vpc.subnets[var.use_default_vpc ? "public" : "private"])
  studio   = var.studio
}

module "notebook" {
  for_each           = toset(local.notebook_enabled ? ["enabled"] : [])
  source             = "Young-ook/sagemaker/aws"
  version            = "0.4.2"
  name               = var.name
  tags               = var.tags
  vpc                = module.vpc.vpc.id
  subnet             = var.use_default_vpc ? null : element(values(module.vpc.subnets["private"]), random_integer.subnet.result)
  notebook_instances = var.notebook_instances
}

### artifact/bucket
module "s3" {
  source        = "Young-ook/sagemaker/aws//modules/s3"
  version       = "0.3.4"
  name          = var.name
  tags          = var.tags
  force_destroy = var.force_destroy
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

### storage/filesystem
module "lustre" {
  for_each = toset(local.notebook_enabled ? ["enabled"] : [])
  source   = "Young-ook/sagemaker/aws//modules/lustre"
  version  = "0.4.6"
  tags     = var.tags
  subnets  = [element(values(module.vpc.subnets[var.use_default_vpc ? "public" : "private"]), random_integer.subnet.result)]
  filesystem = {
    import_path = format("s3://%s", module.s3.bucket.id)
  }
}

module "efs" {
  for_each = toset(local.notebook_enabled ? ["enabled"] : [])
  source   = "Young-ook/sagemaker/aws//modules/efs"
  version  = "0.4.6"
  tags     = var.tags
  vpc      = module.vpc.vpc.id
  subnets  = values(module.vpc.subnets[var.use_default_vpc ? "public" : "private"])
  filesystem = {
    encrypted = false
  }
  access_points = [
    {
      uid         = "1001"
      gid         = "1001"
      permissions = "750"
      path        = "/export/lambda"
    }
  ]
}
