### sagemaker samples
resource "aws_sagemaker_code_repository" "repo" {
  for_each = {
    huggingface = { url = "https://github.com/huggingface/notebooks.git" }
    personalize = { url = "https://github.com/aws-samples/amazon-personalize-samples.git" }
  }
  code_repository_name = each.key
  git_config {
    repository_url = lookup(each.value, "url")
  }
}
