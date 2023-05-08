output "studio" {
  description = "The attributes of the sagemaker studio"
  value       = module.studio
}

output "notebooks" {
  description = "The attributes of the notebook instance"
  value       = module.notebook
}

output "repo" {
  description = "The attributes of code repository"
  value       = aws_sagemaker_code_repository.repo
}
