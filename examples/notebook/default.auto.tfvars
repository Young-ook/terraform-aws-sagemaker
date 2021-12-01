aws_region      = "ap-northeast-1"
azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
name            = "sagemaker-notebook"
use_default_vpc = true
tags = {
  env = "dev"
}
notebook_instances = [
  {
    name          = "default"
    instance_type = "ml.t2.medium"
  }
]
