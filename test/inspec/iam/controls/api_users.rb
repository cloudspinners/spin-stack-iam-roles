# encoding: utf-8

title 'IAM users created to run cloudspin'

stack_manager_users = attribute('stack_manager_users', description: 'IAM users defined for API access')

stack_manager_users.each { |username|
  describe aws_iam_user(username: username) do
    it { should exist }
    it { should_not have_console_password }
    it 'has access keys' do
      expect(described_class.access_keys).to_not be_empty
    end
  end
}

