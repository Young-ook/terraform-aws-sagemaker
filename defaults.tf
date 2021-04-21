### default values

locals {
  default_studio_config = {
    app_network_access_type = "PublicInternetOnly"
    auth_mode               = "IAM"
    user_profiles = [
      {
        name = "default"
      }
    ]
  }
  default_notebook_config = {
    direct_internet_access = "Enabled"
    instance_type          = "ml.t2.medium"
  }
}
