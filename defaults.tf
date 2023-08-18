### default values

## aws partition and region (global, gov, china)
module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

locals {
  default_notebook_config = {
    direct_internet_access = "Enabled"
    instance_type          = "ml.t2.medium"
    volume_size            = "5" # The size, in GB
    lifecycle_config       = null
  }
}
