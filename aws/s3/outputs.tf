output "bucket_arn" {
  value = aws_s3_bucket.test_s3_bucket.arn
}

output "bucket_name" {
  value = aws_s3_bucket.test_s3_bucket.id  # Update this to match the correct resource name
}
