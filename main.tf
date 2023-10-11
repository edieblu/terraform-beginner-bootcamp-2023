
terraform {
  # commenting it out TF cloud as we are using local state
  /* cloud {
    organization = "includeJS"

    workspaces {
      name = "terra-house-1"
    }
  } */
  required_providers {
    terratowns = {
      source  = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
}
provider "terratowns" {
  endpoint  = var.terratowns_endpoint
  user_uuid = var.user_uuid
  token     = var.terratowns_access_token
}

module "terrahouse_aws" {
  source              = "./modules/terrahouse_aws"
  user_uuid           = var.user_uuid
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version     = var.content_version
  assets_path         = var.assets_path
}
resource "terratowns_home" "home" {
  name            = "Cooking Galore"
  domain_name     = module.terrahouse_aws.cloudfront_url
  description     = "A place to share AMAZINGLY delicious recipes"
  town            = "missingo"
  content_version = 1
}
