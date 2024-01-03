# 2024-01-03    15:33
=====================

* 269 - First Example
---------------------
    $ mkdir '269 - First Example'
    $ cd '269 - First Example'
    $ vim 269-FirstExample.yaml
---
Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: t2.micro
      ImageId:  ami-00b8917ae86a424c9  # Amazon Linux 2  us-east-1


> AWS > CloudFormation > *Create stack* > 'Template is ready' >
  'Upload a template file' > 'Choose file' > 269-FirstExample.yaml >
  Next > *Create stack*

# S3 URL:
https://s3.us-east-1.amazonaws.com/cf-templates-d7hy5fhipjz8-us-east-1/2024-01-03T135330.686Zofr-269-FirstExample.yaml

> AWS > CloudFormation > *Update stack* > 'Replace current template' > 
  'Upload a template file' > 'Choose file' > 
  269-FirstExample-updated.yaml > Next > *Update stack*


> AWS > CloudFormation > imran-first-stack > *Delete*
