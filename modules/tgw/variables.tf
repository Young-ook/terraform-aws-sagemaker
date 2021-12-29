### input variables

### network
variable "tgw_config" {
  description = "A Transit Gateway (TGW) configuration"
  default     = {}
}

variable "vpc_attachments" {
  description = "Map of VPC details to attach to Transit Gateway (TGW)"
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
