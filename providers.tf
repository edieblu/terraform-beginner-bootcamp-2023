terraform {
  # commenting it out TF cloud as we are using local state
  /* cloud {
    organization = "includeJS"

    workspaces {
      name = "terra-house-1"
    }
  } */

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

provider "random" {
  # Configuration options
}
