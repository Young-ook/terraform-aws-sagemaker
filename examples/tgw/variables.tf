# Variables for providing to module fixture codes

### network
variable "aws_region" {
  description = "The aws region to deploy"
  type        = string
  default     = "us-east-1"
}

variable "use_default_vpc" {
  description = "A feature flag for whether to use default vpc"
  type        = bool
  default     = false
}

variable "azs" {
  description = "A list of availability zones for the vpc to deploy resources"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "subnets" {
  description = "The subnet IDs to deploy"
  type        = list(string)
  default     = null
}

### sagemaker
variable "sagemaker_studio" {
  description = "Amazon SageMaker studio definition"
  default     = {}
}

variable "notebook_instances" {
  description = "Notebook instances definition"
  default     = []
}

### test client
variable "client_instances" {
  description = "EC2 instance groups definition for test client"
  default     = []
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
