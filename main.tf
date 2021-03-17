resource "aws_dynamodb_table" "table" {
  name           = var.stack_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name = var.stack_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "api_get_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = "{id}"
}

module "dynamodb-post" {
  source      = "./Module/DynamodbIntegration"
  stack_name  = var.stack_name
  api_id      = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id

  http_method = "POST"

  table_arn = aws_dynamodb_table.table.arn
  dynamodb_action = "UpdateItem"

  request_templates = {
    "application/json" = <<-EOT
        { 
            "TableName": "${aws_dynamodb_table.table.name}",
            "ConditionExpression":"attribute_not_exists(id)",
            "Key": {
                "id": { "S": $input.json('$.id') }
            },
              "ExpressionAttributeNames": {
                "#u": "url",
                "#ts": "timestamp"
            },
            "ExpressionAttributeValues":{
                ":u": {"S": $input.json('$.url')},
                ":ts": {"S": "$context.requestTimeEpoch"}
            },
            "UpdateExpression": "SET #u = :u, #ts = :ts",
            "ReturnValues": "ALL_NEW"
        }
    EOT
  }

  responses = [
    {
      status_code       = "200"
      selection_pattern = "200"
      templates = {
        "application/json" = jsonencode({
          short     = "$input.path('$').Attributes.id.S"
          url       = "$input.path('$').Attributes.url.S"
          timestamp = "$input.path('$').Attributes.timestamp.S"
        })
      }
    },
    {
      status_code       = "400"
      selection_pattern = "4\\d{2}"
      templates = {
        "application/json" = jsonencode({
          statusCode = 400
          message    = "this id is not available"
        })
      }
    }
  ]
}

module "dynamodb-get" {
  source      = "./Module/DynamodbIntegration"
  stack_name  = var.stack_name
  api_id      = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_get_resource.id

  http_method = "GET"
  http_path = "{id}"

  table_arn = aws_dynamodb_table.table.arn
  dynamodb_action = "GetItem"

  request_templates = {
    "application/json" = <<-EOT
        { 
            "TableName": "${aws_dynamodb_table.table.name}",
            "Key": {
                "id": { "S": "$input.params().path.id" }
            }
        }
    EOT
  }

  responses = [
    {
      status_code       = "301"
      selection_pattern = "200"
      templates = {
        "application/json" = <<-EOT
          #if($input.path('$').toString().contains('Item'))
            #set($context.responseOverride.header.Location = $input.path('$').Item.url.S) 
            #set($context.responseOverride.header['Cache-Control'] = 'max-age=300')
          #else
            #set($context.responseOverride.header.Location = '404.html') 
            #set($context.responseOverride.header['Cache-Control'] = 'max-age=0')
          #end
        EOT
      }
    },
    {
      status_code       = "400"
      selection_pattern = "4\\d{2}"
      templates = {
        "application/json" = jsonencode({
          statusCode = 400
          message    = "Error"
        })
      }
    }
  ]
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id       = aws_api_gateway_rest_api.api.id
  stage_name        = var.api_stage_name
  stage_description = "Deployed at ${timestamp()}"

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api.body))
  }

  depends_on = [
    module.dynamodb-post,
    module.dynamodb-get
  ]
}