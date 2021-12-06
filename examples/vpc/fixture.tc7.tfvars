name = "yourvpc"
tags = {
  env           = "dev"
  vpc-type      = "custom"
  subnet-type   = "public"
  nat-per-az    = "single"
  vpn-gateway   = "disabled"
  vpc_endpoints = "none"
  test          = "tc7"
}
aws_region = "ap-northeast-2"
vpc_config = {
  cidr        = "10.9.0.0/16"
  azs         = ["ap-northeast-2a", "ap-northeast-2c"]
  subnet_type = "public" # allowed values : "isolated" | "public" | "standard" 
  single_ngw  = true
}
