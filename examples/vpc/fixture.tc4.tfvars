tags = {
  env           = "dev"
  vpc-type      = "custom"
  subnet-type   = "isolated"
  vpn-gateway   = "disabled"
  vpc-endpoints = "for-isolated-network"
  test          = "tc4"
}
aws_region = "ap-northeast-2"
vpc_config = {
  cidr        = "10.1.0.0/16"
  azs         = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  subnet_type = "isolated" # allowed values : "isolated" | "public" | "private" 
}
vpce_config = [
  {
    service             = "s3"
    type                = "Interface"
    private_dns_enabled = false
  },
  {
    service             = "ecr.api"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "ecr.dkr"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "ecs"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "ec2"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "ec2messages"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "autoscaling"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "application-autoscaling"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "kinesis-streams"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "kinesis-firehose"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "logs"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "monitoring"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "sts"
    type                = "Interface"
    private_dns_enabled = true
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
  {
    service             = "ssm"
    type                = "Interface"
    private_dns_enabled = true
  },
  {
    service             = "ssmmessages"
    type                = "Interface"
    private_dns_enabled = true
  },
]
