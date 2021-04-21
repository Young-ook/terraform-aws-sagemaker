# SageMaker Studio

terraform {
  required_version = "0.13.5"
}

provider "aws" {
  region = var.aws_region
}

# sagemaker
module "sagemaker" {
  source             = "../../"
  name               = var.name
  tags               = var.tags
  sagemaker_studio   = null
  notebook_instances = var.notebook_instances
}
