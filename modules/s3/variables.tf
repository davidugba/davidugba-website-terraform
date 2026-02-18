variable "website_bucket_name" {
  description = "S3 bucket name for the www website"
  type        = string
}

variable "root_bucket_name" {
  description = "S3 bucket name for the root domain"
  type        = string
}

variable "tags_website" {
  description = "Tags for the website bucket"
  type        = map(string)
}

variable "tags_root" {
  description = "Tags for the root bucket"
  type        = map(string)
}
