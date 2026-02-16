output "website_bucket_name" {
  description = "Name of the main website S3 bucket"
  value       = aws_s3_bucket.website.bucket
}

output "website_bucket_endpoint" {
  description = "Website endpoint for S3 bucket"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.website.id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "website_url" {
  description = "Website URL"
  value       = "https://davidugba.com"
}

output "route53_zone_id" {
  description = "Route53 hosted zone ID"
  value       = data.aws_route53_zone.website.zone_id
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN"
  value       = aws_cloudfront_distribution.website.viewer_certificate[0].acm_certificate_arn
}