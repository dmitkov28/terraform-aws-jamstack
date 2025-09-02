variable "api_name" {
  description = "Name of the API"
  type        = string
  default     = "my-awesome-jamstack-api"
}

variable "domain" {
  description = "Domain Name of the API"
  type        = string
  default     = "dimitarmitkov.com"
}

variable "ecr_image_uri" {
  description = "ECR image URI"
  type        = string

}

variable "CLOUDFLARE_ZONE_ID" {
  description = "Cloudflare Zone Id"
  type        = string
  sensitive   = true
}





