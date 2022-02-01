# Amazon S3 (Simple Storage Service)
[Amazon S3](https://aws.amazon.com/s3/) is an object storage service that offers industry-leading scalability, data availability, security, and performance.

### Quickstart
```hcl
module "s3" {
  source  = "Young-ook/sagemaker/aws//modules/s3"
  name    = var.name
  tags    = { env = "test" }
}
```
Run terraform:
```
terraform init
terraform apply
```

## Object Lifecycle Management
To manage your objects so that they are stored cost effectively throughout their lifecycle, configure their Amazon S3 Lifecycle. An S3 Lifecycle configuration is a set of rules that define actions that Amazon S3 applies to a group of objects. There are two types of actions:
*  **Transition actions** Define when objects transition to another storage class. For example, you might choose to transition objects to the S3 Standard-IA storage class 30 days after you created them, or archive objects to the S3 Glacier storage class one year after creating them. There are costs associated with the lifecycle transition requests. For pricing information, see Amazon S3 pricing
* **Expiration actions** Define when objects expire. Amazon S3 deletes expired objects on your behalf. The lifecycle expiration costs depend on when you choose to expire objects.

For more information, see [Object lifecycle management](https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lifecycle-mgmt.html).

### Example
```hcl
module "s3" {
  source  = "Young-ook/sagemaker/aws//modules/s3"
  name    = var.name
  tags    = { env = "test" }

  lifecycle_rules = [{
    enabled = "true"
    transition = [{
      days          = "120"
      storage_class = "STANDARD_IA"
    }]
    expiration = {
      days = "160"
    }
  }]
}
```
Modify the terraform configuration file to add a lifecycle rule to apply objects in the S3 bucket.
```
terraform init
terraform apply
```

## Intelligent-Tiering Configuration
S3 Intelligent-Tiering is a new Amazon S3 storage class designed for customers who want to **optimize storage costs automatically when data access patterns change, without performance impact or operational overhead**. S3 Intelligent-Tiering is the first cloud object storage class that delivers automatic cost savings by moving data between access tiers — frequent access, infrequent access, archive, deep archive — when access patterns change, and is ideal for data with unknown or changing access patterns.

S3 Intelligent-Tiering stores objects in many access tiers. For a small monthly monitoring and automation fee per object, S3 Intelligent-Tiering monitors access patterns and moves objects that have not been accessed for 30 consecutive days to the infrequent access tier. There are no retrieval fees in S3 Intelligent-Tiering. If an object in the infrequent access tier is accessed later, it is automatically moved back to the frequent access tier. No additional tiering fees apply when objects are moved between access tiers within the S3 Intelligent-Tiering storage class. **S3 Intelligent-Tiering is designed for 99.9% availability and 99.999999999% durability, and offers the same low latency and high throughput performance of S3 Standard**.

For more information, see [Amazon S3 Intelligent-Tiering](https://docs.aws.amazon.com/AmazonS3/latest/userguide/intelligent-tiering.html).
Also, you can find out more about how to add archive tier to your Intelligent-Tiering stoage classes for lower stoage costs in this blog, [S3 Intelligent-Tiering Adds Archive Access Tiers](https://aws.amazon.com/blogs/aws/s3-intelligent-tiering-adds-archive-access-tiers/).

### Example
```hcl
module "s3" {
  source  = "Young-ook/sagemaker/aws//modules/s3"
  name    = var.name
  tags    = { env = "test" }

  lifecycle_rules = [{
    enabled = "true"
    transition = [
      {
        "days" : "0",
        "storage_class" : "INTELLIGENT_TIERING"
      },
    ]
  }]
  intelligent_tiering_archive_rules = {
    state = "Enabled"
    filter = [{
      prefix = "logs/"
      tags = {
        priority = "high"
        class    = "blue"
      }
    }]
    tiering = [{
      access_tier = "ARCHIVE_ACCESS"
      days        = 125
    }, {
      access_tier = "DEEP_ARCHIVE_ACCESS"
      days        = 180
    }]
  }
}
```
Modify the terraform configuration file to add a lifecycle rule to apply objects in the S3 bucket.
```
terraform init
terraform apply
```

## Storage Cost Optimization
* [How to optimize storage costs using Amazon S3](https://d1.awsstatic.com/product-marketing/S3/Amazon_S3_eBook_Cost_Optimization.pdf)
* [5 Ways to reduce data storage costs using Amazon S3 Storage Lens](https://aws.amazon.com/blogs/storage/5-ways-to-reduce-costs-using-amazon-s3-storage-lens/)
* [Amazon S3 cost optimization for predictable and dynamic access patterns](https://aws.amazon.com/blogs/storage/amazon-s3-cost-optimization-for-predictable-and-dynamic-access-patterns/)
* [Expiring Amazon S3 Objects Based on Last Accessed Date to Decrease Costs](https://aws.amazon.com/blogs/architecture/expiring-amazon-s3-objects-based-on-last-accessed-date-to-decrease-costs/)
