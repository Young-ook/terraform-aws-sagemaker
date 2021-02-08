## aws partition and region (global, gov, china)
data "aws_partition" "current" {}

## default vpc
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

locals {
  vpc_id     = var.vpc == null ? data.aws_vpc.default.id : var.vpc
  subnet_ids = var.subnets == null ? data.aws_subnet_ids.default.ids : var.subnets
}

# security/firewall
resource "aws_security_group" "sagemaker" {
  name        = format("%s", var.name)
  description = format("security group for %s", var.name)
  vpc_id      = local.vpc_id
  tags        = merge(local.default-tags, var.tags)

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
