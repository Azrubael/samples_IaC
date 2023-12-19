#!/bin/bash
# 2023-12-19    11:58

sudo hostnamectl set-hostname k8v-kops

sudo apt update

sudo apt install wget curl awscli -y

# Installing Kubernetes
curl -LO https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl
sudo chmod +x kubectl* && sudo mv kubectl* /usr/local/bin/

# kOps
# https://kops.sigs.k8s.io/getting_started/aws/
# https://kubernetes.io/docs/setup/production-environment/tools/kops/
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
sudo chmod +x kops-linux-amd64 && sudo mv kops-linux-amd64 /usr/local/bin/kops

# Create a key which can be used by kOps for cluster login
ssh-keygen -N "" -f $HOME/.ssh/id_rsa

echo "Enter AWS Access Key:"
read awsaccess

echo "Enter AWS Secret Key:"
read awssecret

echo "Enter Cluster Name: (ex: my-kube.k8s.local)"
read clname

echo "Enter an AZ for the cluster:"
read az

# Configure your AWS user profile
aws configure set aws_access_key_id $awsaccess
aws configure set aws_secret_access_key $awssecret

# Create an S3 Bucket where kOps will save all the cluster's state information.
aws s3 mb s3://$clname

# Expose the s3 bucket as environment variables. 
export KOPS_STATE_STORE=s3://$clname

# Create the cluster with 2 worker nodes.
kops create cluster --name=k8v.azrubael.online \
--state=s3://k8v.azrubael.online \
--zones=us-east-1a,us-east-1b \
--node-count=2 --node-size=t2.micro \
--control-plane-size=t2.micro \
--dns-zone=k8v.azrubael.online --yes

kops update cluster --name k8v.azrubael.online --state=s3://k8v.azrubael.online --yes --admin

kops validate cluster --name k8v.azrubael.online --state=s3://k8v.azrubael.online --wait 10m --count 3

# The .bashrc file is a script file that’s executed when a user logs in. 
echo "export KOPS_STATE_STORE=s3://$clname" >> .bashrc