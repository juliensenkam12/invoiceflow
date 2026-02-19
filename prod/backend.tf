terraform {
  backend "s3" {
    bucket         = "invoiceflow-tf-state-prod"
    key            = "prod/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "invoiceflow-tf-lock"
    encrypt        = true
  }
}
