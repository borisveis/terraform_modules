# Specify the AWS provider and region
provider "aws" {
  region = var.region
}
resource "aws_s3_bucket" "test_s3_bucket" {
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_acl" "test_s3_bucket_acl" {
  bucket = aws_s3_bucket.test_s3_bucket.id
  acl    = var.acl
}

