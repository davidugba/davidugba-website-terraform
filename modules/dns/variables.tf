variable "zone_name" {
  description = "Route53 hosted zone name (must include trailing dot)"
  type        = string
}

variable "root_domain" {
  description = "Root domain record name"
  type        = string
}

variable "www_domain" {
  description = "WWW domain record name"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  type        = string
}

variable "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID"
  type        = string
}
