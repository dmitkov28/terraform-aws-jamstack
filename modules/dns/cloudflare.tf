resource "cloudflare_dns_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      value = dvo.resource_record_value
      type  = dvo.resource_record_type
    }
  }

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  content = each.value.value
  type    = each.value.type
  ttl     = 60
  proxied = false

  depends_on = [aws_acm_certificate.cert]
}
