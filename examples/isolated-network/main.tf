# SageMaker isolated-network

terraform {
  #required_version = "0.13.5"
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# isolated vpc
module "vpc" {
  source = "Young-ook/spinnaker/aws//modules/spinnaker-aware-aws-vpc"
  name   = join("-", [var.name, "aws"])
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

# peering
resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id = module.vpc.vpc.id
  vpc_id      = module.corp.vpc.id
  auto_accept = true
}

output "route_tables" {
  value = {
    vpc_rt  = values(module.vpc.route_tables.private)
    corp_rt = values(module.corp.route_tables.private)
  }
}

resource "aws_route" "peer-to-corp" {
  for_each                  = module.vpc.route_tables.private
  route_table_id            = each.value
  destination_cidr_block    = module.corp.vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

resource "aws_route" "peer-to-aws" {
  for_each                  = module.corp.route_tables.private
  route_table_id            = each.value
  destination_cidr_block    = module.vpc.vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# control plane network
module "corp" {
  source              = "Young-ook/spinnaker/aws//modules/spinnaker-aware-aws-vpc"
  name                = join("-", [var.name, "corp"])
  tags                = var.tags
  azs                 = var.azs
  cidr                = "10.20.0.0/16"
  vpc_endpoint_config = []
  enable_igw          = true
  enable_ngw          = false
}

# sagemaker
module "sagemaker" {
  source             = "../../"
  name               = var.name
  tags               = var.tags
  vpc                = module.vpc.vpc.id
  subnets            = values(module.vpc.subnets["private"])
  notebook_instances = var.notebook_instances
}

# client
module "client" {
  source      = "Young-ook/ssm/aws"
  name        = var.name
  tags        = var.tags
  subnets     = values(module.corp.subnets["public"])
  policy_arns = [aws_iam_policy.client.arn]
  node_groups = var.node_groups
}

resource "aws_iam_policy" "client" {
  name = join("-", [var.name, "create-presigned-url"])
  #tag = var.tags
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
