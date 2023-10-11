output "bucket_name" {
  value       = module.terrahouse_aws.bucket_name
  description = "name of the bucket"
}

output "S3_bucket_endpoint" {
  value       = module.terrahouse_aws.bucket_endpoint
  description = "S3 static website hosting endpoint"
}

output "cloudfront_url" {
  value       = module.terrahouse_aws.cloudfront_url
  description = "CloudFront distribution url"
}
