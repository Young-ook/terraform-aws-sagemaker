aws_region = "ap-northeast-2"
name       = "s3-tc1"
tags = {
  env                         = "dev"
  test                        = "tc1"
  versioning                  = "true"
  force-destroy               = "true"
  lifecycle-rules             = "disabled"
  intelligent-tiering-archive = "disabled"
}
force_destroy = true
versioning    = "Enabled"
