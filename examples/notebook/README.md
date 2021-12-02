[[English](README.md)] [[한국어](README.ko.md)]

# SageMaker Notebook
An [Amazon SageMaker notebook instance](https://docs.aws.amazon.com/sagemaker/latest/dg/nbi.html) is a machine learning (ML) compute instance running the Jupyter Notebook App. SageMaker manages creating the instance and related resources. Use Jupyter notebooks in your notebook instance to prepare and process data, write code to train models, deploy models to SageMaker hosting, and test or validate your models.

## How Are Amazon SageMaker Studio Notebooks Different from Notebook Instances?
When you're starting a new notebook, we recommend that you create the notebook in Amazon SageMaker Studio instead of launching a notebook instance from the Amazon SageMaker console. There are many benefits to using a SageMaker Studio notebook, including the following:
- Starting a Studio notebook is faster than launching an instance-based notebook. Typically, it is 5-10 times faster than instance-based notebooks. 
- Notebook sharing is an integrated feature in SageMaker Studio. Users can generate a shareable link that reproduces the notebook code and also the SageMaker image required to execute it, in just a few clicks.
- SageMaker Studio notebooks come pre-installed with the latest Amazon SageMaker Python SDK.
- SageMaker Studio notebooks are accessed from within Studio. This enables you to build, train, debug, track, and monitor your models without leaving Studio.

For more information, please refer to the [this](https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-comparison.html) developer guide.

## Download example
Download this example on your workspace
```sh
git clone https://github.com/Young-ook/terraform-aws-sagemaker
cd terraform-aws-sagemaker/examples/notebook
```
 
## Setup
[This](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/notebook/main.tf) is the example of terraform configuration file to create an SageMaker notebook instance. Check out and apply it using terraform command.

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
terraform destroy
```
Don't forget you have to use the `-var-file` option when you run terraform destroy command to delete the aws resources created with extra variable files.
```
terraform destroy -var-file tc1.tfvars
```

## SageMaker notebook examples
### Clone GitHub repository
After terraform successfully creates a sagemaker notebook instance in your aws environment, open the sagemaker notebook in your web browser. And click `git` icon on the left navigation bar, and select clone repository button to get the example codes from github repository. Or you can open a terminal in the jupyter notebook and directly clone the repository in the sagemaker workspace as below.

```
cd SageMaker
pwd
```

```
/home/ec2-user/SageMaker
```

```
git clone https://github.com/aws-samples/aws-ai-ml-workshop-kr
```

### Bring Your Own Containers (BYOC)
You can run your owne container in the sagemaker. There are some examples to explain how to use custom containers for machine leaning workloads.

#### Hello Docker
Find `sagemaker/byoc` directory and move in. Click `hello_docker.ipynb` file to open the interactive (notebook) interface for machine learning jobs and follow the instructions. Note this example written in korean. For english example, please refer to [this](TBD)

#### Scikit learn

#### Tensorflow

### Model Monitor
