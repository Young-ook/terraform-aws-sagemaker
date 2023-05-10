### output variables

output "studio" {
  description = "The SageMaker studio attributes"
  value       = aws_sagemaker_domain.studio
}

output "users" {
  description = "The SageMaker studio users"
  value       = aws_sagemaker_user_profile.user
}

output "role" {
  description = "The IAM roles for SageMaker studio"
  value = {
    studio = aws_iam_role.studio
  }
}
