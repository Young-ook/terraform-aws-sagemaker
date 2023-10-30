### output variables

output "fsx" {
  description = "Attributes of the generated fsx"
  value       = aws_fsx_lustre_file_system.fsx
}
