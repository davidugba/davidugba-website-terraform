variable "comment" {
  description = "CloudFront distribution comment"
  type        = string
}

variable "aliases" {
  description = "Alternate domain names (CNAMEs)"
  type        = list(string)
}

variable "origin_domain_name" {
  description = "Origin domain name (S3 website endpoint)"
  type        = string
}

variable "origin_id" {
  description = "Origin ID (must match existing distribution to avoid drift)"
  type        = string
}

variable "target_origin_id" {
  description = "Target origin ID for the default cache behavior"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN (must be in us-east-1 for CloudFront)"
  type        = string
  default     = ""
}

variable "waf_web_acl_arn" {
  description = "WAF Web ACL ARN for the CloudFront distribution"
  type        = string
}

variable "tags" {
  description = "Tags for the distribution"
  type        = map(string)
}
