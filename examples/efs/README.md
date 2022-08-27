# Amazon Elastic File System (EFS)

## Download example
Download this example on your workspace
```sh
git clone https://github.com/Young-ook/terraform-aws-sagemaker
cd terraform-aws-sagemaker/examples/efs
```

## Setup
[This](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/efs/main.tf) is an example of terraform configuration file to create an Amazon EFS. Check out and apply it using terraform command.

If you don't have the terraform tool in your environment, go to the main [page](https://github.com/Young-ook/terraform-aws-sagemaker) of this repository and follow the installation instructions.

Run terraform:
```
terraform init
```

At the first, you must decided to build a custom vpc using terraform module or to retrieve and use a default vpc on your AWS account. In this example, you can configure where to your sagemaker notebook instance running on using `use_default_vpc` variable.

```
terraform plan -target module.vpc
terraform apply -target module.vpc
```

Also you can use the `-var-file` option for customized paramters when you run the terraform plan/apply command.
```
terraform plan -var-file tc1.tfvars -target module.vpc
terraform apply -var-file tc1.tfvars -target module.vpc
```

After vpc creation or default vpc discovery operation is complete, run terraform again to create the sagemaker notebook instance:
```
terraform plan
terraform apply
```

Don't forget to use the `-var-file` option when re-running the terraform apply command to create another resource if you configured additional variables in the previous step.
```
terraform plan -var-file tc1.tfvars
terraform apply -var-file tc1.tfvars
```

## Clean up
Run terraform:
```
$ terraform destroy
```
Don't forget you have to use the `-var-file` option when you run terraform destroy command to delete the aws resources created with extra variable files.
```
$ terraform destroy -var-file tc1.tfvars
```

# Additional resources
* [Mount an EFS file system to an Amazon SageMaker notebook](https://aws.amazon.com/blogs/machine-learning/mount-an-efs-file-system-to-an-amazon-sagemaker-notebook-with-lifecycle-configurations/)
