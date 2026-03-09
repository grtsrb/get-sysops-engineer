variable "db_subnet_list" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))

  description = "List of private subnets for task1"
}
variable "public_subnet_list" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))

  description = "List of public subnets for task1"
}

variable "region" {
  type        = string
  description = "AWS region to deploy resources in"

  default = "eu-central-1"
}