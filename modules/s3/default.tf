### default values

locals {
  default_lifecycle_rules = [
    {
      "enabled" : "true",
      "expiration" : {
        "days" : "365"
      },
      "id" : null,
      "prefix" : null,
      "noncurrent_version_expiration" : {
        "days" : "120"
      },
      "noncurrent_version_transition" : [],
      "tags" : {},
      "transition" : [
        {
          "days" : "180",
          "storage_class" : "STANDARD_IA"
        }
      ]
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
