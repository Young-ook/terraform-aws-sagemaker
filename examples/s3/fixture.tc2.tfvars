aws_region = "ap-northeast-2"
name       = "s3-tc2"
tags = {
  env                         = "dev"
  test                        = "tc2"
  versioning                  = "true"
  force-destroy               = "true"
  lifecycle-rules             = "enabled"
  intelligent-tiering-archive = "disabled"
}
force_destroy = true
versioning    = "Enabled"
lifecycle_rules = [
  {
    id     = "intelligent_tiering"
    status = "Enabled"
    filter = {
      prefix = "datas/"
    }
    expiration = {
      days = 365
    }
    transition = [
      {
        days = 0
        # valid values for 'storage_class':
        #   STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING,
        #   GLACIER, DEEP_ARCHIVE, GLACIER_IR
        storage_class = "INTELLIGENT_TIERING"
      },
      {
        days          = 180
        storage_class = "GLACIER_IR"
      },
    ]
    noncurrent_version_expiration = {
      days = 120
    }
    noncurrent_version_transition = []
  },
  {
    id     = "infrequent_access"
    status = "Enabled"
    transition = [
      {
        days          = 90
        storage_class = "STANDARD_IA"
      },
    ]
  },
  {
    id     = "glacier"
    status = "Disabled"
    transition = [
      {
        days          = 360
        storage_class = "GLACIER"
      },
    ]
  },
]
