terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Primary provider for most resources
provider "aws" {
  region = var.aws_region
}

# CloudFront requires ACM certificates in us-east-1
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# Main website bucket (www.davidugba.com)
resource "aws_s3_bucket" "website" {
  bucket = "www.davidugba.com"

  tags = {
    Name        = "David Ugba Website"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Website configuration for main bucket
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

# Root domain bucket (davidugba.com) - can be used for redirects
resource "aws_s3_bucket" "root" {
  bucket = "davidugba.com"

  tags = {
    Name        = "David Ugba Root Domain"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Website configuration for root bucket
resource "aws_s3_bucket_website_configuration" "root" {
  bucket = aws_s3_bucket.root.id

  index_document {
    suffix = "index.html"
  }
}

# Public access block for main website bucket
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Public access block for root bucket
resource "aws_s3_bucket_public_access_block" "root" {
  bucket = aws_s3_bucket.root.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket policy to allow CloudFront to read from S3
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.website]
}

# Bucket policy for root bucket
resource "aws_s3_bucket_policy" "root" {
  bucket = aws_s3_bucket.root.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.root.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.root]
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "David Ugba Personal Website"
  default_root_object = "index.html"
  price_class         = "PriceClass_All"
  aliases             = ["davidugba.com", "www.davidugba.com"]

  origin {
    domain_name = aws_s3_bucket_website_configuration.website.website_endpoint
    origin_id   = "www.davidugba.com.s3.eu-north-1.amazonaws.com-mj5qynv7ehu"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "www.davidugba.com.s3.eu-north-1.amazonaws.com-mj5qynv7ehu"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  lifecycle {
    ignore_changes = [
      viewer_certificate[0].acm_certificate_arn,
    ]
  }

  web_acl_id = var.waf_web_acl_arn

  tags = {
    Name        = "David Ugba Website CDN"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Route53 Hosted Zone (already exists - we'll import this)
data "aws_route53_zone" "website" {
  name         = "davidugba.com."
  private_zone = false
}

# Route53 A record for root domain (davidugba.com)
resource "aws_route53_record" "root_a" {
  zone_id = data.aws_route53_zone.website.zone_id
  name    = "davidugba.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# Route53 A record for www subdomain
resource "aws_route53_record" "www_a" {
  zone_id = data.aws_route53_zone.website.zone_id
  name    = "www.davidugba.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# Route53 AAAA record for IPv6 support (root domain)
resource "aws_route53_record" "root_aaaa" {
  zone_id = data.aws_route53_zone.website.zone_id
  name    = "davidugba.com"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# Route53 AAAA record for IPv6 support (www subdomain)
resource "aws_route53_record" "www_aaaa" {
  zone_id = data.aws_route53_zone.website.zone_id
  name    = "www.davidugba.com"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}