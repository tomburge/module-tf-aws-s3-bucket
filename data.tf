data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_kms_alias" "s3_key" {
  name = "alias/aws/s3"
}

data "aws_iam_policy_document" "default_encryption" {
  statement {
    sid = "AllowSSLRequestsOnly"
    actions = [
      "s3:*",
    ]
    effect = "Deny"
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid = "DenyIncorrectEncryptionHeader"
    actions = [
      "s3:PutObject",
    ]
    effect = "Deny"
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  # statement {
  #   sid = "DenyUnEncryptedObjectUploads"
  #   actions = [
  #     "s3:PutObject",
  #   ]
  #   effect = "Deny"
  #   resources = [
  #     aws_s3_bucket.this.arn,
  #     "${aws_s3_bucket.this.arn}/*",
  #   ]
  #   condition {
  #     test     = "Null"
  #     variable = "s3:x-amz-server-side-encryption"
  #     values   = ["true"]
  #   }
  #   principals {
  #     type        = "AWS"
  #     identifiers = ["*"]
  #   }
  # }
}

data "aws_iam_policy_document" "kms_encryption" {
  statement {
    sid = "AllowSSLRequestsOnly"
    actions = [
      "s3:*",
    ]
    effect = "Deny"
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid = "DenyIncorrectEncryptionHeader"
    actions = [
      "s3:PutObject",
    ]
    effect = "Deny"
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = [var.kms_key_config.key_arn]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  # statement {
  #   sid = "DenyUnEncryptedObjectUploads"
  #   actions = [
  #     "s3:PutObject",
  #   ]
  #   effect = "Deny"
  #   resources = [
  #     aws_s3_bucket.this.arn,
  #     "${aws_s3_bucket.this.arn}/*",
  #   ]
  #   condition {
  #     test     = "StringNotEquals"
  #     variable = "s3:x-amz-server-side-encryption"
  #     values   = "aws:kms"
  #   }
  #   condition {
  #     test     = "StringNotEquals"
  #     variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
  #     values   = var.kms_key_config.key_arn
  #   }
  #   principals {
  #     type        = "AWS"
  #     identifiers = ["*"]
  #   }
  # }
}

# data "aws_iam_policy_document" "bucket_policy" {
#   statement {
#     sid = "AllowSSLRequestsOnly"
#     actions = [
#       "s3:*",
#     ]
#     effect = "Deny"
#     resources = [
#       aws_s3_bucket.this.arn,
#       "${aws_s3_bucket.this.arn}/*",
#     ]
#     condition {
#       test     = "Bool"
#       variable = "aws:SecureTransport"
#       values   = ["false"]
#     }
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#   }
#   statement {
#     sid = "DenyIncorrectEncryptionHeader"
#     actions = [
#       "s3:PutObject",
#     ]
#     effect = "Deny"
#     resources = [
#       aws_s3_bucket.this.arn,
#       "${aws_s3_bucket.this.arn}/*",
#     ]
#     condition {
#       test     = "StringNotEquals"
#       variable = "s3:x-amz-server-side-encryption"
#       values   = [try(var.kms_key_config.algorithm, "aws:kms")]
#     }
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#   }
#   statement {
#     sid = "DenyUnEncryptedObjectUploads"
#     actions = [
#       "s3:PutObject",
#     ]
#     effect = "Deny"
#     resources = [
#       aws_s3_bucket.this.arn,
#       "${aws_s3_bucket.this.arn}/*",
#     ]
#     condition {
#       test     = "Null"
#       variable = "s3:x-amz-server-side-encryption"
#       values   = ["true"]
#     }
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#   }
# }
