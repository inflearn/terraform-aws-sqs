resource "aws_sqs_queue_policy" "this" {
  for_each = {for q in var.queue_policies : q.queue_url => q}

  queue_url = each.value.queue_url
  policy    = each.value.policy
}
