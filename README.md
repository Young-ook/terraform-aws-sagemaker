# Amazon SageMaker
[Amazon SageMaker](https://aws.amazon.com/sagemaker/) helps data scientists and developers to prepare, build, train, and deploy high-quality machine learning (ML) models quickly by bringing together a broad set of capabilities purpose-built for ML.
+ This module creates SageMaker studio and Jupyter notebook instances on AWS.
+ This module utilises the default VPC of a target region if the user does not pass variables for vpc and subnets. In this case, this module does not create VPC endpoints that allows SageMaker to access AWS services over a private network.

## Examples
- [Amazon EFS](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/efs)
- [Amazon S3](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/s3)
- [Amazon VPC](https://github.com/Young-ook/terraform-aws-vpc/blob/main/examples/vpc)
- [Amazon SageMaker Studio](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/studio)
- [Amazon SageMaker Notebook](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/notebook)
- [Securing Amazon SageMaker Studio connectivity using a private VPC](https://aws.amazon.com/ko/blogs/machine-learning/securing-amazon-sagemaker-studio-connectivity-using-a-private-vpc/)
- [Building secure Amazon SageMaker access URLs with AWS Service Catalog](https://aws.amazon.com/blogs/mt/building-secure-amazon-sagemaker-access-urls-with-aws-service-catalog/)
- [Secure multi-account model deployment with Amazon SageMaker: Part 1](https://aws.amazon.com/blogs/machine-learning/part-1-secure-multi-account-model-deployment-with-amazon-sagemaker/)
- [Secure multi-account model deployment with Amazon SageMaker: Part 2](https://aws.amazon.com/blogs/machine-learning/part-2-secure-multi-account-model-deployment-with-amazon-sagemaker/)
- [Hybrid-network Architecture with AWS Transit Gateway](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/tgw)
- [Huggingface with Amazon SageMaker](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/huggingface)

## Getting started
### AWS CLI
Follow the official guide to install and configure profiles.
- [AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [AWS CLI Configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)

After the installation is complete, you can check the aws cli version:
```
aws --version
aws-cli/2.5.8 Python/3.9.11 Darwin/21.4.0 exe/x86_64 prompt/off
```

### Terraform
Terraform is an open-source infrastructure as code software tool that enables you to safely and predictably create, change, and improve infrastructure.

#### Install
This is the official guide for terraform binary installation. Please visit this [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) website and follow the instructions.

Or, you can manually get a specific version of terraform binary from the websiate. Move to the [Downloads](https://www.terraform.io/downloads.html) page and look for the appropriate package for your system. Download the selected zip archive package. Unzip and install terraform by navigating to a directory included in your system's `PATH`.

Or, you can use [tfenv](https://github.com/tfutils/tfenv) utility. It is very useful and easy solution to install and switch the multiple versions of terraform-cli.

First, install tfenv using brew.
```
brew install tfenv
```
Then, you can use tfenv in your workspace like below.
```
tfenv install <version>
tfenv use <version>
```
Also this tool is helpful to upgrade terraform v0.12. It is a major release focused on configuration language improvements and thus includes some changes that you'll need to consider when upgrading. But the version 0.11 and 0.12 are very different. So if some codes are written in older version and others are in 0.12 it would be great for us to have nice tool to support quick switching of version.
```
tfenv list
tfenv install latest
tfenv use <version>
```

### Setup
```hcl
module "sagemaker" {
  source  = "Young-ook/sagemaker/aws"
  name    = "sagemaker"
  tags    = { env = "test" }
}
```
Run terraform:
```
terraform init
terraform apply
```

# Known Issues
## Not supported instance in the availability zone
You may receive a 'Failed' error message when creating a SageMaker notebook instance. This happens for a number of reasons, so you should check the detailed messages about the state of your notebook instance.
```
Error: error waiting for sagemaker notebook instance (sagemaker-lhdhu-default) to create: unexpected state 'Failed',
wanted target 'InService'. last error: %!s(<nil>)
```

Open the AWS Management Console and go to the SageMaker service page. Then select the *Notebook Instances* menu in the left navigation bar. This will show the instances that failed to create. Select the instance and check the details in the pop-up message. If you see a message like the below, you should try creating the notebook instance again by changing the Availability Zone or Instance Type values.
```
The Notebook Instance type 'ml.t3.large' is not available in the availability zone 'ap-northeast-2b'. We apologize for the inconvenience.
Please try again using subnet in a different availability zone, or try a different instance type.
```

Run terraform to delete a randomly selected subnet index and notebook instance:
```
terraform destroy -target module.sagemaker.random_integer.subnet -target module.sagemaker.aws_sagemaker_notebook_instance.ni
```
Then retry terraform apply

```
terraform apply
```
