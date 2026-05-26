output "enabled" {
  description = "Whether the module is enabled."
  value       = local.enabled
}

output "id" {
  description = "ID of the logging configuration"
  value       = try(aws_s3_bucket_logging.this[0].id, null)
}

output "target_bucket_id" {
  description = "ID of the target logging bucket"
  value       = var.target_bucket_id
}
