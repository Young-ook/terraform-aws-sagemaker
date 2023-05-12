### Amazon SageMaker Studio

### aws partitions
module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

### security/policy
resource "aws_iam_role" "studio" {
  name = local.name
  tags = merge(var.tags, local.default-tags)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = format("sagemaker.%s", module.aws.partition.dns_suffix)
      }
    }]
  })
}

### https://docs.aws.amazon.com/sagemaker/latest/dg/security-iam-awsmanpol.html
resource "aws_iam_role_policy_attachment" "studio" {
  policy_arn = format("arn:%s:iam::aws:policy/AmazonSageMakerFullAccess", module.aws.partition.partition)
  role       = aws_iam_role.studio.name
}

resource "aws_iam_role_policy_attachment" "extra" {
  for_each   = { for k, v in lookup(var.studio, "policy_arns", []) : k => v }
  policy_arn = each.value
  role       = aws_iam_role.studio.name
}

#### security/firewall
resource "aws_security_group" "studio" {
  name        = local.name
  description = format("security group for %s", local.name)
  tags        = merge(var.tags, local.default-tags)
  vpc_id      = var.vpc

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### Lifecycle configuration for SageMaker Studio.
### A shell script (base64-encoded) that runs only once when the SageMaker Studio Notebook is created.
resource "aws_sagemaker_studio_lifecycle_config" "lc" {
  for_each                         = { for lc in lookup(var.studio, "lifecycle_configs", []) : lc.name => lc }
  tags                             = merge(var.tags, local.default-tags)
  studio_lifecycle_config_name     = join("-", [local.name, "lc", each.key])
  studio_lifecycle_config_app_type = lookup(each.value, "type", "JupyterServer")
  studio_lifecycle_config_content  = base64encode(lookup(each.value, "content"))
}

### application/studio
resource "aws_sagemaker_domain" "studio" {
  domain_name             = local.name
  tags                    = merge(var.tags, local.default-tags)
  auth_mode               = lookup(var.studio, "auth_mode", local.default_studio["auth_mode"])
  app_network_access_type = lookup(var.studio, "app_network_access_type", local.default_studio["app_network_access_type"])
  vpc_id                  = var.vpc
  subnet_ids              = var.subnets

  default_user_settings {
    execution_role  = aws_iam_role.studio.arn
    security_groups = [aws_security_group.studio.id]
  }
}

locals {
  app_configs       = var.studio != null ? try(var.studio.app_configs, []) : []
  user_profiles     = var.studio != null ? try(var.studio.user_profiles, []) : []
  lifecycle_configs = { for k, v in aws_sagemaker_studio_lifecycle_config.lc : k => v.arn }
}

### application/users
resource "aws_sagemaker_user_profile" "user" {
  depends_on        = [aws_sagemaker_studio_lifecycle_config.lc]
  for_each          = { for user in local.user_profiles : user.name => user }
  user_profile_name = try(each.key, local.default_user_profile["name"])
  tags              = merge(var.tags, local.default-tags)
  domain_id         = aws_sagemaker_domain.studio.id

  user_settings {
    execution_role  = aws_iam_role.studio.arn
    security_groups = [aws_security_group.studio.id]

    dynamic "jupyter_server_app_settings" {
      for_each = (lookup(each.value, "jupyter_server_app_settings", null) != null) ? [
        lookup(each.value, "jupyter_server_app_settings")
      ] : []
      content {
        lifecycle_config_arns = (lookup(jupyter_server_app_settings.value, "lifecycle_configs", null) != null) ? [
          for v in lookup(jupyter_server_app_settings.value, "lifecycle_configs", []) : local.lifecycle_configs[v]
        ] : null
      }
    }

    dynamic "kernel_gateway_app_settings" {
      for_each = (lookup(each.value, "kernel_gateway_app_settings", null) != null) ? [
        lookup(each.value, "kernel_gateway_app_settings")
      ] : []
      content {
        default_resource_spec {
          lifecycle_config_arn = (lookup(kernel_gateway_app_settings.value, "lifecycle_rule", null) != null) ? (
            lookup(aws_sagemaker_studio_lifecycle_config.lc, lookup(kernel_gateway_app_settings.value, "lifecycle_rule"))["arn"]
          ) : null
        }
      }
    }
  }
}

resource "aws_sagemaker_app" "app" {
  depends_on        = [aws_sagemaker_user_profile.user]
  for_each          = { for app in local.app_configs : app.name => app }
  app_name          = each.key
  app_type          = lookup(each.value, "type", local.default_app["type"])
  tags              = merge(var.tags, local.default-tags)
  domain_id         = aws_sagemaker_domain.studio.id
  user_profile_name = aws_sagemaker_user_profile.user[lookup(each.value, "profile", local.default_app["profile"])].user_profile_name
}
