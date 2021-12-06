output "vpc" {
  value = module.vpc.vpc
}

output "subnets" {
  value = module.vpc.subnets
}

output "route_tables" {
  value = module.vpc.route_tables
}

output "vpce" {
  value = module.vpc.vpce
}

output "vgw" {
  value = module.vpc.vgw
}
