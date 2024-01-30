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
- [금융 워크로드를 위한 카카오페이의 AWS 기반 MLOps 플랫폼 구축 사례](https://youtu.be/BbsmOYasu1A?si=c92-xk5V5ms5OqzJ)
- [if kakao 2022: ML모델 학습 파이프라인 설계](https://tech.kakaopay.com/post/ifkakao2022-mlops-model-training-pipeline/)
- [Machine learning best practices in financial services](https://aws.amazon.com/blogs/machine-learning/machine-learning-best-practices-in-financial-services/)
- [Secure multi-account model deployment with Amazon SageMaker: Part 1](https://aws.amazon.com/blogs/machine-learning/part-1-secure-multi-account-model-deployment-with-amazon-sagemaker/)
- [Secure multi-account model deployment with Amazon SageMaker: Part 2](https://aws.amazon.com/blogs/machine-learning/part-2-secure-multi-account-model-deployment-with-amazon-sagemaker/)
- [Building secure machine learning environments with Amazon SageMaker](https://aws.amazon.com/ko/blogs/machine-learning/building-secure-machine-learning-environments-with-amazon-sagemaker/)
- [Building secure Amazon SageMaker access URLs with AWS Service Catalog](https://aws.amazon.com/blogs/mt/building-secure-amazon-sagemaker-access-urls-with-aws-service-catalog/)
- [Deploy Amazon SageMaker into a secure VPC](https://github.com/Young-ook/terraform-aws-sagemaker/tree/main/examples/fsi)
- [Securing Amazon SageMaker Studio connectivity using a private VPC](https://aws.amazon.com/ko/blogs/machine-learning/securing-amazon-sagemaker-studio-connectivity-using-a-private-vpc/)

## Hybrid Connectivity
- [Access an Amazon SageMaker Studio notebook from a corporate network](https://aws.amazon.com/blogs/machine-learning/access-an-amazon-sagemaker-studio-notebook-from-a-corporate-network/)
- [From on premises to AWS: Hybrid-cloud architecture for network file shares](https://aws.amazon.com/ko/blogs/storage/from-on-premises-to-aws-hybrid-cloud-architecture-for-network-file-shares/)
- [Securing Amazon SageMaker Studio connectivity using a private VPC](https://aws.amazon.com/ko/blogs/machine-learning/securing-amazon-sagemaker-studio-connectivity-using-a-private-vpc/)
