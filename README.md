# Amazon SageMaker
[Amazon SageMaker](https://aws.amazon.com/sagemaker/) helps data scientists and developers to prepare, build, train, and deploy high-quality machine learning (ML) models quickly by bringing together a broad set of capabilities purpose-built for ML.
+ This module creates SageMaker studio and Jupyter notebook instances on AWS.
+ This module utilises the default VPC of a target region if the user does not pass variables for vpc and subnets. In this case, this module does not create VPC endpoints that allows SageMaker to access AWS services over a private network.

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

# Known Issues
## Not supported instance in the availability zone
You may receive a 'Failed' error message when creating a SageMaker notebook instance. This happens for a number of reasons, so you should check the detailed messages about the state of your notebook instance.
```
Error: error waiting for sagemaker notebook instance (sagemaker-lhdhu-default) to create: unexpected state 'Failed', wanted target 'InService'. last error: %!s(<nil>)
```

Open the AWS Management Console and go to the SageMaker service page. Then select the *Notebook Instances* menu in the left navigation bar. This will show the instances that failed to create. Select the instance and check the details in the pop-up message. If you see a message like the below, you should try creating the notebook instance again by changing the Availability Zone or Instance Type values.
```
The Notebook Instance type 'ml.t3.large' is not available in the availability zone 'ap-northeast-2b'. We apologize for the inconvenience. Please try again using subnet in a different availability zone, or try a different instance type.
```
