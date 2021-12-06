tags = {
  env           = "dev"
  vpc-type      = "custom"
  subnet-type   = "public"
  vpc_endpoints = "s3-essential"
  test          = "tc6"
}
aws_region = "us-east-1"
vpc_config = {
  cidr        = "10.9.0.0/16"
  azs         = ["us-east-1a", "us-east-1c"]
  subnet_type = "public" # allowed values : "isolated" | "public" | "private" 
  single_ngw  = true
}
vpce_config = [
  {
    service             = "s3"
    type                = "Interface"
    private_dns_enabled = false
  },
]
