### default values

locals {
  default_fsx_luster_config = {
    deployment_type             = "PERSISTENT_1"
    per_unit_storage_throughput = 50
    import_path                 = null
    storage_capacity            = 1200
    storage_type                = "SSD"
  }
}
