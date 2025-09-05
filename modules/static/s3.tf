resource "aws_s3_bucket" "static_site" {
  bucket        = var.bucket_name
  force_destroy = true
  tags = {
    Name        = "StaticWebsite"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket" "redirect_www" {
  bucket        = "www.${var.bucket_name}"
  force_destroy = true

  tags = {
    Name        = "RedirectBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_website_configuration" "redirect_www" {
  bucket = aws_s3_bucket.redirect_www.id

  redirect_all_requests_to {
    host_name = var.domain_name     
    protocol  = "https"
  }
}

resource "aws_s3_bucket_policy" "redirect_www_policy" {
  bucket = aws_s3_bucket.redirect_www.id
  depends_on = [aws_s3_bucket_public_access_block.redirect_www]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.redirect_www.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "redirect_www" {
  bucket = aws_s3_bucket.redirect_www.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

output "redirect_www_endpoint" {
  value = aws_s3_bucket_website_configuration.redirect_www.website_endpoint
}


resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }

}

resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.static_site.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cloudfront_dist.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "static_site" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
