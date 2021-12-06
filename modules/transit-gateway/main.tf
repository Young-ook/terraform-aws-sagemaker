## transit gateway

module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

## parameters
locals {
  amazon_side_asn                  = lookup(var.tgw_config, "amazon_side_asn", local.default_tgw_config.amazon_side_asn)
  default_route_table_assocication = lookup(var.tgw_config, "enable_default_route_table_association", local.default_tgw_config.default_route_table_association)
  default_route_table_propagation  = lookup(var.tgw_config, "enable_default_route_table_propagation", local.default_tgw_config.default_route_table_propagation)
  auto_accept_shared_attachments   = lookup(var.tgw_config, "enable_auto_accept_shared_attachments", local.default_tgw_config.auto_accept_shared_attachments)
  vpn_ecmp_support                 = lookup(var.tgw_config, "enable_vpn_ecmp_support", local.default_tgw_config.vpn_ecmp_support)
  dns_support                      = lookup(var.tgw_config, "enable_dns_support", local.default_tgw_config.dns_support)
}

## feature
locals {
}

## default tgw
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = local.name
  tags                            = merge(local.default-tags, var.tags)
  default_route_table_association = local.default_route_table_assocication ? "enable" : "disable"
  default_route_table_propagation = local.default_route_table_propagation ? "enable" : "disable"
  auto_accept_shared_attachments  = local.auto_accept_shared_attachments ? "enable" : "disable"
  vpn_ecmp_support                = local.vpn_ecmp_support ? "enable" : "disable"
  dns_support                     = local.dns_support ? "enable" : "disable"
  amazon_side_asn                 = local.amazon_side_asn

  lifecycle {
    create_before_destroy = true
  }
}
