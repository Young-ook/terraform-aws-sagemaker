# Variables for providing to module fixture codes

### network
variable "aws_region" {
  description = "The aws region to deploy"
  type        = string
  default     = "us-east-1"
}

### sagemaker
variable "studio" {
  description = "Amazon SageMaker studio definition"
  default     = {}
}

variable "notebook_instances" {
  description = "Amazon SageMaker Notebook instances definition"
  default     = []
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
