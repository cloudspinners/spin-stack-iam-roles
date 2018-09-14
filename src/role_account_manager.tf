output "spin_account_manager_role_arn" {
  value = "${aws_iam_role.spin_account_manager.arn}"
}

# This role can be assumed by the specified user(s)
resource "aws_iam_role" "spin_account_manager" {
  name        = "spin_role-${var.managed_stack_name}-account"
  description = "Can create and destroy IAM resources for ${var.managed_stack_name} stacks"

  assume_role_policy = <<END_ASSUME_ROLE_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": [
          "${join("\",\"", formatlist("arn:aws:iam::%s:user/%s", data.aws_caller_identity.current_aws_account.account_id, var.stack_manager_users))}"
        ]
      }
    }
  ]
}
END_ASSUME_ROLE_POLICY
}

resource "aws_iam_role_policy_attachment" "attach_sysadmin_policy_to_account_manager_role" {
  role       = "${aws_iam_role.spin_account_manager.name}"
  policy_arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
}

resource "aws_iam_role_policy_attachment" "attach_iam_full_policy_to_account_manager_role" {
  role       = "${aws_iam_role.spin_account_manager.name}"
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "attach_parameter_policy_to_account_manager_role" {
  role       = "${aws_iam_role.spin_account_manager.name}"
  policy_arn = "${aws_iam_policy.rights_for_ssm_parameters.arn}"
}
