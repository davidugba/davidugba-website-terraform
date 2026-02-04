variable "aws_region" {
  description = "Primary AWS region for resources"
  type        = string
  default     = "eu-north-1"
}

variable "waf_web_acl_arn" {
  description = "WAF Web ACL ARN for CloudFront distribution"
  type        = string
  default     = "arn:aws:wafv2:us-east-1:049749094059:global/webacl/CreatedByCloudFront-19b6d8fc/216d413e-52d1-4e83-9a20-61abf376bb67"
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for the domain"
  type        = string
}