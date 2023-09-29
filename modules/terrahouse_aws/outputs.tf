output "bucket_name" {
  value       = aws_s3_bucket.website_bucket.bucket
  description = "name of the bucket"
}
