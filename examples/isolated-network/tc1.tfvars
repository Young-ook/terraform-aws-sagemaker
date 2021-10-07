aws_region = "ap-northeast-2"
azs        = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
name       = "sagemaker-fsi-tc1"
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
node_groups = [
  {
    name          = "win"
    max_size      = 1
    instance_type = "t3.large"
    image_id      = "ami-04a18ed8b7b44aced" # Windows Server 2019 English Full Base (ap-northeast-2)
  },
]
