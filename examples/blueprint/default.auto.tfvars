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
        lifecycle_configs = ["hello", "world"]
        # code_repository config requires version 0.4.1 or higher
        code_repository = [
          "https://github.com/huggingface/notebooks.git",
          "https://github.com/aws-samples/amazon-personalize-samples.git",
          "https://github.com/aws-samples/generative-ai-on-aws-immersion-day.git",
          # ai/ml workshop (korean)
          "https://github.com/aws-samples/aws-ai-ml-workshop-kr.git",
        ]
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
