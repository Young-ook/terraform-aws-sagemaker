## sagemaker

## notebook instance (ni)
# security/policy
resource "aws_iam_role" "ni" {
  name = format("%s-ni", local.name)
  tags = merge(local.default-tags, var.tags)
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = format("sagemaker.%s", module.aws.partition.dns_suffix)
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "sagemaker-admin" {
  policy_arn = format("arn:%s:iam::aws:policy/AmazonSageMakerFullAccess", module.aws.partition.partition)
  role       = aws_iam_role.ni.id
}

resource "aws_sagemaker_domain" "studio" {
  count                   = var.sagemaker_studio != null ? 1 : 0
  domain_name             = format("%s", local.name)
  auth_mode               = lookup(var.sagemaker_studio, "auth_mode", local.default_studio_config["auth_mode"])
  app_network_access_type = lookup(var.sagemaker_studio, "app_network_access_type", local.default_studio_config["app_network_access_type"])
  vpc_id                  = var.vpc
  subnet_ids              = var.subnets

  default_user_settings {
    execution_role  = aws_iam_role.ni.arn
    security_groups = [aws_security_group.sagemaker.id]
  }
}

locals {
  user_profiles = var.sagemaker_studio != null ? lookup(var.sagemaker_studio, "user_profiles", local.default_studio_config["user_profiles"]) : []
}

resource "aws_sagemaker_user_profile" "user" {
  for_each          = { for user in local.user_profiles : user.name => user }
  domain_id         = aws_sagemaker_domain.studio.0.id
  user_profile_name = format("%s", local.name)
  user_settings {
    execution_role  = aws_iam_role.ni.arn
    security_groups = [aws_security_group.sagemaker.id]
  }
}

# drawing lots for choosing a subnet
resource "random_integer" "subnet" {
  min = 0
  max = length(var.subnets) - 1
}

resource "aws_sagemaker_notebook_instance" "ni" {
  for_each                = { for ni in var.notebook_instances : ni.name => ni }
  name                    = format("%s-%s", local.name, each.key)
  role_arn                = aws_iam_role.ni.arn
  tags                    = merge(local.default-tags, var.tags)
  direct_internet_access  = lookup(each.value, "direct_internet_access", local.default_notebook_config["direct_internet_access"])
  subnet_id               = var.subnets[random_integer.subnet.result]
  security_groups         = [aws_security_group.sagemaker.id]
  instance_type           = lookup(each.value, "instance_type", local.default_notebook_config["instance_type"])
  volume_size             = lookup(each.value, "volume_size", local.default_notebook_config["volume_size"])
  default_code_repository = lookup(each.value, "default_code_repository", null)

  depends_on = [
    aws_iam_role_policy_attachment.sagemaker-admin,
  ]
}

# WIP
resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "lc" {
  for_each  = { for ni in var.notebook_instances : ni.name => ni }
  name      = format("%s-%s", local.name, each.key)
  on_create = base64encode("echo foo")
  on_start  = base64encode("echo bar")
}
