### network
variable "vpc" {
  description = "The vpc ID for EFS"
  type        = string
}

variable "subnets" {
  description = "The subnet IDs for EFS"
  type        = list(string)
}

### file system
variable "volume" {
  description = "EFS file system configuration"
  default     = {}
}

### description
variable "name" {
  description = "The logical name of the module instance"
  type        = string
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
