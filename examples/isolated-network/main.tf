# SageMaker isolated-network

terraform {
  required_version = "0.13.5"
}

provider "aws" {
  region = var.aws_region
}

# isolated vpc
module "isolated-vpc" {
  source = "Young-ook/spinnaker/aws//modules/spinnaker-aware-aws-vpc"
  name   = join("-", [var.name, "isolated"])
  tags   = var.tags
  azs    = var.azs
  cidr   = "10.10.0.0/16"
  vpc_endpoint_config = [
    {
      service             = "notebook"
      type                = "Interface"
      private_dns_enabled = false
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
      service             = "sts"
      type                = "Interface"
      private_dns_enabled = true
    },
  ]
  enable_igw = false
  enable_ngw = false
}

# control plane network
module "control-plane-vpc" {
  source              = "Young-ook/spinnaker/aws//modules/spinnaker-aware-aws-vpc"
  name                = join("-", [var.name, "control-plane"])
  tags                = var.tags
  azs                 = var.azs
  cidr                = "10.20.0.0/16"
  vpc_endpoint_config = []
  enable_igw          = true
  enable_ngw          = false
}

# transit gateway
module "tgw" {
  source                                = "terraform-aws-modules/transit-gateway/aws"
  version                               = "~> 2.0"
  name                                  = var.name
  tags                                  = var.tags
  share_tgw                             = false
  enable_auto_accept_shared_attachments = true

  vpc_attachments = {
    isolated-vpc = {
      vpc_id      = module.isolated-vpc.vpc.id
      subnet_ids  = values(module.isolated-vpc.subnets["private"])
      dns_support = true
      tgw_routes = [
        {
          destination_cidr_block = "10.10.0.0/16"
        },
      ]
    }
    control-plane-vpc = {
      vpc_id      = module.control-plane-vpc.vpc.id
      subnet_ids  = values(module.control-plane-vpc.subnets["private"])
      dns_support = true
      tgw_routes = [
        {
          destination_cidr_block = "10.20.0.0/16"
        },
      ]
    }
  }
}

# sagemaker
module "sagemaker" {
  source             = "../../"
  name               = var.name
  tags               = var.tags
  vpc                = module.isolated-vpc.vpc.id
  subnets            = values(module.isolated-vpc.subnets["private"])
  notebook_instances = var.notebook_instances
}
