output "notebooks" {
  description = "The attributes of the notebook instance"
  value       = module.sm.notebooks
}

output "studio" {
  description = "The attributes of the sagemaker studio"
  value       = module.sm.studio
}

output "users" {
  description = "The attributes of users of sagemaker studio"
  value       = module.sm.users
}

output "vpc" {
  description = "The attributes of vpc for sagemaker"
  value       = module.vpc.vpc
}

output "subnets" {
  description = "The attributes of subnets where to deploy"
  value       = module.vpc.subnets
}
