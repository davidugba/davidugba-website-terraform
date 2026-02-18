terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

moved {
  from = aws_s3_bucket.website
  to   = module.s3.aws_s3_bucket.website
}

moved {
  from = aws_s3_bucket_website_configuration.website
  to   = module.s3.aws_s3_bucket_website_configuration.website
}

moved {
  from = aws_s3_bucket_public_access_block.website
  to   = module.s3.aws_s3_bucket_public_access_block.website
}

moved {
  from = aws_s3_bucket_policy.website
  to   = module.s3.aws_s3_bucket_policy.website
}

moved {
  from = aws_s3_bucket.root
  to   = module.s3.aws_s3_bucket.root
}

moved {
  from = aws_s3_bucket_website_configuration.root
  to   = module.s3.aws_s3_bucket_website_configuration.root
}

moved {
  from = aws_s3_bucket_public_access_block.root
  to   = module.s3.aws_s3_bucket_public_access_block.root
}

moved {
  from = aws_s3_bucket_policy.root
  to   = module.s3.aws_s3_bucket_policy.root
}

moved {
  from = aws_cloudfront_distribution.website
  to   = module.cdn.aws_cloudfront_distribution.website
}

moved {
  from = aws_route53_record.root_a
  to   = module.dns.aws_route53_record.root_a
}

moved {
  from = aws_route53_record.www_a
  to   = module.dns.aws_route53_record.www_a
}

moved {
  from = aws_route53_record.root_aaaa
  to   = module.dns.aws_route53_record.root_aaaa
}

moved {
  from = aws_route53_record.www_aaaa
  to   = module.dns.aws_route53_record.www_aaaa
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

locals {
  website_bucket_name = "www.davidugba.com"
  root_bucket_name    = "davidugba.com"

  website_tags = {
    Name        = "David Ugba Website"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }

  root_tags = {
    Name        = "David Ugba Root Domain"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }

  cdn_tags = {
    Name        = "David Ugba Website CDN"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }

  # Must match existing distribution config to avoid drift
  cloudfront_origin_id = "www.davidugba.com.s3.eu-north-1.amazonaws.com-mj5qynv7ehu"
}

module "s3" {
  source = "./modules/s3"

  website_bucket_name = local.website_bucket_name
  root_bucket_name    = local.root_bucket_name

  tags_website = local.website_tags
  tags_root    = local.root_tags
}

module "cdn" {
  source = "./modules/cdn"

  comment            = "David Ugba Personal Website"
  aliases            = [local.root_bucket_name, local.website_bucket_name]
  origin_domain_name = module.s3.website_endpoint
  origin_id          = local.cloudfront_origin_id
  target_origin_id   = local.cloudfront_origin_id

  acm_certificate_arn = var.acm_certificate_arn
  waf_web_acl_arn     = var.waf_web_acl_arn
  tags                = local.cdn_tags
}

module "dns" {
  source = "./modules/dns"

  zone_name = "davidugba.com."

  root_domain = local.root_bucket_name
  www_domain  = local.website_bucket_name

  cloudfront_domain_name    = module.cdn.domain_name
  cloudfront_hosted_zone_id = module.cdn.hosted_zone_id
}