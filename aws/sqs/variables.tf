variable "dlq_message_retention_seconds" {
  description = "The number of seconds Dead Letter Queue retains a message."
  default     = 345600
  # default 4 days
  type = number
}

variable "dlq_visibility_timeout_seconds" {
  description = " The visibility timeout for the Dead Letter Queue"
  default     = 30
  # default 30 seconds
  type = number
}

variable "sqs_name" {
  description = "SQS name"
  # no default - value required
  type = string
}

variable "project_base" {
  description = "Project Base"
  # no default - value required
  type = string
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message."
  default     = 1209600
  # default 14 days
  type = number
}

variable "visibility_timeout_seconds" {
  description = " The visibility timeout for the queue"
  default     = 300
  # default 5 minutes
  type = number
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK"
  default     = null
  # no default - when no value provided SQS will NOT be encrypted
  type = string
}

variable "kms_data_key_reuse_period_seconds" {
  description = "The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again"
  default     = 86400
  # default 1 day
  type = number
}


variable "redrive" {
  description = "Set true to create Dead Letter Queue (name of original SQS + dlq)"
  # default do not create Dead Letter Queue
  default = false
  type    = bool
}

variable "maxReceiveCount" {
  description = "After max receives message is forwarded to Dead Letter Queue "
  # default - 5 times
  default = 5
  type    = number
}


variable "sns_map" {
  description = "Map of SNS queues to be connected to SQS"
  default     = []
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
  sqs_tags = merge(
    {
      Application = var.application
      Cost-Center = var.cost-center
      Environment = upper(var.environment)
      Project     = var.project
      Vertical    = var.vertical
    },
    var.common_tags
  )
}