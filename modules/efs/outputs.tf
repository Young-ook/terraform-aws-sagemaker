# output variables

output "efs" {
  description = "Attributes of the generated efs"
  value       = aws_efs_file_system.efs
}

output "mnt" {
  description = "A list of mount target to access efs volume"
  value       = aws_efs_mount_target.efs
}

output "security_group" {
  description = "The attributes of security group for efs"
  value       = aws_security_group.efs
}
