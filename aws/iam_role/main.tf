resource "aws_iam_role" "eks_cluster_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect   = "Allow"
        Sid      = ""
      },
    ]
  })
}
