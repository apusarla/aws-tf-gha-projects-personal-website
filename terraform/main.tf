resource "aws_s3_bucket" "static_site" {
  bucket = "725740881803-static-site"
  lifecycle {
    ignore_changes = all
  }
}

# resource "aws_s3_bucket_website_configuration" "static_site_config" {
#   bucket = aws_s3_bucket.static_site.id

#   index_document {
#     suffix = "index.html"
#   }
# }

# resource "aws_s3_bucket_policy" "static_site_policy" {
#     bucket = aws_s3_bucket.static_site.id
#     policy = jsonencode({
#         Version = "2012-10-17"
#         Statement = [
#             {
#                 Effect = "Allow"
#                 Principal = "*"
#                 Action = "s3:GetObject"
#                 Resource = "${aws_s3_bucket.static_site.arn}/*"
#             }
#         ]
#     })
# }
resource "aws_s3_bucket_public_access_block" "static_site_access" {
    bucket = aws_s3_bucket.static_site.id
    block_public_acls       = true
    ignore_public_acls      = true
    block_public_policy     = true
    restrict_public_buckets = true
}


## to create a certificate
resource "aws_acm_certificate" "krp" {
  domain_name = "krp.com"
  validation_method = "DNS"
  subject_alternative_names = ["*.krp.com", "krishiv.com", "*.krishiv.com", "krishivrajpusarla.com"]

  tags = {
    Name = "krp.com"
  }

}

output "certificate_arn" {
  value = aws_acm_certificate.krp.arn
}

data "aws_route53_zone" "krp" {
  name         = "krp.com"
  private_zone = false
}

## certificate validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.krp.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.krp.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "krp_cert_validation" {
  certificate_arn         = aws_acm_certificate.krp.certificate_arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
