# Specify the AWS provider and region
provider "aws" {
  region = var.region
}
resource "aws_s3_bucket" "test_s3_bucket" {
  bucket = var.bucket_name
  acl    = var.acl


  versioning {
    enabled = false
  }
  tags = var.tags
}

