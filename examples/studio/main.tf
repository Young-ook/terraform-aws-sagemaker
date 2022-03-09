# SageMaker Studio

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# vpc
module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "2.70.0"
  create_vpc         = !var.use_default_vpc
  name               = var.name
  azs                = var.azs
  cidr               = "10.0.0.0/16"
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  enable_nat_gateway = false
  tags               = var.tags

  # enable dns support
  enable_dns_hostnames = true
  enable_dns_support   = true

  # vpc endpoint for s3
  enable_s3_endpoint = true

  # vpc endpoint for ecr
  enable_ecr_api_endpoint              = true
  ecr_api_endpoint_private_dns_enabled = true
  ecr_api_endpoint_security_group_ids  = [aws_security_group.vpce.id]

  enable_ecr_dkr_endpoint              = true
  ecr_dkr_endpoint_private_dns_enabled = true
  ecr_dkr_endpoint_security_group_ids  = [aws_security_group.vpce.id]

  # vpc endpoint for sts
  enable_sts_endpoint             = true
  sts_endpoint_security_group_ids = [aws_security_group.vpce.id]

  # vpc endpoint for cloudwatch
  enable_logs_endpoint             = true
  logs_endpoint_security_group_ids = [aws_security_group.vpce.id]

  enable_monitoring_endpoint             = true
  monitoring_endpoint_security_group_ids = [aws_security_group.vpce.id]

  # vpc endpoint for sagemaker
  enable_sagemaker_api_endpoint             = true
  sagemaker_api_endpoint_security_group_ids = [aws_security_group.vpce.id]

  enable_sagemaker_notebook_endpoint             = true
  sagemaker_notebook_endpoint_region             = var.aws_region
  sagemaker_notebook_endpoint_security_group_ids = [aws_security_group.vpce.id]

  enable_sagemaker_runtime_endpoint             = true
  sagemaker_runtime_endpoint_security_group_ids = [aws_security_group.vpce.id]
}

module "default-vpc" {
  source = "Young-ook/vpc/aws"
  name   = var.name
  tags   = var.tags
}

# security/firewall
resource "aws_security_group" "vpce" {
  name        = format("%s-%s", var.name, "vpce")
  description = format("security group for vpc endpoint for %s", var.name)
  vpc_id      = var.use_default_vpc ? module.default-vpc.vpc.id : module.vpc.vpc_id
  tags        = var.tags

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [module.sagemaker.security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# bucket
module "s3" {
  source          = "./bucket"
  tags            = var.tags
  vpc_endpoint_s3 = var.use_default_vpc ? null : module.vpc.vpc_endpoint_s3_id
}

# sagemaker
module "sagemaker" {
  source             = "../../"
  name               = var.name
  tags               = var.tags
  vpc                = var.use_default_vpc ? module.default-vpc.vpc.id : module.vpc.vpc_id
  subnets            = var.use_default_vpc ? values(module.default-vpc.subnets.public) : module.vpc.private_subnets
  studio             = var.studio
  notebook_instances = var.notebook_instances
}
