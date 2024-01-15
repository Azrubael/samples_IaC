# 2024-01-04  09:18
===================

* 276 - Outputs
---------------

# Outputs
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html

# Template reference
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html

# Amazon EC2 resource type reference. It specifies an EC2 instance.
# If an Elastic IP address is attached to your instance, AWS CloudFormation reattaches the Elastic IP address after it updates the instance. 
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_EC2.html

В опциональном разделе «Outputs» объявляются выходные значения, которые можно импортировать в другие стеки (для создания межстековых ссылок), возвращать в ответ (для описания вызовов стека) или просматривать на консоли AWS CloudFormation. Например, вы можете вывести имя сегмента S3 для стека, чтобы его было легче найти.

# General Example:
---
Outputs:
  Logical ID:
    Description: Information about the value
    Value: Value to return
    Export:
      Name: Name of resource to export

# Exampe:
---
Outputs:
  BackupLoadBalancerDNSName:
    Description: The DNSName of the backup load balancer
    Value: !GetAtt BackupLoadBalancer.DNSName
    Condition: CreateProdResources
  InstanceID:
    Description: The Instance ID
    Value: !Ref EC2Instance

# For example, to declare AWS::EC2::Instance entity in your AWS CloudFormation template, use the following syntax:
---
Type: AWS::EC2::Instance
Properties:
  AdditionalInfo: String
  Affinity: String
  AvailabilityZone: String
  BlockDeviceMappings: 
    - BlockDeviceMapping
  CpuOptions: 
    CpuOptions
  CreditSpecification: 
    CreditSpecification
  DisableApiTermination: Boolean
  EbsOptimized: Boolean
  ElasticGpuSpecifications: 
    - ElasticGpuSpecification
  ElasticInferenceAccelerators: 
    - ElasticInferenceAccelerator
  EnclaveOptions: 
    EnclaveOptions
  HibernationOptions: 
    HibernationOptions
  HostId: String
  HostResourceGroupArn: String
  IamInstanceProfile: String
  ImageId: String
  InstanceInitiatedShutdownBehavior: String
  InstanceType: String
  Ipv6AddressCount: Integer
  Ipv6Addresses: 
    - InstanceIpv6Address
  KernelId: String
  KeyName: String
  LaunchTemplate: 
    LaunchTemplateSpecification
  LicenseSpecifications: 
    - LicenseSpecification
  Monitoring: Boolean
  NetworkInterfaces: 
    - NetworkInterface
  PlacementGroupName: String
  PrivateDnsNameOptions: 
    PrivateDnsNameOptions
  PrivateIpAddress: String
  PropagateTagsToVolumeOnCreation: Boolean
  RamdiskId: String
  SecurityGroupIds: 
    - String
  SecurityGroups: 
    - String
  SourceDestCheck: Boolean
  SsmAssociations: 
    - SsmAssociation
  SubnetId: String
  Tags: 
    - Tag
  Tenancy: String
  UserData: String
  Volumes: 
    - Volume



  $ vim outputs.yaml
---
AWSTemplateFormatVersion: '2010-09-09'
Description: >-
  CloudFormation template with examples of Outputs
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
Outputs:
  PrintSomeINFO:
    Value: !GetAtt
      - EC2Instance
      - PublicDnsName


# And let's create a CloudFormation stack
> AWS > CloudFormation > *Create stack* > 'Template is ready' >
  'Upload a template file' > 'Choose file' > outputs.yaml >
  Next > *Create stack* > Submit

# After stack gets greated, check your outputs section:
> AWs > CloudFormation > Stacks > imran-outputs > Outputs >
  > PrintSomeINFO = ec2-54-81-187-224.compute-1.amazonaws.com