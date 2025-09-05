
module "static" {
  source                       = "../static"
  bucket_name                  = var.bucket_name
  cloudfront_distribution_name = var.cloudfront_distribution_name
  static_site_build_dist       = var.static_site_build_dist
  domain_name                  = var.domain_name
  aws_acm_certificate_arn      = module.dns.aws_acm_certificate_arn

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  depends_on = [module.dns]
}

module "dns" {
  source             = "../dns"
  domain_name        = var.domain_name
  cloudflare_zone_id = var.cloudflare_zone_id

  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

module "dns_routing" {
  source                     = "../dns-routing"
  cloudflare_zone_id         = var.cloudflare_zone_id
  cloudfront_domain          = module.static.cloudfront_domain
  cloudfront_redirect_domain = module.static.cloudfront_redirect_domain
  subdomain                  = null

  depends_on = [module.static, module.dns]
}
