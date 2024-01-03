# 2024-01-03  16:34
===================


* 271 - Change Set
------------------

# Creating a change set
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-changesets-create.html

When you have a stack life up and running and you want to make change, you really need to see what this change is going to or how this change is going to affect your existing resources.

[Чтобы создать набор изменений для работающего стека, отправьте изменения, которые вы хотите внести, предоставив измененный шаблон, новые значения входных параметров или и то, и другое. CloudFormation генерирует набор изменений, сравнивая ваш стек с отправленными вами изменениями.]
[Вы можете изменить шаблон либо перед созданием набора изменений, либо во время создания набора изменений.]

So now we're going to create EN2 instance and going to create some changes to it. And we'll see from the Change Set how doess it affect.

  $ vim 271-change-set.yaml
---
Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: t2.micro
      ImageId:  ami-00b8917ae86a424c9  # Amazon Linux 2  us-east-1
      Tags:
        - Key: "Name"
          Value: !Join [ "-", [Lets,C,Changeset] ]


> AWS > CloudFormation > *Create stack* > 'Template is ready' >
  'Upload a template file' > 'Choose file' > 271-change-stack.yaml >
  Next > *Create stack* > Submit


  $ vim 271-change-set-updated.yaml
---
Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: t2.micro
      ImageId:  ami-002070d43b0a4f171  # Centos-7  us-east-1
      Tags:
        - Key: "Name"
          Value: "change-7"
        - Key: "Project"
          Value: "Imran-7"

> AWS > CloudFormation > *Update stack* > 'Replace current template' > 
  'Upload a template file' > 'Choose file' > 
  271-change-stack.yaml > Next > *Update stack*

> AWS > CloudFormation > Delete

