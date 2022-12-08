tags               = { example = "eks_blueprint" }
notebook_instances = []
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
    }
  ]
}
