provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-richiebzzzt"
    key    = "global/s3/terraform.state"
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "terraform-up-and-running-state-richiebzzzt"
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform-state.arn
  description = "the arn of the s3 bucket"
}

output "dynamo_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the dynamodb table"
}
