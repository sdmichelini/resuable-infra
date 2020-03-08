provider "aws" {
  region = "us-east-1"
}

module "my-bucket" {
  source = "../../terraform-aws-secure-bucket"

  environment = "test"
  name        = "my-secure-bucket"
}
