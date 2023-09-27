[[English](README.md)] [[한국어](README.ko.md)]

# MLOps for Financial Service Industry (FSI)
This is an example that shows how to configure Hybrid network and deploy SageMaker service in your isolated network. This blueprint create two VPCs. One is an isolated vpc to place the sagemaker notebook instance, and the other is a control tower vpc to simulate a corporate data center.
![aws-sm-fsi-hybrid-arch](../../images/aws-sm-fsi-hybrid-arch.png)

## Setup
### Download
Download this example on your workspace
```
git clone https://github.com/Young-ook/terraform-aws-sagemaker
cd terraform-aws-sagemaker/examples/fsi
```

Then change the current directory to **fsi** under your workspace. There is an exmaple that shows how to use terraform configurations to create and manage an SageMaker and utilities on your AWS account. Check out and apply it using terraform command. If you don't have the terraform tools in your environment, go to the main [page](https://github.com/Young-ook/terraform-aws-sagemaker) of this repository and follow the installation instructions before you move to the next step.

Run terraform:
```
terraform init
terraform apply -target module.vpc -target module.corp
```
Also you can use the *-var-file* option for customized paramters when you run the terraform plan/apply command.
```
terraform plan -var-file tc1.tfvars -target module.vpc -target module.corp
terraform apply -var-file tc1.tfvars -target module.vpc -target module.corp
```

Run terraform to create other resources:
```
terraform apply
```

## Clean up
Run terraform:
```
terraform destroy
```
**[DON'T FORGET]** You have to use the *-var-file* option when you run terraform destroy command to delete the aws resources created with extra variable files.
```
terraform destroy -var-file tc1.tfvars
```

# Additional Resources
## Compliance
- [Amazon SageMaker를 활용한 기계 학습에서 EFS 안의 민감 정보를 삭제하기 위한 서버리스 솔루션](https://aws.amazon.com/ko/blogs/tech/sensitive-ml-training-data-lifecycle-management-using-aws-lambda/)
