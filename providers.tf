terraform {
  # commenting it out TF cloud as we are using local state
  /* cloud {
    organization = "includeJS"

    workspaces {
      name = "terra-house-1"
    }
  } */

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}
