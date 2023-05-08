# output variables 

output "notebooks" {
  description = "The attributes of the notebook instances"
  value       = aws_sagemaker_notebook_instance.ni
}

output "security_group" {
  description = "The attributes of security group for the sagemaker (studio)"
  value       = aws_security_group.sagemaker
}

output "endpoints" {
  description = "The attributes of sagemaker endpoints for inference"
  value       = aws_sagemaker_endpoint_configuration.ep
}
