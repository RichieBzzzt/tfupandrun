provider "aws" {
    region = "us-east-2"
}

module "webserver_cluster" {
    source = "../../../modules/services/webserver-cluster"
}

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-richiebzzzt"
    key    = "stage/services/webserver-cluster/terraform.state"
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
