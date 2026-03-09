terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "eu-central-1" # Frankfurt 
  profile = "get-sysops-case-study-task1"

  default_tags {
    tags = {
      Author  = "Nikola Vlaskalin"
      Region  = "eu-central-1"
      Project = "GET Case Study"
      Task    = "Task 1"
    }
  }
}

terraform {
  backend "s3" {
    bucket       = "get-sysops-case-study-remote-state"
    key          = "task1/computing/terraform.tfstate"
    region       = "eu-central-1"
    profile      = "get-sysops-case-study-task1"
    use_lockfile = true
  }
}