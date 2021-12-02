# elastic file system

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  count               = var.use_default_vpc ? 0 : 1
  source              = "Young-ook/spinnaker/aws//modules/spinnaker-aware-aws-vpc"
  name                = var.name
  tags                = var.tags
  azs                 = var.azs
  cidr                = "10.10.0.0/16"
  vpc_endpoint_config = []
  enable_igw          = false
  enable_ngw          = false
}

module "efs" {
  depends_on = [module.vpc]
  source     = "../../modules/efs"
  name       = var.name
  tags       = var.tags
  vpc        = var.use_default_vpc ? null : module.vpc.0.vpc.id
  subnets    = var.use_default_vpc ? null : values(module.vpc.0.subnets["private"])
}
