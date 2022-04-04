output "notebooks" {
  description = "The attributes of the notebook instance"
  value       = module.sagemaker.notebooks
}

output "bucket" {
  description = "The attributes of s3 bucket for personalize data sets"
  value = {
    uri  = format("s3://%s", module.s3.bucket.id)
    name = module.s3.bucket.id
  }
}
