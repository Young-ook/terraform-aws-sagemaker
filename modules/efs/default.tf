### default values

locals {
  default_access_point = {
    path = "/"
    acl = {
      owner_gid   = "1001"
      owner_uid   = "1001"
      permissions = "750"
    }
    posix_user = {
      uid = "1001"
      gid = "1001"
    }
  }
}
