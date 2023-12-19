output "studio" {
  description = "The attributes of the sagemaker studio"
  value       = module.studio
}

output "notebooks" {
  description = "The attributes of the notebook instance"
  value       = module.notebook
}

output "file_systems" {
  description = "File systems"
  value = {
    efs = module.efs
    fsx = module.lustre
  }
}
