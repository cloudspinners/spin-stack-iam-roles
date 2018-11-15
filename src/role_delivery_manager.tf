
output "spin_delivery_manager_role_arn" {
  value = "${aws_iam_role.spin_delivery_manager.arn}"
}

# This role can be assumed by the specified user(s)
resource "aws_iam_role" "spin_delivery_manager" {
  name        = "spin_role-${var.managed_stack_name}-delivery"
  description = "Can create and destroy delivery resources for ${var.managed_stack_name}"

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

resource "aws_iam_policy" "rights_for_delivery_resources" {
  name        = "delivery-resource-rights-for-${var.managed_stack_name}"
  description = "Can manage pipelines for ${var.managed_stack_name}"

  policy = <<END_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "codepipeline:*",
        "codebuild:*",
        "s3:*",
        "ssm:DescribeParameters",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath",
        "ssm:GetParameterHistory",
        "ssm:PutParameter",
        "ssm:DeleteParameter",
        "ssm:DeleteParameters",
        "ssm:AddTagsToResource"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
END_POLICY
}

resource "aws_iam_role_policy_attachment" "attach_iam_full_policy_to_delivery_manager_role" {
  role       = "${aws_iam_role.spin_delivery_manager.name}"
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "attach_delivery_policy_to_delivery_manager_role" {
  role       = "${aws_iam_role.spin_delivery_manager.name}"
  policy_arn = "${aws_iam_policy.rights_for_delivery_resources.arn}"
}
