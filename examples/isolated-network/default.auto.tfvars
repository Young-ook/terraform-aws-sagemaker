aws_region = "ap-northeast-2"
azs        = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
name       = "sagemaker-url-tc1"
tags = {
  env  = "dev"
  test = "tc1"
}
notebook_instances = [
  {
    name          = "default"
    instance_type = "ml.t3.large"

    # Supported values: Enabled (Default) or Disabled. If set to Disabled,
    # the notebook instance will be able to access resources only in your VPC
    direct_internet_access = "Disabled"
  }
]
