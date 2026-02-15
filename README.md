# David Ugba Website Infrastructure

Production AWS website infrastructure for davidugba.com managed with Terraform.

## Architecture

![Architecture Diagram (PNG)](docs/architecture.png)

```mermaid
flowchart LR
	user[User Browser] -->|HTTPS| cf[CloudFront Distribution]
	cf -->|Origin: S3 Website Endpoint| s3www[S3 Bucket: www.davidugba.com]
	cf -->|Origin: S3 Website Endpoint| s3root[S3 Bucket: davidugba.com]
	r53[Route 53 Hosted Zone] -->|A/AAAA records| cf
	acm[ACM Certificate (us-east-1)] -->|TLS| cf
```

Mermaid source: docs/architecture.mmd

- S3 buckets for static website hosting
- CloudFront distribution for global CDN and HTTPS
- Route53 DNS records (A and AAAA)
- ACM certificate for TLS

## Prerequisites

- Terraform v1.0+
- AWS CLI configured
- Existing Route53 hosted zone for the domain
- ACM certificate in us-east-1

## Usage

1. terraform init
2. terraform plan
3. terraform apply

## Import Existing Resources (if already created in AWS)

```bash
terraform import aws_s3_bucket.website www.davidugba.com
terraform import aws_s3_bucket.root davidugba.com

terraform import aws_s3_bucket_website_configuration.website www.davidugba.com
terraform import aws_s3_bucket_website_configuration.root davidugba.com

terraform import aws_s3_bucket_public_access_block.website www.davidugba.com
terraform import aws_s3_bucket_public_access_block.root davidugba.com

terraform import aws_s3_bucket_policy.website www.davidugba.com
terraform import aws_s3_bucket_policy.root davidugba.com

terraform import aws_cloudfront_distribution.website <DISTRIBUTION_ID>

terraform import aws_route53_record.root_a ZONEID_davidugba.com_A
terraform import aws_route53_record.www_a ZONEID_www.davidugba.com_A
```

## Notes

- State files and tfvars are ignored via .gitignore
- Existing resources were imported before apply

## Outputs

Run: terraform output

## Contact

David Ugba — Cloud Engineering Enthusiast
