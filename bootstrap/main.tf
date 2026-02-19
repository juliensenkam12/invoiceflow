provider "aws" {}

resource "aws_s3_bucket" "tf_state" {
  bucket = "invoiceflow-tf-state-prod"
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "invoiceflow-tf-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
