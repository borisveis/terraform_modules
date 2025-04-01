provider "aws" {
  region = var.region
}

# Create the S3 bucket
resource "aws_s3_bucket" "test_s3_bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

# Apply a bucket policy instead of an ACL
resource "aws_s3_bucket_policy" "test_s3_bucket_policy" {
  bucket = aws_s3_bucket.test_s3_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.test_s3_bucket.arn}/*"
    }]
  })
}
