tags = {
  env           = "dev"
  vpc-type      = "custom"
  subnet-type   = "private"
  nat-per-az    = "single"
  vpc-endpoints = "none"
  test          = "tc1"
}
aws_region = "ap-northeast-2"
vpc_config = {
  cidr        = "10.9.0.0/16"
  azs         = ["ap-northeast-2a", "ap-northeast-2c"]
  subnet_type = "private" # allowed values : "isolated" | "public" | "private" 
  single_ngw  = true
}
