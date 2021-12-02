resource "random_string" "uid" {
  length  = 12
  upper   = false
  lower   = true
  number  = false
  special = false
}

locals {
  service  = "sagemaker"
  uid      = join("-", [local.service, random_string.uid.result])
  name     = var.name == null ? local.uid : var.name
  name-tag = { Name = format("%s", local.name) }
  default-tags = merge(
    { "terraform.io" = "managed" },
  )
  sagemaker-shared-tag = {
    format("sagemaker/%s", local.name) = "shared"
  }
}
