### output variables

locals {
  bucket_name           = (local.directory_bucket ? aws_s3_directory_bucket.bucket["enabled"].id : aws_s3_bucket.bucket["enabled"].id)
  bucket_arn_with_slash = join("/", [(local.directory_bucket ? aws_s3_directory_bucket.bucket["enabled"].arn : aws_s3_bucket.bucket["enabled"].arn), "*"])
  bucket_arn            = (local.directory_bucket ? aws_s3_directory_bucket.bucket["enabled"].arn : aws_s3_bucket.bucket["enabled"].arn)
}

output "bucket" {
  description = "Attributes of the generated S3 bucket"
  value       = local.directory_bucket ? aws_s3_directory_bucket.bucket["enabled"] : aws_s3_bucket.bucket["enabled"]
}

output "policy_arns" {
  description = "A map of IAM polices to allow access this S3 bucket. If you want to make an IAM role or instance-profile has permissions to manage this bucket, please attach the `poliy_arn` of this output on your side."
  value       = zipmap(["read", "write"], [aws_iam_policy.read.arn, aws_iam_policy.write.arn])
}

output "empty" {
  description = "Bash script to empty the S3 bucket"
  value = join(" ", [
    "bash -e",
    format("%s/script/empty.sh", path.module),
    format("-r %s", local.aws.region),
    format("-b %s", local.bucket_name),
  ])
}
