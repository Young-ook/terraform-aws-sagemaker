aws_region      = "ap-northeast-2"
azs             = ["ap-northeast-2a", "ap-northeast-2c", ]
use_default_vpc = false
name            = "efs-tc1"
tags = {
  test = "tc1"
  vpc  = "custom"
}
