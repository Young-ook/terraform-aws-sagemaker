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

module "main" {
  source  = "../.."
  subnets = [element(values(module.vpc.subnets["public"]), 0)]
}
