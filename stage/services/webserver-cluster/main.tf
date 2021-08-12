provider "aws" {
    region = "us-east-2"
}

module "webserver_cluster" {
    source = "../../../modules/services/webserver-cluster"
    cluster_name = "webservers-stage"
    db_remote_state_bucket = "terraform-up-and-running-state-richiebzzzt"
    db_remote_state_key = "stage/datastores/mysql/terraform.state"

    instance_type = "t2.micro"
    min_size = 2
    max_size = 2
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

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 9 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
  scheduled_action_name = "scale_out_during_business_hours"
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  min_size = 2
  max_size = 10
  desired_capacity = 2
  recurrence = "0 17 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
  scheduled_action_name = "scale_in_at_night"
}

