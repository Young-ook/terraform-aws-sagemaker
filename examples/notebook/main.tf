# SageMaker Notebook

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  count               = var.use_default_vpc ? 0 : 1
  source              = "Young-ook/spinnaker/aws//modules/spinnaker-aware-aws-vpc"
  name                = join("-", [var.name, "aws"])
  tags                = var.tags
  azs                 = var.azs
  cidr                = "10.10.0.0/16"
  vpc_endpoint_config = []
  enable_igw          = false
  enable_ngw          = false
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
