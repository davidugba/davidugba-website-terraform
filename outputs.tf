output "website_bucket_name" {
  description = "Name of the main website S3 bucket"
  value       = module.s3.website_bucket_name
}

output "website_bucket_endpoint" {
  description = "Website endpoint for S3 bucket"
  value       = module.s3.website_endpoint
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.cdn.distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.cdn.domain_name
}

output "website_url" {
  description = "Website URL"
  value       = "https://davidugba.com"
}

output "route53_zone_id" {
  description = "Route53 hosted zone ID"
  value       = module.dns.zone_id
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN"
  value       = module.cdn.acm_certificate_arn
}