variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for DNS records"
  type        = string
}

variable "cloudfront_domain" {
  description = "CloudFront distribution domain name"
  type        = string
}

variable "cloudfront_redirect_domain" {
  description = "CloudFront redirect distribution domain name"
  type        = string
}

variable "subdomain" {
  description = "Subdomain for the main site (e.g., 'test')"
  type        = string
  default     = "test"
}

variable "ttl" {
  description = "TTL for DNS records"
  type        = number
  default     = 1
}

variable "proxied" {
  description = "Whether to proxy through Cloudflare"
  type        = bool
  default     = false
}
