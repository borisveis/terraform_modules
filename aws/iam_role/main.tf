resource "aws_iam_role" "role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = var.trusted_services
        }
        Effect   = "Allow"
        Sid      = ""
      },
    ]
  })
}

# Attach managed policies
resource "aws_iam_role_policy_attachment" "managed_policies" {
  count      = length(var.policy_arns)
  role       = aws_iam_role.role.name
  policy_arn = var.policy_arns[count.index]
}
output "role_arn" {
  description = "The ARN of the created IAM Role"
  value       = aws_iam_role.role.arn
}