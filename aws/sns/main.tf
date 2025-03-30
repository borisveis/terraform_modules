resource "aws_sns_topic" "general_sns" {
  name              = local.sns_name
  kms_master_key_id = var.kms_master_key_id

  tags = merge(
    local.common_tags,
    { Name = local.sns_name }
    )

}



resource "aws_sns_topic_policy" "sns_policy" {
  count = var.policy ? 1 : 0

  arn    = aws_sns_topic.general_sns.arn
  policy = data.aws_iam_policy_document.sns-topic-policy.json
}

data "aws_iam_policy_document" "sns-topic-policy" {
  dynamic "statement" {
    for_each = var.full_access
    content {
      actions = var.full_actions
      condition {
        test     = "StringEquals"
        variable = "AWS:SourceOwner"
        values = [ statement.value ]
      }
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      resources = [
        aws_sns_topic.general_sns.arn,
      ]
      sid = join("_", [ "FULL_ACCESS_FOR",statement.value ])
    }
  }

  dynamic "statement" {
    for_each = var.limited_access
    content {
      actions = var.limited_actions
      condition {
        test     = "StringEquals"
        variable = "AWS:SourceOwner"
        values = [ statement.value ]
      }
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      resources = [
        aws_sns_topic.general_sns.arn,
      ]
      sid = join("_",[ "LIMITED_ACCESS_FOR", statement.value ])
    }
  }
}


output "sns_id" {
  value = aws_sns_topic.general_sns.id
 }

output "sns_arn" {
  value = aws_sns_topic.general_sns.arn
 }
