variable "managed_stack_name" {
  description = "The name of the stack definition these roles are used to manage."
}

variable "instance_identifier" {
  description = "A unique identifier for this instance of the stack."
}

variable "environment_name" {
  description = "An identifier to link a collection of stack instances that work together."
}

variable "region" {
  description = "The region into which to deploy the stack."
  default     = "eu-west-1"
}

variable "aws_profile" {
  description = "The profile in ~/.aws/credentials to use."
  default     = "default"
}

variable "assume_role_arn" {
  description = "The IAM role to assume."
  default     = ""
}

variable "stack_manager_users" {
  description = "Users who should be able to assume the role."
  type = "list"
  default = []
}
