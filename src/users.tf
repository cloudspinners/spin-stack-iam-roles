
resource "aws_iam_group" "spin_api_users" {
  name = "spin_api_users-${var.managed_stack_name}"
}

resource "aws_iam_group_membership" "spin_api_users" {
  name = "api_user-membership-${var.managed_stack_name}"
  users = [ "${var.stack_manager_users}" ]
  group = "${aws_iam_group.spin_api_users.name}"
}

resource "aws_iam_group_policy" "rights_to_assume_role" {
  name  = "rights_to_assume_role-${var.managed_stack_name}"
  group = "${aws_iam_group.spin_api_users.id}"

  policy = <<ENDOFPOLICY
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": [ "iam:GetUser", "iam:GetRole" ],
    "Resource": "*"
  }
}
ENDOFPOLICY
}
