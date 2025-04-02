variable "is_private" {
  default = true
}
variable "public_locations" {
  type = set(string)
  default = ["us-east-1"]
}
variable "commons" {}
variable "group_name" {
  default = ""
}
variable "name" {
  type = string
}
variable "activated" {
  type    = bool
  default = true
}
variable "concurrency" {
  type    = number
  default = 5
}
variable "frequency" {
  type    = number
  default = 15
}
variable "group_id" {
  description = "If ID is provided, the check will be added to it. Else, a new group will be created"
  type        = number
  default     = 0
}
variable "muted" {
  type    = bool
  default = false
}

variable "headers" {
  type = map(string)
  default = {
  }
}
variable "url" {
  type = string
}
variable "method" {
  default = "POST"
}
variable "body" {
  type    = string
  default = ""
}
variable "assertions" {
  type    = list(any)
  default = [
    {
      source     = "STATUS_CODE"
      comparison = "EQUALS"
      target     = "200"
    }
  ]
}

variable "create_group" {
  default = true
}

variable "attempt_retries" {
  type = bool
  default = false
}
variable "retry_type" {
  type = string
  default = "FIXED"
  description = "see documentation of type. Most common non-default is Fixed for fixed retry interval."
}

variable "retry_base_backoff_seconds" {
  description= "The number of seconds to wait before the first retry attempt"
  type = number
  default = 5
}
variable "retry_max_retries" {
  description = "The maximum number of times to retry the check. Value must be between 1 and 10"
  type = number
  default = 3
}
variable "retry_max_duration_seconds" {
  description = "The total amount of time to continue retrying the check"
  default = 30
}
variable "retry_same_region" {
  type = bool
  default = true
}

locals {
  active_group_id   = var.create_group?  checkly_check_group.group[0].id:var.group_id
  private_locations = var.is_private ? [var.commons.account.name] : []
  public_locations  = var.is_private ? [] : var.public_locations
  assertions        = [for a in var.assertions : merge({source = "", comparison = "", target = "", property = ""}, a)]
}