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

resource "aws_iam_role_policy_attachment" "extra" {
  for_each   = { for k, v in var.policy_arns : k => v }
  policy_arn = each.value
  role       = aws_iam_role.ni.id
}

# Lifecycle configuration for SageMaker Studio.
# A shell script (base64-encoded) that runs only once when the SageMaker Studio Notebook is created.
resource "aws_sagemaker_studio_lifecycle_config" "studio" {
  for_each                         = { for lc in lookup(var.studio, "lifecycle_configs", []) : lc.type => lc }
  tags                             = merge(var.tags, local.default-tags)
  studio_lifecycle_config_name     = join("-", [local.name, "lc", each.key])
  studio_lifecycle_config_app_type = each.key
  studio_lifecycle_config_content  = base64encode(lookup(each.value, "content"))
}

resource "aws_sagemaker_domain" "studio" {
  depends_on              = [aws_sagemaker_studio_lifecycle_config.studio]
  for_each                = toset(var.studio != null ? ["enabled"] : [])
  domain_name             = format("%s", local.name)
  auth_mode               = lookup(var.studio, "auth_mode", local.default_studio_config["auth_mode"])
  app_network_access_type = lookup(var.studio, "app_network_access_type", local.default_studio_config["app_network_access_type"])
  vpc_id                  = var.vpc
  subnet_ids              = var.subnets

  default_user_settings {
    execution_role  = aws_iam_role.ni.arn
    security_groups = [aws_security_group.sagemaker.id]

    dynamic "jupyter_server_app_settings" {
      for_each = { for lc in lookup(var.studio, "lifecycle_configs", []) : lc.type => lc if lc.type == "JupyterServer" }
      content {
        default_resource_spec {
          lifecycle_config_arn = aws_sagemaker_studio_lifecycle_config.studio[jupyter_server_app_settings.key].arn
        }
      }
    }
  }
}

locals {
  user_profiles = var.studio != null ? lookup(var.studio, "user_profiles", local.default_studio_config["user_profiles"]) : []
}

resource "aws_sagemaker_user_profile" "user" {
  for_each          = { for user in local.user_profiles : user.name => user }
  domain_id         = aws_sagemaker_domain.studio["enabled"].id
  user_profile_name = each.key
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

# Lifecycle configuration for SageMaker Notebook Instances.
# on_create : A shell script (base64-encoded) that runs only once when the SageMaker Notebook Instance is created.
# on_start : A shell script (base64-encoded) that runs every time the SageMaker Notebook Instance is started including the time it's created.
resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "lc" {
  for_each  = { for ni in var.notebook_instances : ni.name => ni }
  name      = join("-", [local.name, each.key])
  on_create = base64encode(lookup(lookup(each.value, "lifecycle_config", local.default_notebook_config["lifecycle_config"]), "on_create", ""))
  on_start  = base64encode(lookup(lookup(each.value, "lifecycle_config", local.default_notebook_config["lifecycle_config"]), "on_start", ""))
}

resource "aws_sagemaker_notebook_instance" "ni" {
  depends_on              = [aws_iam_role_policy_attachment.sagemaker-admin]
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
  lifecycle_config_name   = lookup(each.value, "lifecycle_config", null) != null ? aws_sagemaker_notebook_instance_lifecycle_configuration.lc[each.key].name : null
}

# WIP: sagemaker endpoint
resource "aws_sagemaker_model" "model" {
  for_each                 = { for m in var.models : m.name => m }
  name                     = lower(each.key)
  tags                     = merge(local.default-tags, var.tags)
  execution_role_arn       = aws_iam_role.ni.arn # todo: replace with new role
  enable_network_isolation = lookup(each.value, "enable_network_isolation", false)

  dynamic "primary_container" {
    for_each = { for k, v in each.value : k => v if k == "primary_container" }
    content {
      image              = lookup(primary_container.value, "image", null)
      model_data_url     = lookup(primary_container.value, "model_data_url", null)
      container_hostname = lookup(primary_container.value, "container_hostname", null)
      environment        = lookup(primary_container.value, "environment", null)
    }
  }

  dynamic "container" {
    for_each = {} # lookup(each.value, "containers", [])
    content {
      image              = lookup(container.value, "image", null)
      model_data_url     = lookup(container.value, "model_data_url", null)
      container_hostname = lookup(container.value, "container_hostname", null)
      environment        = lookup(container.value, "environment", null)
    }
  }

  dynamic "vpc_config" {
    for_each = { for k, v in each.value : k => v if k == "vpc_config" }
    content {
      subnets            = lookup(vpc_config.value, "subnets", null)
      security_group_ids = lookup(vpc_config.value, "security_group_ids", null)
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_sagemaker_endpoint_configuration" "ep" {
  depends_on  = [aws_sagemaker_model.model]
  for_each    = { for ep in var.endpoints : ep.name => ep }
  name        = lower(local.name)
  tags        = merge(local.default-tags, var.tags)
  kms_key_arn = lookup(each.value, "kms_key_arn", null)

  dynamic "production_variants" {
    for_each = { for k, v in each.value : k => v if k == "production_variants" }
    content {
      model_name             = aws_sagemaker_model.model[production_variants.key].name
      variant_name           = lookup(production_variants.value, "variant_name", null)
      accelerator_type       = lookup(production_variants.value, "accelerator_type", null)
      instance_type          = lookup(production_variants.value, "instance_type", "ml.t2.medium")
      initial_instance_count = lookup(production_variants.value, "initial_instance_count", 0)
      initial_variant_weight = lookup(production_variants.value, "initial_variant_weight", null)
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
