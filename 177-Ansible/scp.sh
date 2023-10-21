#!/bin/bash
for (( i=1; i<9; i++))
do
    scp -i "~/.aws/230724-ec2-t2micro.pem" /mnt/SSDATA/CODE/DevOpsCompl20/samples_IaC/177-Ansible/exercise${i}/* ubuntu@52.201.241.15:/home/ubuntu/vprofile/exercise${i}/
done