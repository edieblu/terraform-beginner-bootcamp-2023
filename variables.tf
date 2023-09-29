
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

variable "user_uuid" {
  description = "The UUID of the user"
  type        = string

  validation {
    condition     = length(var.user_uuid) == 36
    error_message = "value must be a valid UUID"
  }
}
