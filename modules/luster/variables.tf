### network
variable "subnets" {
  # A list of IDs for the subnets that the file system will be accessible from.
  # File systems currently support only one subnet. 
  description = "The subnet IDs for FSx filesystem"
  type        = list(string)
}

### filesystem
variable "filesystem" {
  description = "FSx for Luster configuration"
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
