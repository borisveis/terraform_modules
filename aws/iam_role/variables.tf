variable "role_name" {
  description = "The name of the IAM role for the EKS cluster."
  type        = string
}

  description = "examples: eks.amazonaws.com,ec2.amazonaws.com"

  default     = "ec2.amazonaws.com"
}
variable "Effect" {
  type = string
  default = "Allow"
  }