# VPC Endpoint Services (AWS Private Link)

This Terraform project shows how to specify and deploy the following components:
+ 1 keypair (run ssh-keygen in your home folder to create a key "~/.ssh/tfvpce/id_rsa.pub")
+ 2 service providers in a private VPC (no internet conenction):
    - ec2 "provider1" running a web server that returns "provider1" in one subnet and AZ
    - ec2 "provider2" running a web server that returns "provider2" in another subnet and AZ
    - network load balancer
    - VPC endpoint service (uses internally a private VPC link)
+ 1 service consumer in a public VPC (with internet connection via internet gateway)
    - internet gateway
    - ec2 "consumer" that returns "consumer"
    - VPC endpoint (generates automatically an ENI with a private ip address)

To test that we can now connect from public VPC (consumer) to the private VPC (provider):
1. log into consuemr (ssh or through AWS Console "EC2 Instance Connect (browser-based SSH connection)")
2. curl &lt;DNS name of VPC endpoint &gt; (take it from the output variable "vpcept_dns_entry")
3. curl should return "Server name: provider1" or "Server name: provider2" (i.e. the web server response of ec2 "provider" sitting in the private VPC)

## Generate a keypair to access EC2 instances

    ssh-keygen

## Terraform commands
    
    terraform init
    
    terraform validate
    
    terraform plan -out=tfplan
    
    terraform apply -auto-approve tfplan
    or
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
<br>
<a href="https://medium.com/@sahityamaruvada/setting-up-aws-network-load-balancer-with-terraform-0-12-b87e75992949">Setting up AWS Network Load Balancer with Terraform 0.12</a>
