## aws partition and region (global, gov, china)
module "current" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

## features
locals {
  use_default_vpc         = (var.vpc == null || var.vpc == "") ? true : false
  use_default_vpc_subnets = (var.subnets == null || var.subnets == "") ? true : false
}

## default vpc
data "aws_vpc" "vpc" {
  for_each = local.use_default_vpc ? toset(["default"]) : toset([])
  default  = true
}

data "aws_subnet_ids" "subnets" {
  for_each = local.use_default_vpc_subnets ? toset(["default"]) : toset([])
  vpc_id   = data.aws_vpc.vpc["default"].id
}

locals {
  vpc_id     = local.use_default_vpc ? data.aws_vpc.vpc["default"].id : var.vpc
  subnet_ids = local.use_default_vpc_subnets ? data.aws_subnet_ids.subnets["default"].ids : var.subnets
}

# security/firewall
resource "aws_security_group" "efs" {
  name        = format("%s", local.name)
  description = format("default security group for %s", local.name)
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
