aws_region      = "ap-northeast-1"
azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
name            = "sagemaker-studio-tc1"
use_default_vpc = false
tags = {
  env  = "dev"
  test = "tc1"
}
sagemaker_studio = {
  app_network_access_type = "VpcOnly"
  auth_mode               = "IAM"
}
