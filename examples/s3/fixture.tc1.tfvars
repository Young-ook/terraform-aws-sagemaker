aws_region = "ap-northeast-2"
name       = "s3-tc1"
tags = {
  env           = "dev"
  test          = "tc1"
  versioning    = "true"
  force-destroy = "true"
}
force_destroy = true
versioning    = true
