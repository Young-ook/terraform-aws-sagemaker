### output variables

output "fsx" {
  description = "Attributes of the generated fsx"
  value       = aws_fsx_lustre_file_system.fsx
}

output "mnt" {
  description = "FSx for Lustre file system mount script"
  value = templatefile("${path.module}/templates/mnt.tpl", {
    dns_name = aws_fsx_lustre_file_system.fsx.dns_name
    mnt_name = aws_fsx_lustre_file_system.fsx.mount_name
  })
}
