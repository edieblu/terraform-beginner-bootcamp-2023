
variable "user_uuid" {
  type = string
}
variable "content_version" {
  type = number
}
variable "terratowns_endpoint" {
  type = string
}

variable "terratowns_access_token" {
  type = string
}

variable "home_one" {
  type = object({
    content_version = number
    public_path     = string
  })
}

variable "home_two" {
  type = object({
    content_version = number
    public_path     = string
  })
}
