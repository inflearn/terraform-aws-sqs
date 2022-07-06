output "sqs_queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = {for k, v in aws_sqs_queue.this : k => v.id}
}

output "sqs_queue_arn" {
  description = "The ARN of the SQS queue"
  value       = {for k, v in aws_sqs_queue.this : k => v.arn}
}

output "sqs_dlq_arn" {
  description = "The ARN of the Dead Letter SQS queue"
  value       = {for k, v in aws_sqs_queue.dlq : k => v.arn}
}

output "sqs_queue_name" {
  description = "The name of the SQS queue"
  value       = {for k, v in data.aws_arn.this : k => v.resource}
}
