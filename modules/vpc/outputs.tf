### output variables

output "vpc" {
  description = "The attributes of the default VPC Id"
  value       = data.aws_vpc.default
}

output "subnets" {
  description = "A list of subnet IDs in the default VPC"
  value = zipmap(
    ["public"],
    [{ for net in data.aws_subnet.default : net.availability_zone => net.id }]
  )
}

output "route_tables" {
  description = "A list of subnet IDs in the default VPC"
  value = zipmap(
    ["main"],
    [data.aws_vpc.default.main_route_table_id]
  )
}
