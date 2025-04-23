
resource "aws_s3_bucket" "test_s3_bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_public_access_block" "test_s3_bucket_bpa" {
  bucket                  = aws_s3_bucket.test_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "test_s3_bucket_policy" {
  bucket     = aws_s3_bucket.test_s3_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.test_s3_bucket_bpa]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCodePipelineAccess",
        Effect    = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        },
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:GetObjectVersion"
        ],
        Resource = [
          "${aws_s3_bucket.test_s3_bucket.arn}/*"
        ]
      }
    ]
  })
}
