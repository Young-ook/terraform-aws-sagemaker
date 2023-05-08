### default variables

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
    user_profiles = [
      {
        name = "default"
      }
    ]
  }
}