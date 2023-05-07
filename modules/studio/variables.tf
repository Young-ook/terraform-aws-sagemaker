### input variables

### network
variable "vpc" {
  description = "A VPC Id. for an SageMaker studio"
  type        = string
  default     = null
}

variable "subnets" {
  description = "A list of subnet IDs to deploy an SageMaker studio"
  type        = list(string)
}

### sagemaker domain (studio)
variable "studio" {
  description = "SageMaker studio definition"
  default     = {}
}

### description
variable "name" {
  description = "SageMaker studio name"
  type        = string
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
