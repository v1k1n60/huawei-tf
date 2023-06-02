# Huawei Terraform Scripts
------------

El siguiente es un ejemplo de aprovisionmiento de infraestructura en la nube de Huawei Cloud usando funcionalidades de Iac (Infrastructure as Code) con la herramienta Terraform.

Principalmente se trata del aprovisionamiento de:
* Componentes de Networking: [VPC](https://www.huaweicloud.com/intl/es-us/product/vpc.html), Subnet, Security Group
* Instancia de cómputo ECS ([Elastic Cloud Server](https://www.huaweicloud.com/intl/es-us/product/ecs.html))

![Solution Diagram](huawei_tf.png "Solution Diagram")
## Steps
1. Install Terraform
2. Add the oficial provider
3. Obtain Active and Secret Key (AK/SK)
4. Resoources are deploy to the cloud

## Requirements
------------
* Terraform: https://www.terraform.io
* Huawei provider: https://github.com/huaweicloud/terraform-provider-huaweicloud

## Instructions
------------
* Obtain a AK/SK from the Huawei Cloud console in [MyCredentials](https://console-intl.huaweicloud.com/iam/#/mine/apiCredential) page 
* Add your AK/SK data and region to the terraform.tfvars terraform file
* Don't forget initialize your environment with: `terraform init`
* Apply the script into the cloud using: `terraform apply`