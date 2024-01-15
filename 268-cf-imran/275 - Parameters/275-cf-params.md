# 2024-01-04  17:12
===================

* 275 - Parameters
------------------

# Parameters
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html

Используйте дополнительный раздел «Параметры», чтобы настроить шаблоны. Параметры позволяют вводить пользовательские значения в шаблон каждый раз, когда вы создаете или обновляете стек.

Example:
---
Parameters:
  InstanceTypeParameter:
    Type: String
    Default: t2.micro
    AllowedValues:
      - t2.micro
      - m1.small
      - m1.large
    Description: Enter t2.micro, m1.small, or m1.large. Default is t2.micro.


$ vim inputparams.yaml
---
AWSTemplateFormatVersion: '2010-09-09'
Description: >-
  CloudFormation template with examples of Mappings and Parameters
Parameters:
  NameOfService:
    Description: "The name of the service this stack is to be used for."
    Type: String
  InstanceTypeParameter:
    Description: Enter t2.micro, t2.small or t2.medium
    Type: String
    Default: t2.micro
    AllowedValues:
      - t2.micro
      - t2.small
      - t2.medium
  KeysNames:
    Description: Name of EC2 login key
    Type: AWS::EC2::KeyPair::KeyName
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
      InstanceType: !Ref InstanceTypeParameter
      KeyName: !Ref KeysNames
      SecurityGroups:
        - !Ref VprofileSG
      UserData:
        Fn::Base64: !Sub |
         #!/bin/bash
         sudo apt install wget -y
      Tags:
        - Key: "Name"
          Value: !Ref NameOfService
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
