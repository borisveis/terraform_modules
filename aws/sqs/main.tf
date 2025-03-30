resource "aws_sqs_queue" "general_sqs" {
  name                              = "${var.project_base}-${var.environment}-${var.sqs_name}"
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  message_retention_seconds         = var.message_retention_seconds
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  redrive_policy                    = var.redrive ? "{\"deadLetterTargetArn\":\"${join("", aws_sqs_queue.redrive_sqs.*.arn)}\",\"maxReceiveCount\":${var.maxReceiveCount}}" : null

  tags = merge(
    local.sqs_tags,
    { Name = "${var.project_base}-${var.environment}-${var.sqs_name}" }
  )

}

resource "aws_sqs_queue" "redrive_sqs" {
  count = var.redrive ? 1 : 0

  name                              = "${var.project_base}-${var.environment}-${var.sqs_name}-dlq"
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  message_retention_seconds         = var.dlq_message_retention_seconds
  visibility_timeout_seconds        = var.dlq_visibility_timeout_seconds

  tags = merge(
    local.sqs_tags,
    { Name = "${var.project_base}-${var.environment}-${var.sqs_name}" }
  )
}


output "sqs_id" {
  value = aws_sqs_queue.general_sqs.id
}

output "sqs_arn" {
  value = aws_sqs_queue.general_sqs.arn
}

output "dlq_arn" {
  value = var.redrive ? aws_sqs_queue.redrive_sqs[0].arn : ""
}

output "dlq_id" {
  value = var.redrive ? aws_sqs_queue.redrive_sqs[0].id : ""
}

data "aws_iam_policy_document" "sqs_iam_policy_doc" {
  dynamic "statement" {
    for_each = var.sns_map
    content {
      sid    = element(split(":", statement.value), 5)
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      actions   = ["SQS:SendMessage"]
      resources = [aws_sqs_queue.general_sqs.arn]
      condition {
        test     = "ArnEquals"
        variable = "aws:SourceArn"
        values = [
          statement.value
        ]
      }
    }
  }
}



resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.general_sqs.id
  policy    = data.aws_iam_policy_document.sqs_iam_policy_doc.json
}