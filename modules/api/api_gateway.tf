module "api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "5.3.0"

  name          = local.api_gateway_name
  description   = "Managed by Terraform"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  create_domain_name    = false
  create_domain_records = false

  stage_access_log_settings = {
    create_log_group            = true
    log_group_retention_in_days = 7
    format = jsonencode({
      context = {
        domainName              = "$context.domainName"
        integrationErrorMessage = "$context.integrationErrorMessage"
        protocol                = "$context.protocol"
        requestId               = "$context.requestId"
        requestTime             = "$context.requestTime"
        responseLength          = "$context.responseLength"
        routeKey                = "$context.routeKey"
        stage                   = "$context.stage"
        status                  = "$context.status"
        error = {
          message      = "$context.error.message"
          responseType = "$context.error.responseType"
        }
        identity = {
          sourceIP = "$context.identity.sourceIp"
        }
        integration = {
          error             = "$context.integration.error"
          integrationStatus = "$context.integration.integrationStatus"
        }
      }
    })
  }

  routes = {
    "ANY /" = {
      integration = {
        uri = module.lambda_function.lambda_function_arn
      }
    }
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

  depends_on = [aws_acm_certificate_validation.cert]
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${module.api_gateway.api_execution_arn}/*/*"
}

resource "aws_apigatewayv2_domain_name" "this" {
  domain_name = local.domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [aws_acm_certificate_validation.cert]
}

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id      = module.api_gateway.api_id
  domain_name = aws_apigatewayv2_domain_name.this.id
  stage       = module.api_gateway.stage_id
}


