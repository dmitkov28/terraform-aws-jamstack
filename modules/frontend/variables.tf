variable "bucket_name" {
  type = string
}

variable "cloudfront_distribution_name" {
  type = string
}

variable "static_site_build_dist" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}
