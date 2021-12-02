# Amazon EFS (Elastic File System)
[Amazon EFS](https://aws.amazon.com/efs/) is simple, serverless, set-and-forget, elastic file system. It automatically grows and shrinks as you add and remove files with no need for management or provisioning.

## Quickstart
### Setup
```hcl
module "efs" {
  source  = "Young-ook/sagemaker/aws//modules/efs"
  name    = var.name
}
```

Run terraform:
```
terraform init
terraform apply
```
