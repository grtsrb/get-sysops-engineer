variable "region" {
  type        = string
  description = "AWS region to deploy resources in"

  default = "eu-central-1"
}

variable "my_ip_address" {
  type        = string
  description = "My IP address"
}

variable "ssh_public_key" {
  type        = string
  description = "Public key for ssh access"
}