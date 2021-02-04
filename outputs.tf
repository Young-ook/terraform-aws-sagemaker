# output variables 

output "notebooks" {
  description = "The attributes of the notebook instances"
  value       = aws_sagemaker_notebook_instance.ni
}

output "studio" {
  description = "The attributes of the sagemaker domain (studio)"
  value       = aws_sagemaker_domain.studio
}

output "users" {
  description = "The attributes of the users of sagemaker domain (studio)"
  value       = aws_sagemaker_user_profile.user
}

output "security_group" {
  description = "The attributes of security group for the sagemaker (studio)"
  value       = aws_security_group.sagemaker
}
