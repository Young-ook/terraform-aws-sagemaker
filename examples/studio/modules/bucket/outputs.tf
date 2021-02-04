output "bucket" {
  description = "The attributes of s3 bucket for sagemaker"
  value       = aws_s3_bucket.storage
}
