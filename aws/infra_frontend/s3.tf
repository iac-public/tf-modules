resource "aws_s3_bucket" "website" {
  provider = aws.tokyo
  bucket   = "${var.system_name}-${var.env}-website-bucket"
}

resource "aws_s3_bucket_public_access_block" "website" {
  provider = aws.tokyo
  bucket   = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "website" {
  provider = aws.tokyo
  bucket   = aws_s3_bucket.website.id
  policy   = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  provider = aws.virginia
  comment  = "OAI for CloudFront to access S3"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = ["s3:GetObject"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }

    resources = [
      "${aws_s3_bucket.website.arn}/*"
    ]
  }
}