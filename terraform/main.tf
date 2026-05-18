resource "aws_s3_bucket" "static_site" {
  bucket = "725740881803-static-site"
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_s3_bucket_website_configuration" "static_site_config" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "static_site_policy" {
    bucket = aws_s3_bucket.static_site.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = "*"
                Action = "s3:GetObject"
                Resource = "${aws_s3_bucket.static_site.arn}/*"
            }
        ]
    })
}
resource "aws_s3_bucket_public_access_block" "static_site_access" {
    bucket = aws_s3_bucket.static_site.id
    block_public_acls       = false
    ignore_public_acls      = false
    block_public_policy     = false
    restrict_public_buckets = false
}
