### security/network 
variable "vpc_endpoint_s3" {
  description = "The ID of vpc endpoint for s3"
  type        = string
  default     = null
}

### description
variable "name" {
  description = "The logical name of the module instance"
  type        = string
  default     = "eks"
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
