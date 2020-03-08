output "bucket" {
  value = aws_s3_bucket.secure_bucket.bucket
}

output "arn" {
  value = aws_s3_bucket.secure_bucket.arn
}

output "kms_key_arn" {
  value = aws_kms_key.bucket_key.arn
}
