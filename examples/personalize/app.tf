# idp
module "idp" {
  for_each = toset(var.personalize_example == "retailstore" ? ["enabled"] : [])
  source   = "Young-ook/passport/aws//modules/cognito"
  name     = join("-", ["cognito", random_pet.name.id])
  tags     = var.tags
  policy_arns = {
    authenticated   = [aws_iam_policy.put-events["enabled"].arn]
    unauthenticated = [aws_iam_policy.put-events["enabled"].arn]
  }
}

# analytics
resource "aws_pinpoint_app" "marketing" {
  for_each = toset(var.personalize_example == "retailstore" ? ["enabled"] : [])
  name     = join("-", ["pinpoint", random_pet.name.id])
  tags     = var.tags
}

resource "aws_iam_policy" "put-events" {
  for_each = toset(var.personalize_example == "retailstore" ? ["enabled"] : [])
  name     = join("-", [random_pet.name.id, "put-events"])
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


# dynamodb tables
module "products" {
  for_each = toset(var.personalize_example == "retailstore" ? ["enabled"] : [])
  source   = "Young-ook/lambda/aws//modules/dynamodb"
  name     = join("-", ["products", random_pet.name.id])
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

module "category" {
  for_each = toset(var.personalize_example == "retailstore" ? ["enabled"] : [])
  source   = "Young-ook/lambda/aws//modules/dynamodb"
  name     = join("-", ["category", random_pet.name.id])
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

module "experiment-strategy" {
  for_each = toset(var.personalize_example == "retailstore" ? ["enabled"] : [])
  source   = "Young-ook/lambda/aws//modules/dynamodb"
  name     = join("-", ["experiment", random_pet.name.id])
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
