### default values

locals {
  default_lifecycle_rules = [
    {
      enabled                       = false
      id                            = null
      tags                          = {}
      prefix                        = null
      expiration                    = {}
      transition                    = []
      noncurrent_version_expiration = {}
      noncurrent_version_transition = []
    }
  ]
  default_intelligent_tiering_archive_rules = {}
}
