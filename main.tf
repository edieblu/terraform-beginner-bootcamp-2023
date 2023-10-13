
terraform {
  cloud {
    organization = "includeJS"

    workspaces {
      name = "terra-house-1"
    }
  }
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

module "home_one_hosting" {
  source          = "./modules/terrahome_aws"
  user_uuid       = var.user_uuid
  public_path     = var.home_one.public_path
  content_version = var.home_one.content_version
}
resource "terratowns_home" "home_one" {
  name            = "Cooking Galore 1"
  domain_name     = module.home_one_hosting.domain_name
  description     = "A place to share AMAZINGLY delicious recipes"
  town            = "missingo"
  content_version = var.home_one.content_version
}

module "home_two_hosting" {
  source          = "./modules/terrahome_aws"
  user_uuid       = var.user_uuid
  public_path     = var.home_two.public_path
  content_version = var.home_two.content_version
}

resource "terratowns_home" "home_two" {
  name            = "Cooking Galore"
  domain_name     = module.home_two_hosting.domain_name
  description     = "Fava Peas: The Underrated Gems of the Pea Family"
  town            = "cooker-cove"
  content_version = var.home_two.content_version
}
