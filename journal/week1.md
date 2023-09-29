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
