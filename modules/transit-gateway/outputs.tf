### output variables

output "tgw" {
  description = "Attributes of the Transit Gateway (TGW)"
  value       = aws_ec2_transit_gateway.tgw
}
