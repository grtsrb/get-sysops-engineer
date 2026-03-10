variable "region" {
  type        = string
  description = "AWS region to deploy resources in"

  default = "eu-central-1"
}

variable "test" {
  description = "Test variable"
}