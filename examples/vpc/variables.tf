# Variables for providing to module fixture codes

### network
variable "aws_region" {
  description = "The aws region to deploy"
  type        = string
  default     = "us-east-1"
}

variable "vpc_config" {
  description = "A Virtual Private Cloud (VPC) configuration"
  default     = {}
}

variable "vpce_config" {
  description = "A Virtual Private Cloud (VPC) endpoints configuration"
  default     = []
}

variable "vgw_config" {
  description = "A Virtual Private Gateway (VGW) configuration"
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
