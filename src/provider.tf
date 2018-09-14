provider "aws" {
  region  = "${var.region}"
  profile = "${var.aws_profile}"

  assume_role {
    role_arn     = "${var.assume_role_arn}"
    session_name = "session-${var.instance_identifier}"
  }
}

data "aws_caller_identity" "current_aws_account" {}
