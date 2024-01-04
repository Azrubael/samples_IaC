# 2024-01-03  19:52
===================


* 274 - Mappings And Pseudo Parameters
--------------------------------------

In this exersice we're going to create a security group and EC2 instance from some template file. 

# AWS CloudFormation Template reference
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html

# Amazon EC2 resource type reference
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_EC2.html

# AWS::EC2::SecurityGroup
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-securitygroup.html

The following example specifies a security group with an ingress and egress rule.
---
InstanceSecurityGroup:
  Type: AWS::EC2::SecurityGroup
  Properties:
    GroupDescription: Allow http to client host
    VpcId: !Ref myVPC
    SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 80
        ToPort: 80
        CidrIp: 0.0.0.0/0
    SecurityGroupEgress:
      - IpProtocol: tcp
        FromPort: 80
        ToPort: 80
        CidrIp: 0.0.0.0/0


# If you generally create EC2 instance from from the console, you create EC2 instance first. And while you create EC2 instance you select or create your security group. If you like that order, you can do the same order in the template. CloudFormation is smart enought to understand how to order you resources. 

  $ vim multiresource.yaml
---
Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: t2.micro
      ImageId:  ami-00b8917ae86a424c9  # Amazon Linux 2  us-east-1
      Tags:
        - Key: "Name"
          Value: !Join [ "-", [my,inst,from,AWS,CloudFormation] ]
      SecurityGroups:
        - !Ref VprofileSG
      
  VprofileSG:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow sh & http from MyIP
      # VpcId: !Ref myVPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 188.163.109.118/32

      SecurityGroupEgress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0


[05:05]
> AWS > CloudFormation > *Create stack* > 'Template is ready' >
  'Upload a template file' > 'Choose file' > multiresource.yaml >
  Next > *Create stack* > Submit



# 2024-01-04  10:05
===================
Запропоновано вище рішення не працює.
План перевірки:

  1) Write me a yaml file to start AWS EC2 instance of type 't2.micro' from an image ami-00b8917ae86a424c9, with a new security group 'VprofileSG' that have an ingress rule to permit ssh connection and an egress rule to permit outbound traffic through port 80 for all IPv4 addresses. Also in that yaml file explicitly indicate my default VPC with ID vpc-01522a1e7c7bac9d7 and IPv4 CIDR 172.31.0.0/16.

  $ vim <multis-2.yaml>
MySubnet	
CREATE_FAILED
	Resource handler returned message: "The CIDR '172.31.0.0/16' conflicts with another subnet (Service: Ec2, Status Code: 400, Request ID: 9fec1ebd-b0b7-4b56-b7fd-d5fc7711801b)" (RequestToken: cd318375-29f6-9f27-4642-77fb77a244da, HandlerErrorCode: AlreadyExists)

  2) Write me a yaml file to start AWS EC2 instance of type 't2.micro' from an image ami-00b8917ae86a424c9, with a new security group 'VprofileSG' that have an ingress rule to permit ssh connection and an egress rule to permit outbound traffic through port 80 for all IPv4 addresses. Also in that yaml file explicitly indicate my default VPC with ID vpc-01522a1e7c7bac9d7.

  vim <multis-2.yaml>
MySubnet	
CREATE_FAILED
	Resource handler returned message: "The CIDR '172.31.0.0/20' conflicts with another subnet (Service: Ec2, Status Code: 400, Request ID: 3aed3c2c-bc8a-4d54-89a4-037cd9408b90)" (RequestToken: 811e6f2f-6798-1cb7-c634-bd461efcc945, HandlerErrorCode: AlreadyExists)