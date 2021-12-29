# security/firewall
resource "aws_security_group" "efs" {
  name        = format("%s", local.name)
  description = format("default security group for %s", local.name)
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
