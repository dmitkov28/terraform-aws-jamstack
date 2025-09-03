output "aws_acm_certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "aws_acm_certificate_validation_arn" {
  value = aws_acm_certificate_validation.cert.certificate_arn
}
