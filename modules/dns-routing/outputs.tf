output "main_cname_record" {
  description = "Main CNAME record details"
  value = {
    id      = cloudflare_dns_record.main_cname.id
    name    = cloudflare_dns_record.main_cname.name
    content = cloudflare_dns_record.main_cname.content
  }
}

output "www_cname_record" {
  description = "WWW CNAME record details"
  value = {
    id      = cloudflare_dns_record.www_cname.id
    name    = cloudflare_dns_record.www_cname.name
    content = cloudflare_dns_record.www_cname.content
  }
}

output "dns_records" {
  description = "All DNS records created"
  value = {
    main = cloudflare_dns_record.main_cname
    www  = cloudflare_dns_record.www_cname
  }
}
