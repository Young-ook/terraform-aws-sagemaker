### parallel file system

resource "aws_fsx_lustre_file_system" "fsx" {
  tags                        = merge(local.default-tags, var.tags)
  subnet_ids                  = var.subnets
  deployment_type             = lookup(var.filesystem, "deployment_type", local.default_fsx_luster_config.deployment_type)
  per_unit_storage_throughput = lookup(var.filesystem, "per_unit_storage_throughput", local.default_fsx_luster_config.per_unit_storage_throughput)
  storage_capacity            = lookup(var.filesystem, "storage_capacity", local.default_fsx_luster_config.storage_capacity)
  storage_type                = lookup(var.filesystem, "storage_type", local.default_fsx_luster_config.storage_type)
  import_path                 = var.s3
}
