module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "8.1.0"

  function_name = local.lambda_function_name
  description   = "Managed by Terraform"
  architectures = ["arm64"]

  create_package = false
  memory_size    = 512
  timeout        = 120

  image_uri                         = var.ecr_image_uri
  package_type                      = "Image"
  cloudwatch_logs_retention_in_days = 14

  environment_variables = {
    AWS_LWA_PORT = 8000
  }
}

resource "aws_lambda_alias" "lambda_prod_alias" {
  function_name    = module.lambda_function.lambda_function_name
  name             = "prod"
  function_version = "$LATEST"
}

resource "aws_lambda_alias" "lambda_dev_alias" {
  function_name    = module.lambda_function.lambda_function_name
  name             = "dev"
  function_version = "$LATEST"
}

resource "aws_lambda_function_url" "dev_url" {
  function_name      = module.lambda_function.lambda_function_name
  qualifier          = aws_lambda_alias.lambda_dev_alias.name
  authorization_type = "NONE"
}

resource "aws_lambda_function_url" "prod_url" {
  function_name      = module.lambda_function.lambda_function_name
  qualifier          = aws_lambda_alias.lambda_prod_alias.name
  authorization_type = "NONE"
}
