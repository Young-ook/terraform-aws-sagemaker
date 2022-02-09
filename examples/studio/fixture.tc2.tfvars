aws_region      = "ap-northeast-2"
azs             = ["ap-northeast-2a", "ap-northeast-2c", "ap-northeast-2d"]
name            = "sagemaker-studio-tc2"
use_default_vpc = true
tags = {
  env  = "dev"
  test = "tc2"
}
sagemaker_studio = {
  auth_mode     = "IAM"
  user_profiles = []
}
