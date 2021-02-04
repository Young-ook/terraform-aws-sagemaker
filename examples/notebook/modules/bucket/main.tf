resource "random_string" "name" {
  length  = 12
  upper   = false
  lower   = true
  number  = false
  special = false
}

resource "aws_s3_bucket" "storage" {
  bucket = random_string.name.result
  tags   = var.tags

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "private" {
  depends_on = [aws_s3_bucket_public_access_block.private]
  bucket     = aws_s3_bucket.storage.id
  policy = jsonencode({
    Statement = [
      {
        Sid = "AllowAccessFromVpcEndpoint"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect = "Deny"
        Principal = {
          AWS = flatten([
            data.aws_caller_identity.current.account_id,
          ])
        }
        Resource = [
          join("/", [aws_s3_bucket.storage.arn, "*"]),
          aws_s3_bucket.storage.arn,
        ]
        Condition = {
          StringNotEquals = {
            "aws:sourceVpce" = var.vpc_endpoint_s3
          }
        }
      },
      {
        Sid    = "AllowTerraformToReadBuckets"
        Action = "s3:ListBucket"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.account_id,
        }
        Resource = [
          aws_s3_bucket.storage.arn,
        ]
      }
    ]
    Version = "2012-10-17"
  })
}
