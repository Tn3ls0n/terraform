# Project Title

Azure IAC with Terraform

## Description

Provisions the following resources.
- service principal
- key vault
- aks cluster
- aks vnet
- acr

## Getting Started

### Dependencies

* Azure subscription
* Azure cli
* Terraform

### Updating Variables

* Update variables in root terraform.tfvars file.
* Update the cluster name in the modules\aks\main.tf file. This must be unique. 

### Executing program

* How to run the program
```
terraform init
terraform plan
tarrafrom apply
terraform destroy
```