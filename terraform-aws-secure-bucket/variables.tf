variable "environment" {
  description = "Name of the environment that this bucket will reside in."
  default     = ""
}

variable "name" {
  description = "Name of the bucket itself. Will be used to compute the final bucket name."
}

variable "extra_tags" {
  type        = map(string)
  description = "Extra Tags to Apply to the Resources Created by this Module."
  default     = {}
}
