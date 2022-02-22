aws_region = "ap-northeast-2"
name       = "s3-tc4"
tags = {
  env                         = "dev"
  test                        = "tc4"
  versioning                  = "false"
  force-destroy               = "true"
  lifecycle-rules             = "disabled"
  intelligent-tiering-archive = "enabled"
}
force_destroy = true
versioning    = "Enabled"
intelligent_tiering_archive_rules = [
  {
    state = "Disabled"
    tiering = [
      {
        # allowed values for 'access_tier':
        #   ARCHIVE_ACCESS, DEEP_ARCHIVE_ACCESS
        access_tier = "ARCHIVE_ACCESS"
        days        = 125
      },
    ]
  }
]
