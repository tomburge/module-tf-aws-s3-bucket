# Variables
variable "access_log_config" {
  description = "This is the access logging configuration"
  type = object({
    target_bucket = string
    target_prefix = string
  })
}

variable "bucket_name" {
  description = "This is the bucket name"
  type        = string
}

variable "bucket_policy" {
  description = "This is the bucket policy"
  type        = any
  default     = null
}

variable "force_destroy" {
  description = "This removes the bucket and all contents"
  type        = bool
  default     = false
}

variable "kms_key_config" {
  description = "This is the KMS Key Configuration to use for encryption"
  type = object({
    key_arn    = string
    algorithm  = string
    bucket_key = bool
  })
  default = null
}

variable "metric_config" {
  type = list(object({
    metric_name = string
    prefix      = optional(string)
    tags = optional(object({
      priority = string
      class    = string
    }))
  }))
  default = null
}

variable "object_lock" {
  description = "This sets object lock and cannot be changed on existing bucket"
  type        = bool
  default     = false
}

variable "public_block_config" {
  description = "This is the public access block configuration"
  type = object({
    public_acls        = optional(bool)
    public_policy      = optional(bool)
    public_acls_ignore = optional(bool)
    public_restrict    = optional(bool)
  })
  default = {
    public_acls        = true
    public_acls_ignore = true
    public_policy      = true
    public_restrict    = true
  }
}

variable "tags" {
  description = "This is the bucket tags"
  type        = map(string)
  default     = null
}

variable "version_config" {
  type = object({
    enable = bool
  })
  default = {
    enable = false
  }
}
