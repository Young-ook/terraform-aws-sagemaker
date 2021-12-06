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
}
