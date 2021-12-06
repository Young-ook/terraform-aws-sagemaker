tags = {
  env           = "dev"
  vpc-type      = "custom"
  subnet-type   = "private"
  nat-per-az    = "single"
  vpc_endpoints = "sagemaker-essential"
  test          = "tc3"
}
aws_region = "us-east-1"
vpc_config = {
  cidr        = "10.9.0.0/16"
  azs         = ["us-east-1a", "us-east-1c"]
  subnet_type = "private" # allowed values : "isolated" | "public" | "private" 
  single_ngw  = true
}
vpce_confnig = [
  {
    service             = "s3"
    type                = "Interface"
    private_dns_enabled = false
  },
  {
    service             = "sagemaker.api"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "sagemaker.runtime"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "notebook"
    type                = "Interface"
    private_dns_enabled = true
  },
]
