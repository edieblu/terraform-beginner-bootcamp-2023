## Terrahome AWS

```tf
module "home_one" {
  source          = "./modules/terrahome_aws"
  user_uuid       = var.user_uuid
  public_path     = var.home_one_public_path
  content_version = var.content_version
}
```

The public directory expects a directory structure like this:

```bash
index.html
error.html
assets/
```
