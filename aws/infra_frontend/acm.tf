resource "aws_acm_certificate" "main" {
  provider          = aws.virginia
  domain_name       = var.record_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}