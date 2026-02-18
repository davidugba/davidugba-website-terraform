# Modules

This project is split into small, focused modules:

- `modules/s3`: S3 buckets + website configs + public access blocks + bucket policies
- `modules/cdn`: CloudFront distribution (WAF + TLS settings)
- `modules/dns`: Route53 zone lookup + A/AAAA alias records pointing to CloudFront
