output "studio" {
  description = "The attributes of the sagemaker studio"
  value       = module.studio
}

output "notebooks" {
  description = "The attributes of the notebook instance"
  value       = module.notebook
}

output "lustre" {
  description = "The attribute of FSx for Lustre file system"
  value       = module.lustre.fsx
}
