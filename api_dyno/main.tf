
##############################################################
# DynamoDB Table to store data
##############################################################
resource "aws_dynamodb_table" "WebhookTable" {
  name           = "${var.dynamo_table_name}"
  read_capacity  = "${var.ddb_default_rcu}"
  write_capacity = "${var.ddb_default_wcu}"
  hash_key       = "request_id"
  attribute {
    name = "request_id"
    type = "S"
  }
}

##############################################################
# IAM Role for API Gateway
##############################################################
resource "aws_iam_role" "api-gateway-role" {
  name = "api-gateway-dynamo-role-tf"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

##############################################################
# IAM Policy to get access to dynamo db
##############################################################
resource "aws_iam_role_policy" "api-gateway-policy" {
  name = "api-gateway-dynamo-policy-tf"
  role = "${aws_iam_role.api-gateway-role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem"
      ],
      "Resource": [
        "${aws_dynamodb_table.WebhookTable.arn}"
      ]
    }
  ]
}
EOF
}

##############################################################
# GateWay Rest API 
##############################################################
resource "aws_api_gateway_rest_api" "WebhookAPI" {
  name        = "WebhookAPI"
  description = "This API receives spacelift webhook data and persists it in dnyamo db"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

##############################################################
# API Gateway Resource
##############################################################
resource "aws_api_gateway_resource" "Spacelift" {
  rest_api_id = "${aws_api_gateway_rest_api.WebhookAPI.id}"
  parent_id   = "${aws_api_gateway_rest_api.WebhookAPI.root_resource_id}"
  path_part   = "spacelift"
}

##############################################################
# API Gateway Method
##############################################################
resource "aws_api_gateway_method" "API_Method" {
  rest_api_id   = "${aws_api_gateway_rest_api.WebhookAPI.id}"
  resource_id   = "${aws_api_gateway_resource.Spacelift.id}"
  http_method   = "POST"
  authorization = "NONE"
}

##############################################################
# API Gateway Integration
##############################################################
resource "aws_api_gateway_integration" "API_Integration" {
  rest_api_id          = "${aws_api_gateway_rest_api.WebhookAPI.id}"
  resource_id          = "${aws_api_gateway_resource.Spacelift.id}"
  http_method          = "${aws_api_gateway_method.API_Method.http_method}"
  type                 = "AWS"
  uri                  = "arn:aws:apigateway:${var.aws_region}:dynamodb:action/PutItem"
  credentials          = "${aws_iam_role.api-gateway-role.arn}"
  integration_http_method = "POST"
  
  request_templates = {
    "application/json" = <<EOT
                        {
                        "TableName": "${var.dynamo_table_name}",
                            "Item": {
                                "request_id": {
                                    "S": "$context.requestId"
                                    },
                                "context": {
                                    "S": "$context"
                                    },
                                "jsonBody" : {
                                    "S": "$input.path('$')"
                                    }
                            }
                    }
                EOT
    }

}

##############################################################
# API Gateway Method Response
##############################################################
resource "aws_api_gateway_method_response" "post-response-200" {
  rest_api_id = "${aws_api_gateway_rest_api.WebhookAPI.id}"
  resource_id = "${aws_api_gateway_resource.Spacelift.id}"
  http_method = "${aws_api_gateway_method.API_Method.http_method}"
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

##############################################################
# API Gateway Integration Response
##############################################################
resource "aws_api_gateway_integration_response" "post-response" {
  depends_on = [aws_api_gateway_integration.API_Integration]
  rest_api_id = "${aws_api_gateway_rest_api.WebhookAPI.id}"
  resource_id = "${aws_api_gateway_resource.Spacelift.id}"
  http_method = "${aws_api_gateway_method.API_Method.http_method}"
  status_code = "${aws_api_gateway_method_response.post-response-200.status_code}"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}
##############################################################
# Deployment of Gateway
##############################################################
resource "aws_api_gateway_deployment" "WebhookDeployment" {
  rest_api_id = "${aws_api_gateway_rest_api.WebhookAPI.id}"
  triggers = {
    redeployment = sha1(jsonencode([
      "${aws_api_gateway_resource.Spacelift.id}",
      "${aws_api_gateway_rest_api.WebhookAPI.id}",
      "${aws_api_gateway_integration.API_Integration.id}"
    ]))
  }
}

##############################################################
# Gateway Stage
##############################################################
resource "aws_api_gateway_stage" "WebhookDeployStage" {
  deployment_id = "${aws_api_gateway_deployment.WebhookDeployment.id}"
  rest_api_id   = "${aws_api_gateway_rest_api.WebhookAPI.id}"
  stage_name    = "${var.aws_gateway_stage}"
}

