variable "domain_name" {
  type = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone Id"
  type        = string
  sensitive   = true
}

variable "cname_key" {
  type = string
}

variable "cname_value" {
  type = string
}




