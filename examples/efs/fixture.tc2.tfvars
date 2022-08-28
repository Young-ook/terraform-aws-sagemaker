aws_region      = "ap-northeast-2"
azs             = ["ap-northeast-2a", "ap-northeast-2d"]
use_default_vpc = true
tags = {
  test = "tc2"
}
notebook_instances = [
  {
    name = "with-lc"
    lifecycle_config = {
      on_create = "echo 'A notebook has been created'"
      on_start  = "echo 'Notebook started'"
    }
  },
  {
    name = "without-lc"
  },
]
