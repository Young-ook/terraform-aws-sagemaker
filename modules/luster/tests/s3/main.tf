terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
  }
}

module "vpc" {
  source  = "Young-ook/vpc/aws"
  version = "1.0.6"
}

module "s3" {
  source        = "Young-ook/sagemaker/aws//modules/s3"
  version       = "0.4.3"
  force_destroy = true
}

module "main" {
  source  = "../.."
  subnets = [element(values(module.vpc.subnets["public"]), 0)]
  filesystem = {
    import_path = format("s3://%s", module.s3.bucket.id)
  }
}
