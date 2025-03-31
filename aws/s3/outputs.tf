output "bucket_arn" {
  value = module.s3.bucket_arn  # Referencing the bucket ARN from the S3 module
}