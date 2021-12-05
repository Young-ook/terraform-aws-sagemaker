### default values

locals {
  default_vpc_config = {
    cidr        = "10.0.0.0/16"
    azs         = ["us-east-1a", "us-east-1b", "us-east-1c"]
    subnet_type = "standard" # allowed values : "isolated" | "public" | "standard"
    single_ngw  = false
  }
  default_vgw_config = {
    enable_vgw      = false
    amazon_side_asn = "64512"
  }
  default_vpce_config = [
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

}
