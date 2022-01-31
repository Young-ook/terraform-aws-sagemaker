# S3 bucket

provider "aws" {
  region = "ap-northeast-2"
}

module "s3" {
  source                            = "../../modules/s3"
  name                              = var.name
  tags                              = var.tags
  force_destroy                     = var.force_destroy
  versioning                        = var.versioning
  lifecycle_rules                   = var.lifecycle_rules
  intelligent_tiering_archive_rules = var.intelligent_tiering_archive_rules
}
