output "efs" {
  description = "The attributes of efs"
  value       = module.efs.efs
}

output "mnt" {
  description = "A list of mount target to access efs volume"
  value       = module.efs.mnt
}

output "security_group" {
  description = "The attributes of security group for efs"
  value       = module.efs.security_group
}
