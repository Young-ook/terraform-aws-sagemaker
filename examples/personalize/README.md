# Amazon Personalize with Amazon SageMaker
[Amazon SageMaker](https://aws.amazon.com/pm/sagemaker) helps data scientists and developers to prepare, build, train, and deploy high-quality machine learning models quickly by bringing together a broad set of capabilities purpose-built for machine learning.

[Amazon Personalize](https://aws.amazon.com/personalize/) enables developers to build applications with the same machine learning (ML) technology used by Amazon.com for real-time personalized recommendations – no ML expertise required.

Amazon Personalize makes it easy for developers to build applications capable of delivering a wide array of personalization experiences, including specific product recommendations, personalized product re-ranking, and customized direct marketing. Amazon Personalize is a fully managed machine learning service that goes beyond rigid static rule based recommendation systems and trains, tunes, and deploys custom ML models to deliver highly customized recommendations to customers across industries such as retail and media and entertainment.

## Setup
[This](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/personalize/main.tf) is the example of terraform configuration file to create SageMaker on AWS. Check out and apply it using terraform command.

Run terraform:
```
terraform init
terraform apply
```
Also you can use the `-var-file` option for customized paramters when you run the terraform plan/apply command.
```
terraform plan -var-file tc1.tfvars
terraform apply -var-file tc1.tfvars
```

## Getting started
After a SageMaker notebook instance is launched, you can access and open a JupyterLab or Jupyter notebook in the sagemaker service page of AWS management console. This example that will deploy all the resources you need to build your first campaign with Amazon Personalize. The notebooks provided can also serve as a template to building your own models with your own data. This repository is cloned into the environment so you can explore the more advanced notebooks with this approach as well.

This tutorial will walk you through building an environment to create a custom dataset, model, and recommendation campaign with Amazon Personalize. The steps below outline the process of building your own recommendation model, improving it, and then cleaning up all of your resources to prevent any unwanted charges. To get started executing these follow the steps in the next section.

1. `1.Building_Your_First_Campaign.ipynb` - Guides you through building your first campaign and recommendation algorithm.
2. `2.View_Campaign_And_Interactions.ipynb` - Showcase how to generate a recommendation and how to modify it with real time intent.
3. `Cleanup.ipynb` - Deletes anything that was created so you are not charged for additional resources.

You can download the Jupyter notebooks from the /notebooks folder. If you have any issues with any of the content here please visit the original [repo](https://github.com/aws-samples/amazon-personalize-samples) for updates.

## Clean up
If you run this hands-on lab on SageMaker Studio, don't forget you have to delete users (profiles) before you destroy the SageMaker Studio. For more the details, please refer to [this](https://docs.aws.amazon.com/sagemaker/latest/dg/gs-studio-delete-domain.html).

Next, follow the instruction of `Cleanup.ipynb` notebook to purge the resource that we made through SageMaker notebook. Then, run terraform destroy command to delete infrastructure:
```
terraform destroy
```

Don't forget you have to use the `-var-file` option when you run terraform destroy command to delete the aws resources created with extra variable files.
```
terraform destroy -var-file tc1.tfvars
```
