# Resources
resource "aws_s3_bucket" "this" {
  bucket              = var.bucket_name
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock
  tags                = var.tags
}

resource "aws_s3_bucket_logging" "this" {
  count         = var.access_log_config != null ? 1 : 0
  bucket        = aws_s3_bucket.this.id
  target_bucket = var.access_log_config.target_bucket
  target_prefix = var.access_log_config.target_prefix
}

resource "aws_s3_bucket_metric" "this" {
  for_each = var.metric_config != null ? { for idx, config in var.metric_config : idx => config } : {}
  bucket   = aws_s3_bucket.this.id
  name     = each.value.metric_name
  dynamic "filter" {
    for_each = (try(length(each.value.prefix), 0) > 0 || try(length(each.value.tags), 0) > 0) ? [each.value] : []
    content {
      prefix = filter.value.prefix
      tags   = filter.value.tags
    }
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.this.id
  policy = var.bucket_policy != null ? var.bucket_policy : (
    var.kms_key_config != null ? data.aws_iam_policy_document.kms_encryption.json :
    data.aws_iam_policy_document.default_encryption.json
  )
}

resource "aws_s3_bucket_public_access_block" "this" {
  count                   = var.public_block_config != null ? 1 : 0
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.public_block_config.public_acls != null ? var.public_block_config.public_acls : true
  block_public_policy     = var.public_block_config.public_policy != null ? var.public_block_config.public_policy : true
  ignore_public_acls      = var.public_block_config.public_acls_ignore != null ? var.public_block_config.public_acls_ignore : true
  restrict_public_buckets = var.public_block_config.public_restrict != null ? var.public_block_config.public_restrict : true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.kms_key_config != null ? [1] : []

    content {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key_config.key_arn
        sse_algorithm     = "aws:kms"
      }
      bucket_key_enabled = lookup(var.kms_key_config, "bucket_key", true)
    }
  }

  dynamic "rule" {
    for_each = var.kms_key_config == null ? [1] : []

    content {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = true
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.version_config.enable == true ? "Enabled" : "Disabled"
  }
}

