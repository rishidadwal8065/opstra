# opstra
This Project is for multi tenant end to end CI/CD solution 

# you can execute the below  script to install required packages to execute python script
pip install -r requirements.txt


# Steps to install terraform in machine considering amazon linux as base OS
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

# Steps used to install AWS CLI and post instalation please use AWS CONFIGURE
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

# AWS CONFIGURE
Run aws configure in the terminal.
Enter your AWS Access Key ID, Secret Access Key, default region, and preferred output format.

# IMPORTANT ->
I have executed my terraform to make task done via   cloudshell 

# git clone
a) https://github.com/rishidadwal8065/opstra.git
b ) cd opstra/terraform

# Steps to install EKS,Deployment,Route53,RDS,S3 configrations, make sure you are in opstra directory
c) terraform init
d) terraform apply  -var="tenant_name=opstra" -auto-approve


# Steps to destroy EKS,Deployment,Route53,RDS,S3 configrations
e)terraform destroy  -var="tenant_name=opstra" -auto-approve


####  IMPORTANT INSTRUCTIONS #########
# I have faced format issue in script because I have transfered files from window to unix OS .If you do the same make sure youare converting  script in unix format.

a) sudo yum install dos2unix

dos2unix <scriptname>