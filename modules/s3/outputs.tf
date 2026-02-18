output "website_bucket_name" {
  description = "Name of the main website S3 bucket"
  value       = aws_s3_bucket.website.bucket
}

output "website_endpoint" {
  description = "S3 website endpoint for the www bucket"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "root_bucket_name" {
  description = "Name of the root domain S3 bucket"
  value       = aws_s3_bucket.root.bucket
}
