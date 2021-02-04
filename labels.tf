resource "random_string" "sagemaker-suffix" {
  length  = 12
  upper   = false
  lower   = true
  number  = false
  special = false
}

locals {
  name = var.name == null ? join("-", ["sagemaker", random_string.sagemaker-suffix.result]) : var.name
  default-tags = merge(
    { "terraform.io" = "managed" },
  )
  name-tag = {
    Name = format("%s", local.name)
  }
  sagemaker-shared-tag = {
    format("sagemaker/%s", local.name) = "shared"
  }
}
