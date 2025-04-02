resource "checkly_check_group" "group" {
  count = var.create_group ? 1 : 0

  name              = length(var.group_name) > 0 ? var.group_name : var.name
  activated         = var.activated
  locations         = local.public_locations
  private_locations = local.private_locations
  concurrency       = var.concurrency
  muted             = var.muted
  tags              = var.commons.checkly.tags

  alert_channel_subscription {
    activated  = true
    channel_id = var.commons.checkly.channel_id
  }
}

resource "checkly_check" "check" {
  name      = var.name
  activated = var.activated

  frequency = var.frequency
  type      = "API"

  group_id = local.active_group_id
  request {

    follow_redirects = true
    skip_ssl         = false
    url              = var.url
    method           = var.method
    body             = var.body
    headers          = var.headers

    dynamic "assertion" {
      for_each = local.assertions

      content {
        source     = assertion.value.source
        comparison = assertion.value.comparison
        target     = assertion.value.target
        property   = assertion.value.property
      }
    }

  }
 dynamic "retry_strategy" {
    for_each = var.attempt_retries ? [1] : []

    content {
      type                  = var.retry_type
      base_backoff_seconds  = var.retry_base_backoff_seconds
      max_duration_seconds   = var.retry_max_duration_seconds
      same_region            = var.retry_same_region
    }
  }
}

output "group_id" {
  value = local.active_group_id
}