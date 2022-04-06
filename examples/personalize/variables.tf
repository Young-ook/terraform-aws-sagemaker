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
variable "studio" {
  description = "Amazon SageMaker studio definition"
  default     = {}
}

variable "notebook_instances" {
  description = "Amazon SageMaker Notebook instances definition"
  default     = []
}

variable "personalize_example" {
  description = "Choose what you want to run example: [samples, retailstore]"
  validation {
    condition     = contains(["samples", "retailstore"], var.personalize_example)
    error_message = "Allowed values are [samples, retailstore]."
  }
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
