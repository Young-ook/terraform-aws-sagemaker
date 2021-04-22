# Amazon SageMaker
[Amazon SageMaker](https://aws.amazon.com/sagemaker/) helps data scientists and developers to prepare, build, train, and deploy high-quality machine learning (ML) models quickly by bringing together a broad set of capabilities purpose-built for ML.

* This module creates SageMaker studio and Jupyter notebook instances on AWS.
* This module utilises the default VPC of a target region if the user does not pass variables for vpc and subnets. In this case, this module does not create VPC endpoints that allows SageMaker to access AWS services over a private network.

## Examples
- [Amazon SageMaker Studio](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/studio)
- [Amazon SageMaker Notebook](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/notebook)
- [Securing Amazon SageMaker Studio connectivity using a private VPC](https://aws.amazon.com/ko/blogs/machine-learning/securing-amazon-sagemaker-studio-connectivity-using-a-private-vpc/)
- [Building secure Amazon SageMaker access URLs with AWS Service Catalog](https://aws.amazon.com/blogs/mt/building-secure-amazon-sagemaker-access-urls-with-aws-service-catalog/)

## Quickstart
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
$ terraform init
$ terraform apply
```

## Clean up
Before you destroy the SageMaker Studio, repeat the following steps for each user in the **User name** list on SageMaker control panel.
1. Choose the user.
2. On the User Details page, for each non-failed app in the Apps list, choose Delete app.
3. On the Delete app dialog, choose Yes, delete app, type delete in the confirmation field, and then choose Delete.
4. When the Status for all apps show as Deleted, choose Delete user.
For more informatiom, please refer to [this](https://docs.aws.amazon.com/sagemaker/latest/dg/gs-studio-delete-domain.html).
