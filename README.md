# VPC Endpoint Services (AWS Private Link)

This Terraform project shows how to specify and deploy the following components:
+ 1 keypair (run ssh-keygen in your home folder to create a key "~/.ssh/tfvpce/id_rsa.pub")
+ 1 service provider VPC with 1 ec2
+ 1 service consumer VPC with 1 ec2

## Generate a keypair to access EC2 instances

    ssh-keygen

## Terraform commands
    
    terraform init
    
    terraform validate
    
    terraform plan -out=tfplan
    
    terraform apply -auto-approve tfplan
    
    terraform apply -auto-approve
    
    terraform destroy -auto-approve

## To delete Terraform state files
    rm -rfv **/.terraform # remove all recursive subdirectories
    
<br>

<img src="./VPC%20Endpoint%20Service.svg?sanitize=true">

## Links
<a href="https://docs.aws.amazon.com/vpc/latest/userguide/endpoint-service.html">VPC Endpoint Services (Private Link)</a>
<br>
<a href="https://cloudaffaire.com/create-a-vpc-endpoint-service/">Create a VPC Endpoint Service</a>