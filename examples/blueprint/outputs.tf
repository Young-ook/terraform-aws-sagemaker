output "notebooks" {
  description = "The attributes of the notebook instance"
  value       = module.sagemaker.notebooks
}

output "studio" {
  description = "The attributes of the sagemaker studio"
  value       = module.sagemaker.studio
}

output "users" {
  description = "The attributes of users of sagemaker studio"
  value       = module.sagemaker.users
}

output "endpoints" {
  description = "The attributes of sagemaker endpoints"
  value       = module.sagemaker.endpoints
}

output "repo" {
  description = "The attributes of code repository"
  value       = aws_sagemaker_code_repository.repo
}
