aws_region      = "ap-northeast-2"
azs             = ["ap-northeast-2a", "ap-northeast-2d"]
name            = "sagemaker-notebook-tc2"
use_default_vpc = true
tags = {
  env  = "dev"
  test = "tc2"
}
notebook_instances = [
  {
    name        = "default"
    volume_size = "500"
  }
]
