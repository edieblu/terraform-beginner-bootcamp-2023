
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
  description     = "5 Interesting Facts About Greece"
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
  name        = "Green Gem Gourmet"
  domain_name = module.home_two_hosting.domain_name
  description = <<EOT
Welcome to Green Gem Gourmet, your culinary compass for exploring a world of legumes and grains. From the versatile fava pea to a myriad of beans, peas, and grains, we're here to unlock the culinary potential of these nutritious gems.

Join us for a gastronomic journey that celebrates the richness of the plant-based world. Whether you're a seasoned cook or a budding chef, Green Gem Gourmet is your source for delicious recipes, cooking tips, and the latest in the world of legumes and grains.

Dive into the diverse and flavorful world of plant-based delights with us!
EOT

  town            = "cooker-cove"
  content_version = var.home_two.content_version
}
