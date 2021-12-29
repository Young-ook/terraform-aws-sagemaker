# Amazon Personalize with SageMaker

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# sagemaker
module "sagemaker" {
  source = "../../"
  name   = var.name
  tags   = var.tags
  notebook_instances = [
    {
      name                    = "default"
      instance_type           = "ml.m5.xlarge"
      default_code_repository = aws_sagemaker_code_repository.repo.code_repository_name
    }
  ]
}

# personalize sample
resource "aws_sagemaker_code_repository" "repo" {
  code_repository_name = "amazon-personalize-samples"
  git_config {
    repository_url = "https://github.com/aws-samples/amazon-personalize-samples.git"
  }
}
