aws_region = "ap-northeast-2"
name       = "s3-tc4"
tags = {
  env                 = "dev"
  test                = "tc4"
  versioning          = "false"
  force-destroy       = "true"
  lifecycle-rules     = "disabled"
  intelligent-tiering = "enabled"
}
force_destroy   = true
versioning      = true
lifecycle_rules = []
intelligent_tiering = {
  state = "Disabled"
  tiering = [
    {
      access_tier = "ARCHIVE_ACCESS"
      days        = 125
    },
  ]
}
