terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1" # Frankfurt 
  profile = "get-sysops-case-study-task2"
}

terraform {
  backend "s3" {
    bucket = "get-sysops-case-study-remote-state"
    key    = "task2/terraform.tfstate"
    region = "eu-central-1"
    profile = "get-sysops-case-study-task2"
    use_lockfile = true
  }
}
