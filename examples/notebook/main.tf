# SageMaker Notebook

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# sagemaker
module "sagemaker" {
  source             = "../../"
  name               = var.name
  tags               = var.tags
  notebook_instances = var.notebook_instances
}
