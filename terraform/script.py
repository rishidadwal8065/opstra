import subprocess
import json
import requests
import boto3

zid = []

zoneid = zid

# Set the AWS region
AWS_REGION = "us-east-1"  # Replace with your preferred AWS region

# Set the EKS cluster name
EKS_CLUSTER_NAME = "eks-cluster-devloper"  # Replace with your EKS cluster name

# Set the path to the kubeconfig file
KUBECONFIG_PATH = "~/.kube/config"  # Adjust the path as needed

# Set the name for the Route 53 CNAME record
TENANT_NAME = "opstra"  # Replace with your desired tenant name

# Set the AWS Route 53 DNS zone name
DNS_ZONE_NAME = "arcstone.ai"  # Replace with your DNS zone name

# AWS CLI command to create/update an EKS cluster
subprocess.run(f"aws eks --region {AWS_REGION} update-kubeconfig --name {EKS_CLUSTER_NAME}", shell=True)

# Fetch the hostname from the EKS cluster
eks_hostname = subprocess.check_output("kubectl get svc hello-world -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'", shell=True, text=True).strip()

# Create or update a Route 53 CNAME record
hosted_zone_id = subprocess.check_output(f"aws route53 list-hosted-zones --query 'HostedZones[?Name==`{DNS_ZONE_NAME}.`].Id' --output text", shell=True, text=True).strip()

hzid = hosted_zone_id.split()
change_batch = {
    "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": f"i_{TENANT_NAME}.{DNS_ZONE_NAME}",
                "Type": "CNAME",
                "TTL": 300,
                "ResourceRecords": [
                    {
                        "Value": eks_hostname
                    }
                ]
            }
        }
    ]
}



for ids in hzid:
    route53_client = boto3.client('route53')
    response = route53_client.get_hosted_zone(Id=ids)
    terraform_metadata = response['HostedZone']['Config']['Comment']
    if "Managed by Terraform" in terraform_metadata:
        zid.append(ids.split('/')[2:3])

zd = zid[0][0]
print(zd)

subprocess.run(f"aws route53 change-resource-record-sets --region {AWS_REGION} --hosted-zone-id {zd.strip()} --change-batch '{json.dumps(change_batch)}'", shell=True)

# Check if the specified URL is accessible
#url = f"http://i_{TENANT_NAME}.{DNS_ZONE_NAME}:8080"
#response = requests.head(url)
#if response.status_code == 200:
#    print(f"URL {url} is accessible.")
#else:
#    print(f"URL {url} is not accessible.")
