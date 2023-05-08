terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
  }
}

module "vpc" {
  source  = "Young-ook/vpc/aws"
  version = "1.0.3"
}

module "main" {
  source  = "../.."
  vpc     = module.vpc.vpc.id
  subnets = values(module.vpc.subnets["public"])
  notebook_instances = [
    {
      name = "with-lc"
      lifecycle_config = {
        on_create = "echo 'A notebook has been created'"
        on_start  = "echo 'Notebook started'"
      }
    },
    {
      name          = "without-lc"
      instance_type = "ml.t3.large"
    },
  ]
}

resource "test_assertions" "pet_name" {
  component = "pet_name"

  check "pet_name" {
    description = "default random pet name"
    condition   = can(regex("^sagemaker", module.main.notebooks.with-lc.name))
  }
}
