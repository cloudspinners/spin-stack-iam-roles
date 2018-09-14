# encoding: utf-8

title 'Spin Stack Manager IAM role'

instance_identifier = attribute('instance_identifier', description: 'Unique identifier for the instance of the IAM stack')
stack_manager_users = attribute('stack_manager_users', description: 'IAM users defined for API access')
managed_stack_name = attribute('managed_stack_name', description: 'Name of the stack which should be manageable by these roles')

describe aws_iam_role_extended("spin_role-#{managed_stack_name}-manager") do
  it { should exist }
end

describe aws_iam_role_extended("spin_role-#{managed_stack_name}-manager").allowed_iam_user_names do
  it { should_not be_empty }
  it { should match_array(stack_manager_users) }
end
