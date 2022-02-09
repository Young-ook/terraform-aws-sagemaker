aws_region      = "ap-northeast-2"
azs             = ["ap-northeast-2a", "ap-northeast-2d"]
name            = "sm-studio"
use_default_vpc = true
tags = {
  env = "dev"
}
sagemaker_studio = {
  auth_mode = "IAM"
  user_profiles = [
    {
      name = "default-user"
    }
  ]
}
