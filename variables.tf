### network
variable "vpc" {
  description = "The vpc ID for sagemaker"
  type        = string
}

variable "subnets" {
  description = "The subnet IDs to deploy sagemaker"
  type        = list(string)
  validation {
    condition     = var.subnets != null && length(var.subnets) > 0
    error_message = "The subnets required."
  }
}

### sagemaker domain
variable "studio" {
  description = "Amazon SageMaker studio definition"
  default     = null
}

variable "notebook_instances" {
  description = "SageMaker Notebook instances definition"
  default     = []
}

### security
variable "policy_arns" {
  description = "A list of policy ARNs to attach the sagemaker role"
  type        = list(string)
  default     = []
}

variable "models" {
  description = "Model artifact definition"
  default     = []
}

variable "endpoints" {
  description = "SageMaker endpoint configuration"
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
