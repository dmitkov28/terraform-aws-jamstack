output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.static_site.website_endpoint
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.cloudfront_dist.domain_name
}

output "cloudfront_redirect_domain" {
  value = aws_cloudfront_distribution.www_redirect_cf.domain_name
}
