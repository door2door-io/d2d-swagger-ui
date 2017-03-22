# D2D Swagger UI
In this repository you can find the Terraform files used to manage the infrastructure of [apidocs.d2di.net](http://apidocs.d2di.net/).

We are using an original copy of Swagger UI, so we are not versioning the project at the moment.

In order to host this project at Amazon services, Terraform creates a S3 bucket, uploads a copy of Swagger UI in the bucket, and creates a Route53 address to point to it.

## What are the reasons of using Infrastructure as Code?

Here you can find the answers to that question as well as other questions you may have regarding the Terraform structure and new processes:

https://allyapp.atlassian.net/wiki/display/AP/03.+Infrastructure+as+Code

## Dependencies

- Terraform v0.8.7
- Terragrunt v0.11.0

### Installing terraform

```bash
$ brew install terraform
```

### Installing terragrunt

Terragrunt is a thin wrapper for Terraform that supports locking and enforces best practices for Terraform state.

- Locking
- Remote state management
- Managing multiple modules

Steps to install:

1. Download the version for your OS [here](https://github.com/gruntwork-io/terragrunt/releases)

2. Rename the file to `terragrunt`

3. Move the file to your desired directory, lets say `/dev/terragrunt/`

4. Add it to the `$PATH`
```
$ export PATH=$PATH:/dev/terragrunt
```

5. Now you can run the command `terragrunt` from your terminal.
   _Be aware that in order to run terraform/terragrunt commands, you'll need to run *./tf.sh <action>*_



## Creation of a subdomain

It's worth to point out that there's a file `terraform/environmnets/terraform.tfvars` that should be present at that
specific location to be used by `terragrunt`, so don't move it and don't modify it unless you know what you're doing.

### 1) Copy the files for the new subdomain


### 2) Modify the following files

- Modify `vars.tf` to provision precisely what you want in the particular environment.

- Set the `TF_VAR_BUCKET_NAME` and `TF_VAR_AWS_PROFILE` in the `tf.sh` file of an environment.

The naming convention for profile names is the following:

- `d2d`: IAM users that belong to the AWS where our production environments run.
- `d2d-play`: IAM users that belong to the new AWS account (aka playground).

http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html

### 3) Provision AWS resources with terraform!

Before running any execution, it's always recommended to run terraform plan and look at the expected creation of resources in
order to ensure that's the execution will create/destroy/modify resources you were expecting to.

```bash
$ ./tf.sh plan
# Verify the output in the console and then:
$ ./tf.sh apply
```
Then be patient and in a few minutes the execution will end.


## What's the reason to explicitly specify the profile?

Having to deal with more than 1 AWS account, in order to avoid an undesired execution against the account that's considered as default,
it's a good practice to explicitly specify the profile to be fully aware against what's the AWS account the execution of the plan is being run against.
If the profile is not specified, the execution could lead to a creation or removal of resources in an undesired account.
It's also hard to know by looking at the secret and access keys, to what account they refer to.
