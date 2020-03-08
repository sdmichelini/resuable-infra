# Secure S3 Bucket

Creates a secure S3 locked-down w/ some sensible default security policies.

## Default Policies

### Encryption

Bucket creation includes it's own AWS KMS key. All objects uploaded to the bucket use that key and there is an explicit deny on upload of objects
not encrypted with that KMS key.

### Private

The S3 bucket is private and not exposed to the internet.
