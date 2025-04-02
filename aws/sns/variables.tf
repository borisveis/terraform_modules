variable "sns_name" {
  description = "SNS Topic name suffix"
  type        = string
}

variable "project_base" {
  description = "Project Base"
  type        = string
}

variable "topic_name" {
  type        = string
  description = "[Optional; default to <project_base>-<environment>-<sns_name>] Name of the topic if the default is undesirable"
  default     = ""
}

variable "policy" {
  description = "When true policy will be created according to full_access and limited_access arguments"
  default     = false
  type        = bool
  }

variable "full_access" {
  description = "List of AWS account IDs to grant full access to the SNS topic"
  default     = []
  type        = list(string)
}

variable "full_actions" {
  description = "List of actions to use for full access policy statement"
  default     = [
        "SNS:Subscribe",
        "SNS:SetTopicAttributes",
        "SNS:RemovePermission",
        "SNS:Receive",
        "SNS:Publish",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:AddPermission",
      ]
  type        = list(string)
}

variable "limited_actions" {
  description = "List of actions to use for limited access policy statement"
  default     = [
        "SNS:Subscribe",
        "SNS:Receive",
        "SNS:GetTopicAttributes",
      ]
  type        = list(string)
}

variable "limited_access" {
  description = "List of AWS account IDs to grant limited access to the SNS topic"
  default     = []
  type        = list(string)
}

variable "publish_actions" {
  description = "List of actions to use for publish access policy statement"
  default     = [ "SNS:Publish" ]
  type        = list(string)
}

variable "publish_access" {
  description = "List of AWS ARNs to grant publish accss to the SNS topic"
  default     = []
  type        = list(string)
}

variable "kms_master_key_id" {
  description = " The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK"
  default     = null
  # no default - when no value provided SNS will NOT be encrypted
  type        = string
}

locals {
  sns_name = length(var.topic_name) > 0 ? var.topic_name : "${var.project_base}-${var.environment}-${var.sns_name}"
}

# Required tag values
variable "environment" {
  type        = string
  description = "The build environment"
}
variable "project" {
  type        = string
  description = "Project tag value"
}
variable "application" {
  type        = string
  description = "Application tag value"
}

# Optional tag values
variable "cost-center" {
  type        = string
  description = "[OPTIONAL; 09055] Cost-Center tag value"
  default     = "09055"
}
variable "vertical" {
  type        = string
  description = "[OPTIONAL; ITCTO] Vertical tag value"
  default     = "ITCTO"
}
variable "common_tags" {
  type        = map(string)
  description = "[OPTIONAL; none] Tags to add to all objects created"
  default     = {}

}

# Merged tag values (e.g.; output)
locals {
  common_tags = merge(
    {
      Environment = upper(var.environment),
      Project     = var.project,
      Application = var.application,
      Cost-Center = var.cost-center,
      Vertical    = var.vertical
    },
    var.common_tags
  )
}