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

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone Id"
  type        = string
  sensitive   = true
}

variable "image_architecture" {
  type    = string
  default = "linux/arm64"
  validation {
    condition     = contains(["linux/amd64", "linux/arm64"], var.image_architecture)
    error_message = "Image architecture must be either 'linux/amd64' or 'linux/arm64'."
  }
}

variable "image_tag" {
  type = string
}

variable "build_context" {
  type = string
}




