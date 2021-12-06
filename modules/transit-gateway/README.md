# AWS Transit Gateway
[AWS Transit Gateway](https://aws.amazon.com/transit-gateway/) is a service that connects VPCs and on-premises networks through a central hub. This simplifies your network and puts an end to complex peering relationships. It acts as a cloud router – each new connection is only made once.

As you expand globally, inter-Region peering connects AWS Transit Gateways together using the AWS global network. Your data is automatically encrypted, and never travels over the public internet. And, because of its central position, AWS Transit Gateway Network Manager has a unique view over your entire network, even connecting to Software-Defined Wide Area Network (SD-WAN) devices.

## Quickstart
### Setup

```hcl
module "tgw" {
  source = "Young-ook/sagemaker/aws//modules/tgw"
}
```

Run terraform:
```
terraform init
terraform apply
```
