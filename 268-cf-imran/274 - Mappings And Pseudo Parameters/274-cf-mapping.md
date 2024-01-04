# 2024-01-04  16:21
===================

* 274 - Mappings And Pseudo Parameters
--------------------------------------

# What is AWS CloudFormation?
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html

# Mappings
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/mappings-section-structure.html

  $ vim Map-n-Pseudo.yaml
---
AWSTemplateFormatVersion: '2010-09-09'
Description: >-
  CloudFormation template with examples of Mappings and Pseudoparameters
Mappings: 
  AmiRegionMap: 
    us-east-1:      # Amazon Linix 2 
      AMI: "ami-00b8917ae86a424c9"
    eu-west-3:      # Paris
      AMI: "ami-072a132dda549474e"
    eu-central-1:   # Frankfurt
      AMI: "ami-02da8ff11275b7907"
Resources:
  EC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId:  !FindInMap
        - AmiRegionMap
        - !Ref AWS::Region
        - AMI
      InstanceType: t2.micro
      SecurityGroups:
        - !Ref VprofileSG
      UserData:
        Fn::Base64: !Sub |
         #!/bin/bash
         sudo apt install wget -y
      Tags:
        - Key: "Name"
          Value: !Join [ "-", [my,inst,from,AWS,CloudFormation] ]
  VprofileSG:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow ssh from MyIP & http to all IPv4
      GroupName: Vprofile-SG
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80 
          ToPort: 80
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 188.163.109.118/32


# Three times for three selected regions
> AWS > CloudFormation > *Create stack* > 'Template is ready' >
  'Upload a template file' > 'Choose file' > Map-n-Pseudo.yaml >
  Next > *Create stack* > Submit