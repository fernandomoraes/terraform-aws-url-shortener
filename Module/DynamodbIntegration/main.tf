data "aws_region" "current" {}

module "dynamodb_integration" {
  source = "../ApiGateway"

  api_id                         = var.api_id
  resource_id                    = var.resource_id
  http_method                    = var.http_method
  authorization                  = var.authorization
  method_request_parameters      = var.method_request_parameters
  integration_request_parameters = var.integration_request_parameters

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:dynamodb:action/${var.dynamodb_action}"
  credentials             = aws_iam_role.dynamodb_role.arn
  request_templates       = var.request_templates
  responses               = var.responses
}

data "aws_iam_policy_document" "policy_document_apigw" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "apigateway.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "policy_document_dynamodb" {
  statement {
    actions = [
      "dynamodb:${var.dynamodb_action}",
    ]
    resources = [
      var.table_arn
    ]
  }
}

resource "aws_iam_role" "dynamodb_role" {
  name               = "${var.stack_name}-dynamodb-${lower(var.dynamodb_action)}"
  assume_role_policy = data.aws_iam_policy_document.policy_document_apigw.json
}

resource "aws_iam_role_policy" "dynamodb_role_policy" {
  name   = "Dynamodb-${var.dynamodb_action}"
  role   = aws_iam_role.dynamodb_role.id
  policy = data.aws_iam_policy_document.policy_document_dynamodb.json
}