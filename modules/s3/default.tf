### default values

locals {
  default_lifecycle_rules = [
    {
      enabled                       = true
      id                            = null
      tags                          = {}
      prefix                        = null
      expiration                    = {}
      transition                    = []
      noncurrent_version_expiration = {}
      noncurrent_version_transition = []
    }
  ]
  default_intelligent_tiering = {
    state  = "Disabled"
    filter = []
    tiering = [{
      access_tier = "ARCHIVE_ACCESS" # allowed values: ARCHIVE_ACCESS, DEEP_ARCHIVE_ACCESS
      days        = 180
      }
    ]
  }
}
