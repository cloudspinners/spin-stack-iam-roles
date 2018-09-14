
Cloudspin stack to create IAM roles and related stuff for dealing with cloudspin stacks. See https://cloudspin.io.

# Bootstrapping instructions

## (1) Create a privileged IAM user for bootstrapping

Create a user (for example, **spin_bootstrap**) which has the privileges to manage the IAM roles and policies. This will normally be a one-off user; once the stack has been applied to an AWS account, anyone working with the infrastructure, including making IAM changes, should be able to do it using an unprivileged user, and then assume roles with the relevant privileges.

Create the user, then add it to the Power Users managed group, and attach the IAMFullAccess policy to the user. (TODO: we can probably limit this much further, may not need much more than a subset of IAM permissions). Generate an API access key for the user. The user should not need a console password.


### (1.1) Add the bootstrap access key to your credentials file

Put the access credentials for the bootstrap user into your [AWS credentials file](https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html). Give it a profile name, such as `bootstrap_cloudspin`.

File: `~/.aws/credentials`:
```ini
[spin_bootstrap]
aws_access_key_id = AKIA........
aws_secret_access_key = xxxxxxxxxxx
```

## (2) Create an unprivileged user

Create a user (for example, **spin_user**) with no privileges, but which has an API access key, but no console access.


### (2.1) Add the unprivileged user to the AWS credentials file


File: `~/.aws/credentials`:
```ini
[spin_YOURNAME]
aws_access_key_id = AKIA........
aws_secret_access_key = xxxxxxxxxxx
```


## (3) Add the bootstrap user to the stack-instance-local.yaml file

This should be temporary, only done in order to apply the iam-roles in the first place.

File: `./stack-instance-local.yaml`
```yaml
resources:
  aws_profile: spin_bootstrap
  assume_role_profile:
  assume_role_arn:
parameters:
  managed_stack_name: YOUR_STACK_HERE
  stack_manager_users:
    - spin_YOURNAME
```

You might also/instead define the `stack_manager_users` list in an `./environments/stack-instance-ENVIRONMENT.yaml` file, depending on how you plan to manage roles and environments. (At the moment, this stack doesn't do anything clever to support giving different rights to users rights in different environments.)


## (4) Apply the iam-roles stack

Once you have this all in place, you can plan and provision the stack. Do this by applying the stack, setting environment variables to use the bootstrap credentials.

```bash
rake plan
rake up
```

## (5) Replace the bootstrap configuration with the unprivileged user configuration

In your `~/.aws/credentials`:

```ini
[spin_YOURNAME]
aws_access_key_id = AKIA........
aws_secret_access_key = xxxxxxxxxxx
```

Add an assume-role profile to your `~/.aws/config`:

```ini
[profile assume-IAM_ROLE-YOUR_STACK]
role_arn = arn:aws:iam::YOUR_AWS_ACCOUNT_ID:role/spin_role-YOUR_STACK-ROLE
source_profile = IAM_USER_PROFILE_FROM_YOUR_CREDENTIALS_FILE
```

For example:

```ini
[profile assume-spin_network-manager]
role_arn = arn:aws:iam::000000000000:role/spin_role-spin_network-manager
source_profile = spin_YOURNAME
```

Then in your stack configuration:

File: `./stack-instance-local.yaml`
```yaml
resources:
  aws_profile: spin_YOURNAME
  assume_role_profile: assume-YOUR_STACK_HERE-manager
  assume_role_arn: arn:aws:iam::000000000000:role/spin_role-spin_network-manager
parameters:
  managed_stack_name: YOUR_STACK
  stack_manager_users:
    - spin_YOURNAME
```

## (6) Test it

(Note: this currently requires doing the previous configuration step for role *spin_role-spin_network-manager* account, as it requires some extra permissions to run these tests)

```bash
rake test
```
