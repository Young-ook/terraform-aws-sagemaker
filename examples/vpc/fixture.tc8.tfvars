tags = {
  env           = "dev"
  vpc-type      = "default"
  vpc_endpoints = "s3-essential"
  test          = "tc8"
}
aws_region = "us-east-1"
vpce_config = [
  {
    service             = "s3"
    type                = "Interface"
    private_dns_enabled = false
  },
]
