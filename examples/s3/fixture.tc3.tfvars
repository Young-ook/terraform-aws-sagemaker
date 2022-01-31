aws_region = "ap-northeast-2"
name       = "s3-tc3"
tags = {
  env                 = "dev"
  test                = "tc3"
  versioning          = "false"
  force-destroy       = "true"
  lifecycle-rules     = "disabled"
  intelligent-tiering = "enabled"
}
force_destroy   = true
versioning      = true
lifecycle_rules = []
intelligent_tiering = {
  state = "Enabled"
  filter = [
    {
      prefix = "documents/"
      tags = {
        priority = "high"
        class    = "blue"
      }
    },
  ]
  tiering = [
    {
      access_tier = "ARCHIVE_ACCESS"
      days        = 125
    },
    {
      access_tier = "DEEP_ARCHIVE_ACCESS"
      days        = 180
    },
  ]
}
