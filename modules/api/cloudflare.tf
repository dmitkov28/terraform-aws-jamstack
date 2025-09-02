resource "cloudflare_dns_record" "cname_record" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = var.api_name
  type    = "CNAME"
  content = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].target_domain_name
  ttl     = 1
  proxied = false

  depends_on = [aws_apigatewayv2_domain_name.this]
}

resource "cloudflare_dns_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      value = dvo.resource_record_value
      type  = dvo.resource_record_type
    }
  }

  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = each.value.name
  content = each.value.value
  type    = each.value.type
  ttl     = 60
  proxied = false

  depends_on = [aws_acm_certificate.cert]
}
