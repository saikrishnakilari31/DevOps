terraform {
  required_version = ">= 1.4.6"
  backend "s3" {
    bucket         = "my-terraform-state-<env>" # update
    key            = "pi-credit/part1/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tf-state-locks"
    encrypt        = true
  }
}
