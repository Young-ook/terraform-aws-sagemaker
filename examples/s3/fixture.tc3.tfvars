aws_region = "ap-northeast-2"
name       = "s3-tc3"
tags = {
  env                         = "dev"
  test                        = "tc3"
  versioning                  = "false"
  force-destroy               = "true"
  lifecycle-rules             = "enabled"
  intelligent-tiering-archive = "enabled"
}
force_destroy = true
versioning    = true
lifecycle_rules = [
  {
    enabled = true
    transition = [
      {
        days = 0
        # valid values for 'storage_class':
        #   STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING,
        #   GLACIER, DEEP_ARCHIVE, GLACIER_IR
        storage_class = "INTELLIGENT_TIERING"
      },
    ]
  },
]
intelligent_tiering_archive_rules = {
  state = "Enabled"
  filter = [
    {
      prefix = "logs/"
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
