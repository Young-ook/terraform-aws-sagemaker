## aws partition and region (global, gov, china)
module "current" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

# security/firewall
resource "aws_security_group" "sagemaker" {
  name        = format("%s", var.name)
  description = format("security group for %s", var.name)
  vpc_id      = var.vpc
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
