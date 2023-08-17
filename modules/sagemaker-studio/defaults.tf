### default values

### aws partitions
module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

locals {
  default_studio = {
    app_network_access_type = "PublicInternetOnly"
    auth_mode               = "IAM"
    lifecycle_configs = [
      {
        type    = "JupyterServer"
        content = "studio_lifecycle_config_content to be in the range (1 - 16384)"
      },
      {
        type    = "KernelGateway"
        content = "studio_lifecycle_config_content to be in the range (1 - 16384)"
      }
    ]
  }
  default_app = {
    ### Allowed values: JupyterServer, KernelGateway, RStudioServerPro, RSessionGateway and TensorBoard.
    type    = "JupyterServer"
    name    = "default"
    profile = "default"
  }
  default_user_profile = {
    name = "default"
  }
}
