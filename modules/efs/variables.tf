### network
variable "vpc" {
  description = "The vpc ID for efs"
  type        = string
  default     = null
}

variable "subnets" {
  description = "The subnet IDs for efs"
  type        = list(string)
  default     = []
}

### description
variable "name" {
  description = "The logical name of the module instance"
  type        = string
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
