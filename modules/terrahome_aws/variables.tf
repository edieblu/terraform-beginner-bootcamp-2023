
#variable "AWS_ACCESS_KEY_ID" {
#  description = ""
#  type        = string
#  default     = ""
#}

#variable "AWS_SECRET_ACCESS_KEY" {
#  description = ""
#  type        = string
#  default     = ""
#}

variable "public_path" {
  description = "The file path to the public directory"
  type        = string
}

variable "user_uuid" {
  description = "The UUID of the user"
  type        = string

  validation {
    condition     = length(var.user_uuid) == 36
    error_message = "value must be a valid UUID"
  }
}
variable "content_version" {
  description = "The version of the content"
  type        = number

  validation {
    condition     = var.content_version > 0
    error_message = "content_version must be a positive integer"
  }
}
