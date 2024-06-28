terraform {
  backend "s3" {
    bucket = "anandhakumarg-bucket"
    key = "akr/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "Hello"
  }
}
