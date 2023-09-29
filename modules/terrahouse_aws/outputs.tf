output "bucket_name" {
  value       = aws_s3_bucket.website_bucket.bucket
  description = "name of the bucket"
}

output "bucket_endpoint" {
  value       = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
  description = "URL of the bucket"
}
