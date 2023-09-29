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
