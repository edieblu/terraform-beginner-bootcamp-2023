terraform {

  cloud {
    organization = "includeJS"

    workspaces {
      name = "terra-house-1"
    }
  }
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }

}
provider "aws" {
  region = "eu-west-2"
}

variable "AWS_ACCESS_KEY_ID" {
  description = ""
  type        = string
  default     = ""
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = ""
  type        = string
  default     = ""
}

provider "random" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  length  = 32
  special = false
  lower   = true
  upper   = false
}

resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result


}


output "random_bucket_name" {
  value = random_string.bucket_name.result
}
