### default values

locals {
  default_tgw_config = {
    default_route_table_association = false
    default_route_table_propagation = false
    auto_accept_shared_attachments  = false
    vpn_ecmp_support                = true
    dns_support                     = true
    amazon_side_asn                 = "64512"
  }
}
