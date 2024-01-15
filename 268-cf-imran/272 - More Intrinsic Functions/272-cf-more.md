# 2024-01-03  17:21
===================

* 272 - More Intrinsic Functions
--------------------------------

# Ref
It refers to something. Like if you create a security group and then you want to refer that sequrity group while you're creating EC2 instance. 
---
MyEIP:
  Type: "AWS::EC2::EIP"
  Properties:
    InstanceId: !Ref MyEC2Instance


# The intrinsic function Ref returns the value of the specified parameter or resource. When the AWS::LanguageExtensions transform transform is used, you can use intrinsic functions as a parameter to Ref and Fn::GetAtt.
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-ref.html

For some resources, an identifier is returned that has another significant meaning in the context of the resource. An AWS::EC2::EIP resource, for instance, returns the IP address, and an AWS::EC2::Instance returns the instance ID.


  $ vim 272-ref-func.yaml
---
Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: t2.micro
      ImageId:  ami-00b8917ae86a424c9  # Amazon Linux 2  us-east-1
      Tags:
        - Key: "Name"
          Value: !Join
            - " "
            - - "My Instance in"
              - !Ref AWS::Region

> AWS > CloudFormation > *Create stack* > 'Template is ready' >
  'Upload a template file' > 'Choose file' > 272-ref-func.yaml >
  Next > *Create stack* > Submit


        This example demonstrates how to use the Fn::Sub intrinsic function to substitute values for the Identifier for different stages. The Ref and the Fn::GetAtt functions can then be used to reference the appropriate values, based on the input for the stage. Fn::Sub is first used with Fn::GetAtt to obtain the ARN of the appropriate Amazon SQS queue to set the dimensions of the Amazon CloudWatch alarm. Next, Fn::Join is used with Ref to create the logical ID string of the Stage parameter. 
---
AWSTemplateFormatVersion: 2010-09-09
Transform: 'AWS::LanguageExtensions'
Parameters:
  Stage:
    Type: String
    Default: Dev
    AllowedValues:
      - Dev
      - Prod
Conditions:
  isProd: !Equals 
    - !Ref Stage
    - Prod
  isDev: !Equals 
    - !Ref Stage
    - Dev
Resources:
  DevQueue:
    Type: 'AWS::SQS::Queue'
    Condition: isDev
    Properties:
      QueueName: !Sub 'My${Stage}Queue'
  ProdQueue:
    Type: 'AWS::SQS::Queue'
    Condition: isProd
    Properties:
      QueueName: !Sub 'My${Stage}Queue'
  DevTopic:
    Condition: isDev
    Type: 'AWS::SNS::Topic'
  ProdTopic:
    Condition: isProd
    Type: 'AWS::SNS::Topic'
  MyAlarm:
    Type: 'AWS::CloudWatch::Alarm'
    Properties:
      AlarmDescription: Alarm if queue depth grows beyond 10 messages
      Namespace: AWS/SQS
      MetricName: ApproximateNumberOfMessagesVisible
      Dimensions:
        - Name: !Sub '${Stage}Queue'
          Value: !GetAtt 
            - !Sub '${Stage}Queue'
            - QueueName
      Statistic: Sum
      Period: 300
      EvaluationPeriods: 1
      Threshold: 10
      ComparisonOperator: GreaterThanThreshold
      AlarmActions:
        - !Ref 
          'Fn::Join':
            - ''
            - - !Ref Stage
              - Topic