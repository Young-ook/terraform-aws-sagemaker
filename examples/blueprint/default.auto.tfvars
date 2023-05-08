tags               = { example = "sagemaker_blueprint" }
notebook_instances = null
studio = {
  # Supported values: PublicInternetOnly (Default) or VpcOnly.
  # To disable direct internet access, set to VpcOnly when onboarding to Studio.
  app_network_access_type = "VpcOnly"

  # The mode of authentication that members use to access the domain.
  # Valid values are IAM and SSO.
  auth_mode = "IAM"
  user_profiles = [
    {
      name = "default"
      jupyter_server_app_settings = {
        lifecycle_rule = "hello"
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
      name    = "distributed-training"
      type    = "KernelGateway"
      content = "echo hello"
    },
  ]
}
