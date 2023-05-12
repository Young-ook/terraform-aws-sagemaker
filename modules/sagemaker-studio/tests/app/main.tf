terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
  }
}

module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

module "vpc" {
  source  = "Young-ook/vpc/aws"
  version = "1.0.3"
}

module "main" {
  source  = "../.."
  vpc     = module.vpc.vpc.id
  subnets = values(module.vpc.subnets["public"])
  studio = {
    # Supported values: PublicInternetOnly (Default) or VpcOnly.
    # To disable direct internet access, set to VpcOnly when onboarding to Studio.
    app_network_access_type = "VpcOnly"

    # The mode of authentication that members use to access the domain.
    # Valid values are IAM and SSO.
    auth_mode = "IAM"
    app_configs = [
      {
        name    = "userxyz"
        profile = "hello"
        type    = "JupyterServer"
      }
    ]
    user_profiles = [
      {
        name = "hello"
        jupyter_server_app_settings = {
          lifecycle_configs = ["hello", "world"]
        }
      }
    ]
    lifecycle_configs = [
      {
        name    = "hello"
        type    = "JupyterServer"
        content = "echo hello"
      },
      {
        name    = "world"
        type    = "JupyterServer"
        content = "echo world"
      },
      {
        name    = "distributed-training"
        type    = "KernelGateway"
        content = "echo hello"
      },
    ]
  }
}
