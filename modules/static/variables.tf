variable "bucket_name" {
  type = string
}

variable "cloudfront_distribution_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "aws_acm_certificate_arn" {
  type = string
}

variable "static_site_build_dist" {
  type = string

  validation {
    condition     = can(fileset(var.static_site_build_dist, "**")) && length(fileset(var.static_site_build_dist, "**")) > 0
    error_message = "The directory '${var.static_site_build_dist}' must exist and contain at least one file."
  }
}
