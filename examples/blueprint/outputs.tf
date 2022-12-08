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
