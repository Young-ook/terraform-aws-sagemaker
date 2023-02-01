# SageMaker isolated-network

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# isolated vpc
module "vpc" {
  source  = "Young-ook/vpc/aws"
  version = "1.0.3"
  name    = join("-", [var.name, "aws"])
  tags    = var.tags
  vpc_config = {
    azs         = var.azs
    cidr        = "10.10.0.0/16"
    subnet_type = "isolated"
  }
  vpce_config = [
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
}

# corp network
module "corp" {
  source  = "Young-ook/vpc/aws"
  version = "1.0.3"
  name    = join("-", [var.name, "corp"])
  tags    = var.tags
  vpc_config = {
    azs         = var.azs
    cidr        = "10.20.0.0/16"
    subnet_type = "isolated"
  }
  vpce_config = [
    {
      service             = "ec2messages"
      type                = "Interface"
      private_dns_enabled = true
    },
    {
      service             = "ssmmessages"
      type                = "Interface"
      private_dns_enabled = true
    },
    {
      service             = "ssm"
      type                = "Interface"
      private_dns_enabled = true
    },
  ]
}

# transit gateway
module "tgw" {
  source     = "Young-ook/vpc/aws//modules/tgw"
  version    = "1.0.3"
  tags       = var.tags
  tgw_config = {}
  vpc_attachments = {
    vpc = {
      vpc     = module.vpc.vpc.id
      subnets = values(module.vpc.subnets["private"])
    }
    corp = {
      vpc     = module.corp.vpc.id
      subnets = values(module.corp.subnets["private"])
    }
  }
}

# sagemaker
module "sagemaker" {
  source  = "Young-ook/sagemaker/aws"
  version = "0.3.2"
  name    = var.name
  tags    = var.tags
  vpc     = module.vpc.vpc.id
  subnets = values(module.vpc.subnets["private"])
  notebook_instances = [
    {
      name          = "default"
      instance_type = "ml.t3.large"

      # Supported values: Enabled (Default) or Disabled. If set to Disabled,
      # the notebook instance will be able to access resources only in your VPC
      direct_internet_access = "Disabled"
    }
  ]
}

# client
data "aws_ami" "win" {
  most_recent = true
  owners      = ["801119661308"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "client" {
  source      = "Young-ook/ssm/aws"
  version     = "0.0.7"
  name        = var.name
  tags        = var.tags
  subnets     = values(module.corp.subnets["private"])
  policy_arns = [aws_iam_policy.client.arn]
  node_groups = [
    {
      name          = "linux"
      max_size      = 1
      instance_type = "t3.large"
    },
    {
      name          = "windows"
      max_size      = 1
      instance_type = "t3.large"
      image_id      = data.aws_ami.win.id
    },
  ]
}

resource "aws_iam_policy" "client" {
  name = join("-", [var.name, "create-presigned-url"])
  tags = var.tags
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sagemaker:CreatePresignedNotebookInstanceUrl",
        ]
        Effect   = "Allow"
        Resource = ["*"]
      },
    ]
  })
}
