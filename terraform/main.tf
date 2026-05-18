resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "static_site_bucket" {
  bucket = "725740881803-static-site-bucket"
}
