# module-tf-aws-s3-bucket

## What does this module do?

-   Creates S3 Bucket
-   Applies Default Bucket Policy
    -   Allow SSL Only
    -   Deny Incorrect Encryption Header
    -   Deny Unencrypted Object Uploads
-   Applies Default Server Side Encryption if custom KMS not specified
-   Requires Access Logging
-   Optional Bucket Metric Filters
-   Optional Bucket Versioning Note: **MFA not supported yet**

## Configuration Options:

-   access_log_config (object):
    -   target_bucket (string)
    -   target_prefix (string)
-   bucket_name (string)
-   bucket_policy (data source): **NOTE: in-progress**
-   force_destroy (bool): true | false
-   kms_key_config (object):
    -   key_arn (string)
    -   algorithm (string): aws:kms | aws:kms:dsse | AES256
    -   bucket_key (bool): true | false
-   metric_config (list(object)):
    -   metric_name (string)
    -   prefix (string)
    -   tags (object):
        -   priority (string)
        -   class (string)
-   object_lock (bool): true | false
-   public_block_config (object):
    -   public_acls (bool): true | false
    -   public_acls_ignore (bool): true | false
    -   public_policy (bool): true | false
    -   public_restrict (bool): true | false
-   version_config (object):
    -   enable (bool): true | false
-   tags (map(string)): **Example below**

```
tags =  {
	"repo" = "https://github.com/tomburge/module-tf-aws-s3-bucket",
	"terraform" = "true"
}
```

## Example Module Configuration:

```
module  "bucket_test" {
	source  =  "./modules/module-tf-aws-s3-bucket"
	bucket_name  =  "toms-test-bucket-name"
	force_destroy  =  false
	access_log_config  =  {
		target_bucket  =  "0123456789-us-east-1-access-logs"
		target_prefix  =  "test-bucket-name-0123456789-us-east-1"
	}
	kms_key_config  =  {
		key_arn  =  "arn:aws:kms:us-east-1:0123456789:key/<kms-key-guid>"
		algorithm  =  "aws:kms"
		bucket_key  =  true
	}
	metric_config  =  [
		{
			metric_name  =  "testing1"
		},
		{
			metric_name  =  "testing2"
			prefix  =  "test"
			tags  = {
				"priority" = "high"
				"class" = "red"
			}
		},
		{
			metric_name  =  "testing3"
			prefix  =  "test"
			tags  = {
				"priority" = "medium"
				"class" = "yellow"
			}
		},
		{
			metric_name  =  "testing4"
			prefix  =  "test"
			tags  = {
				"priority" = "low"
				"class" = "green"
			}
		},
	]
	public_block_config  =  {
		public_acls  =  true
		public_acls_ignore  =  true
		public_policy  =  true
		public_restrict  =  true
	}
	version_config  =  {
		enable  =  false
	}
}
```
