locals {
  image_name = "${var.api_name}_image"
  image_tag  = var.image_tag != "" ? var.image_tag : "latest"
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "3.0.1"

  repository_name         = "${var.api_name}_ecr"
  repository_force_delete = true

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 tagged images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v", "latest", "main", "dev", "prod"],
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = { type = "expire" }
      },
      {
        rulePriority = 2,
        description  = "Delete untagged images after 1 day",
        selection = {
          tagStatus   = "untagged",
          countType   = "sinceImagePushed",
          countUnit   = "days",
          countNumber = 1
        },
        action = { type = "expire" }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "docker_image" "tf_image" {
  name = "${local.image_name}:${local.image_tag}"
  build {
    context  = var.build_context
    platform = var.image_architecture
    tag      = ["${module.ecr.repository_url}:${local.image_tag}"]
  }
  depends_on = [module.ecr]
}

data "aws_ecr_authorization_token" "token" {}

resource "docker_registry_image" "ecr_image" {
  name          = "${module.ecr.repository_url}:${local.image_tag}"
  keep_remotely = true

  auth_config {
    address  = split("/", module.ecr.repository_url)[0]
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }

  depends_on = [docker_image.tf_image]
}
