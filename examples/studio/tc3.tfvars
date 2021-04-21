aws_region      = "ap-northeast-1"
azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
name            = "sagemaker-tc3"
use_default_vpc = true
tags = {
  env  = "dev"
  test = "tc3"
}
notebook_instances = [
  {
    name          = "default"
    instance_type = "ml.t2.medium"
  }
]
