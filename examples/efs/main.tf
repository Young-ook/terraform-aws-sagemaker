# elastic file system

provider "aws" {
  region = var.aws_region
}

# vpc
module "vpc" {
  source = "Young-ook/vpc/aws"
  name   = var.name
  tags   = var.tags
  vpc_config = var.use_default_vpc ? null : {
    cidr        = "10.10.0.0/16"
    azs         = var.azs
    subnet_type = "isolated"
    single_ngw  = true
  }
}

# efs
module "efs" {
  depends_on = [module.vpc]
  source     = "../../modules/efs"
  name       = var.name
  tags       = var.tags
  vpc        = module.vpc.vpc.id
  subnets    = var.use_default_vpc ? values(module.vpc.subnets.public) : values(module.vpc.subnets.private)
}

# sagemaker
module "sm" {
  source             = "../../"
  name               = var.name
  tags               = var.tags
  vpc                = module.vpc.vpc.id
  subnets            = var.use_default_vpc ? values(module.vpc.subnets["public"]) : values(module.vpc.subnets["private"])
  notebook_instances = var.notebook_instances
}
