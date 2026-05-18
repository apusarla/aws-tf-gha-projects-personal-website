resource "aws_s3_bucket" "static_site_bucket" {
  bucket = var.bucket_name
}

