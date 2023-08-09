output "sagemaker-studio" {
  description = "The attributes of the sagemaker studio"
  value       = module.studio
}

output "sagemaker-notebooks" {
  description = "The attributes of the notebook instance"
  value       = module.notebook
}

output "emr-studio" {
  description = "Amazon EMR studio"
  value       = module.emr-studio
}
