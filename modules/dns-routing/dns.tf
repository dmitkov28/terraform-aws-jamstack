resource "cloudflare_dns_record" "main_cname" {
  zone_id = var.cloudflare_zone_id
  name    = var.subdomain != null && var.subdomain != "" ? var.subdomain : "@"
  type    = "CNAME"
  content = var.cloudfront_domain
  ttl     = var.ttl
  proxied = var.proxied

  # settings = {
  #   flatten_cname = var.subdomain != null || var.subdomain != ""
  # }

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_dns_record" "www_cname" {
  zone_id = var.cloudflare_zone_id
  name    = var.subdomain != null && var.subdomain != "" ? "www.${var.subdomain}" : "www"
  type    = "CNAME"
  content = var.cloudfront_redirect_domain
  ttl     = var.ttl
  proxied = var.proxied

  lifecycle {
    create_before_destroy = true
  }
}


