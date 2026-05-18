provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket = "725740881803-tf-resources-gha"
    key    = "github-actions/terraform.tfstate"
    region = "eu-north-1"
    encrypt = true
    dynamodb_table = "725740881803-tf-resources-gha-lock"
  }
}