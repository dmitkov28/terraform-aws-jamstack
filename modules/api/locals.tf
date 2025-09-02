locals {
  lambda_function_name = var.api_name
  api_gateway_name     = "${var.api_name}_api_gateway"
  domain_name          = "${var.api_name}.${var.domain}"
}
