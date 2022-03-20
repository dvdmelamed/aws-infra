locals {
  # Each policy variable is set to a bool, defaulting to false (not included).
  # Include a policy by setting a policy variable to `true`, passing the hard-coded "Deny" statment
  # into the combined policy block.

  # Exclude a policy from the combined policy by omitting the policy variable in the module call.
  # This results in the default setting of `false`, and
  # the dynamic `for_each` statement will return an array with an empty string,
  # and the statement will not be included.
  deny_leaving_orgs_statement                = var.deny_leaving_orgs ? [""] : []
  deny_creating_iam_users_statement          = var.deny_creating_iam_users ? [""] : []
  deny_deleting_kms_keys_statement           = var.deny_deleting_kms_keys ? [""] : []
  deny_deleting_route53_zones_statement      = var.deny_deleting_route53_zones ? [""] : []
  deny_deleting_cloudwatch_logs_statement    = var.deny_deleting_cloudwatch_logs ? [""] : []
  deny_root_account_statement                = var.deny_root_account ? [""] : []
  protect_s3_buckets_statement               = var.protect_s3_buckets ? [""] : []
  deny_s3_buckets_public_access_statement    = var.deny_s3_buckets_public_access ? [""] : []
  protect_iam_roles_statement                = var.protect_iam_roles ? [""] : []
  limit_regions_statement                    = var.limit_regions ? [""] : []
  deny_unencrypted_object_uploads_statement  = var.require_s3_encryption ? [""] : []
  deny_incorrect_encryption_header_statement = var.require_s3_encryption ? [""] : []
  require_mfa_delete_statement               = var.require_mfa_delete ? [""] : []
  deny_non_tls_s3_requests_statement         = var.deny_non_tls_s3_requests ? [""] : []
  require_MFA_statement                      = var.require_MFA ? [""] : []
  deny_cloudtrail_manipulation_statement     = var.deny_cloudtrail_manipulation ? [""] : []
}

#
# Combine Policies
#


data "aws_iam_policy_document" "combined_policy_block" {

  #
  # Deny leaving AWS Organizations
  #

  dynamic "statement" {
    for_each = local.deny_leaving_orgs_statement
    content {
      sid       = "DenyLeavingOrgs"
      effect    = "Deny"
      actions   = ["organizations:LeaveOrganization"]
      resources = ["*"]
    }
  }

  #
  # Deny creating IAM users or access keys
  #

  dynamic "statement" {
    for_each = local.deny_creating_iam_users_statement
    content {
      sid    = "DenyCreatingIAMUsers"
      effect = "Deny"
      actions = [
        "iam:CreateUser",
        "iam:CreateAccessKey"
      ]
      resources = ["*"]
    }
  }

  #
  # Deny deleting KMS Keys
  #

  dynamic "statement" {
    for_each = local.deny_deleting_kms_keys_statement
    content {
      sid    = "DenyDeletingKMSKeys"
      effect = "Deny"
      actions = [
        "kms:ScheduleKeyDeletion",
        "kms:Delete*"
      ]
      resources = ["*"]
    }
  }

  #
  # Deny deleting Route53 Hosted Zones
  #

  dynamic "statement" {
    for_each = local.deny_deleting_route53_zones_statement
    content {
      sid    = "DenyDeletingRoute53Zones"
      effect = "Deny"
      actions = [
        "route53:DeleteHostedZone"
      ]
      resources = ["*"]
    }
  }

  #
  # Deny deleting VPC Flow logs, cloudwatch log groups, and cloudwatch log streams
  #

  dynamic "statement" {
    for_each = local.deny_deleting_cloudwatch_logs_statement
    content {
      sid    = "DenyDeletingCloudwatchLogs"
      effect = "Deny"
      actions = [
        "ec2:DeleteFlowLogs",
        "logs:DeleteLogGroup",
        "logs:DeleteLogStream"
      ]
      resources = ["*"]
    }
  }

  #
  # Deny deleting VPC Flow logs, cloudwatch log groups, and cloudwatch log streams
  #

  dynamic "statement" {
    for_each = local.deny_cloudtrail_manipulation_statement
    content {
      sid       = "DenyCloudTrailActions"
      effect    = "Deny"
      # Cannot deny cloudtrail:PutEventSelectors due to Epsagon role
      # actions   = ["cloudtrail:DeleteTrail", "cloudtrail:PutEventSelectors", "cloudtrail:StopLogging", "cloudtrail:UpdateTrail"]
      actions   = ["cloudtrail:DeleteTrail", "cloudtrail:StopLogging", "cloudtrail:UpdateTrail"]
      resources = ["*"]
    }
  }


  #
  # Deny root account
  #

  dynamic "statement" {
    for_each = local.deny_root_account_statement
    content {
      sid       = "DenyRootAccount"
      actions   = ["*"]
      resources = ["*"]
      effect    = "Deny"
      condition {
        test     = "StringLike"
        variable = "aws:PrincipalArn"
        values   = ["arn:aws:iam::*:root"]
      }
    }
  }

  #
  # Protect S3 Buckets
  #

  dynamic "statement" {
    for_each = local.protect_s3_buckets_statement
    content {
      sid    = "ProtectS3Buckets"
      effect = "Deny"
      actions = [
        "s3:DeleteBucket",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
      ]
      resources = var.protect_s3_bucket_resources
    }
  }


  #
  # Deny S3 Buckets Public Access (will not override an account-level setting)
  #

  dynamic "statement" {
    for_each = local.deny_s3_buckets_public_access_statement
    content {
      sid    = "DenyS3BucketsPublicAccess"
      effect = "Deny"
      actions = [
        "s3:PutBucketPublicAccessBlock",
        "s3:DeletePublicAccessBlock"
      ]
      resources = var.deny_s3_bucket_public_access_resources
    }
  }

  #
  # Protect IAM Roles
  #

  dynamic "statement" {
    for_each = local.protect_iam_roles_statement
    content {
      sid    = "ProtectIAMRoles"
      effect = "Deny"
      actions = [
        "iam:AttachRolePolicy",
        "iam:DeleteRole",
        "iam:DeleteRolePermissionsBoundary",
        "iam:DeleteRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PutRolePermissionsBoundary",
        "iam:PutRolePolicy",
        "iam:UpdateAssumeRolePolicy",
        "iam:UpdateRole",
        "iam:UpdateRoleDescription"
      ]
      resources = var.protect_iam_role_resources
    }
  }

  #
  # Restrict Regional Operations
  #

  dynamic "statement" {
    for_each = local.limit_regions_statement
    content {
      sid    = "LimitRegions"
      effect = "Deny"

      # These actions do not operate in a specific region, or only run in
      # a single region, so we don't want to try restricting them by region.
      # List of actions can be found in the following example:
      # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_general.html
      not_actions = [
        "a4b:*",
        "access-analyzer:*",
        "acm:*",
        "aws-marketplace-management:*",
        "aws-marketplace:*",
        "aws-portal:*",
        "budgets:*",
        "ce:*",
        "chime:*",
        "cloudfront:*",
        "config:*",
        "cur:*",
        "directconnect:*",
        "ec2:DescribeRegions",
        "ec2:DescribeTransitGateways",
        "ec2:DescribeVpnGateways",
        "fms:*",
        "globalaccelerator:*",
        "health:*",
        "iam:*",
        "importexport:*",
        "kms:*",
        "mobileanalytics:*",
        "networkmanager:*",
        "organizations:*",
        "pricing:*",
        "route53:*",
        "route53domains:*",
        "s3:GetAccountPublic*",
        "s3:ListAllMyBuckets",
        "s3:PutAccountPublic*",
        "shield:*",
        "sts:*",
        "support:*",
        "trustedadvisor:*",
        "waf-regional:*",
        "waf:*",
        "wafv2:*",
        "wellarchitected:*"
      ]

      resources = ["*"]

      condition {
        test     = "StringNotEquals"
        variable = "aws:RequestedRegion"
        values   = var.allowed_regions
      }
    }
  }

  #
  # Require S3 encryption
  #
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingServerSideEncryption.html

  dynamic "statement" {
    for_each = local.deny_incorrect_encryption_header_statement
    content {
      sid       = "DenyIncorrectEncryptionHeader"
      effect    = "Deny"
      actions   = ["s3:PutObject"]
      resources = ["*"]
      condition {
        test     = "StringNotEquals"
        variable = "s3:x-amz-server-side-encryption"
        values   = ["AES256", "aws:kms"]
      }
    }
  }

  dynamic "statement" {
    for_each = local.deny_unencrypted_object_uploads_statement
    content {
      sid       = "DenyUnEncryptedObjectUploads"
      effect    = "Deny"
      actions   = ["s3:PutObject"]
      resources = ["*"]
      condition {
        test     = "Null"
        variable = "s3:x-amz-server-side-encryption"
        values   = [true]
      }
    }
  }

  #
  # Require MFA Delete S3
  #

  dynamic "statement" {
    for_each = local.require_mfa_delete_statement
    content {
      sid       = "RequireMFAS3Delete"
      effect    = "Deny"
      actions   = ["s3:DeleteObject"]
      resources = ["arn:aws:s3:::*/*"]
      condition {
        test     = "BoolIfExists"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["false"]
      }
    }
  }

  #
  # Deny all non-ssl requests to s3 buckets
  #

  dynamic "statement" {
    for_each = local.deny_non_tls_s3_requests_statement
    content {
      sid       = "DenyNoTLSRequests"
      effect    = "Deny"
      actions   = ["s3:*"]
      resources = ["arn:aws:s3:::*/*"]
      condition {
        test     = "BoolIfExists"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
    }
  }

  #
  # Require MFA to perform an API action
  #

  dynamic "statement" {
    for_each = local.require_MFA_statement
    content {
      sid       = "DenyStopAndTerminateWhenMFAIsNotPresent"
      effect    = "Deny"
      actions   = ["ec2:StopInstances", "ec2:TerminateInstances"]
      resources = ["*"]
      condition {
        test     = "BoolIfExists"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["false"]
      }
    }
  }
}


#
# Deny all access
#

data "aws_iam_policy_document" "deny_all_access" {

  statement {
    sid       = "DenyAllAccess"
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "generated" {
  name        = "jit-scp-${var.target.name}-root-policy"
  description = "${var.target.name} SCP generated by Terraform"
  content     = var.deny_all ? data.aws_iam_policy_document.deny_all_access.json : data.aws_iam_policy_document.combined_policy_block.json

  tags = var.tags
}

resource "aws_organizations_policy_attachment" "generated" {
  policy_id = aws_organizations_policy.generated.id
  target_id = var.target.id
}
