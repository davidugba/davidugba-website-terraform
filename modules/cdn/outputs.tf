output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.website.id
}

output "domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "hosted_zone_id" {
  description = "CloudFront hosted zone ID for Route53 alias records"
  value       = aws_cloudfront_distribution.website.hosted_zone_id
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN currently configured on the distribution"
  value       = aws_cloudfront_distribution.website.viewer_certificate[0].acm_certificate_arn
}
