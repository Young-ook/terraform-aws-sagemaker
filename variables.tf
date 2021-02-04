### network
variable "vpc" {
  description = "The vpc ID for sagemaker"
  type        = string
  default     = null
}

variable "subnets" {
  description = "The subnet IDs to deploy sagemaker"
  type        = list(string)
  default     = null
}

### sagemaker studio
variable "sagemaker_studio" {
  description = "Amazon SageMaker studio definition"
  default = {
    app_network_access_type = "VpcOnly"
    auth_mode               = "IAM"
    user_profiles = [
      {
        name = "default"
      }
    ]
  }
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
