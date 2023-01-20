### default values

locals {
  default_studio_config = {
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
  default_notebook_config = {
    direct_internet_access = "Enabled"
    instance_type          = "ml.t2.medium"
    volume_size            = "5" # The size, in GB
    lifecycle_config = {
      on_create = ""
      on_start  = ""
    }
  }
}
