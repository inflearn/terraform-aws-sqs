resource "aws_sqs_queue" "dlq" {
  for_each                   = {for q in var.queues : "${try(q.name, "")}${try(q.name_prefix, "")}" => q if try(q.dlq, true)}
  name                       = try("${each.value.name}-dlq", null)
  name_prefix                = try("${each.value.name_prefix}-dlq", null)
  visibility_timeout_seconds = try(each.value.visibility_timeout_seconds, null)
  message_retention_seconds  = try(each.value.message_retention_seconds, null)
}

resource "aws_sqs_queue" "this" {
  for_each = {for q in var.queues : "${try(q.name, "")}${try(q.name_prefix, "")}" => q}

  name                       = try(each.value.name, null)
  name_prefix                = try(each.value.name_prefix, null)
  visibility_timeout_seconds = try(each.value.visibility_timeout_seconds, null)
  message_retention_seconds  = try(each.value.message_retention_seconds, null)
  max_message_size           = try(each.value.max_message_size, null)
  delay_seconds              = try(each.value.delay_seconds, null)
  receive_wait_time_seconds  = try(each.value.receive_wait_time_seconds, null)
  policy                     = try(each.value.policy, null)
  redrive_policy             = try(each.value.dlq, true) ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[each.key].arn,
    maxReceiveCount     = try(each.value.max_receive_count, 4)
  }) : null
  redrive_allow_policy = try(each.value.dlq, true) ? jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.dlq[each.key].arn]
  }) : null
  fifo_queue                        = try(each.value.fifo_queue, null)
  content_based_deduplication       = try(each.value.content_based_deduplication, null)
  deduplication_scope               = try(each.value.deduplication_scope, null)
  fifo_throughput_limit             = try(each.value.fifo_throughput_limit, null)
  kms_master_key_id                 = try(each.value.kms_master_key_id, null)
  kms_data_key_reuse_period_seconds = try(each.value.kms_data_key_reuse_period_seconds, null)

  tags = var.tags
}

data "aws_arn" "this" {
  for_each = {for q in var.queues : "${try(q.name, "")}${try(q.name_prefix, "")}" => q}

  arn = aws_sqs_queue.this[each.key].arn
}
