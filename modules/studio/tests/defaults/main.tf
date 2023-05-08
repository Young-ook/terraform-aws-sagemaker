terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
  }
}

module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

module "vpc" {
  source  = "Young-ook/vpc/aws"
  version = "1.0.3"
}

module "s3" {
  source  = "Young-ook/sagemaker/aws//modules/s3"
  version = "0.3.4"
}

module "main" {
  source  = "../.."
  vpc     = module.vpc.vpc.id
  subnets = values(module.vpc.subnets["public"])
  studio  = {}
}
