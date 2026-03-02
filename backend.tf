terraform {
  backend "s3" {
    bucket         = "terraform-state-harshith"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
