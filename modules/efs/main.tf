### elastic file system

# efs
resource "aws_efs_file_system" "efs" {
  tags = merge(local.default-tags, var.tags)
}

resource "aws_efs_mount_target" "efs" {
  for_each        = { for k, v in var.subnets : k => v }
  file_system_id  = aws_efs_file_system.efs.id
  security_groups = [aws_security_group.efs.id]
  subnet_id       = each.value
}

resource "aws_efs_access_point" "ap" {
  tags           = merge(local.default-tags, var.tags)
  file_system_id = aws_efs_file_system.efs.id

  ### directory on the Amazon EFS file system that the access point provides access to.
  root_directory {
    path = local.default_access_point.path
    creation_info {
      owner_uid   = local.default_access_point.acl.owner_uid
      owner_gid   = local.default_access_point.acl.owner_gid
      permissions = local.default_access_point.acl.permissions
    }
  }

  ### operating system user and group applied to all file system requests made using the access point.
  posix_user {
    uid = local.default_access_point.posix_user.uid
    gid = local.default_access_point.posix_user.gid
  }
}
