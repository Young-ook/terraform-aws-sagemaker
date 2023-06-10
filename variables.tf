### input variables

### network
variable "vpc" {
  description = "A vpc ID for sagemaker"
  type        = string
}

variable "subnet" {
  description = "A subnet ID to deploy sagemaker"
  type        = string
  default     = null
  validation {
    condition     = var.subnet != ""
    error_message = "A subnet is invalid."
  }
}

### sagemaker notebook
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
