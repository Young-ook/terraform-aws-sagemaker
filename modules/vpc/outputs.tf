### output variables

output "vpc" {
  description = "The attributes of the default VPC Id"
  value       = (local.use_default_vpc ? data.aws_vpc.default.0 : aws_vpc.vpc.0)
}

output "subnets" {
  description = "A list of subnet IDs in the default VPC"
  value = (local.use_default_vpc ?
    {
      public = { for net in data.aws_subnet.default : net.availability_zone => net.id }
    } :
    {
      private = { for k, v in aws_subnet.private : k => v.id }
    }
  )
}

output "route_tables" {
  description = "A list of subnet IDs in the default VPC"
  value = (local.use_default_vpc ?
    {
      main = data.aws_vpc.default.0.main_route_table_id
    } :
    {
      private = { for k, v in aws_route_table.private : k => v.id }
    }
  )
}
