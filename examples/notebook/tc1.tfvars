aws_region      = "ap-northeast-1"
azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
name            = "sagemaker-notebook-tc1"
use_default_vpc = true
tags = {
  env  = "dev"
  test = "tc1"
}
notebook_instances = [
  {
    name          = "default"
    instance_type = "ml.t2.medium"

    # Supported values: Enabled (Default) or Disabled. If set to Disabled,
    # the notebook instance will be able to access resources only in your VPC
    direct_internet_access = "Disabled"
  }
]
