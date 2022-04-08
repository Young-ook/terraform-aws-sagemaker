# aws partitions
module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

# idp
module "idp" {
  for_each = toset(var.personalize_example == "retailstore" ? ["enabled"] : [])
  source   = "Young-ook/passport/aws//modules/cognito"
  name     = join("-", ["cognito", local.name])
  tags     = var.tags
  policy_arns = {
    authenticated   = [aws_iam_policy.put-events["enabled"].arn]
    unauthenticated = [aws_iam_policy.put-events["enabled"].arn]
  }
}

# analytics
resource "aws_pinpoint_app" "marketing" {
  for_each = toset(var.personalize_example == "retailstore" ? ["enabled"] : [])
  name     = join("-", ["pinpoint", local.name])
  tags     = var.tags
}

resource "aws_iam_policy" "put-events" {
  for_each = toset(var.personalize_example == "retailstore" ? ["enabled"] : [])
  name     = join("-", [local.name, "put-events"])
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "mobileanalytics:PutEvents",
          "personalize:PutEvents",
        ]
        Effect   = "Allow"
        Resource = ["*"]
      },
      {
        Action = [
          "mobiletargeting:UpdateEndpoint",
          "mobiletargeting:PutEvents",
        ]
        Effect   = "Allow"
        Resource = [aws_pinpoint_app.marketing["enabled"].arn]
      },
    ]
  })
}


# dynamodb
module "products-db" {
  for_each = toset(var.personalize_example == "retailstore" ? ["enabled"] : [])
  source   = "Young-ook/lambda/aws//modules/dynamodb"
  name     = join("-", ["products", local.name])
  tags     = var.tags

  attributes = [
    {
      name = "id"
      type = "S"
    },
    {
      name = "category"
      type = "S"
    },
    {
      name = "featured"
      type = "S"
    }
  ]

  key_schema = {
    hash_key  = "id"
    range_key = "category"
  }

  local_secondary_indices = [{
    name            = "id-featured-index"
    hash_key        = "id"
    range_key       = "featured"
    projection_type = "ALL"
  }]

  global_secondary_indices = [{
    name            = "category-index"
    hash_key        = "category"
    projection_type = "ALL"
  }]
}

module "category-db" {
  for_each = toset(var.personalize_example == "retailstore" ? ["enabled"] : [])
  source   = "Young-ook/lambda/aws//modules/dynamodb"
  name     = join("-", ["category", local.name])
  tags     = var.tags

  attributes = [
    {
      name = "id"
      type = "S"
    },
  ]

  key_schema = {
    hash_key = "id"
  }
}

module "experiment-strategy-db" {
  for_each = toset(var.personalize_example == "retailstore" ? ["enabled"] : [])
  source   = "Young-ook/lambda/aws//modules/dynamodb"
  name     = join("-", ["experiment", local.name])
  tags     = var.tags

  attributes = [
    {
      name = "id"
      type = "S"
    },
    {
      name = "feature"
      type = "S"
    },
    {
      name = "name"
      type = "S"
    }
  ]

  key_schema = {
    hash_key = "id"
  }

  global_secondary_indices = [{
    name            = "feature-name-index"
    hash_key        = "feature"
    range_key       = "name"
    projection_type = "ALL"
  }]
}

# build
locals {
  services = ["carts", "orders", "products", "recommendations", "search", "users", "web-ui"]
}

module "ecr" {
  for_each     = toset(var.personalize_example == "retailstore" ? local.services : [])
  source       = "Young-ook/eks/aws//modules/ecr"
  name         = each.key
  scan_on_push = false
}

module "ci" {
  for_each = toset(var.personalize_example == "retailstore" ? local.services : [])
  source   = "Young-ook/spinnaker/aws//modules/codebuild"
  version  = "2.3.1"
  name     = join("-", [each.key, local.name])
  tags     = var.tags
  project = {
    environment = {
      image           = "aws/codebuild/docker:17.09.0"
      privileged_mode = true
      environment_variables = {
        AWS_REGION     = module.aws.region.name
        DEPLOY_REGION  = module.aws.region.name
        REPOSITORY_URI = module.ecr[each.key].url
        SERVICE_PATH   = join("/", ["examples/personalize/retailstore", each.key])
        SERVICE_NAME   = each.key
      }
    }
    source = {
      type      = "GITHUB"
      location  = "https://github.com/Young-ook/terraform-aws-sagemaker.git"
      buildspec = join("/", ["examples/personalize/retailstore", each.key, "buildspec.yml"])
      version   = "retail-store"
    }
    artifact = {}
  }
  policy_arns = [
    module.ecr[each.key].policy_arns["read"],
    module.ecr[each.key].policy_arns["write"],
  ]
}
