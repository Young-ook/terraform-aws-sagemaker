# SageMaker Studio
Amazon SageMaker Studio is the first fully integrated development environment (IDE) for machine learning (ML). With a single click, data scientists and developers can quickly spin up Amazon SageMaker Studio Notebooks for exploring datasets and building models. With the new ability to launch Amazon SageMaker Studio in your Amazon Virtual Private Cloud (Amazon VPC), you can control the data flow from your Amazon SageMaker Studio notebooks. This allows you to restrict internet access, monitor and inspect traffic using standard AWS networking and security capabilities, and connect to other AWS resources through AWS PrivateLink or VPC endpoints.

## Setup
[This](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/studio/main.tf) is the example of terraform configuration file to create SageMaker studio on AWS. Check out and apply it using terraform command.

Run terraform:
```
$ terraform init
$ terraform apply
```
Also you can use the `-var-file` option for customized paramters when you run the terraform plan/apply command.
```
$ terraform plan -var-file default.tfvars
$ terraform apply -var-file default.tfvars
```

## Clean up
Before you destroy the SageMaker Studio, make sure that users in the SageMaker are deleted. Repeat the following steps for each user in the **User name** list on SageMaker control panel.
1. Choose the user.
2. On the User Details page, for each non-failed app in the Apps list, choose Delete app.
3. On the Delete app dialog, choose Yes, delete app, type delete in the confirmation field, and then choose Delete.
4. When the Status for all apps show as Deleted, choose Delete user.
For more informatiom, please refer to [this](https://docs.aws.amazon.com/sagemaker/latest/dg/gs-studio-delete-domain.html).

Run terraform:
```
$ terraform destroy
```
Don't forget you have to use the `-var-file` option when you run terraform destroy command to delete the aws resources created with extra variable files.
```
$ terraform destroy -var-file default.tfvars
```
