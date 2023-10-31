output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "The ARN of the bucket."
}

output "bucket_id" {
  value       = aws_s3_bucket.this.id
  description = "The ID of the bucket."
}

output "bucket_policy_id" {
  value       = aws_s3_bucket_policy.policy.id
  description = "The ID of the bucket policy."
}

output "logging_target_bucket" {
  value       = aws_s3_bucket_logging.this[0].target_bucket
  description = "The S3 bucket where logging is stored."
}

output "logging_target_prefix" {
  value       = aws_s3_bucket_logging.this[0].target_prefix
  description = "The prefix applied to log objects."
}

output "public_access_block_settings" {
  value       = aws_s3_bucket_public_access_block.this.*.id
  description = "The public access block settings."
}

output "server_side_encryption_configuration" {
  value       = aws_s3_bucket_server_side_encryption_configuration.this.*.id
  description = "The server-side encryption configuration."
}

output "versioning_configuration" {
  value       = aws_s3_bucket_versioning.this.versioning_configuration
  description = "The versioning configuration."
}


