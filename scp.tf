module "scp_ou" {
  for_each = local.ous
  source = "./modules/scp"
  target = each.value

  # Deny the ability to remove an account from the AWS Organization it is assigned to
  deny_leaving_orgs = true

  # Deny deleting KMS keys
  deny_deleting_kms_keys = true

  # Deny manipulation of CloudTrail
  deny_cloudtrail_manipulation = true

  # Deny deleting Route53 zones
  deny_deleting_route53_zones = true

  # Deny deleting CloudWatch logs
  # Causes issues with Cloudformation
  deny_deleting_cloudwatch_logs = false

  # Deny public access to buckets
  deny_s3_buckets_public_access          = true
  deny_s3_bucket_public_access_resources = ["arn:aws:s3:::*/*"]

  # Restrict the regions where AWS non-global services can be created
  limit_regions   = true
  allowed_regions = var.allowed_regions

  # Require S3 Objects to be Encrypted (Encryption at rest)
  require_s3_encryption = false

  # Require MFA S3 Delete
  require_mfa_delete = true

  # Deny Unsecure SSL Requests to S3
  deny_non_tls_s3_requests = true

  # Require MFA to perform an API Action
  require_MFA = true

  # SCP policy tags
  tags = {
    managed_by = "managed by Terraform"
  }
}
