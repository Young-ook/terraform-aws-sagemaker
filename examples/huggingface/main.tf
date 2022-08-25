# Hugging Face Transformers Amazon SageMaker Examples

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# resource name
module "frigga" {
  source  = "Young-ook/spinnaker/aws//modules/frigga"
  version = "2.3.5"
}

# (default) vpc
module "vpc" {
  source = "Young-ook/vpc/aws"
  name   = module.frigga.name
  tags   = var.tags
}

# sagemaker
module "sagemaker" {
  source  = "Young-ook/sagemaker/aws"
  name    = module.frigga.name
  tags    = var.tags
  vpc     = module.vpc.vpc.id
  subnets = values(module.vpc.subnets.public)
  notebook_instances = [
    {
      name                    = "default"
      instance_type           = "ml.m5.xlarge"
      default_code_repository = aws_sagemaker_code_repository.repo.code_repository_name
    }
  ]
}

# huggingface examples repo
resource "aws_sagemaker_code_repository" "repo" {
  code_repository_name = "huggingface"
  git_config {
    repository_url = "https://github.com/huggingface/notebooks.git"
  }
}
