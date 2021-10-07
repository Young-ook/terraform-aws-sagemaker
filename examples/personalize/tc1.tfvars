aws_region      = "ap-northeast-1"
azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
name            = "sagemaker-personalize-tc1"
use_default_vpc = true
tags = {
  env  = "dev"
  test = "tc1"
}
sagemaker_studio = {
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
