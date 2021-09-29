# Citrix ADC Automation

Terraform module that create bulk Content Switching rules and attach it to corresponding Load Balancing virtual server with rewrite rules.   

## Usage

```terraform
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```
