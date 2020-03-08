data "aws_region" "current" {}

locals {
  tags = merge({
    Name        = var.name
    Environment = var.environment
  }, var.extra_tags)
  bucket_name = "${var.environment}-${var.name}-${data.aws_region.current.name}"
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket = local.bucket_name
  acl    = "private"

  tags = local.tags

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

data "aws_iam_policy_document" "must_encrypt" {
  statement {
    sid    = "DenyIncorrectEncryptionHeader"
    effect = "Deny"

    actions = ["s3:PutObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = ["${aws_s3_bucket.secure_bucket.arn}/*"]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
  }

  statement {
    sid    = "DenyNoEncryption"
    effect = "Deny"

    actions = ["s3:PutObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = ["${aws_s3_bucket.secure_bucket.arn}/*"]
    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }
  }
}

resource "aws_s3_bucket_policy" "must_encrypt" {
  bucket = aws_s3_bucket.secure_bucket.id

  policy = data.aws_iam_policy_document.must_encrypt.json
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_kms_key" "bucket_key" {
  description         = "Key used to lock ${local.bucket_name}."
  enable_key_rotation = true

  tags = local.tags
}
