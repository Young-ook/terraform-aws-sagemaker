## elastic file system

# efs
resource "aws_efs_file_system" "efs" {
  tags      = merge(local.default-tags, var.tags)
  encrypted = lookup(var.volume, "encrypted", local.default_efs.encrypted)
}

resource "aws_efs_mount_target" "efs" {
  for_each        = { for k, v in var.subnets : k => v }
  file_system_id  = aws_efs_file_system.efs.id
  security_groups = [aws_security_group.efs.id]
  subnet_id       = each.value
}
