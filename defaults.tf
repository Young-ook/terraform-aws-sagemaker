### default values

locals {
  default_studio_config = {
    app_network_access_type = "VpcOnly"
    auth_mode               = "IAM"
    user_profiles = [
      {
        name = "default"
      }
    ]
  }
}
