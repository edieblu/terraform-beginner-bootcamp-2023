# Terraform Beginner Bootcamp 2023 - Week 1

⬅️ [Go Back](../README.md)

## Table of Contents

- [Root Module Structure](#root-module-structure)
- [TF Variables in TF Cloud](#tf-variables-in-tf-cloud)
- [Migrating from TF Cloud to TF CLI](#migrating-from-tf-cloud-to-tf-cli)
- [Loading TF Variables and the TFVars file](#loading-tf-variables-and-the-tfvars-file)

## Root Module Structure

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

```
  ________ PROJECT_ROOT ________
 |                              |
 ├── main.tf         - root module
 ├── variables.tf    - store the structure of input variables of the module
 ├── terraform.tfvars - store the variables of the module
 ├── outputs.tf      - store the output of the module
 ├── providers.tf    - store the required providers of the module
 ├── README.md
 └── LICENSE
```

💡 you can run the `tree` command to see the structure of the module

## TF Variables in TF Cloud

We can set two kinds of variables:

- Terraform Variables - those that live in the local terraform.tfvars file
- Environment Variables - those that live in workspace environment (e.g. AWS credentials)

Learn about TF variables precedence in TF cloud [here](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables#precedence).

## Migrating from TF Cloud to TF CLI

Comment out the `cloud` block, then delete the tf lock file and the `.terraform` directory. Lastly, run `terraform init` to initialize the module. Also make sure to run `terraform destroy` before finishing a session in GitPod.

## Loading TF Variables and the TFVars file

You can store variables inside a `.tfvars` file and then pass it to the module using the `-var-file` flag. You can also use the `-var` flag to pass variables to the module. The `terraform.tfvars` file is automatically loaded by Terraform.

```bash
user_uuid = "73abc949-c183-4c61-bda6-a724952ec87d"
```

Since `terraform.tfvars` won't be commited to GH, we can copy the `terraform.tfvars.example` and create a `terraform.tfvars` file with the same content on worskpace creation.

You can also use `auto.tfvars` to automatically load variables. This file is loaded first, then `terraform.tfvars` and then `*.auto.tfvars` in alphabetical order.

## TF Imports and Dealing with Configuration Drift

You can import existing resources into your TF state file using the `terraform import` [command](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import).

```bash
terraform import aws_s3_bucket.bucket bucket-name
```

You can also do it by using an `import` block inside the module.

```bash
import {
  to = aws_s3_bucket.bucket
  id = "bucket-name"
}
```

We needed to manually import these resources because we created them outside of TF Cloud (we deleted out state file when migrating from cloud back to local). This is called configuration drift. Note: not all resources support `import`.

## Terraform Refresh

Use `terraform apply -refresh-only -auto-approve` to refresh the state file without making any changes to the infrastructure.

## Modules

The modules should be stored in the `./modules` directory and sourced from the `main.tf` file.

### Module Sources

Documentation [here](https://developer.hashicorp.com/terraform/language/modules/sources).

Modules can be sourced from local paths, GitHub, Terraform Registry, etc. Make sure to pass in the required variables when using a module.

Example with local source:

```bash
module "s3_bucket" {
  source = "./modules/s3_bucket"
  user_uuid   = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Module Varibles

Note that even if the module has a `variables.tf` file, you still need to reference those variables in the root level `variables.tf` file.

```bash
variable "user_uuid" {
  type        = string
}

```

```bash
output "bucket_name" {
  value       = module.terrahouse_aws.bucket_name
  description = "name of the bucket"
}
```

## S3 Provider for Static Website Hosting

We'll be using the `aws_s3_bucket_website_configuration` resource to configure our bucket for static website hosting.

Documentation [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration)

### Uploading Files to S3

Documentation [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object.)

Make sure to add a `content_type` to the `aws_s3_object` resource ([docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object#content_type)).

### TerraForm Path

In Terraform there's a special path called `path.module` that points to the root directory of the module. This is useful when you want to reference files inside the module.

For example, if you want to reference a file called `index.html` inside the `./modules/s3_bucket` directory, you can do it like this:

```bash
source = "${path.module}/index.html"
```

Documentation [here](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

### TerraForm Console

You can use the `terraform console` command to test out expressions. For example:

```bash
path.root
```

### Etags

An etag is a hash of the object. It's used to determine if the object has changed. If the etag is different, then the object has changed. More docs [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/ETag) and in TF docs [here](https://developer.hashicorp.com/terraform/language/functions/filemd5).

```bash
resource "aws_s3_object" "index_file" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = var.index_html_filepath

  etag = filemd5(var.index_html_filepath)
}
```

### TF Built-in Functions

We'll be using a function called `fileexists` to check if a file exists. More docs [here](https://developer.hashicorp.com/terraform/language/functions/fileexists).

Don't forget to add the variables in the main `variables.tf`, as well as `terraform.tfvars` file and passing them into the `main.tf` file.

`jsonencode` is another useful function that converts a map to a json string. More docs [here](https://www.terraform.io/docs/language/functions/jsonencode.html). We'll be using it for creating our bucket policy.

## CDN with CloudFront

We'll be using the `aws_cloudfront_distribution` resource to create a CDN. More docs [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution).

And more on [OAC resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control), bucket policy resource [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy).

[Here](https://aws.amazon.com/blogs/networking-and-content-delivery/amazon-cloudfront-introduces-origin-access-control-oac/) for CloudFront bucket policy.

Note that you will need to replace the colon inside the bucket policy json with equal sign to comply with hcl syntax.

## TF Data Sources

Data sources are used to fetch information about existing resources. More docs [here](https://www.terraform.io/docs/language/data-sources/index.html).

```bash
data "aws_route53_zone" "terrahouse_zone" {
  name = "terrahouse.io."
}
```

## TF Locals

Locals are used to store values that are used multiple times in the module. More docs [here](https://www.terraform.io/docs/language/values/locals.html).

```bash
locals {
  bucket_name = "terrahouse-${var.user_uuid}"
}
```

## CloudFront Invalidations

To invalidate the CloudFront cache inside the AWS console use the `/*` wildcard to invalidate all. More docs [here](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Invalidation.html).

To prevent a change to our TF intrastructure everytime a file is changed, we'll be using resource metatag `lifecycle` to prevent the resource from being destroyed and recreated.

Specifically we'll be using a resource called `terraform_data`.
```bash

## TF Resource Lifecycle

More docs [here](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html).
The resource lifecyle is used to control the behavior of the resource during creation, update and deletion.

```bash
lifecycle {
  create_before_destroy = true
}
```

## TF Provisioners

### Local Exec Provisioner

The local-exec provisioner invokes a local executable after a resource is created. This invokes a process on the machine running Terraform, not on the resource (more [here](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)).

This is not a good practice, because configuration management should be done with a configuration management tool like Ansible, Chef, Puppet, etc.

### Remote Exec Provisioner

The remote-exec provisioner invokes a script on a remote resource after it is created. This can be used to run a configuration management tool, bootstrap into a cluster, etc. (more [here](https://www.terraform.io/docs/language/resources/provisioners/remote-exec.html)).

```bash
provisioner "remote-exec" {
  inline = [
    "echo 'Hello, World!' > index.html",
    "nohup python -m SimpleHTTPServer 8080 &"
  ]
}
```

## TF Heredoc

A heredoc is used to create a multiline string. More docs [here](https://www.terraform.io/docs/language/expressions/strings.html#heredoc-syntax).

```bash
provisioner "local-exec" {
  command = <<-EOT
    aws s3 sync ${path.module}/public s3://${aws_s3_bucket.website_bucket.bucket}/ --delete
  EOT
}
```
