### default values

locals {
  default_fsx_luster_config = {
    deployment_type             = "PERSISTENT_1"
    per_unit_storage_throughput = 50
    storage_capacity            = 1200
    storage_type                = "SSD"

    # The s3 bucket URI for import data (e.g., s3://my-bucket/optional-prefix)
    import_path = null
  }
}
