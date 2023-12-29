### security/policy
resource "aws_lambda_permission" "sync" {
  for_each      = toset(local.notebook_enabled ? ["enabled"] : [])
  function_name = module.lambda["cherrypick"].function.arn
  action        = "lambda:InvokeFunction"
  principal     = "s3.amazonaws.com"
  source_arn    = module.s3.bucket.arn
}

resource "aws_s3_bucket_notification" "sync" {
  for_each   = toset(local.notebook_enabled ? ["enabled"] : [])
  depends_on = [aws_lambda_permission.sync]
  bucket     = module.s3.bucket.id
  lambda_function {
    lambda_function_arn = module.lambda["cherrypick"].function.arn
    events = [
      "s3:ObjectCreated:Put",
      "s3:ObjectRemoved:Delete"
    ]
  }
}

resource "time_sleep" "wait" {
  depends_on      = [module.efs]
  for_each        = toset(local.notebook_enabled ? ["enabled"] : [])
  create_duration = "5s"
}

### application/package
data "archive_file" "lambda_zip_file" {
  for_each = { for fn in(local.notebook_enabled ? [
    {
      name = "cherrypick"
    },
  ] : []) : fn.name => fn }
  output_path = join("/", [path.module, "apps", "build", "${each.key}.zip"])
  source_dir  = join("/", [path.module, "apps", each.key])
  excludes    = ["__init__.py", "*.pyc", "*.yaml"]
  type        = "zip"
}

### application/function
module "lambda" {
  depends_on = [time_sleep.wait]
  source     = "Young-ook/eventbridge/aws//modules/lambda"
  version    = "0.0.14"
  for_each = { for fn in(local.notebook_enabled ? [
    {
      name = "cherrypick"
      function = {
        package = data.archive_file.lambda_zip_file["cherrypick"].output_path
        handler = "cherrypick.lambda_handler"
        timeout = 300
        aliases = [
          {
            name    = "dev"
            version = "$LATEST"
          },
        ]
      }
      filesystem = {
        local_mount_path = "/mnt/data"
        arn              = module.efs["enabled"].ap.0.arn
      }
      vpc = {
        subnets         = values(module.vpc.subnets[var.use_default_vpc ? "public" : "private"])
        security_groups = [module.efs["enabled"].security_group.id]
      }
      policy_arns = [
        module.s3.policy_arns["read"],
        module.s3.policy_arns["write"],
      ]
    },
  ] : []) : fn.name => fn }
  tags        = var.tags
  lambda      = lookup(each.value, "function")
  filesystem  = lookup(each.value, "filesystem")
  vpc         = lookup(each.value, "vpc")
  policy_arns = lookup(each.value, "policy_arns")
}
