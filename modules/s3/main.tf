## simple storage service

module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

locals {
  bucket_arn_with_slash = join("/", [aws_s3_bucket.bucket.arn, "*"])
}

# security/policy
resource "aws_iam_policy" "read" {
  name        = format("%s-read", local.name)
  description = format("Allow to read objects and the S3 bucket")
  path        = "/"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "s3:HeadBucket",
          "s3:List*",
          "s3:Get*",
        ]
        Effect   = "Allow"
        Resource = [aws_s3_bucket.bucket.arn, local.bucket_arn_with_slash, ]
      }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "write" {
  name        = format("%s-write", local.name)
  description = format("Allow to write objects and the S3 bucket")
  path        = "/"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "s3:Put*",
          "s3:DeleteObject*",
        ]
        Effect   = "Allow"
        Resource = [local.bucket_arn_with_slash]
      },
      {
        Action = [
          "s3:HeadBucket",
        ]
        Effect   = "Allow"
        Resource = [aws_s3_bucket.bucket.arn, ]
      }
    ]
    Version = "2012-10-17"
  })
}

# security/policy
resource "aws_s3_bucket_policy" "bucket" {
  for_each   = var.bucket_policy == null ? {} : var.bucket_policy
  depends_on = [aws_s3_bucket_public_access_block.bucket]
  bucket     = aws_s3_bucket.bucket.id
  policy     = lookup(each.value, "policy", null)
}

# security/policy
resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = local.name
  tags          = merge(local.default-tags, var.tags)
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = var.canned_acl
}

resource "aws_s3_bucket_versioning" "versioning" {
  for_each = toset(var.versioning != null ? ["versioning"] : [])
  bucket   = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.versioning
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  for_each = toset(var.server_side_encryption != null ? ["sse"] : [])
  bucket   = aws_s3_bucket.bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = lookup(var.server_side_encryption, "sse_algorithm", null)
      kms_master_key_id = lookup(var.server_side_encryption, "kms_master_key_id", null)
    }
  }
}

resource "aws_s3_bucket_logging" "log" {
  for_each      = toset(var.logging_rules != null ? ["log"] : [])
  bucket        = aws_s3_bucket.bucket.id
  target_bucket = lookup(var.logging_rules, "target_bucket", local.name)
  target_prefix = lookup(var.logging_rules, "target_prefix", "log/")
}

resource "aws_s3_bucket_lifecycle_configuration" "lc" {
  for_each = toset(var.lifecycle_rules != null ? ["lc"] : [])
  bucket   = aws_s3_bucket.bucket.id

  dynamic "rule" {
    for_each = { for k, v in var.lifecycle_rules : k => v }
    content {
      id     = lookup(rule.value, "id", local.name)
      status = lookup(rule.value, "status", "Disabled")

      dynamic "filter" {
        for_each = { for k, v in lookup(rule.value, "filter", []) : k => v }
        content {
          prefix = lookup(filter.value, "prefix", null)
          dynamic "tag" {
            for_each = { for k, v in lookup(filter.value, "tag", []) : k => v }
            content {
              key   = lookup(tag.value, "key")
              value = lookup(tag.value, "value")
            }
          }
        }
      }

      dynamic "expiration" {
        for_each = { for k, v in rule.value : k => v if k == "expirarion" }
        content {
          date                         = lookup(expiration.value, "date", null)
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }

      dynamic "transition" {
        for_each = lookup(rule.value, "transition", [])
        content {
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = { for k, v in rule.value : k => v if k == "noncurrent_version_expiration" }
        content {
          noncurrent_days = lookup(noncurrent_version_expiration.value, "days", null)
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = lookup(rule.value, "noncurrent_version_transition", [])
        content {
          noncurrent_days = lookup(noncurrent_version_transition.value, "days", null)
          storage_class   = noncurrent_version_transition.value.storage_class
        }
      }
    }
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "int" {
  for_each = { for k, v in(var.intelligent_tiering_archive_rules != null ? var.intelligent_tiering_archive_rules : []) : k => v }
  bucket   = aws_s3_bucket.bucket.id
  name     = local.name
  status   = lookup(each.value, "status", "Disabled")

  dynamic "filter" {
    for_each = { for k, v in lookup(each.value, "filter", []) : k => v }
    content {
      prefix = lookup(filter.value, "prefix")
      tags   = lookup(filter.value, "tags")
    }
  }

  dynamic "tiering" {
    for_each = { for k, v in lookup(each.value, "tiering", []) : k => v }
    content {
      access_tier = lookup(tiering.value, "access_tier")
      days        = lookup(tiering.value, "days")
    }
  }
}

locals {
  aws_region  = module.aws.region.name
  bucket_name = aws_s3_bucket.bucket.id
}

# cleanup script
resource "local_file" "empty" {
  count      = var.force_destroy ? 1 : 0
  depends_on = [aws_s3_bucket.bucket]
  content = join("\n", [
    "#!/bin/sh",
    "aws s3api delete-objects \\",
    "  --region ${local.aws_region} --bucket ${local.bucket_name} \\",
    "  --delete \"$(aws s3api list-object-versions \\",
    "    --region ${local.aws_region} --bucket ${local.bucket_name} \\",
    "    --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}' \\",
    "    --output json)\"",
    "echo $?",
    "exit 0"
  ])
  filename        = "${path.module}/empty.sh"
  file_permission = "0700"
}

resource "null_resource" "empty" {
  count      = var.force_destroy ? 1 : 0
  depends_on = [local_file.empty]
  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/empty.sh"
  }
}
