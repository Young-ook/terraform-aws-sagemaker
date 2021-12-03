## virtual private cloud

## feature
locals {
  use_default_vpc = (var.vpc_config == null || var.vpc_config == {}) ? true : false
  cidr            = lookup(var.vpc_config, "cidr", local.default_vpc_config.cidr)
  azs             = lookup(var.vpc_config, "azs", local.default_vpc_config.azs)
  selected_az     = local.azs.0
  igw_enabled     = lookup(var.vpc_config, "enable_igw", local.default_vpc_config.enable_igw)
  ngw_enabled     = lookup(var.vpc_config, "enable_ngw", local.default_vpc_config.enable_ngw)
  single_ngw      = lookup(var.vpc_config, "single_ngw", local.default_vpc_config.single_ngw)
}

## default vpc
data "aws_vpc" "default" {
  count   = local.use_default_vpc ? 1 : 0
  default = true
}

data "aws_subnet_ids" "default" {
  count  = local.use_default_vpc ? 1 : 0
  vpc_id = data.aws_vpc.default.0.id
}

data "aws_subnet" "default" {
  for_each = local.use_default_vpc ? toset(data.aws_subnet_ids.default.0.ids) : toset([])
  id       = each.key
}

## custom vpc
resource "aws_vpc" "vpc" {
  count                = !local.use_default_vpc ? 1 : 0
  cidr_block           = local.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.default-tags,
    { Name = local.name },
    var.tags,
  )
}

# security/firewall
resource "aws_security_group" "vpce" {
  count       = !local.use_default_vpc ? 1 : 0
  name        = format("%s-%s", local.name, "vpce")
  description = format("security group for vpc endpoint of %s", local.name)
  vpc_id      = aws_vpc.vpc.0.id
  tags        = merge(local.default-tags, var.tags)

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### private subnet
resource "aws_subnet" "private" {
  for_each          = !local.use_default_vpc ? toset(local.azs) : toset([])
  vpc_id            = aws_vpc.vpc.0.id
  availability_zone = each.value
  cidr_block        = cidrsubnet(local.cidr, 8, (index(local.azs, each.value) * 8) + 1)

  tags = merge(
    local.default-tags,
    { Name = join(".", [local.name, "private", each.value]) },
    { "kubernetes.io/role/internal-elb" = "1" },
    var.tags,
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "private" {
  for_each = !local.use_default_vpc ? (local.ngw_enabled && local.single_ngw ? toset([local.selected_az]) : toset(local.azs)) : toset([])
  vpc_id   = aws_vpc.vpc.0.id

  tags = merge(
    local.default-tags,
    { Name = join("-", [local.name, "private", "rt"]) },
    var.tags,
  )
}

resource "aws_route_table_association" "private" {
  for_each       = !local.use_default_vpc ? toset(local.azs) : toset([])
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = local.ngw_enabled && local.single_ngw ? aws_route_table.private[local.selected_az].id : aws_route_table.private[each.key].id
}
