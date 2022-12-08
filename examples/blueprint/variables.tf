# Variables for providing to module fixture codes

### network
variable "aws_region" {
  description = "The aws region to deploy"
  type        = string
  default     = "ap-northeast-2"
}

variable "use_default_vpc" {
  description = "A feature flag for whether to use default vpc"
  type        = bool
  default     = true
}

variable "azs" {
  description = "A list of availability zones for the vpc to deploy resources"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2d"]
}

variable "subnets" {
  description = "The subnet IDs to deploy"
  type        = list(string)
  default     = null
}

### sagemaker
variable "notebook_instances" {
  description = "SageMaker Notebook instances definition"
  default     = []
}

variable "studio" {
  description = "Amazon SageMaker studio definition"
  default     = {}
}

### s3
variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = true
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
