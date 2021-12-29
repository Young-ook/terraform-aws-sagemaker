### network
variable "vpc" {
  description = "The vpc ID for sagemaker"
  type        = string
}

variable "subnets" {
  description = "The subnet IDs to deploy sagemaker"
  type        = list(string)
}

### sagemaker studio
variable "sagemaker_studio" {
  description = "Amazon SageMaker studio definition"
  default     = null
}

variable "notebook_instances" {
  description = "Notebook instances definition"
  default     = []
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
