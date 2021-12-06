tags = {
  env           = "dev"
  vpc-type      = "custom"
  subnet-type   = "isolated"
  vpn-gateway   = "enabled"
  vpc-endpoints = "none"
  test          = "tc5"
}
aws_region = "ap-northeast-2"
vpc_config = {
  cidr        = "10.1.0.0/16"
  azs         = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  subnet_type = "isolated" # allowed values : "isolated" | "public" | "private" 
}
vgw_config = {
  enable_vgw = true
}
