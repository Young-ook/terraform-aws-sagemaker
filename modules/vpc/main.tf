## virtual private cloud

## parameters
locals {
  cidr        = lookup(var.vpc_config, "cidr", local.default_vpc_config.cidr)
  azs         = lookup(var.vpc_config, "azs", local.default_vpc_config.azs)
  selected_az = local.azs.0
  single_ngw  = lookup(var.vpc_config, "single_ngw", local.default_vpc_config.single_ngw)
  subnet_type = lookup(var.vpc_config, "subnet_type", local.default_vpc_config.subnet_type)
}

## feature
locals {
  default_vpc = (var.vpc_config == null || var.vpc_config == {}) ? true : false
  vpc         = local.default_vpc ? data.aws_vpc.default.0 : aws_vpc.vpc.0
  isolated    = ("isolated" == local.subnet_type) ? true : false
  public      = ("public" == local.subnet_type) ? true : false
  standard    = ("standard" == local.subnet_type) ? true : false
}

## default vpc
data "aws_vpc" "default" {
  count   = local.default_vpc ? 1 : 0
  default = true
}

data "aws_subnet_ids" "default" {
  count  = local.default_vpc ? 1 : 0
  vpc_id = data.aws_vpc.default.0.id
}

data "aws_subnet" "default" {
  for_each = local.default_vpc ? toset(data.aws_subnet_ids.default.0.ids) : toset([])
  id       = each.key
}

## custom vpc
resource "aws_vpc" "vpc" {
  count                = !local.default_vpc ? 1 : 0
  cidr_block           = local.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.default-tags,
    { Name = local.name },
    var.tags,
  )

  lifecycle {
    create_before_destroy = true
  }
}

# security/firewall
resource "aws_security_group" "vpce" {
  count       = !local.public ? 1 : 0
  name        = format("%s-%s", local.name, "vpce")
  description = format("security group for vpc endpoint of %s", local.name)
  vpc_id      = local.vpc.id
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
  for_each          = !local.default_vpc && !local.public ? toset(local.azs) : toset([])
  vpc_id            = local.vpc.id
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
  for_each = !local.default_vpc && !local.public ? (local.single_ngw ? toset([local.selected_az]) : toset(local.azs)) : toset([])
  vpc_id   = local.vpc.id

  tags = merge(
    local.default-tags,
    { Name = join("-", [local.name, "private", "rt"]) },
    var.tags,
  )
}

resource "aws_route_table_association" "private" {
  for_each       = !local.default_vpc && !local.public ? toset(local.azs) : toset([])
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = local.single_ngw ? aws_route_table.private[local.selected_az].id : aws_route_table.private[each.key].id
}

resource "aws_route" "ingw" {
  for_each               = !local.default_vpc && local.standard ? (local.single_ngw ? toset([local.selected_az]) : toset(local.azs)) : toset([])
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ingw[each.value].id

  timeouts {
    create = "5m"
  }
}

# nat gateway
resource "aws_eip" "ingw" {
  for_each = !local.default_vpc && local.standard ? (local.single_ngw ? toset([local.selected_az]) : toset(local.azs)) : toset([])
  tags     = merge(local.default-tags, var.tags, )
  vpc      = true
}

resource "aws_nat_gateway" "ingw" {
  for_each      = !local.default_vpc && local.standard ? (local.single_ngw ? toset([local.selected_az]) : toset(local.azs)) : toset([])
  allocation_id = aws_eip.ingw[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(
    local.default-tags,
    { Name = join("-", [local.name, "internet-facing", "ngw", each.key]) },
    var.tags,
  )
}

### public subnet
resource "aws_subnet" "public" {
  for_each                = !local.default_vpc && (local.public || local.standard) ? toset(local.azs) : toset([])
  vpc_id                  = local.vpc.id
  availability_zone       = each.value
  cidr_block              = cidrsubnet(local.cidr, 8, (index(local.azs, each.value) * 8) + 2)
  map_public_ip_on_launch = true

  tags = merge(
    local.default-tags,
    { Name = join(".", [local.name, "public", each.value]) },
    { "kubernetes.io/role/elb" = "1" },
    var.tags,
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "public" {
  for_each = !local.default_vpc && (local.public || local.standard) ? toset([local.selected_az]) : toset([])
  vpc_id   = local.vpc.id

  tags = merge(
    local.default-tags,
    { Name = join("-", [local.name, "public", "rt"]) },
    var.tags,
  )
}

resource "aws_route_table_association" "public" {
  for_each       = !local.default_vpc && (local.public || local.standard) ? toset(local.azs) : toset([])
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[local.selected_az].id
}

resource "aws_route" "igw" {
  for_each               = !local.default_vpc && (local.public || local.standard) ? toset([local.selected_az]) : toset([])
  route_table_id         = aws_route_table.public[local.selected_az].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[local.selected_az].id

  timeouts {
    create = "5m"
  }
}

# internet gateway
resource "aws_internet_gateway" "igw" {
  for_each = !local.default_vpc && (local.public || local.standard) ? toset([local.selected_az]) : toset([])
  vpc_id   = local.vpc.id

  tags = merge(
    local.default-tags,
    { Name = join("-", [local.name, "igw"]) },
    var.tags,
  )
}
