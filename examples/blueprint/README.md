[[English](README.md)] [[한국어](README.ko.md)]

# SageMaker Blueprint
Amazon SageMaker Studio is the first fully integrated development environment (IDE) for machine learning (ML). With a single click, data scientists and developers can quickly spin up Amazon SageMaker Studio Notebooks for exploring datasets and building models. With the new ability to launch Amazon SageMaker Studio in your Amazon Virtual Private Cloud (Amazon VPC), you can control the data flow from your Amazon SageMaker Studio notebooks. This allows you to restrict internet access, monitor and inspect traffic using standard AWS networking and security capabilities, and connect to other AWS resources through AWS PrivateLink or VPC endpoints.

This is SageMaker Blueprint example helps you compose complete SageMaker clusters that are fully bootstrapped with the operational software that is needed to deploy and operate ML workloads. With this SageMaker Blueprint example, you describe the configuration for the desired state of your ML developemnt environment, such as the control plane, worker nodes, private secure network as an Infrastructure as Code (IaC) template/blueprint. Once a blueprint is configured, you can use it to stamp out consistent environments across multiple AWS accounts and Regions using your automation workflow tool, such as Jenkins, CodePipeline. SageMaker Blueprint also helps you implement relevant security controls needed to operate workloads from multiple teams in the same cluster.

## Setup
### Download
Download this example on your workspace
```
git clone https://github.com/Young-ook/terraform-aws-sagemaker
cd terraform-aws-sagemaker/examples/blueprint
```

Then you are in **blueprint** directory under your current workspace. There is an exmaple that shows how to use terraform configurations to create and manage an SageMaker and utilities on your AWS account. Check out and apply it using terraform command. If you don't have the terraform tools in your environment, go to the main [page](https://github.com/Young-ook/terraform-aws-sagemaker) of this repository and follow the installation instructions before you move to the next step.

Run terraform:
```
terraform init
terraform apply
```
Also you can use the *-var-file* option for customized paramters when you run the terraform plan/apply command.
```
terraform plan -var-file fixture.tc1.tfvars
terraform apply -var-file fixture.tc1.tfvars
```

## Storage
Amazon S3 (Simple Storage Service) is an object storage service that offers industry-leading scalability, data availability, security, and performance. In this blueprint, you use an s3 bucket for machine learning datas. And you can utilize s3 lifecycle configuration to enable intelligent-tiering that switches storage classes automatically based on object access pattern. This is important because it is easist way to reduce the storage cost of large volume datas for mahcine learning workloads.

![aws-s3-lc-int-tiering](../../images/aws-s3-lc-int-tiering.png)

## File System
Amazon FSx for Lustre is a fully managed service makes it easier for you to use Lustre for workloads where storage speed matters. FSx for Lustre eliminates the traditional complexity of setting up and managing Lustre file systems, enabling you to spin up and run a battle-tested high-performance file system in minutes. It also provides multiple deployment options so you can optimize cost for your needs. For your information, please refer to [this description about FSx for Lustre](https://github.com/Young-ook/terraform-aws-sagemaker/tree/main/modules/lustre).

You might want to mount the FSx for Lustre file system if you want to allow your ML training job to access your datas faster than reading datas from S3 object storage directly. This [guide document](https://docs.aws.amazon.com/fsx/latest/LustreGuide/mount-fs-auto-mount-onreboot.html) describes how to automatically mount the FSx for Lustre file system at boot time.

## Applications
- [Huggingface](./apps/README.md#huggingface-transformers-with-amazon-sagemaker)
- [Personalize](./apps/README.md#amazon-personalize)
- [JumpStart](./apps/README.md#jumpstart)
- [Generative AI on AWS](./apps/README.md#generative-ai-on-aws)

## Clean up
Before you destroy the SageMaker Studio, make sure that users in the SageMaker are deleted. Repeat the following steps for each user in the **User name** list on SageMaker control panel.
1. Choose the user.
2. On the User Details page, for each non-failed app in the Apps list, choose Delete app.
3. On the Delete app dialog, choose Yes, delete app, type delete in the confirmation field, and then choose Delete.
4. When the Status for all apps show as Deleted, choose Delete user.

If you run SageMaker Studio, don't forget you have to delete users (profiles) before you destroy the SageMaker Studio. For more the details, please refer to [this](https://docs.aws.amazon.com/sagemaker/latest/dg/gs-studio-delete-domain.html).

Run terraform:
```
terraform destroy
```
**[DON'T FORGET]** You have to use the *-var-file* option when you run terraform destroy command to delete the aws resources created with extra variable files.
```
terraform destroy -var-file fixture.tc1.tfvars
```

# Additional Resources
## Amazon EFS
- [Mount an EFS file system to an Amazon SageMaker notebook](https://aws.amazon.com/blogs/machine-learning/mount-an-efs-file-system-to-an-amazon-sagemaker-notebook-with-lifecycle-configurations/)

## Amazon FSx for Lustre
- [Speed up training on Amazon SageMaker using Amazon FSx for Lustre and Amazon EFS file systems](https://aws.amazon.com/blogs/machine-learning/speed-up-training-on-amazon-sagemaker-using-amazon-efs-or-amazon-fsx-for-lustre-file-systems/)

## Amazon SageMaker
- [Dive deep into Amazon SageMaker Studio Notebooks architecture](https://aws.amazon.com/blogs/machine-learning/dive-deep-into-amazon-sagemaker-studio-notebook-architecture/)
- [Dynamic A/B testing for machine learning models with Amazon SageMaker MLOps projects](https://aws.amazon.com/blogs/machine-learning/dynamic-a-b-testing-for-machine-learning-models-with-amazon-sagemaker-mlops-projects/)
- [Huggingface with Amazon SageMaker](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/huggingface)
- [Amazon SageMaker Feature Store Workshop](https://github.com/aws-samples/amazon-sagemaker-feature-store-end-to-end-workshop)
- [Build a powerful question answering bot with Amazon SageMaker, Amazon OpenSearch Service, Streamlit, and LangChain](https://aws.amazon.com/blogs/machine-learning/build-a-powerful-question-answering-bot-with-amazon-sagemaker-amazon-opensearch-service-streamlit-and-langchain/)
- [Amazon SageMaker for Tableau](https://aws.amazon.com/quickstart/architecture/amazon-sagemaker-for-tableau/)
- [A quick guide to using Spot instances with Amazon SageMaker](https://towardsdatascience.com/a-quick-guide-to-using-spot-instances-with-amazon-sagemaker-b9cfb3a44a68)
- [Save costs by automatically shutting down idle resources within Amazon SageMaker Studio](https://aws.amazon.com/blogs/machine-learning/save-costs-by-automatically-shutting-down-idle-resources-within-amazon-sagemaker-studio/)
- [Take advantage of advanced deployment strategies using Amazon SageMaker deployment guardrails](https://aws.amazon.com/ko/blogs/machine-learning/take-advantage-of-advanced-deployment-strategies-using-amazon-sagemaker-deployment-guardrails/)
- [Host multiple TensorFlow computer vision models using Amazon SageMaker multi-model endpoints](https://aws.amazon.com/blogs/machine-learning/host-multiple-tensorflow-computer-vision-models-using-amazon-sagemaker-multi-model-endpoints/)
- [Save on inference costs by using Amazon SageMaker multi-model endpoints](https://aws.amazon.com/blogs/machine-learning/save-on-inference-costs-by-using-amazon-sagemaker-multi-model-endpoints/)
- [Understanding the key capabilities of Amazon SageMaker Feature Store](https://aws.amazon.com/blogs/machine-learning/understanding-the-key-capabilities-of-amazon-sagemaker-feature-store/)

## AWS Clean Rooms
- [Guidance for Predictive Segmentation using Third-Party Data with AWS Clean Rooms](https://aws.amazon.com/solutions/guidance/predictive-segmentation-using-third-party-data-with-aws-clean-rooms/)

## AWS Neuron
- [AWS Neuron](https://awsdocs-neuron.readthedocs-hosted.com/en/latest/index.html)

## AWS SDK for Pandas
- [AWS SDK for Pandas](https://github.com/aws/aws-sdk-pandas)

## Data Version Control (DVC)
- [DVC AI Blog](https://dvc.ai/blog)
