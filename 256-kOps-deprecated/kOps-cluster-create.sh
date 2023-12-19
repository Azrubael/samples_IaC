#!/bin/bash

echo "Enter AWS Access Key:"
read awsaccess

echo "Enter AWS Secret Key:"
read awssecret

echo "Enter Cluster Name: (ex: my-kube.k8s.local)"
read clname

echo "Enter an AZ for the cluster:"
read az

sudo apt update

# download kubectl; give execute permission; move to binary path
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.25.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# download kOps
sudo curl -LO https://github.com/kubernetes/kops/releases/download/v1.25.0/kops-linux-amd64

# Give executable permission to the downloaded kOps file and move it to binary path
sudo chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops

# Configure your AWS user profile
aws configure set aws_access_key_id $awsaccess
aws configure set aws_secret_access_key $awssecret

# Create a key which can be used by kOps for cluster login
ssh-keygen -N "" -f $HOME/.ssh/id_rsa

# Create an S3 Bucket where kOps will save all the cluster's state information.
aws s3 mb s3://$clname

# Expose the s3 bucket as environment variables. 
export KOPS_STATE_STORE=s3://$clname

# Create the cluster with 2 worker nodes. 
kops create cluster --node-count=2 --master-size="t3.medium" --node-size="t3.medium" --master-volume-size=30 --node-volume-size=30 --zones=$az --name $clname

# Apply the specified cluster specifications to the cluster 
kops get cluster
kops update cluster $clname --yes

# The .bashrc file is a script file that’s executed when a user logs in. 
echo "export KOPS_STATE_STORE=s3://$clname" >> .bashrc
