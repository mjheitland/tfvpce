This Terraform project shows how to specify and deploy the following components:
+ 1 keypair (run ssh-keygen in your home folder to create a key "~/.ssh/tfvpce/id_rsa.pub")
+ 1 service provider VPC with 1 ec2
+ 1 service consumer VPC with 1 ec2

## generate a keypair to access EC2 instances

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
    
![Alt text](https://./VPC Endpoint Service.svg?sanitize=true)
<img src="./VPC%20Endpoint%20Service.svg?sanitize=true">
